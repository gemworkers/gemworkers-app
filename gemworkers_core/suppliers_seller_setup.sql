-- suppliers_seller_setup.sql
-- Adds seller_id to the suppliers table so each supplier belongs to one seller.
-- Safe to re-run (ADD COLUMN IF NOT EXISTS, UPDATE WHERE seller_id IS NULL).
-- Does NOT touch RLS policies.

-- ── Add seller_id column ──────────────────────────────────────────────────────

ALTER TABLE suppliers
  ADD COLUMN IF NOT EXISTS seller_id uuid REFERENCES sellers(id) ON DELETE SET NULL;

-- ── Assign existing suppliers to "My Shop" ────────────────────────────────────
-- Only updates rows that don't already have a seller_id set.

UPDATE suppliers
SET seller_id = 'a0000000-0000-0000-0000-000000000001'
WHERE seller_id IS NULL;

-- ── Verify ────────────────────────────────────────────────────────────────────

-- SELECT id, name, seller_id FROM suppliers;
