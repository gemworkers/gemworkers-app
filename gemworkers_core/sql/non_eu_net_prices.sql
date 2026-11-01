-- ============================================================================
-- GemWorkers — Buyers outside the EU pay the price WITHOUT VAT, rounded up
-- (Zakaria 2026-11-01) · money change: run sql/tests/run_money_tests.js before + after.
-- ============================================================================
-- Builds on sql/vat_included_prices.sql (one price, VAT included). For a stone
-- that ships from an EU country (NL, so the entered price contains Dutch VAT)
-- to a buyer OUTSIDE the EU (export — no VAT), the buyer pays:
--   unit price  = entered price ÷ (1 + VAT rate), rounded to cents, then
--                 rounded UP to the next €10 (below €20: up to the next €1)
--                 × quantity
--   shipping    = entered shipping ÷ (1 + VAT rate), rounded UP to the next €1
-- e.g. €395 → €326.45 → €330; €12.10 shipping → €10.
-- Same rule as the store's display (lib/price-shown.ts netRound / shipRound).
-- Offers are not changed: what a buyer offers is what they pay.
-- Stones from TH/PK: no VAT inside, price unchanged (as before).
-- The UK minimum order now compares with what the buyer actually pays.
-- apply_order_tax: the sql/vat_included_prices.sql version + the export lines.
-- Applied to live DB 2026-11-01 (verified: 395→330, 18.15→15, export rounding live; money tests 43/43).
-- ============================================================================

BEGIN;

-- Rounding up for prices without VAT (stone unit price and shipping).
CREATE OR REPLACE FUNCTION public._net_price_round(p numeric)
RETURNS numeric
LANGUAGE sql IMMUTABLE
AS $$
  SELECT CASE WHEN p >= 20 THEN ceil(p / 10) * 10 ELSE ceil(p) END;
$$;

CREATE OR REPLACE FUNCTION public.apply_order_tax(p_order_ids uuid[], p_ship_to text)
 RETURNS numeric
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO 'public'
AS $function$
DECLARE
  v_dest  text := upper(trim(p_ship_to));
  v_name  text;
  o       record;
  c       record;
  b       public.buyer_business%ROWTYPE;
  v_vatc  text;
  v_total numeric := 0;
  v_gross numeric;
  v_gship numeric;
  v_rate  numeric;
  v_tax   numeric;
  v_strip numeric;
  v_orate numeric;   -- VAT rate inside the price (EU origin), for exports
  v_net   numeric;   -- final order_total
  v_snet  numeric;   -- final shipping_cost
