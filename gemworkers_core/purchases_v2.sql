-- GemWorkers — Purchases v2: typed line items + lot inventory support
-- Uses ADD COLUMN IF NOT EXISTS on both purchase_items and inventory_items.
-- Safe to re-run at any time — existing rows get the DEFAULT values.

-- =============================================================================
-- purchase_items: typed line items
-- =============================================================================

-- line_type — 'individual' | 'multiple' | 'lot'
ALTER TABLE purchase_items
  ADD COLUMN IF NOT EXISTS line_type TEXT NOT NULL DEFAULT 'individual';

-- Ensure the check constraint is correct (drop + recreate for idempotency).
ALTER TABLE purchase_items
  DROP CONSTRAINT IF EXISTS purchase_items_line_type_check;
ALTER TABLE purchase_items
  ADD CONSTRAINT purchase_items_line_type_check
  CHECK (line_type IN ('individual', 'multiple', 'lot'));

-- Display name: item name for multiples, lot name for lots.
ALTER TABLE purchase_items ADD COLUMN IF NOT EXISTS item_name      TEXT         NOT NULL DEFAULT '';

-- Gem detail fields (individual lines).
ALTER TABLE purchase_items ADD COLUMN IF NOT EXISTS variety        TEXT         NOT NULL DEFAULT '';
ALTER TABLE purchase_items ADD COLUMN IF NOT EXISTS weight_value   NUMERIC(10,4);
ALTER TABLE purchase_items ADD COLUMN IF NOT EXISTS weight_unit    TEXT         NOT NULL DEFAULT 'ct';
ALTER TABLE purchase_items ADD COLUMN IF NOT EXISTS origin_country TEXT         NOT NULL DEFAULT '';

-- Lot-specific: approximate stone count (also drives cost allocation via quantity).
ALTER TABLE purchase_items ADD COLUMN IF NOT EXISTS approx_count   INTEGER;

-- =============================================================================
-- inventory_items: unsorted lot support
-- =============================================================================

ALTER TABLE inventory_items ADD COLUMN IF NOT EXISTS is_unsorted_lot     BOOLEAN NOT NULL DEFAULT false;
ALTER TABLE inventory_items ADD COLUMN IF NOT EXISTS lot_remaining_count INTEGER;
ALTER TABLE inventory_items ADD COLUMN IF NOT EXISTS parent_lot_id       UUID
  REFERENCES inventory_items(id) ON DELETE SET NULL;

CREATE INDEX IF NOT EXISTS inventory_items_parent_lot_id_idx
  ON inventory_items (parent_lot_id);
