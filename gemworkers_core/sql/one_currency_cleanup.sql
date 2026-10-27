-- =============================================================================
-- GemWorkers — One currency: euros (clean-up of the buyer-currency layer)
-- =============================================================================
-- Applied to live DB 2026-10-27
--
-- Zakaria 2026-10-27: "one currency like Etsy, clean, no old files".
-- Inside GemWorkers everything is euros. Buyers outside the euro see an
-- "≈ $" hint on the store and pay in their own currency through Stripe
-- Adaptive Pricing (Stripe converts). Store, admin and offer-notify were
-- switched to euros first (commits f94e6de, c35b749); this removes the
-- database side of the old USD/GBP/AUD/CAD layer (sql/local_currency.sql,
-- offers_local_currency.sql, counter_offer_neat_local.sql):
--   • trigger orders_offer_currency + _order_offer_currency()
--   • set_order_currency(), _local_price(), _offer_local_label(), fx_rates
--   • submit_storefront_offer without p_currency / p_local_amount
--   • counter_offer, _offer_message_card, issue_invoice, earnings_report:
--     live definitions copied, only the currency parts removed
--   • buyer_offers view without offer_currency / local_*
--   • columns orders.charge_* and storefront_offers.offer_currency /
--     offer_rate / local_offered / local_counter
-- Kept: orders.eur_received (euros Stripe credited) and the ECB "≈" hints.
-- Old test invoices keep their frozen data.charge (wiped before launch).
-- =============================================================================

BEGIN;

-- 1. Accepted offers no longer carry a buyer-currency amount onto the order.
DROP TRIGGER IF EXISTS orders_offer_currency ON public.orders;
DROP FUNCTION IF EXISTS public._order_offer_currency();

-- 2. Checkout no longer locks a currency per order.
DROP FUNCTION IF EXISTS public.set_order_currency(uuid[], text, numeric);

-- 3. Offers: euros only.
DROP FUNCTION IF EXISTS public.submit_storefront_offer(uuid, numeric, text, text, numeric);
CREATE OR REPLACE FUNCTION public.submit_storefront_offer(p_inventory_item_id uuid, p_offered_price numeric, p_buyer_note text DEFAULT ''::text)
 RETURNS uuid
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO 'public'
AS $function$
DECLARE
  v_item     record;
  v_offer_id uuid;
BEGIN
  -- Read item + seller status + sale_method.
  -- sale_method is the only addition vs the original SELECT.
  SELECT i.id, i.seller_id, i.is_listed, i.status, i.sale_method,
         s.status AS seller_status
  INTO   v_item
  FROM   inventory_items i
  JOIN   sellers         s ON s.id = i.seller_id
  WHERE  i.id = p_inventory_item_id;

  IF NOT FOUND THEN
    RAISE EXCEPTION 'Item not found';
  END IF;
  IF NOT v_item.is_listed THEN
    RAISE EXCEPTION 'Item is not listed for sale';
  END IF;
  IF v_item.status <> 'available' THEN
    RAISE EXCEPTION 'Item is not available for offers (status: %)', v_item.status;
  END IF;
  IF v_item.seller_status <> 'active' THEN
    RAISE EXCEPTION 'Seller is not active';
  END IF;

  -- Reject offers on buy_now-only stones.
  IF v_item.sale_method = 'buy_now' THEN
    RAISE EXCEPTION 'This item is not accepting offers';
  END IF;

  IF p_offered_price IS NULL OR p_offered_price <= 0 THEN
    RAISE EXCEPTION 'Offered price must be greater than zero';
  END IF;

  -- Offers are in whole cents: reject anything with more than 2 decimals
  -- rather than silently rounding the buyer's amount.
  IF p_offered_price <> round(p_offered_price, 2) THEN
    RAISE EXCEPTION 'Please enter your offer in euros and cents (at most 2 decimals), e.g. 49.80';
  END IF;

  -- One active offer per buyer per stone.
  IF EXISTS (
    SELECT 1 FROM storefront_offers
    WHERE  buyer_id          = auth.uid()
      AND  inventory_item_id = p_inventory_item_id
      AND  status            IN ('pending', 'countered')
  ) THEN
    RAISE EXCEPTION 'You already have a pending offer on this item';
  END IF;

  -- Blocked in this stone's conversation → no offers on this stone.
  IF EXISTS (
    SELECT 1 FROM conversations
    WHERE  buyer_id          = auth.uid()
      AND  inventory_item_id = p_inventory_item_id
      AND  status            = 'blocked'
  ) THEN
    RAISE EXCEPTION 'Offers on this stone aren''t available for your account';
  END IF;

  INSERT INTO storefront_offers (
    buyer_id,    inventory_item_id,       seller_id,
    offered_price, buyer_note
  )
  VALUES (
    auth.uid(),  p_inventory_item_id,     v_item.seller_id,
    p_offered_price, COALESCE(p_buyer_note, '')
  )
  RETURNING id INTO v_offer_id;

  RETURN v_offer_id;
