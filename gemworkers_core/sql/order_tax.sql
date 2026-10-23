-- =============================================================================
-- GemWorkers — Tax at checkout (tax plan step 3)
-- =============================================================================
-- Applied to live DB 2026-10-23
--
-- Rules (Zakaria 2026-10-23, see tax_rules_required_only.sql):
--   • Collect VAT ONLY when the stone ships from inside the destination's
--     customs union (or the same country): NL → EU buyer. Rate = the buyer's
--     country rate (OSS from day one). VAT is charged on goods + shipping.
--   • Everything else: nothing collected; an import estimate is shown as a
--     reminder (paid by the buyer on delivery). mode 'none' or a value under
--     free_below_eur → no reminder.
--   • tax_rules.min_order_eur: orders below it are refused (UK £135 rule).
--
-- Money: orders.order_total is NOT changed (goods + shipping; commission and
-- seller_payout keep using it). The VAT is stored separately in
-- orders.tax_amount and the buyer pays order_total + tax_amount. The VAT
-- belongs to GemWorkers (to pay to the Belastingdienst), never the seller.
--
-- Nothing existing is rewritten: create_platform_order, respond_to_offer,
-- confirm/cancel functions are untouched.
--
-- 1. orders: ship_to_country, tax_scheme, tax_name, tax_rate, tax_amount,
--    import_estimate (all nullable; tax_amount default 0).
-- 2. _tax_calc(origin, dest, product_type, amount) — the one calculation.
-- 3. tax_quote(item_id, ship_to) — public, for the stone page / cart.
-- 4. apply_order_tax(order_ids[], ship_to) — buyer, stamps pending orders
--    right before the Stripe session is created.
-- =============================================================================

BEGIN;

-- 1. Order columns ------------------------------------------------------------
ALTER TABLE public.orders
  ADD COLUMN IF NOT EXISTS ship_to_country text,
  ADD COLUMN IF NOT EXISTS tax_scheme      text
    CHECK (tax_scheme IS NULL OR tax_scheme IN ('domestic','oss','buyer_pays','none')),
  ADD COLUMN IF NOT EXISTS tax_name        text,
  ADD COLUMN IF NOT EXISTS tax_rate        numeric(6,4),
  ADD COLUMN IF NOT EXISTS tax_amount      numeric(10,2) NOT NULL DEFAULT 0
    CHECK (tax_amount >= 0),
  ADD COLUMN IF NOT EXISTS import_estimate numeric(10,2);

COMMENT ON COLUMN public.orders.tax_amount IS
  'VAT collected by GemWorkers (domestic / OSS). Buyer pays order_total + tax_amount. Not part of seller_payout.';
COMMENT ON COLUMN public.orders.import_estimate IS
  'Reminder only: estimated import tax/duty the buyer pays on delivery. Never charged.';

-- 2. The calculation ------------------------------------------------------------
CREATE OR REPLACE FUNCTION public._tax_calc(
  p_origin       text,
  p_dest         text,
  p_product_type text,
  p_amount       numeric
)
RETURNS TABLE (
  scheme          text,
  tax_name        text,
  tax_rate        numeric,
  tax_amount      numeric,
  import_estimate numeric,
  min_order_eur   numeric
)
LANGUAGE plpgsql
STABLE
SET search_path = public
AS $$
DECLARE
  r        public.tax_rules%ROWTYPE;
  v_union  text;
  v_duty   numeric;
  v_extra  numeric;
BEGIN
  SELECT * INTO r FROM public.tax_rules WHERE country_code = p_dest;

  IF NOT FOUND THEN
    -- No rule: buyer pays on delivery, no estimate.
    RETURN QUERY SELECT 'buyer_pays'::text, NULL::text, NULL::numeric, 0::numeric, NULL::numeric, NULL::numeric;
    RETURN;
  END IF;

  SELECT t.customs_union INTO v_union FROM public.tax_rules t WHERE t.country_code = p_origin;

  -- Required VAT: same country, or same customs union (NL → EU).
  IF r.mode = 'collect' AND r.tax_rate IS NOT NULL
     AND (p_origin = p_dest OR (r.customs_union IS NOT NULL AND v_union = r.customs_union)) THEN
    RETURN QUERY SELECT
      CASE WHEN p_origin = p_dest THEN 'domestic' ELSE 'oss' END,
      COALESCE(r.tax_name, 'VAT'),
      r.tax_rate,
      round(p_amount * r.tax_rate, 2),
      NULL::numeric,
      r.min_order_eur;
    RETURN;
  END IF;

  -- Nothing to pay, or under the country's free limit: no reminder.
  IF r.mode = 'none' OR (r.free_below_eur IS NOT NULL AND p_amount < r.free_below_eur) THEN
    RETURN QUERY SELECT 'none'::text, r.tax_name, NULL::numeric, 0::numeric, NULL::numeric, r.min_order_eur;
    RETURN;
  END IF;

  -- Buyer pays on delivery: estimate = duty + import tax on (value + duty).
  v_duty := CASE p_product_type
              WHEN 'jewelry'  THEN r.duty_jewelry
              WHEN 'specimen' THEN r.duty_specimen
              ELSE r.duty_loose
            END;
  SELECT o.extra_duty INTO v_extra FROM public.origin_duties o
  WHERE  o.dest_code = p_dest AND o.origin_code = p_origin;
  IF v_extra IS NOT NULL THEN
    v_duty := COALESCE(v_duty, 0) + v_extra;   -- e.g. US tariff by origin
  END IF;

  RETURN QUERY SELECT
    'buyer_pays'::text,
    r.tax_name,
    r.tax_rate,
    0::numeric,
    CASE
      WHEN v_duty IS NULL AND r.tax_rate IS NULL THEN NULL      -- unknown: reminder without amount
      ELSE round(p_amount * (COALESCE(v_duty, 0)
                             + COALESCE(r.tax_rate, 0) * (1 + COALESCE(v_duty, 0))), 2)
    END,
    r.min_order_eur;
