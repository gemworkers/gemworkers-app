-- locations_v2.sql
-- Extends the locations table with slot_count.
-- Safe to re-run (ADD COLUMN IF NOT EXISTS).
-- Run AFTER branches_locations_setup.sql and sellers_setup.sql.

ALTER TABLE locations ADD COLUMN IF NOT EXISTS slot_count integer;

-- Expand the type CHECK constraint to include the new storage types.
ALTER TABLE locations DROP CONSTRAINT IF EXISTS locations_type_check;
ALTER TABLE locations ADD CONSTRAINT locations_type_check
  CHECK (type IN ('country','shop','zone','unit','slot','other',
                  'safe','cabinet','shelf','drawer','tray','box','section'));
