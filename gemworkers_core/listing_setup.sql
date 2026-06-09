-- Adds marketplace listing columns to inventory_items.
-- is_listed feeds a future public marketplace storefront (per-seller visibility).
-- Safe to re-run: ADD COLUMN IF NOT EXISTS will skip existing columns.

ALTER TABLE inventory_items
  ADD COLUMN IF NOT EXISTS is_listed     BOOLEAN        NOT NULL DEFAULT false,
  ADD COLUMN IF NOT EXISTS selling_price NUMERIC(12,2),
  ADD COLUMN IF NOT EXISTS listed_at     TIMESTAMPTZ;
