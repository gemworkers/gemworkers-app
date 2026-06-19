-- =============================================================================
-- GemWorkers — Shipping Information Columns
-- =============================================================================
-- Adds five per-stone shipping fields to inventory_items, captured at listing
-- time in the Flutter listing sheet and exposed on the public storefront.
--
-- All columns are nullable with no defaults:
--   • Existing listed stones get NULL across all five — storefront degrades
--     gracefully (Shipping section omitted; no "€0" or "0 days" shown).
--   • shipping_cost = 0   → free shipping (an intentional seller choice).
--   • shipping_cost = NULL → not specified ("Contact seller").
--   • delivery_days_min / delivery_days_max form a range ("5–10 days").
--     min-only → "From N days". Both NULL → omit delivery row.
--   • prep_days → handling time before dispatch. NULL → omit.
--   • courier → free text (DHL, Royal Mail, etc.). NULL → omit.
--
-- No CHECK constraints — values are validated in the Flutter UI.
-- Idempotent: ADD COLUMN IF NOT EXISTS is safe to run on the live DB.
-- =============================================================================

ALTER TABLE public.inventory_items
  ADD COLUMN IF NOT EXISTS courier           text,
  ADD COLUMN IF NOT EXISTS shipping_cost     numeric(10,2),
  ADD COLUMN IF NOT EXISTS delivery_days_min integer,
  ADD COLUMN IF NOT EXISTS delivery_days_max integer,
  ADD COLUMN IF NOT EXISTS prep_days         integer;