END;
$function$;
REVOKE ALL ON FUNCTION public.submit_storefront_offer(uuid, numeric, text) FROM PUBLIC, anon;
GRANT EXECUTE ON FUNCTION public.submit_storefront_offer(uuid, numeric, text) TO authenticated, service_role;

CREATE OR REPLACE FUNCTION public.counter_offer(p_offer_id uuid, p_counter_price numeric)
 RETURNS json
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO 'public', 'pg_temp'
AS $function$
DECLARE
  v_offer   record;
  v_item    record;
  v_role    text;
  v_expires timestamptz := now() + interval '48 hours';
BEGIN
  IF p_counter_price IS NULL OR p_counter_price <= 0 THEN
    RAISE EXCEPTION 'Counter-offer must be greater than zero';
  END IF;
  IF p_counter_price <> round(p_counter_price, 2) THEN
    RAISE EXCEPTION 'Please enter the counter-offer in euros and cents (at most 2 decimals), e.g. 49.80';
  END IF;

  SELECT o.id, o.inventory_item_id, o.seller_id, o.offered_price, o.status
  INTO   v_offer
  FROM   storefront_offers o
  WHERE  o.id = p_offer_id
  FOR UPDATE;

  IF NOT FOUND THEN
    RAISE EXCEPTION 'Offer not found';
  END IF;

  IF v_offer.seller_id IS DISTINCT FROM public.current_seller_id()
     AND NOT public.is_owner() THEN
    RAISE EXCEPTION 'This offer does not belong to your shop';
  END IF;

  IF v_offer.status = 'countered' THEN
    RAISE EXCEPTION 'A counter-offer has already been sent for this offer';
  END IF;
  IF v_offer.status <> 'pending' THEN
    RAISE EXCEPTION 'Offer is no longer pending (status: %)', v_offer.status;
  END IF;

  SELECT id, status, is_listed, selling_price
  INTO   v_item
  FROM   inventory_items
  WHERE  id = v_offer.inventory_item_id
  FOR UPDATE;

  IF NOT FOUND OR v_item.status <> 'available' OR v_item.is_listed IS NOT TRUE THEN
    RAISE EXCEPTION 'Item is no longer available (status: %)', COALESCE(v_item.status, 'missing');
  END IF;

  IF p_counter_price <= v_offer.offered_price THEN
    RAISE EXCEPTION 'Counter-offer must be higher than the buyer''s offer (%)',
      public._offer_card_label(v_offer.offered_price);
  END IF;
  IF v_item.selling_price IS NULL OR p_counter_price >= v_item.selling_price THEN
    RAISE EXCEPTION 'Counter-offer must be lower than the listed price (%)',
      COALESCE(public._offer_card_label(v_item.selling_price), 'not set');
  END IF;

  v_role := CASE WHEN v_offer.seller_id IS NOT DISTINCT FROM public.current_seller_id()
                 THEN 'seller' ELSE 'owner' END;

  UPDATE storefront_offers
  SET    status             = 'countered',
         counter_price      = p_counter_price,
         countered_at       = now(),
         counter_expires_at = v_expires,
         countered_by_role  = v_role
  WHERE  id = p_offer_id;

  RETURN json_build_object(
    'offer_id',           p_offer_id,
    'counter_price',      p_counter_price,
    'counter_expires_at', v_expires
  );
