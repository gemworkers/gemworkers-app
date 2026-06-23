-- structured_dimensions.sql
--
-- Adds structured numeric dimension columns to inventory_items, replacing
-- the retired free-text dimensions_mm field for loose stones and specimens.
--
-- Notes:
--   - length, width, height are nullable; dimensions are optional per item.
--   - dimension_unit defaults to 'mm' (gemstone industry standard); CHECK
--     constraint limits values to 'mm' or 'cm'.
--   - The old free-text column dimensions_mm is intentionally LEFT in place
--     (retired from the UI, not dropped) — this migration does not touch it.
--   - Scoping to loose_stone / specimen types is handled at the app layer;
--     jewelry uses size_or_length and is unaffected — no DB-level enforcement
--     is needed here.
--   - All four columns use ADD COLUMN IF NOT EXISTS for idempotency.

ALTER TABLE public.inventory_items
  ADD COLUMN IF NOT EXISTS length         numeric,
  ADD COLUMN IF NOT EXISTS width          numeric,
  ADD COLUMN IF NOT EXISTS height         numeric,
  ADD COLUMN IF NOT EXISTS dimension_unit text
    NOT NULL DEFAULT 'mm'
    CHECK (dimension_unit IN ('mm', 'cm'));
