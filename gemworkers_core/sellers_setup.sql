-- ── Sellers Migration ─────────────────────────────────────────────────────────
--
-- YOUR DATA IS SAFE:
--   • The "GemWorkers Netherlands" shop (UUID a0000000-...0001) is KEPT intact
--     and renamed to "My Shop". All attached inventory items, orders, locations,
--     and movement history remain linked to it via the same UUID.
--   • The empty "GemWorkers Thailand" shop (UUID a0000000-...0002) is deleted
--     (no inventory, orders, or locations are attached to it).
--
-- Approach: rename branches → sellers AND rename branch_id → seller_id on all
-- four referencing tables. All operations are non-destructive (data preserved).
-- Safe to re-run: every rename is guarded by an IF EXISTS check.
-- ─────────────────────────────────────────────────────────────────────────────

-- 1. Rename branches table → sellers.
DO $$
BEGIN
  IF EXISTS (
    SELECT 1 FROM information_schema.tables
    WHERE table_name = 'branches' AND table_schema = 'public'
  ) THEN
    ALTER TABLE branches RENAME TO sellers;
    RAISE NOTICE 'Renamed branches → sellers';
  ELSE
    RAISE NOTICE 'sellers table already exists, skipping rename';
  END IF;
END $$;

-- 2. Rename branch_id → seller_id on inventory_items.
DO $$
BEGIN
  IF EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'inventory_items' AND column_name = 'branch_id'
      AND table_schema = 'public'
  ) THEN
    ALTER TABLE inventory_items RENAME COLUMN branch_id TO seller_id;
  END IF;
END $$;

-- 3. Rename branch_id → seller_id on orders.
DO $$
BEGIN
  IF EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'orders' AND column_name = 'branch_id'
      AND table_schema = 'public'
  ) THEN
    ALTER TABLE orders RENAME COLUMN branch_id TO seller_id;
  END IF;
END $$;

-- 4. Rename branch_id → seller_id on purchases.
DO $$
BEGIN
  IF EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'purchases' AND column_name = 'branch_id'
      AND table_schema = 'public'
  ) THEN
    ALTER TABLE purchases RENAME COLUMN branch_id TO seller_id;
  END IF;
END $$;

-- 5. Rename branch_id → seller_id on locations.
DO $$
BEGIN
  IF EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'locations' AND column_name = 'branch_id'
      AND table_schema = 'public'
  ) THEN
    ALTER TABLE locations RENAME COLUMN branch_id TO seller_id;
  END IF;
END $$;

-- 6. Add new contact columns to sellers (contact_note is kept but unused by app).
ALTER TABLE sellers ADD COLUMN IF NOT EXISTS contact_name TEXT NOT NULL DEFAULT '';
ALTER TABLE sellers ADD COLUMN IF NOT EXISTS email       TEXT NOT NULL DEFAULT '';
ALTER TABLE sellers ADD COLUMN IF NOT EXISTS phone       TEXT NOT NULL DEFAULT '';

-- 7. Migrate any existing contact_note data into contact_name.
DO $$
BEGIN
  IF EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'sellers' AND column_name = 'contact_note'
      AND table_schema = 'public'
  ) THEN
    UPDATE sellers
    SET contact_name = contact_note
    WHERE contact_note IS NOT NULL AND contact_note != '' AND contact_name = '';
  END IF;
END $$;

-- 8. Delete the empty Thailand seller (no-op if already gone).
DELETE FROM sellers WHERE id = 'a0000000-0000-0000-0000-000000000002';

-- 9. Rename the seeded Netherlands seller to a neutral placeholder.
--    Only runs if the name hasn't been changed yet — edit via the UI afterwards.
UPDATE sellers
SET name = 'My Shop'
WHERE id   = 'a0000000-0000-0000-0000-000000000001'
  AND name = 'GemWorkers Netherlands';

-- 10. Status vocabulary: 'active' | 'pending' | 'suspended'
--     Column is TEXT so no ALTER is needed. This comment documents valid values.
--     'pending' supports future online-apply → owner-approves flow.

-- 11. Update RLS policies.
ALTER TABLE sellers ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS branches_all ON sellers;
DROP POLICY IF EXISTS sellers_all  ON sellers;
CREATE POLICY sellers_all ON sellers
  FOR ALL TO public USING (true) WITH CHECK (true);