END;
$function$;

CREATE OR REPLACE FUNCTION public._offer_message_card()
 RETURNS trigger
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO 'public', 'pg_temp'
AS $function$
DECLARE
  v_kind    text;
  v_amount  numeric;
  v_body    text;
  v_label   text;
  v_conv_id uuid;
  v_name    text;
BEGIN
  IF TG_OP = 'INSERT' THEN
    IF NEW.status <> 'pending' THEN
      RETURN NEW;
    END IF;
    v_kind := 'offer_made';
  ELSIF NEW.status IS DISTINCT FROM OLD.status THEN
    IF NEW.status = 'countered' THEN
      v_kind := 'offer_countered';
    ELSIF OLD.status = 'countered' THEN
      v_kind := CASE
                  WHEN NEW.status = 'accepted'  THEN 'counter_accepted'
                  WHEN NEW.status = 'declined' AND NEW.responded_by_role = 'system'
                                                THEN 'offer_declined'
                  WHEN NEW.status = 'declined'  THEN 'counter_declined'
                  WHEN NEW.status = 'expired'   THEN 'counter_expired'
                  WHEN NEW.status = 'withdrawn' THEN 'offer_withdrawn'
                END;
    ELSE
      v_kind := CASE NEW.status
                  WHEN 'accepted'  THEN 'offer_accepted'
                  WHEN 'declined'  THEN 'offer_declined'
                  WHEN 'expired'   THEN 'offer_expired'
                  WHEN 'withdrawn' THEN 'offer_withdrawn'
                END;
    END IF;
  END IF;

  IF v_kind IS NULL THEN
    RETURN NEW;
  END IF;

  BEGIN
    v_amount := CASE WHEN v_kind IN ('offer_countered', 'counter_accepted',
                                     'counter_declined', 'counter_expired')
                     THEN NEW.counter_price
                     ELSE NEW.offered_price
                END;
    v_label := public._offer_card_label(v_amount);
    v_body  := CASE v_kind
                 WHEN 'offer_made'       THEN 'Offer made: '               || v_label
                 WHEN 'offer_accepted'   THEN 'Offer accepted: '           || v_label
                 WHEN 'offer_declined'   THEN 'Offer declined: '           || v_label
                 WHEN 'offer_expired'    THEN 'Offer expired: '            || v_label
                 WHEN 'offer_withdrawn'  THEN 'Offer withdrawn: '          || v_label
                 WHEN 'offer_countered'  THEN 'Counter-offer: '            || v_label
                 WHEN 'counter_accepted' THEN 'Counter-offer accepted: '   || v_label
                 WHEN 'counter_declined' THEN 'Counter-offer declined: '   || v_label
                 WHEN 'counter_expired'  THEN 'Counter-offer expired: '    || v_label
               END;

    SELECT id INTO v_conv_id
    FROM   public.conversations
    WHERE  inventory_item_id = NEW.inventory_item_id
      AND  buyer_id          = NEW.buyer_id;

    IF v_conv_id IS NULL THEN
      SELECT NULLIF(split_part(btrim(display_name), ' ', 1), '')
      INTO   v_name
      FROM   public.buyers
      WHERE  id = NEW.buyer_id;

      INSERT INTO public.conversations (inventory_item_id, buyer_id, seller_id, buyer_first_name)
      VALUES (NEW.inventory_item_id, NEW.buyer_id, NEW.seller_id, left(v_name, 50))
      ON CONFLICT (inventory_item_id, buyer_id) DO NOTHING
      RETURNING id INTO v_conv_id;

      IF v_conv_id IS NULL THEN
        SELECT id INTO v_conv_id
        FROM   public.conversations
        WHERE  inventory_item_id = NEW.inventory_item_id
          AND  buyer_id          = NEW.buyer_id;
      END IF;
    END IF;

    INSERT INTO public.messages
      (conversation_id, sender_role, sender_user_id, body, kind, offer_id, offer_amount)
    VALUES
      (v_conv_id, 'system', NULL, v_body, v_kind, NEW.id, v_amount)
    ON CONFLICT (offer_id, kind) WHERE offer_id IS NOT NULL DO NOTHING;

    UPDATE public.conversations
    SET    last_message_at = now()
    WHERE  id = v_conv_id;
  EXCEPTION WHEN OTHERS THEN
    RAISE WARNING '[offer card] offer % kind % failed: % (%)', NEW.id, v_kind, SQLERRM, SQLSTATE;
  END;

  RETURN NEW;