END;
$$;

REVOKE ALL ON FUNCTION public._tax_calc(text, text, text, numeric) FROM PUBLIC, anon, authenticated;

-- 3. Quote for display (stone page / cart) ------------------------------------
-- Uses the listed price + the stone's shipping. Only listed, available stones.
CREATE OR REPLACE FUNCTION public.tax_quote(p_item_id uuid, p_ship_to text)
RETURNS TABLE (
  scheme          text,
  tax_name        text,
  tax_rate        numeric,
  tax_amount      numeric,
  import_estimate numeric,
  min_order_eur   numeric,
  goods_total     numeric
)
LANGUAGE plpgsql
STABLE
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_origin text;
  v_type   text;
  v_amount numeric;
BEGIN
  SELECT s.country, i.product_type,
         COALESCE(i.selling_price, 0) + COALESCE(i.shipping_cost, 0)
  INTO   v_origin, v_type, v_amount
  FROM   public.inventory_items i
  JOIN   public.sellers s ON s.id = i.seller_id
  WHERE  i.id = p_item_id
    AND  i.is_listed = true;

  IF NOT FOUND THEN
    RETURN;
  END IF;

  RETURN QUERY
  SELECT c.scheme, c.tax_name, c.tax_rate, c.tax_amount, c.import_estimate, c.min_order_eur, v_amount
  FROM   public._tax_calc(v_origin, upper(p_ship_to), v_type, v_amount) c;
END;
$$;

REVOKE ALL ON FUNCTION public.tax_quote(uuid, text) FROM PUBLIC;
GRANT EXECUTE ON FUNCTION public.tax_quote(uuid, text) TO anon, authenticated;

-- 4. Stamp the buyer's pending orders -----------------------------------------
-- Called right before the Stripe session; recalculated on every call (the
-- buyer may change "Ship to" between attempts). Refuses orders under the
-- destination's minimum. Returns the total VAT across the orders.
CREATE OR REPLACE FUNCTION public.apply_order_tax(p_order_ids uuid[], p_ship_to text)
RETURNS numeric
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_dest  text := upper(trim(p_ship_to));
  v_name  text;
  o       record;
  c       record;
  v_total numeric := 0;
BEGIN
  IF auth.uid() IS NULL THEN
    RAISE EXCEPTION 'Not signed in';
  END IF;

  SELECT name INTO v_name FROM public.shipping_countries WHERE code = v_dest AND enabled;
  IF NOT FOUND THEN
    RAISE EXCEPTION 'We don''t ship to this country.';
  END IF;

  FOR o IN
    SELECT ord.id, ord.order_total, s.country AS origin,
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
    SELECT * INTO c FROM public._tax_calc(o.origin, v_dest, o.product_type, o.order_total);

    IF c.min_order_eur IS NOT NULL AND o.order_total < c.min_order_eur THEN
      RAISE EXCEPTION 'Orders shipped to % must be at least €%.', v_name,
        CASE WHEN c.min_order_eur = trunc(c.min_order_eur)
             THEN trunc(c.min_order_eur)::text ELSE c.min_order_eur::text END;
    END IF;

    UPDATE public.orders
    SET    ship_to_country = v_dest,
           tax_scheme      = c.scheme,
           tax_name        = c.tax_name,
           tax_rate        = c.tax_rate,
           tax_amount      = c.tax_amount,
           import_estimate = c.import_estimate
    WHERE  id = o.id;

    v_total := v_total + c.tax_amount;
  END LOOP;

  RETURN v_total;
END;
$$;

REVOKE ALL ON FUNCTION public.apply_order_tax(uuid[], text) FROM PUBLIC, anon;
GRANT EXECUTE ON FUNCTION public.apply_order_tax(uuid[], text) TO authenticated;

COMMIT;

-- VERIFICATION (read-only):
--   SELECT column_name FROM information_schema.columns
--   WHERE table_name = 'orders' AND column_name LIKE 'tax%';
--   SELECT * FROM _tax_calc('NL','DE','loose',100);   -- oss 19% → 19.00
--   SELECT * FROM _tax_calc('TH','DE','loose',100);   -- buyer_pays, estimate
--   SELECT * FROM _tax_calc('NL','US','jewelry',100); -- buyer_pays, est. 20.50
