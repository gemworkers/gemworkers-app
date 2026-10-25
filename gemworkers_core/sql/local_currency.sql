-- =============================================================================
-- GemWorkers — Local currency prices (USD, GBP, AUD, CAD), Etsy style
-- =============================================================================
-- Applied to live DB 2026-10-25
--
-- Zakaria 2026-10-25 (agreed plan): buyers shipping to the US, UK, Australia
-- or Canada see and pay ONE exact price in their own currency:
--   local = euro price × ECB daily rate × 1.02, rounded UP
--           (below 50 → whole number, from 50 → next 5 or 0)
-- stone and shipping are each rounded, the order total is their sum.
-- Records stay in EUR: order_total, payouts, commission, tax report are
-- unchanged. The paid currency is stored per order and locked at checkout;
-- invoices show the paid currency (with the euro amount).
-- Not converted (stay EUR): orders with VAT (only EU buyers have VAT anyway),
-- accepted offers / counter-offers (offers in local currency come later).
--
-- New:
--   orders.charge_currency/charge_rate/charge_markup/charge_shipping/charge_amount
--   orders.eur_received   — euros Stripe credited for the order (before fee)
--   _local_price(eur, rate, markup)
--   set_order_currency(order_ids, currency, rate) — store server only
--   issue_invoice: copied from the live definition, ONE change:
--     -      'currency', 'EUR'
--     +      'currency', 'EUR',
--     +      'charge', CASE WHEN o.charge_currency <> 'EUR' THEN jsonb_build_object(
--     +        'currency', o.charge_currency, 'total', o.charge_amount,
--     +        'goods', o.charge_amount - o.charge_shipping, 'shipping', o.charge_shipping,
--     +        'eur_total', o.order_total, 'rate', o.charge_rate, 'markup', o.charge_markup) END
-- =============================================================================

BEGIN;

ALTER TABLE public.orders
  ADD COLUMN IF NOT EXISTS charge_currency text NOT NULL DEFAULT 'EUR',
  ADD COLUMN IF NOT EXISTS charge_rate     numeric,
  ADD COLUMN IF NOT EXISTS charge_markup   numeric,
  ADD COLUMN IF NOT EXISTS charge_shipping numeric(12,2),
  ADD COLUMN IF NOT EXISTS charge_amount   numeric(12,2),
  ADD COLUMN IF NOT EXISTS eur_received    numeric(12,2);

ALTER TABLE public.orders DROP CONSTRAINT IF EXISTS orders_charge_currency_check;
ALTER TABLE public.orders ADD CONSTRAINT orders_charge_currency_check
  CHECK (charge_currency IN ('EUR', 'USD', 'GBP', 'AUD', 'CAD')
         AND (charge_currency = 'EUR' OR (charge_amount > 0 AND charge_rate > 0)));

