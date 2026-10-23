-- =============================================================================
-- GemWorkers — Business buyers (B2B) at checkout (tax plan step 3c)
-- =============================================================================
-- Applied to live DB 2026-10-23
--
-- Rules:
--   • A buyer may add business details (company + VAT number). The store
--     checks EU VAT numbers in VIES (server side) and stores the result + the
--     VIES consultation number as proof. Only the server (service role)
--     writes buyer_business — a buyer can never mark themselves "verified".
--   • Stone ships from NL to a business in ANOTHER EU country whose VAT
--     number is VIES-valid (checked within 30 days) and registered in the
--     destination country → 0% VAT, scheme 'reverse_charge' (intra-EU
--     supply: VAT return box 3b + ICP declaration; NOT OSS).
--   • Everything else is unchanged: NL business → 21% domestic; not verified
--     → treated as a private buyer (VAT charged); imports / outside EU → as
--     before.
--   • Every order records who bought: customer_type, company, VAT number,
--     VIES result + consultation number (proof for the tax office).
--
-- _tax_calc / tax_quote / apply_order_tax: copied from the live definitions
-- (order_tax.sql, applied 2026-10-23); only the B2B additions are new.
-- =============================================================================

BEGIN;

-- 1. Business details per buyer -----------------------------------------------
CREATE TABLE IF NOT EXISTS public.buyer_business (
  buyer_id         uuid PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  company_name     text NOT NULL CHECK (length(trim(company_name)) BETWEEN 1 AND 200),
  vat_number       text CHECK (vat_number IS NULL OR vat_number ~ '^[A-Z0-9]{4,20}$'),
  vat_country      text,            -- ISO code of the VAT number (EL → GR)
  vies_valid       boolean NOT NULL DEFAULT false,
  vies_name        text,            -- name VIES returned
  vies_address     text,
  vies_reference   text,            -- VIES consultation number (proof)
  vies_checked_at  timestamptz,
  updated_at       timestamptz NOT NULL DEFAULT now()
);

ALTER TABLE public.buyer_business ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS buyer_business_self_select ON public.buyer_business;
CREATE POLICY buyer_business_self_select ON public.buyer_business
  FOR SELECT TO authenticated USING (buyer_id = auth.uid());

DROP POLICY IF EXISTS buyer_business_owner ON public.buyer_business;
CREATE POLICY buyer_business_owner ON public.buyer_business
  FOR SELECT TO authenticated USING (public.is_owner());

REVOKE INSERT, UPDATE, DELETE ON public.buyer_business FROM anon, authenticated;

-- 2. Order fields ---------------------------------------------------------------
ALTER TABLE public.orders
  ADD COLUMN IF NOT EXISTS customer_type    text CHECK (customer_type IS NULL OR customer_type IN ('private','business')),
  ADD COLUMN IF NOT EXISTS buyer_company    text,
  ADD COLUMN IF NOT EXISTS buyer_vat_number text,
  ADD COLUMN IF NOT EXISTS vat_verified     boolean,
  ADD COLUMN IF NOT EXISTS vies_reference   text,
  ADD COLUMN IF NOT EXISTS vies_checked_at  timestamptz;

ALTER TABLE public.orders DROP CONSTRAINT IF EXISTS orders_tax_scheme_check;
ALTER TABLE public.orders ADD CONSTRAINT orders_tax_scheme_check
  CHECK (tax_scheme IS NULL OR tax_scheme IN ('domestic','oss','reverse_charge','buyer_pays','none'));

-- 3. Verified VAT country of a buyer (NULL = treat as private) ----------------
CREATE OR REPLACE FUNCTION public._buyer_vat_country(p_buyer uuid)
RETURNS text
LANGUAGE sql
STABLE
SET search_path = public
AS $$
  SELECT b.vat_country
  FROM   public.buyer_business b
  WHERE  b.buyer_id = p_buyer
    AND  b.vies_valid
    AND  b.vies_checked_at > now() - interval '30 days';
$$;

REVOKE ALL ON FUNCTION public._buyer_vat_country(uuid) FROM PUBLIC, anon, authenticated;

-- 4. The calculation (+ p_vat_country: verified business VAT country) ---------
DROP FUNCTION IF EXISTS public._tax_calc(text, text, text, numeric);

CREATE OR REPLACE FUNCTION public._tax_calc(
  p_origin       text,
  p_dest         text,
  p_product_type text,
  p_amount       numeric,
  p_vat_country  text DEFAULT NULL
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
    -- Verified business in another EU country: intra-EU supply, reverse charge.
    IF p_origin <> p_dest AND p_vat_country = p_dest THEN
      RETURN QUERY SELECT 'reverse_charge'::text, COALESCE(r.tax_name, 'VAT'), 0::numeric, 0::numeric,
                          NULL::numeric, r.min_order_eur;
      RETURN;
    END IF;
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

REVOKE ALL ON FUNCTION public._tax_calc(text, text, text, numeric, text) FROM PUBLIC, anon, authenticated;

-- 5. Quote for display (+ the signed-in buyer's verified VAT country) ---------
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
  FROM   public._tax_calc(v_origin, upper(p_ship_to), v_type, v_amount,
                          public._buyer_vat_country(auth.uid())) c;
END;
$$;

REVOKE ALL ON FUNCTION public.tax_quote(uuid, text) FROM PUBLIC;
GRANT EXECUTE ON FUNCTION public.tax_quote(uuid, text) TO anon, authenticated;

-- 6. Stamp the buyer's pending orders (+ who bought: private / business) -----
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
  b       public.buyer_business%ROWTYPE;
  v_vatc  text;
  v_total numeric := 0;
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
    SELECT * INTO c FROM public._tax_calc(o.origin, v_dest, o.product_type, o.order_total, v_vatc);

    IF c.min_order_eur IS NOT NULL AND o.order_total < c.min_order_eur THEN
      RAISE EXCEPTION 'Orders shipped to % must be at least €%.', v_name,
        CASE WHEN c.min_order_eur = trunc(c.min_order_eur)
             THEN trunc(c.min_order_eur)::text ELSE c.min_order_eur::text END;
    END IF;

    UPDATE public.orders
    SET    ship_to_country  = v_dest,
           tax_scheme       = c.scheme,
           tax_name         = c.tax_name,
           tax_rate         = c.tax_rate,
           tax_amount       = c.tax_amount,
           import_estimate  = c.import_estimate,
           customer_type    = CASE WHEN b.buyer_id IS NULL THEN 'private' ELSE 'business' END,
           buyer_company    = b.company_name,
           buyer_vat_number = b.vat_number,
           vat_verified     = CASE WHEN b.buyer_id IS NULL THEN NULL ELSE (v_vatc IS NOT NULL) END,
           vies_reference   = b.vies_reference,
           vies_checked_at  = b.vies_checked_at
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
--   SELECT * FROM _tax_calc('NL','DE','loose',100,'DE');  -- reverse_charge, 0
--   SELECT * FROM _tax_calc('NL','DE','loose',100,NULL);  -- oss 19.00
--   SELECT * FROM _tax_calc('NL','NL','loose',100,'NL');  -- domestic 21.00
