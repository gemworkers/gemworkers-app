-- ============================================================================
-- GemWorkers — EU standard VAT rates checked against the official EU list
-- (europa.eu Your Europe "VAT rates", last checked by the EU 13/07/2026),
-- compared 2026-10-30: all 27 match. Marks a country verified ONLY when its
-- rate is exactly the official one. Next check: January + July, and before the
-- OSS start (2027-01-01). Applied to live DB 2026-10-30 (verified: 27 verified, 0 not). Safe to run twice.
-- ============================================================================

UPDATE public.tax_rules t
SET verified   = true,
    notes      = trim(both ' ' from coalesce(t.notes, '') ||
                 CASE WHEN coalesce(t.notes, '') LIKE '%EU list 2026-10-30%' THEN ''
                      ELSE ' · Standard rate checked vs EU list 2026-10-30.' END),
    updated_at = now()
FROM (VALUES
  ('AT', 0.20), ('BE', 0.21), ('BG', 0.20), ('CY', 0.19), ('CZ', 0.21), ('DE', 0.19),
  ('DK', 0.25), ('EE', 0.24), ('GR', 0.24), ('ES', 0.21), ('FI', 0.255), ('FR', 0.20),
  ('HR', 0.25), ('HU', 0.27), ('IE', 0.23), ('IT', 0.22), ('LT', 0.21), ('LU', 0.17),
  ('LV', 0.21), ('MT', 0.18), ('NL', 0.21), ('PL', 0.23), ('PT', 0.23), ('RO', 0.21),
  ('SE', 0.25), ('SI', 0.22), ('SK', 0.23)
) AS official(code, rate)
WHERE t.country_code = official.code
  AND t.tax_rate = official.rate;

-- Check: 27 rows verified, 0 EU rows unverified
SELECT count(*) FILTER (WHERE verified) AS verified_eu,
       count(*) FILTER (WHERE NOT verified) AS not_verified_eu
FROM public.tax_rules
WHERE customs_union = 'EU';
