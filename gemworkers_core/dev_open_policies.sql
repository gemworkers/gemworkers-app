-- DEV ONLY — open RLS policies for local development.
-- Allows all operations from any role with no restrictions.
-- REPLACE WITH authenticated policies before going to production.
-- Safe to re-run at any time.

-- ── inventory_items ───────────────────────────────────────────

ALTER TABLE inventory_items ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS inventory_items_select ON inventory_items;
DROP POLICY IF EXISTS inventory_items_insert ON inventory_items;
DROP POLICY IF EXISTS inventory_items_update ON inventory_items;
DROP POLICY IF EXISTS inventory_items_delete ON inventory_items;
DROP POLICY IF EXISTS inventory_items_all    ON inventory_items;

CREATE POLICY inventory_items_all ON inventory_items
  FOR ALL TO public USING (true) WITH CHECK (true);

-- ── suppliers ─────────────────────────────────────────────────

ALTER TABLE suppliers ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS suppliers_select ON suppliers;
DROP POLICY IF EXISTS suppliers_insert ON suppliers;
DROP POLICY IF EXISTS suppliers_update ON suppliers;
DROP POLICY IF EXISTS suppliers_delete ON suppliers;
DROP POLICY IF EXISTS suppliers_all    ON suppliers;

CREATE POLICY suppliers_all ON suppliers
  FOR ALL TO public USING (true) WITH CHECK (true);

-- ── customers ─────────────────────────────────────────────────

ALTER TABLE customers ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS customers_select ON customers;
DROP POLICY IF EXISTS customers_insert ON customers;
DROP POLICY IF EXISTS customers_update ON customers;
DROP POLICY IF EXISTS customers_delete ON customers;
DROP POLICY IF EXISTS customers_all    ON customers;

CREATE POLICY customers_all ON customers
  FOR ALL TO public USING (true) WITH CHECK (true);

-- ── orders ────────────────────────────────────────────────────

ALTER TABLE orders ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS orders_select ON orders;
DROP POLICY IF EXISTS orders_insert ON orders;
DROP POLICY IF EXISTS orders_update ON orders;
DROP POLICY IF EXISTS orders_delete ON orders;
DROP POLICY IF EXISTS orders_all    ON orders;

CREATE POLICY orders_all ON orders
  FOR ALL TO public USING (true) WITH CHECK (true);

-- ── order_items ───────────────────────────────────────────────

ALTER TABLE order_items ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS order_items_select ON order_items;
DROP POLICY IF EXISTS order_items_insert ON order_items;
DROP POLICY IF EXISTS order_items_update ON order_items;
DROP POLICY IF EXISTS order_items_delete ON order_items;
DROP POLICY IF EXISTS order_items_all    ON order_items;

CREATE POLICY order_items_all ON order_items
  FOR ALL TO public USING (true) WITH CHECK (true);

-- ── purchases ─────────────────────────────────────────────────

ALTER TABLE purchases ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS purchases_all ON purchases;

CREATE POLICY purchases_all ON purchases
  FOR ALL TO public USING (true) WITH CHECK (true);

-- ── purchase_items ────────────────────────────────────────────

ALTER TABLE purchase_items ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS purchase_items_all ON purchase_items;

CREATE POLICY purchase_items_all ON purchase_items
  FOR ALL TO public USING (true) WITH CHECK (true);

-- ── branches ──────────────────────────────────────────────────

ALTER TABLE branches ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS branches_all ON branches;

CREATE POLICY branches_all ON branches
  FOR ALL TO public USING (true) WITH CHECK (true);

-- ── locations ─────────────────────────────────────────────────

ALTER TABLE locations ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS locations_all ON locations;

CREATE POLICY locations_all ON locations
  FOR ALL TO public USING (true) WITH CHECK (true);

-- ── item_movements ────────────────────────────────────────────

ALTER TABLE item_movements ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS item_movements_all ON item_movements;

CREATE POLICY item_movements_all ON item_movements
  FOR ALL TO public USING (true) WITH CHECK (true);
