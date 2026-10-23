-- =============================================================================
-- GemWorkers — Tax rules: collect only what the law requires (tax plan)
-- =============================================================================
-- Applied to live DB 2026-10-23
--
-- Zakaria 2026-10-23: no extra responsibility; only collect taxes that are
-- legally required, otherwise remind the buyer (estimate, paid on delivery).
--
-- Meaning of tax_rules.mode from now on (step 3 implements it):
--   collect    = charge this country's VAT at checkout ONLY when the stone
--                ships from inside the same customs union (EU: from NL).
--                Imports into the EU (from TH / PK) → buyer pays on delivery
--                (no IOSS).
--   buyer_pays = nothing collected; checkout shows a reminder with an
--                estimate ("may be charged on delivery").
--   none       = nothing collected, no reminder (e.g. Hong Kong).
-- EU VAT is always the BUYER'S country rate (voluntary OSS from day one —
-- no €10,000 threshold switching). Accountant to confirm.
--
-- 1. New column tax_rules.min_order_eur — orders below this value are
--    refused for that destination. UK: parcels up to £135 would require UK
--    VAT registration, so UK orders below ~€160 are refused.
-- 2. US and GB → buyer_pays (US duties/tariffs paid by the buyer on delivery).
-- 3. EU-27 stay 'collect' (applies only to stones shipped from NL).
-- =============================================================================

BEGIN;

ALTER TABLE public.tax_rules
  ADD COLUMN IF NOT EXISTS min_order_eur numeric(12,2)
  CHECK (min_order_eur IS NULL OR min_order_eur >= 0);

UPDATE public.tax_rules
SET    mode = 'buyer_pays',
       notes = 'Buyer pays import duties + tariffs to the courier on delivery (no collection by GemWorkers). De minimis suspended 2025; tariffs change often — check.',
       updated_at = now()
WHERE  country_code = 'US';

UPDATE public.tax_rules
SET    mode = 'buyer_pays',
       min_order_eur = 160,
       notes = 'Above £135 the buyer pays UK VAT at the border. Parcels up to £135 would need UK VAT registration, so orders under €160 are refused.',
       updated_at = now()
WHERE  country_code = 'GB';

UPDATE public.tax_rules
SET    notes = trim(both ' ' FROM concat_ws(' ', notes,
         'Collect = buyer''s-country VAT via OSS when shipped from NL; from TH/PK the buyer pays import VAT on delivery.')),
       updated_at = now()
WHERE  customs_union = 'EU'
  AND  (notes IS NULL OR notes NOT LIKE '%via OSS%');

COMMIT;

-- VERIFICATION (read-only):
--   SELECT country_code, mode, min_order_eur FROM tax_rules
--   WHERE  country_code IN ('US','GB','NL','DE') ORDER BY 1;