END;
$function$;

-- 4. Invoices: no buyer-currency block.
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
      'currency', 'EUR'
    )
  )
  RETURNING id INTO v_id;
  RETURN v_id;
END;
$function$;

-- 5. Earnings: no own currency margin any more.
CREATE OR REPLACE FUNCTION public.earnings_report(p_from date, p_to date)
RETURNS json
LANGUAGE plpgsql
STABLE
SECURITY DEFINER
SET search_path = public, pg_temp
AS $$
DECLARE
  v json;
BEGIN
  IF NOT public.is_owner() THEN
    RAISE EXCEPTION 'Only the owner can see earnings.';
  END IF;

  WITH base AS (
    SELECT o.id, o.order_number, o.paid_at, o.status, o.payout_kind,
           o.payout_status, o.order_total, o.tax_amount, o.seller_payout,
           o.stripe_fee, o.postage_paid, o.eur_received,
           coalesce((SELECT sum(r.amount - r.tax_amount) FROM order_refunds r WHERE r.order_id = o.id), 0)
         + coalesce((SELECT sum(rt.refund_amount - coalesce(rt.refund_tax, 0)) FROM returns rt
                     WHERE rt.order_id = o.id AND rt.status = 'refunded'), 0) AS refunded,
           coalesce((SELECT sum(r.tax_amount) FROM order_refunds r WHERE r.order_id = o.id), 0)
         + coalesce((SELECT sum(coalesce(rt.refund_tax, 0)) FROM returns rt
                     WHERE rt.order_id = o.id AND rt.status = 'refunded'), 0) AS refunded_vat,
           coalesce((SELECT sum(c.amount) FROM owner_charges c WHERE c.order_id = o.id), 0) AS recovered,
           (SELECT sum(coalesce(i.cost_price, 0) * oi.quantity) FROM order_items oi
              JOIN inventory_items i ON i.id = oi.inventory_item_id WHERE oi.order_id = o.id) AS cost,
           (SELECT i.title FROM order_items oi JOIN inventory_items i ON i.id = oi.inventory_item_id
             WHERE oi.order_id = o.id LIMIT 1) AS stone
    FROM   orders o
    WHERE  o.sale_channel = 'platform'
      AND  o.paid_at IS NOT NULL
      AND  o.status IN ('paid', 'confirmed', 'shipped', 'received', 'refunded')
      AND  (o.paid_at AT TIME ZONE 'Europe/Amsterdam')::date >= p_from
      AND  (o.paid_at AT TIME ZONE 'Europe/Amsterdam')::date <  p_to
  ), calc AS (
    SELECT b.*,
           CASE WHEN b.payout_kind IN ('commission', 'consignment')
                 AND (b.status <> 'refunded' OR b.payout_status = 'paid')
                THEN coalesce(b.seller_payout, 0) ELSE 0 END AS payout,
           coalesce(b.stripe_fee, 0) AS fee,
           coalesce(b.postage_paid, 0) AS postage,
           CASE WHEN b.payout_kind = 'own' AND b.status <> 'refunded'
                THEN coalesce(b.cost, 0) ELSE 0 END AS stone_cost
    FROM base b
  ), rows AS (
    SELECT c.*,
           c.order_total - c.refunded - c.payout + c.recovered - c.fee - c.postage
             - c.stone_cost AS earned,
           c.tax_amount - c.refunded_vat AS vat
    FROM calc c
  )
  SELECT json_build_object(
    'totals', (SELECT json_build_object(
        'orders',      count(*),
        'sales',       coalesce(sum(order_total), 0),
        'refunded',    coalesce(sum(refunded), 0),
        'payout',      coalesce(sum(payout), 0),
        'payout_paid', coalesce(sum(payout) FILTER (WHERE payout_status = 'paid'), 0),
        'recovered',   coalesce(sum(recovered), 0),
        'stripe_fee',  coalesce(sum(fee), 0),
        'postage',     coalesce(sum(postage), 0),
        'stone_cost',  coalesce(sum(stone_cost), 0),
        'earned',      coalesce(sum(earned), 0),
        'vat',         coalesce(sum(vat), 0),
        'fee_pending', count(*) FILTER (WHERE stripe_fee IS NULL),
        'cost_missing', count(*) FILTER (WHERE payout_kind = 'own' AND status <> 'refunded' AND coalesce(cost, 0) = 0)
      ) FROM rows),
    'orders', (SELECT coalesce(json_agg(json_build_object(
        'order_id', id, 'order_number', order_number, 'paid_at', paid_at, 'status', status,
        'kind', payout_kind, 'stone', stone, 'sales', order_total, 'refunded', refunded,
        'payout', payout, 'payout_paid', payout_status = 'paid', 'recovered', recovered,
        'stripe_fee', stripe_fee, 'postage', postage, 'stone_cost', stone_cost,
        'earned', earned, 'vat', vat,
        'cost_missing', payout_kind = 'own' AND status <> 'refunded' AND coalesce(cost, 0) = 0
      ) ORDER BY paid_at DESC), '[]') FROM rows)
  ) INTO v;
  RETURN v;
