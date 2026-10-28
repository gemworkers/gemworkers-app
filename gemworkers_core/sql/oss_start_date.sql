-- =============================================================================
-- GemWorkers — OSS start date: Dutch VAT on EU sales until the Unieregeling starts
-- =============================================================================
-- NOT YET APPLIED
--
-- Zakaria registered for the Unieregeling (OSS, EU scheme) on 2026-10-28,
-- starting next quarter = 2027-01-01. Until then a sale of a stone shipped
-- from NL to a private buyer in another EU country is taxed at the Dutch rate
-- (21%, origin rate — allowed while EU distance sales stay below €10,000 a
-- year) and declared in the NL VAT return (scheme 'domestic'). From the start
-- date the buyer's country rate applies again (scheme 'oss'), automatically.
-- The date lives in store_settings 'oss_start_date' (change it if the
-- Belastingdienst confirms another date; empty = OSS always on).
-- Reverse charge for verified EU businesses is unchanged. Live _tax_calc
-- copied; only the cross-border EU consumer branch changed.
-- =============================================================================

BEGIN;

INSERT INTO public.store_settings (key, value) VALUES ('oss_start_date', '2027-01-01')
ON CONFLICT (key) DO UPDATE SET value = EXCLUDED.value, updated_at = now();

CREATE OR REPLACE FUNCTION public._tax_calc(p_origin text, p_dest text, p_product_type text, p_amount numeric, p_vat_country text DEFAULT NULL::text)
 RETURNS TABLE(scheme text, tax_name text, tax_rate numeric, tax_amount numeric, import_estimate numeric, min_order_eur numeric)
 LANGUAGE plpgsql
 STABLE
 SET search_path TO 'public'
AS $function$
DECLARE
  r        public.tax_rules%ROWTYPE;
  v_union  text;
  v_duty   numeric;
  v_extra  numeric;
  v_oss    date;
  v_orig   public.tax_rules%ROWTYPE;
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
    -- Before the OSS start date (store_settings 'oss_start_date', the date the
    -- Belastingdienst confirms): a sale to a consumer in another EU country is
    -- taxed at the ORIGIN country's rate (allowed below €10,000 a year) and
    -- declared in the NL VAT return ('domestic'). From that date: buyer's rate (OSS).
    SELECT NULLIF(s.value, '')::date INTO v_oss FROM public.store_settings s WHERE s.key = 'oss_start_date';
    IF p_origin <> p_dest AND v_oss IS NOT NULL
       AND (now() AT TIME ZONE 'Europe/Amsterdam')::date < v_oss THEN
      SELECT * INTO v_orig FROM public.tax_rules WHERE country_code = p_origin;
      IF v_orig.tax_rate IS NOT NULL THEN
        RETURN QUERY SELECT 'domestic'::text, COALESCE(v_orig.tax_name, 'VAT'), v_orig.tax_rate,
                            round(p_amount * v_orig.tax_rate, 2), NULL::numeric, r.min_order_eur;
        RETURN;
      END IF;
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
$function$;

COMMIT;
