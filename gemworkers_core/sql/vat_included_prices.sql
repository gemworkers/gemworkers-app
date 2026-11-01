-- ============================================================================
-- GemWorkers — One price, VAT included (option B, Zakaria 2026-11-01)
-- 2026-11-01 · money change: run sql/tests/run_money_tests.js before + after.
-- ============================================================================
-- The price a seller enters (and its shipping) is the FINAL price for every
-- buyer. Where GemWorkers must charge VAT (stone ships from NL to an EU
-- consumer: 'domestic' / 'oss'), the VAT is taken OUT of that price instead of
-- added on top:  VAT = round(price × rate / (1 + rate), 2).
--   * The buyer pays exactly the shown price (orders.order_total + tax_amount).
--   * orders.order_total / shipping_cost become the amounts EXCLUDING VAT, as
--     before — so invoices, earnings, refunds, payouts and the money check work
--     unchanged on the same figures.
--   * Verified EU business (reverse charge, 0% VAT): pays the price minus the
--     Dutch VAT it contains (they reclaim nothing, so they get the net price).
--   * Everyone else (exports, TH/PK stones): pays the price, no VAT — as now.
-- orders.gross_total / gross_shipping keep the original price so a second
-- apply_order_tax (buyer goes back and pays again) gives the same result.
-- apply_order_tax: live definition + only the VAT-split lines changed.
-- Applied to live DB 2026-11-01 (verified: 2 columns, vat_inside true; money tests 42/42).
-- ============================================================================

BEGIN;

ALTER TABLE public.orders ADD COLUMN IF NOT EXISTS gross_total    numeric(12,2);
ALTER TABLE public.orders ADD COLUMN IF NOT EXISTS gross_shipping numeric(12,2);
COMMENT ON COLUMN public.orders.gross_total IS
  'Price incl. any VAT as shown to the buyer (goods + shipping), set by apply_order_tax. sql/vat_included_prices.sql';
COMMENT ON COLUMN public.orders.gross_shipping IS
  'Shipping incl. any VAT as shown to the buyer, set by apply_order_tax. sql/vat_included_prices.sql';

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
    SELECT ord.id, ord.order_total, ord.shipping_cost, ord.gross_total, ord.gross_shipping,
           s.country AS origin,
           (SELECT i.product_type FROM public.order_items oi
              JOIN public.inventory_items i ON i.id = oi.inventory_item_id
             WHERE oi.order_id = ord.id LIMIT 1) AS product_type
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

    IF c.min_order_eur IS NOT NULL AND v_gross < c.min_order_eur THEN
      RAISE EXCEPTION 'Orders shipped to % must be at least €%.', v_name,
        CASE WHEN c.min_order_eur = trunc(c.min_order_eur)
             THEN trunc(c.min_order_eur)::text ELSE c.min_order_eur::text END;
    END IF;

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

    UPDATE public.orders
    SET    ship_to_country  = v_dest,
           tax_scheme       = c.scheme,
           tax_name         = c.tax_name,
           tax_rate         = c.tax_rate,
           tax_amount       = v_tax,
           gross_total      = v_gross,
           gross_shipping   = v_gship,
           order_total      = v_gross - v_tax - v_strip,
           shipping_cost    = CASE WHEN v_rate > 0 THEN round(v_gship / (1 + v_rate), 2) ELSE v_gship END,
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

-- Check: both columns exist, function has the VAT-inside split
SELECT
  (SELECT count(*) FROM information_schema.columns WHERE table_name = 'orders' AND column_name IN ('gross_total', 'gross_shipping')) AS new_columns,
  position('v_gross * v_rate / (1 + v_rate)' IN pg_get_functiondef('public.apply_order_tax(uuid[], text)'::regprocedure)) > 0 AS vat_inside;

COMMIT;