-- ── The price formula (the store's lib/price-shown.ts uses the same) ────────
CREATE OR REPLACE FUNCTION public._local_price(p_eur numeric, p_rate numeric, p_markup numeric DEFAULT 0.02)
RETURNS numeric
LANGUAGE sql
IMMUTABLE
SET search_path = public
AS $$
  SELECT CASE
    WHEN coalesce(p_eur, 0) <= 0 THEN 0
    WHEN p_eur * p_rate * (1 + p_markup) < 50 THEN ceil(p_eur * p_rate * (1 + p_markup))
    ELSE ceil(p_eur * p_rate * (1 + p_markup) / 5) * 5
  END;
$$;

-- ── Lock the buyer's currency on their pending orders (store server) ────────
-- Called by the store right before it opens Stripe, with today's ECB rate.
-- Only orders that may be converted are changed; the rest stay EUR. A rate
-- far outside the normal range (a glitch) is refused → the store pays in EUR.
CREATE OR REPLACE FUNCTION public.set_order_currency(p_order_ids uuid[], p_currency text, p_rate numeric)
RETURNS TABLE (order_id uuid, charge_currency text, charge_amount numeric)
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public, pg_temp
AS $$
DECLARE
  v_country text;
BEGIN
  v_country := CASE p_currency WHEN 'USD' THEN 'US' WHEN 'GBP' THEN 'GB'
                               WHEN 'AUD' THEN 'AU' WHEN 'CAD' THEN 'CA' END;
  IF v_country IS NULL OR p_rate IS NULL OR NOT (
       (p_currency = 'USD' AND p_rate BETWEEN 0.8 AND 1.6) OR
       (p_currency = 'GBP' AND p_rate BETWEEN 0.6 AND 1.1) OR
       (p_currency = 'AUD' AND p_rate BETWEEN 1.2 AND 2.3) OR
       (p_currency = 'CAD' AND p_rate BETWEEN 1.1 AND 2.0)) THEN
    RAISE EXCEPTION 'Unsupported currency or implausible rate: % %', p_currency, p_rate;
  END IF;

  UPDATE public.orders o
  SET    charge_currency = p_currency,
         charge_rate     = p_rate,
         charge_markup   = 0.02,
         charge_shipping = public._local_price(coalesce(o.shipping_cost, 0), p_rate),
         charge_amount   = public._local_price(o.order_total - coalesce(o.shipping_cost, 0), p_rate)
                         + public._local_price(coalesce(o.shipping_cost, 0), p_rate)
  WHERE  o.id = ANY (p_order_ids)
    AND  o.status = 'pending_payment'
    AND  o.sale_channel = 'platform'
    AND  o.offer_id IS NULL
    AND  coalesce(o.tax_amount, 0) = 0
    AND  o.order_total > 0
    AND  coalesce(o.ship_to_country, o.shipping_country) = v_country;

  RETURN QUERY
    SELECT o.id, o.charge_currency, o.charge_amount
    FROM   public.orders o WHERE o.id = ANY (p_order_ids);
END;
$$;

REVOKE ALL ON FUNCTION public.set_order_currency(uuid[], text, numeric) FROM PUBLIC, anon, authenticated;
GRANT EXECUTE ON FUNCTION public.set_order_currency(uuid[], text, numeric) TO service_role;
REVOKE ALL ON FUNCTION public._local_price(numeric, numeric, numeric) FROM PUBLIC, anon, authenticated;
GRANT EXECUTE ON FUNCTION public._local_price(numeric, numeric, numeric) TO service_role;

-- ── Invoice: paid currency in the snapshot (live definition + 'charge') ─────
CREATE OR REPLACE FUNCTION public.issue_invoice(p_order_id uuid)
 RETURNS uuid
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO 'public', 'pg_temp'
AS $function$
DECLARE
  o          record;
  it         record;
  v_id       uuid;
  v_origin   text;
  v_from     text;
  v_to       text;
  v_note     text;
  v_diamond  boolean;
  v_goods    numeric;
  v_ship     numeric;
BEGIN
  IF NOT public._may_issue_invoices() THEN RAISE EXCEPTION 'Not allowed'; END IF;

  SELECT id INTO v_id FROM public.invoices WHERE order_id = p_order_id AND kind = 'invoice';
  IF v_id IS NOT NULL THEN RETURN v_id; END IF;

  SELECT * INTO o FROM public.orders WHERE id = p_order_id FOR UPDATE;
  IF o.id IS NULL OR o.sale_channel <> 'platform' OR o.paid_at IS NULL
     OR o.status IN ('draft','pending_payment','cancelled') THEN
    RAISE EXCEPTION 'Only paid store orders get an invoice.';
  END IF;

  SELECT i.title, i.sku, i.product_type, i.gem_type, i.weight_value, i.weight_unit
  INTO   it
  FROM   public.order_items oi JOIN public.inventory_items i ON i.id = oi.inventory_item_id
  WHERE  oi.order_id = o.id LIMIT 1;

  SELECT s.country INTO v_origin FROM public.sellers s WHERE s.id = o.seller_id;
  SELECT name INTO v_from FROM public.shipping_countries WHERE code = v_origin;
  SELECT name INTO v_to   FROM public.shipping_countries WHERE code = coalesce(o.ship_to_country, o.shipping_country);

  v_ship  := coalesce(o.shipping_cost, 0);
  v_goods := o.order_total - v_ship;
  v_diamond := coalesce(it.gem_type, '') ILIKE '%diamond%' OR coalesce(it.title, '') ILIKE '%diamond%';

  v_note := CASE
    WHEN o.tax_scheme = 'reverse_charge' THEN
      'VAT reverse charged — intra-Community supply of goods (Article 138 EU VAT Directive). Customer VAT number: '
      || coalesce(o.buyer_vat_number, '—') || '.'
    WHEN o.tax_scheme = 'oss' THEN
      'VAT charged at the rate of ' || coalesce(v_to, o.ship_to_country, 'the customer''s country') || ' (EU One-Stop-Shop).'
    WHEN o.tax_scheme = 'domestic' THEN NULL
    WHEN v_origin = 'NL' THEN
      '0% VAT — export of goods outside the EU. Import taxes and duties, if any, are paid by the customer.'
    ELSE
      'Shipped from ' || coalesce(v_from, v_origin, 'outside the EU') || ' — no Dutch VAT. Import taxes and duties, if any, are paid by the customer on delivery.'
  END;

  INSERT INTO public.invoices (number, kind, order_id, net_amount, tax_amount, total, tax_scheme, ship_to_country, data)
  VALUES (
    public._next_invoice_number(), 'invoice', o.id,
    o.order_total, o.tax_amount, o.order_total + o.tax_amount, o.tax_scheme,
    coalesce(o.ship_to_country, o.shipping_country),
    jsonb_build_object(
      'company', public._company_snapshot(),
      'order_number', o.order_number,
      'supply_date', to_char(o.paid_at AT TIME ZONE 'Europe/Amsterdam', 'YYYY-MM-DD'),
      'customer', jsonb_build_object(
        'type',     coalesce(o.customer_type, 'private'),
        'name',     o.shipping_name,
        'company',  o.buyer_company,
        'vat',      o.buyer_vat_number,
        'vat_verified', o.vat_verified,
        'vies_reference', o.vies_reference,
        'address',  concat_ws(E'\n', o.shipping_line1, o.shipping_line2,
                              concat_ws(' ', o.shipping_postal_code, o.shipping_city), o.shipping_state, v_to),
        'country',  coalesce(o.ship_to_country, o.shipping_country),
        'email',    o.order_email
      ),
      'ships_from', v_from,
      'lines', jsonb_build_array(
        jsonb_build_object('description', coalesce(it.title, 'Gemstone'),
                           'detail', concat_ws(' · ', it.sku,
                                               CASE WHEN it.weight_value IS NOT NULL
                                                    THEN it.weight_value::text || ' ' || coalesce(it.weight_unit, '') END),
                           'quantity', 1, 'amount', v_goods)
      ) || CASE WHEN v_ship > 0
                THEN jsonb_build_array(jsonb_build_object('description', 'Shipping', 'quantity', 1, 'amount', v_ship))
                ELSE '[]'::jsonb END,
      'tax_name', o.tax_name,
      'tax_rate', o.tax_rate,
      'vat_note', v_note,
      'diamond_statement', CASE WHEN v_diamond THEN
        'The diamonds herein invoiced have been purchased from legitimate sources not involved in funding conflict and in compliance with United Nations resolutions. The seller hereby guarantees that these diamonds are conflict free, based on personal knowledge and/or written guarantees provided by the supplier of these diamonds.'
        END,
      'currency', 'EUR',
      'charge', CASE WHEN o.charge_currency <> 'EUR' THEN jsonb_build_object(
        'currency', o.charge_currency, 'total', o.charge_amount,
        'goods', o.charge_amount - o.charge_shipping, 'shipping', o.charge_shipping,
        'eur_total', o.order_total, 'rate', o.charge_rate, 'markup', o.charge_markup) END
    )
  )
  RETURNING id INTO v_id;
  RETURN v_id;
END;
$function$;

COMMIT;