BEGIN
  IF auth.uid() IS NULL THEN
    RAISE EXCEPTION 'Not signed in';
  END IF;

  SELECT name INTO v_name FROM public.shipping_countries WHERE code = v_dest AND enabled;
  IF NOT FOUND THEN
    RAISE EXCEPTION 'We don''t ship to this country.';
  END IF;

  SELECT * INTO b FROM public.buyer_business WHERE buyer_id = auth.uid();
  v_vatc := public._buyer_vat_country(auth.uid());

  FOR o IN
    SELECT ord.id, ord.order_total, ord.shipping_cost, ord.gross_total, ord.gross_shipping, ord.offer_id,
           s.country AS origin,
           (SELECT i.product_type FROM public.order_items oi
              JOIN public.inventory_items i ON i.id = oi.inventory_item_id
             WHERE oi.order_id = ord.id LIMIT 1) AS product_type,
           (SELECT oi.price_at_sale FROM public.order_items oi WHERE oi.order_id = ord.id LIMIT 1) AS unit_price,
           (SELECT coalesce(oi.quantity, 1) FROM public.order_items oi WHERE oi.order_id = ord.id LIMIT 1) AS qty
    FROM   public.orders ord
    LEFT JOIN public.sellers s ON s.id = ord.seller_id
    WHERE  ord.id = ANY(p_order_ids)
      AND  ord.buyer_id = auth.uid()
      AND  ord.status = 'pending_payment'
    FOR UPDATE OF ord
  LOOP
    -- The price as shown (first time: the order as created; later: kept).
    v_gross := coalesce(o.gross_total, o.order_total);
    v_gship := coalesce(o.gross_shipping, o.shipping_cost, 0);

    SELECT * INTO c FROM public._tax_calc(o.origin, v_dest, o.product_type, v_gross, v_vatc);

    -- VAT is inside the price: take it out (sql/vat_included_prices.sql).
    v_rate := CASE
                WHEN c.scheme IN ('domestic', 'oss') THEN coalesce(c.tax_rate, 0)
                WHEN c.scheme = 'reverse_charge'
                  THEN coalesce((SELECT tr.tax_rate FROM public.tax_rules tr WHERE tr.country_code = o.origin), 0)
                ELSE 0
              END;
    v_tax   := CASE WHEN c.scheme IN ('domestic', 'oss') AND v_rate > 0
                    THEN round(v_gross * v_rate / (1 + v_rate), 2) ELSE 0 END;
    v_strip := CASE WHEN c.scheme = 'reverse_charge' AND v_rate > 0
                    THEN round(v_gross * v_rate / (1 + v_rate), 2) ELSE 0 END;
    v_net   := v_gross - v_tax - v_strip;
    v_snet  := CASE WHEN v_rate > 0 THEN round(v_gship / (1 + v_rate), 2) ELSE v_gship END;

    -- Export from the EU (buyer outside the EU): no VAT, the price without it,
    -- rounded up (sql/non_eu_net_prices.sql). Not for accepted offers.
    IF c.scheme NOT IN ('domestic', 'oss', 'reverse_charge') AND o.offer_id IS NULL THEN
      SELECT tr.tax_rate INTO v_orate FROM public.tax_rules tr
      WHERE  tr.country_code = o.origin AND tr.customs_union = 'EU' AND tr.mode = 'collect';
      IF coalesce(v_orate, 0) > 0 AND o.unit_price IS NOT NULL THEN
        v_snet := CASE WHEN v_gship > 0 THEN ceil(round(v_gship / (1 + v_orate), 2)) ELSE 0 END;
        v_net  := public._net_price_round(round(o.unit_price / (1 + v_orate), 2)) * o.qty + v_snet;
      END IF;
    END IF;

    IF c.min_order_eur IS NOT NULL AND v_net < c.min_order_eur THEN
      RAISE EXCEPTION 'Orders shipped to % must be at least €%.', v_name,
        CASE WHEN c.min_order_eur = trunc(c.min_order_eur)
             THEN trunc(c.min_order_eur)::text ELSE c.min_order_eur::text END;
    END IF;

    UPDATE public.orders
    SET    ship_to_country  = v_dest,
           tax_scheme       = c.scheme,
           tax_name         = c.tax_name,
           tax_rate         = c.tax_rate,
           tax_amount       = v_tax,
           gross_total      = v_gross,
           gross_shipping   = v_gship,
           order_total      = v_net,
           shipping_cost    = v_snet,
           import_estimate  = c.import_estimate,
           customer_type    = CASE WHEN b.buyer_id IS NULL THEN 'private' ELSE 'business' END,
           buyer_company    = b.company_name,
           buyer_vat_number = b.vat_number,
           vat_verified     = CASE WHEN b.buyer_id IS NULL THEN NULL ELSE (v_vatc IS NOT NULL) END,
           vies_reference   = b.vies_reference,
           vies_checked_at  = b.vies_checked_at
    WHERE  id = o.id;

    v_total := v_total + v_tax;
  END LOOP;

  RETURN v_total;
END;
$function$;

-- Check: rounding helper works (395 → 330 net, 18.15 → 15), export lines present
SELECT public._net_price_round(round(395 / 1.21, 2)) AS from_395,
       public._net_price_round(round(18.15 / 1.21, 2)) AS from_18_15,
       position('_net_price_round' IN pg_get_functiondef('public.apply_order_tax(uuid[], text)'::regprocedure)) > 0 AS export_rounding;

COMMIT;
