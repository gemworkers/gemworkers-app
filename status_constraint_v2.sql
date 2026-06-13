-- Add 'sorted' to the inventory_items status check constraint.
-- Safe to re-run: drops the old constraint by name before re-adding.

ALTER TABLE inventory_items
  DROP CONSTRAINT IF EXISTS inventory_items_status_check;

ALTER TABLE inventory_items
  ADD CONSTRAINT inventory_items_status_check
  CHECK (status IN ('available', 'reserved', 'sold', 'draft', 'sorted'));