END;
$$;

-- 6. Buyers read their offers in euros.
DROP VIEW IF EXISTS public.buyer_offers;
CREATE VIEW public.buyer_offers AS
 SELECT id,
    inventory_item_id,
    offered_price,
    status,
    counter_price,
    counter_expires_at,
    created_at,
    responded_at
   FROM storefront_offers o
  WHERE buyer_id = auth.uid();
REVOKE ALL ON public.buyer_offers FROM PUBLIC, anon;
GRANT SELECT ON public.buyer_offers TO authenticated;

-- 7. Helpers and the rates table of the old layer.
DROP FUNCTION IF EXISTS public._offer_local_label(numeric, text);
DROP FUNCTION IF EXISTS public._local_price(numeric, numeric, numeric);
DROP TABLE IF EXISTS public.fx_rates;

-- 8. The columns of the old layer.
ALTER TABLE public.orders DROP CONSTRAINT IF EXISTS orders_charge_currency_check;
ALTER TABLE public.orders
  DROP COLUMN IF EXISTS charge_currency,
  DROP COLUMN IF EXISTS charge_rate,
  DROP COLUMN IF EXISTS charge_markup,
  DROP COLUMN IF EXISTS charge_shipping,
  DROP COLUMN IF EXISTS charge_amount;
ALTER TABLE public.storefront_offers DROP CONSTRAINT IF EXISTS storefront_offers_currency_check;
ALTER TABLE public.storefront_offers
  DROP COLUMN IF EXISTS offer_currency,
  DROP COLUMN IF EXISTS offer_rate,
  DROP COLUMN IF EXISTS local_offered,
  DROP COLUMN IF EXISTS local_counter;

COMMIT;
