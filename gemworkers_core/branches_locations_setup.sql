-- GemWorkers — Branches & Locations schema
-- Creates NEW tables: branches, locations, item_movements.
-- Uses ALTER TABLE ... ADD COLUMN IF NOT EXISTS for existing tables.
-- Safe to re-run (DROP IF EXISTS only for the three new tables).
-- Do NOT drop inventory_items, suppliers, customers, orders, or purchases.

-- ── 1. branches ────────────────────────────────────────────────

DROP TABLE IF EXISTS item_movements CASCADE;
DROP TABLE IF EXISTS locations      CASCADE;
DROP TABLE IF EXISTS branches       CASCADE;

CREATE TABLE branches (
  id              UUID           PRIMARY KEY DEFAULT gen_random_uuid(),
  name            TEXT           NOT NULL DEFAULT '',
  country         TEXT           NOT NULL DEFAULT '',
  contact_note    TEXT           NOT NULL DEFAULT '',
  status          TEXT           NOT NULL DEFAULT 'active'
                                   CHECK (status IN ('active', 'suspended')),
  commission_rate NUMERIC(7, 4),   -- e.g. 0.0500 = 5 %
  user_fee        NUMERIC(10, 2),  -- recurring fee in base currency
  user_fee_period TEXT,            -- 'monthly' | 'annual' | 'weekly'
  starting_fee    NUMERIC(10, 2),  -- one-time onboarding fee
  joined_date     DATE,
  notes           TEXT           NOT NULL DEFAULT '',
  created_at      TIMESTAMPTZ    NOT NULL DEFAULT now()
);

-- Fixed predictable UUIDs so seeding is idempotent.
INSERT INTO branches (id, name, country, status, joined_date)
VALUES
  ('a0000000-0000-0000-0000-000000000001',
   'GemWorkers Netherlands', 'NL', 'active', CURRENT_DATE),
  ('a0000000-0000-0000-0000-000000000002',
   'GemWorkers Thailand',    'TH', 'active', CURRENT_DATE)
ON CONFLICT (id) DO NOTHING;

-- ── 2. locations ───────────────────────────────────────────────
--    Any-depth tree via parent_id self-reference.

CREATE TABLE locations (
  id             UUID         PRIMARY KEY DEFAULT gen_random_uuid(),
  branch_id      UUID         NOT NULL REFERENCES branches (id) ON DELETE CASCADE,
  name           TEXT         NOT NULL DEFAULT '',
  code           TEXT         NOT NULL DEFAULT '',
  parent_id      UUID         REFERENCES locations (id) ON DELETE SET NULL,
  type           TEXT         NOT NULL DEFAULT 'other'
                                CHECK (type IN
                                  ('country','shop','zone','unit','slot','other')),
  is_status_zone BOOLEAN      NOT NULL DEFAULT false,
  manager_note   TEXT         NOT NULL DEFAULT '',
  created_at     TIMESTAMPTZ  NOT NULL DEFAULT now()
);

CREATE INDEX locations_branch_id_idx ON locations (branch_id);
CREATE INDEX locations_parent_id_idx ON locations (parent_id);

-- Seed default status zones — NL branch.
INSERT INTO locations (branch_id, name, code, type, is_status_zone) VALUES
  ('a0000000-0000-0000-0000-000000000001','Intake',                 'INTAKE',    'zone', true),
  ('a0000000-0000-0000-0000-000000000001','Sorting',                'SORTING',   'zone', true),
  ('a0000000-0000-0000-0000-000000000001','Photography',            'PHOTO',     'zone', true),
  ('a0000000-0000-0000-0000-000000000001','Listed',                 'LISTED',    'zone', true),
  ('a0000000-0000-0000-0000-000000000001','Reserved',               'RESERVED',  'zone', true),
  ('a0000000-0000-0000-0000-000000000001','Sold - Awaiting Shipment','SOLD-WAIT', 'zone', true),
  ('a0000000-0000-0000-0000-000000000001','Shipped',                'SHIPPED',   'zone', true);

