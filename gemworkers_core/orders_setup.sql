-- GemWorkers — Orders & Customers schema
-- Drops and recreates the three new tables from scratch.
-- Does NOT touch inventory_items or suppliers.

-- ── Clean slate ───────────────────────────────────────────────

DROP TABLE IF EXISTS order_items CASCADE;
DROP TABLE IF EXISTS orders     CASCADE;
DROP TABLE IF EXISTS customers  CASCADE;
DROP SEQUENCE IF EXISTS order_number_seq;

-- ── 1. customers ─────────────────────────────────────────────

CREATE TABLE customers (
  id          UUID        PRIMARY KEY DEFAULT gen_random_uuid(),
  name        TEXT        NOT NULL,
  email       TEXT        NOT NULL DEFAULT '',
  phone       TEXT        NOT NULL DEFAULT '',
  country     TEXT        NOT NULL DEFAULT '',
  type        TEXT        NOT NULL DEFAULT 'individual'
                CHECK (type IN ('individual', 'business')),
  manual_tier TEXT
                CHECK (manual_tier IN ('Silver', 'Gold', 'Premium', 'Collector')),
  notes       TEXT        NOT NULL DEFAULT '',
  created_at  TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX customers_name_idx ON customers (name);

-- ── 2. order number sequence ──────────────────────────────────

CREATE SEQUENCE order_number_seq START 1;

-- ── 3. orders ────────────────────────────────────────────────

CREATE TABLE orders (
  id           UUID        PRIMARY KEY DEFAULT gen_random_uuid(),
  customer_id  UUID        REFERENCES customers (id) ON DELETE SET NULL,
  order_number TEXT        NOT NULL UNIQUE
                             DEFAULT 'ORD-' || LPAD(nextval('order_number_seq')::TEXT, 5, '0'),
  status       TEXT        NOT NULL DEFAULT 'draft'
                             CHECK (status IN ('draft', 'confirmed', 'paid', 'cancelled')),
  order_date   DATE        NOT NULL DEFAULT CURRENT_DATE,
  notes        TEXT        NOT NULL DEFAULT '',
  created_at   TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX orders_customer_id_idx ON orders (customer_id);
CREATE INDEX orders_status_idx      ON orders (status);
CREATE INDEX orders_created_at_idx  ON orders (created_at DESC);

-- ── 4. order_items ───────────────────────────────────────────

CREATE TABLE order_items (
  id                UUID           PRIMARY KEY DEFAULT gen_random_uuid(),
  order_id          UUID           NOT NULL REFERENCES orders (id) ON DELETE CASCADE,
  inventory_item_id UUID           NOT NULL REFERENCES inventory_items (id) ON DELETE RESTRICT,
  price_at_sale     NUMERIC(12, 2) NOT NULL CHECK (price_at_sale >= 0),
  quantity          INTEGER        NOT NULL DEFAULT 1 CHECK (quantity > 0),
  created_at        TIMESTAMPTZ    NOT NULL DEFAULT now()
);

CREATE INDEX order_items_order_id_idx     ON order_items (order_id);
CREATE INDEX order_items_inventory_id_idx ON order_items (inventory_item_id);

-- ── 5. RLS — customers ────────────────────────────────────────

ALTER TABLE customers ENABLE ROW LEVEL SECURITY;

CREATE POLICY customers_select ON customers
  FOR SELECT TO authenticated USING (true);

CREATE POLICY customers_insert ON customers
  FOR INSERT TO authenticated WITH CHECK (true);

CREATE POLICY customers_update ON customers
  FOR UPDATE TO authenticated USING (true) WITH CHECK (true);

CREATE POLICY customers_delete ON customers
  FOR DELETE TO authenticated USING (true);

-- ── 6. RLS — orders ───────────────────────────────────────────

ALTER TABLE orders ENABLE ROW LEVEL SECURITY;

CREATE POLICY orders_select ON orders
  FOR SELECT TO authenticated USING (true);

CREATE POLICY orders_insert ON orders
  FOR INSERT TO authenticated WITH CHECK (true);

CREATE POLICY orders_update ON orders
  FOR UPDATE TO authenticated USING (true) WITH CHECK (true);

CREATE POLICY orders_delete ON orders
  FOR DELETE TO authenticated USING (true);

-- ── 7. RLS — order_items ──────────────────────────────────────

ALTER TABLE order_items ENABLE ROW LEVEL SECURITY;

CREATE POLICY order_items_select ON order_items
  FOR SELECT TO authenticated USING (true);

CREATE POLICY order_items_insert ON order_items
  FOR INSERT TO authenticated WITH CHECK (true);

CREATE POLICY order_items_update ON order_items
  FOR UPDATE TO authenticated USING (true) WITH CHECK (true);

CREATE POLICY order_items_delete ON order_items
  FOR DELETE TO authenticated USING (true);
