-- =============================================================================
-- GemWorkers — Product Types Setup Migration
-- =============================================================================
-- Extends public.inventory_items to support three product types using a
-- single-table design:
--
--   'loose_stone'  individual gemstones (ALL existing inventory → this type)
--   'specimen'     mineral specimens / display pieces
--   'jewelry'      finished jewelry pieces
--
-- BACKWARD COMPATIBILITY
--   Every existing row receives product_type = 'loose_stone' automatically
--   via the column DEFAULT applied at column-creation time. No manual UPDATE
--   is needed. All type-specific columns are NULLABLE, so existing rows are
--   fully valid with NULL in every new field.
--
-- IDEMPOTENCY
--   All ALTER TABLE statements use ADD COLUMN IF NOT EXISTS.
--   The CHECK constraint uses DROP CONSTRAINT IF EXISTS before re-adding,
--   so the entire file can be re-run without error.
--
-- WHAT IS NOT CHANGED
--   Existing columns, column types, indexes, triggers, functions, RLS
--   policies, and the public_listings view are untouched in this step.
-- =============================================================================


-- ─────────────────────────────────────────────────────────────────────────────
-- 1.  PRODUCT TYPE DISCRIMINATOR
-- ─────────────────────────────────────────────────────────────────────────────
-- The DEFAULT 'loose_stone' is applied to all existing rows the moment the
-- column is added, satisfying the NOT NULL constraint without a separate UPDATE.

ALTER TABLE public.inventory_items
  ADD COLUMN IF NOT EXISTS product_type text NOT NULL DEFAULT 'loose_stone';

-- Idempotent CHECK constraint (drop then re-add so re-runs never fail).
ALTER TABLE public.inventory_items
  DROP CONSTRAINT IF EXISTS chk_inventory_product_type;

ALTER TABLE public.inventory_items
  ADD CONSTRAINT chk_inventory_product_type
    CHECK (product_type IN ('loose_stone', 'specimen', 'jewelry'));


-- ─────────────────────────────────────────────────────────────────────────────
-- 2.  SHARED / COMMON COLUMNS
--     Applicable to all three product types. All nullable — existing rows
--     are unaffected.
--
--     Note on 'description': the table already has a 'notes' column used for
--     private/internal notes. 'description' is the separate public-facing
--     item description intended for storefront display.
-- ─────────────────────────────────────────────────────────────────────────────

ALTER TABLE public.inventory_items
  ADD COLUMN IF NOT EXISTS certification_lab    text,
  ADD COLUMN IF NOT EXISTS certification_number text,
  ADD COLUMN IF NOT EXISTS treatment            text,
  ADD COLUMN IF NOT EXISTS dimensions_mm        text,
  ADD COLUMN IF NOT EXISTS description          text,
  ADD COLUMN IF NOT EXISTS video_url            text;


-- ─────────────────────────────────────────────────────────────────────────────
-- 3.  LOOSE STONE – SPECIFIC COLUMNS  (product_type = 'loose_stone')
--
--     Note: the table already has 'cut_type' (e.g. "Round Brilliant") and
--     'shape'. The 'cut' column here is the finish/technique descriptor
--     (e.g. rough, faceted, cabochon, carved) — a separate marketing-facing
--     field from the internal cut_type. Both columns may coexist; the
--     distinction can be enforced at the app layer if needed.
-- ─────────────────────────────────────────────────────────────────────────────

ALTER TABLE public.inventory_items
  ADD COLUMN IF NOT EXISTS cut     text,
  ADD COLUMN IF NOT EXISTS clarity text;


-- ─────────────────────────────────────────────────────────────────────────────
-- 4.  SPECIMEN – SPECIFIC COLUMNS  (product_type = 'specimen')
--
--     Specimens are typically weighed in grams, not carats, so weight_grams
--     is a separate numeric column distinct from the existing weight_value /
--     weight_unit (which continue to serve loose stones in carats/grams/etc.).
-- ─────────────────────────────────────────────────────────────────────────────

ALTER TABLE public.inventory_items
  ADD COLUMN IF NOT EXISTS species      text,
  ADD COLUMN IF NOT EXISTS locality     text,
  ADD COLUMN IF NOT EXISTS matrix       text,
  ADD COLUMN IF NOT EXISTS weight_grams numeric;


-- ─────────────────────────────────────────────────────────────────────────────
-- 5.  JEWELRY – SPECIFIC COLUMNS  (product_type = 'jewelry')
-- ─────────────────────────────────────────────────────────────────────────────

ALTER TABLE public.inventory_items
  ADD COLUMN IF NOT EXISTS jewelry_type       text,
  ADD COLUMN IF NOT EXISTS metal              text,
  ADD COLUMN IF NOT EXISTS metal_purity       text,
  ADD COLUMN IF NOT EXISTS size_or_length     text,
  ADD COLUMN IF NOT EXISTS gemstones_used     text,
  ADD COLUMN IF NOT EXISTS total_weight_grams numeric;