-- Seed default status zones — TH branch.
INSERT INTO locations (branch_id, name, code, type, is_status_zone) VALUES
  ('a0000000-0000-0000-0000-000000000002','Intake',                 'INTAKE',    'zone', true),
  ('a0000000-0000-0000-0000-000000000002','Sorting',                'SORTING',   'zone', true),
  ('a0000000-0000-0000-0000-000000000002','Photography',            'PHOTO',     'zone', true),
  ('a0000000-0000-0000-0000-000000000002','Listed',                 'LISTED',    'zone', true),
  ('a0000000-0000-0000-0000-000000000002','Reserved',               'RESERVED',  'zone', true),
  ('a0000000-0000-0000-0000-000000000002','Sold - Awaiting Shipment','SOLD-WAIT', 'zone', true),
  ('a0000000-0000-0000-0000-000000000002','Shipped',                'SHIPPED',   'zone', true);

-- ── 3. Add branch_id + location_id to inventory_items ──────────

ALTER TABLE inventory_items
  ADD COLUMN IF NOT EXISTS branch_id   UUID REFERENCES branches  (id) ON DELETE SET NULL,
  ADD COLUMN IF NOT EXISTS location_id UUID REFERENCES locations  (id) ON DELETE SET NULL;

-- Default existing rows to NL branch.
UPDATE inventory_items
  SET branch_id = 'a0000000-0000-0000-0000-000000000001'
  WHERE branch_id IS NULL;

CREATE INDEX IF NOT EXISTS inventory_items_branch_id_idx   ON inventory_items (branch_id);
CREATE INDEX IF NOT EXISTS inventory_items_location_id_idx ON inventory_items (location_id);

-- ── 4. Add branch_id to orders ─────────────────────────────────

ALTER TABLE orders
  ADD COLUMN IF NOT EXISTS branch_id UUID REFERENCES branches (id) ON DELETE SET NULL;

UPDATE orders
  SET branch_id = 'a0000000-0000-0000-0000-000000000001'
  WHERE branch_id IS NULL;

CREATE INDEX IF NOT EXISTS orders_branch_id_idx ON orders (branch_id);

-- ── 5. Add branch_id to purchases ──────────────────────────────

ALTER TABLE purchases
  ADD COLUMN IF NOT EXISTS branch_id UUID REFERENCES branches (id) ON DELETE SET NULL;

UPDATE purchases
  SET branch_id = 'a0000000-0000-0000-0000-000000000001'
  WHERE branch_id IS NULL;

CREATE INDEX IF NOT EXISTS purchases_branch_id_idx ON purchases (branch_id);

-- ── 6. item_movements (append-only movement log) ────────────────

CREATE TABLE item_movements (
  id                UUID        PRIMARY KEY DEFAULT gen_random_uuid(),
  inventory_item_id UUID        NOT NULL REFERENCES inventory_items (id) ON DELETE CASCADE,
  from_location_id  UUID        REFERENCES locations (id) ON DELETE SET NULL,
  to_location_id    UUID        REFERENCES locations (id) ON DELETE SET NULL,
  moved_at          TIMESTAMPTZ NOT NULL DEFAULT now(),
  reason            TEXT        NOT NULL DEFAULT '',
  note              TEXT        NOT NULL DEFAULT ''
);

CREATE INDEX item_movements_item_id_idx  ON item_movements (inventory_item_id);
CREATE INDEX item_movements_moved_at_idx ON item_movements (moved_at DESC);

-- ── 7. RLS — open dev policies ─────────────────────────────────

ALTER TABLE branches ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS branches_all ON branches;
CREATE POLICY branches_all ON branches
  FOR ALL TO public USING (true) WITH CHECK (true);

ALTER TABLE locations ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS locations_all ON locations;
CREATE POLICY locations_all ON locations
  FOR ALL TO public USING (true) WITH CHECK (true);

ALTER TABLE item_movements ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS item_movements_all ON item_movements;
CREATE POLICY item_movements_all ON item_movements
  FOR ALL TO public USING (true) WITH CHECK (true);
