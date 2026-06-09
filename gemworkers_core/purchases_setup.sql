-- GemWorkers — Purchases schema
-- Drops and recreates the two new tables from scratch.
-- Also adds purchase_id to inventory_items (nullable back-reference).
-- Safe to re-run at any time (all drops are IF EXISTS).

-- ── Clean slate ───────────────────────────────────────────────

DROP TABLE IF EXISTS purchase_items CASCADE;
DROP TABLE IF EXISTS purchases     CASCADE;
DROP SEQUENCE IF EXISTS purchase_number_seq;

-- Drop the column in case this script has been run before.
ALTER TABLE inventory_items DROP COLUMN IF EXISTS purchase_id;

-- ── 1. purchase_number sequence ───────────────────────────────

CREATE SEQUENCE purchase_number_seq START 1;

-- ── 2. purchases ─────────────────────────────────────────────

CREATE TABLE purchases (
  id              UUID           PRIMARY KEY DEFAULT gen_random_uuid(),
  supplier_id     UUID           REFERENCES suppliers (id) ON DELETE SET NULL,
  purchase_number TEXT           NOT NULL UNIQUE
                                   DEFAULT 'PUR-' || LPAD(nextval('purchase_number_seq')::TEXT, 5, '0'),
  purchase_date   DATE           NOT NULL DEFAULT CURRENT_DATE,
  gem_cost        NUMERIC(12, 2) NOT NULL DEFAULT 0 CHECK (gem_cost >= 0),
  shipping_cost   NUMERIC(12, 2) NOT NULL DEFAULT 0 CHECK (shipping_cost >= 0),
  customs_cost    NUMERIC(12, 2) NOT NULL DEFAULT 0 CHECK (customs_cost >= 0),
  other_fees      NUMERIC(12, 2) NOT NULL DEFAULT 0 CHECK (other_fees >= 0),
  total_cost      NUMERIC(12, 2) NOT NULL DEFAULT 0,
  notes           TEXT           NOT NULL DEFAULT '',
  created_at      TIMESTAMPTZ    NOT NULL DEFAULT now()
);

CREATE INDEX purchases_supplier_id_idx ON purchases (supplier_id);
CREATE INDEX purchases_created_at_idx  ON purchases (created_at DESC);

-- ── 3. Add purchase_id back-reference to inventory_items ──────
--    Nullable. Set when a gem is auto-created from a purchase.
--    ON DELETE SET NULL so deleting a purchase does NOT cascade-delete gems.

ALTER TABLE inventory_items
  ADD COLUMN purchase_id UUID REFERENCES purchases (id) ON DELETE SET NULL;

CREATE INDEX inventory_items_purchase_id_idx ON inventory_items (purchase_id);

-- ── 4. purchase_items (lot line items) ───────────────────────
--
--    One row per gem TYPE in the lot.
--    quantity = how many individual gems of that type.
--    allocated_cost = quantity × cost_per_gem = this line's share of total
--                     landed cost. Computed and stored by the app, not by DB.
--    No inventory_item_id here — the link from gems back to a purchase is
--    inventory_items.purchase_id (one-to-many: one purchase, many gems).

CREATE TABLE purchase_items (
  id             UUID           PRIMARY KEY DEFAULT gen_random_uuid(),
  purchase_id    UUID           NOT NULL REFERENCES purchases (id) ON DELETE CASCADE,
  gem_type       TEXT           NOT NULL DEFAULT '',
  quantity       INTEGER        NOT NULL DEFAULT 1 CHECK (quantity > 0),
  allocated_cost NUMERIC(12, 2) NOT NULL DEFAULT 0,
  notes          TEXT           NOT NULL DEFAULT '',
  created_at     TIMESTAMPTZ    NOT NULL DEFAULT now()
);

CREATE INDEX purchase_items_purchase_id_idx ON purchase_items (purchase_id);

-- ── 5. RLS — open dev policies ────────────────────────────────
--    FOR ALL TO public USING(true) WITH CHECK(true)
--    Replace with authenticated policies before going to production.

ALTER TABLE purchases ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS purchases_all ON purchases;
CREATE POLICY purchases_all ON purchases
  FOR ALL TO public USING (true) WITH CHECK (true);

ALTER TABLE purchase_items ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS purchase_items_all ON purchase_items;
CREATE POLICY purchase_items_all ON purchase_items
  FOR ALL TO public USING (true) WITH CHECK (true);
