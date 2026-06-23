-- =============================================================================
-- GemWorkers — Specimen & Jewelry Weight Unit Columns
-- =============================================================================
-- Adds unit selectors for the two weight fields that previously had no unit:
--
--   weight_grams_unit       → unit for specimen  weight_grams
--   total_weight_grams_unit → unit for jewelry   total_weight_grams
--
-- These mirror weight_unit on loose stones (which already stores 'ct'/'g'/'kg'
-- with a NOT NULL DEFAULT 'ct'). The new columns allow all three units so that
-- sellers can record, for example, a heavy specimen in kg or a small gemstone
-- cabochon in carats — consistent with the loose-stone picker.
--
-- DEFAULT 'g':
--   Both weight_grams and total_weight_grams were added historically with no
--   unit column, with grams implied by the column name. Defaulting to 'g' keeps
--   every existing row honest (a row with weight_grams = 12.5 and no unit choice
--   now reads as 12.5 g, which matches the original intent) rather than
--   silently coercing old data to 'ct'.
--
-- IDEMPOTENCY:
--   ADD COLUMN IF NOT EXISTS — safe to re-run; a second run is a no-op.
--   CHECK constraints are added inline and are idempotent alongside the column.
-- =============================================================================

ALTER TABLE public.inventory_items
  ADD COLUMN IF NOT EXISTS weight_grams_unit text
    NOT NULL DEFAULT 'g'
    CHECK (weight_grams_unit IN ('ct', 'g', 'kg')),
  ADD COLUMN IF NOT EXISTS total_weight_grams_unit text
    NOT NULL DEFAULT 'g'
    CHECK (total_weight_grams_unit IN ('ct', 'g', 'kg'));
