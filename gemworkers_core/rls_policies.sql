-- =============================================================================
-- GemWorkers — Production RLS Policies
-- =============================================================================
-- Replaces all open dev policies with role-scoped access control.
--
-- Roles (stored in user_profiles.role):
--   owner  — full access to every table, no restrictions
--   seller — read/write only rows that belong to their seller_id
--   anon   — blocked from every table
--
-- Prerequisites: all table-setup scripts must have been run first.
-- Safe to re-run (all DROPs use IF EXISTS).
-- =============================================================================


-- =============================================================================
-- 1. DROP ALL OPEN DEV POLICIES
-- =============================================================================

-- From dev_open_policies.sql
DROP POLICY IF EXISTS inventory_items_all ON inventory_items;
DROP POLICY IF EXISTS suppliers_all       ON suppliers;
DROP POLICY IF EXISTS customers_all       ON customers;
DROP POLICY IF EXISTS orders_all          ON orders;
DROP POLICY IF EXISTS order_items_all     ON order_items;
DROP POLICY IF EXISTS purchases_all       ON purchases;
DROP POLICY IF EXISTS purchase_items_all  ON purchase_items;
DROP POLICY IF EXISTS sellers_all         ON sellers;
DROP POLICY IF EXISTS locations_all       ON locations;
DROP POLICY IF EXISTS item_movements_all  ON item_movements;

-- From orders_setup.sql (per-operation open policies)
DROP POLICY IF EXISTS customers_select   ON customers;
DROP POLICY IF EXISTS customers_insert   ON customers;
DROP POLICY IF EXISTS customers_update   ON customers;
DROP POLICY IF EXISTS customers_delete   ON customers;
DROP POLICY IF EXISTS orders_select      ON orders;
DROP POLICY IF EXISTS orders_insert      ON orders;
DROP POLICY IF EXISTS orders_update      ON orders;
DROP POLICY IF EXISTS orders_delete      ON orders;
DROP POLICY IF EXISTS order_items_select ON order_items;
DROP POLICY IF EXISTS order_items_insert ON order_items;
DROP POLICY IF EXISTS order_items_update ON order_items;
DROP POLICY IF EXISTS order_items_delete ON order_items;

-- From database_setup.sql
DROP POLICY IF EXISTS "authenticated_full_access" ON suppliers;
DROP POLICY IF EXISTS "authenticated_full_access" ON inventory_items;

-- From auth_setup.sql
DROP POLICY IF EXISTS user_profiles_all ON user_profiles;

-- Idempotent drops for policies this file creates (safe re-run)
DROP POLICY IF EXISTS user_profiles_owner        ON user_profiles;
DROP POLICY IF EXISTS user_profiles_self_select  ON user_profiles;
DROP POLICY IF EXISTS user_profiles_self_update  ON user_profiles;
DROP POLICY IF EXISTS sellers_owner              ON sellers;
DROP POLICY IF EXISTS sellers_seller_select      ON sellers;
DROP POLICY IF EXISTS inventory_items_owner      ON inventory_items;
DROP POLICY IF EXISTS inventory_items_seller     ON inventory_items;
DROP POLICY IF EXISTS suppliers_owner            ON suppliers;
DROP POLICY IF EXISTS suppliers_seller           ON suppliers;
DROP POLICY IF EXISTS locations_owner            ON locations;
DROP POLICY IF EXISTS locations_seller           ON locations;
DROP POLICY IF EXISTS item_movements_owner       ON item_movements;
DROP POLICY IF EXISTS item_movements_seller      ON item_movements;
DROP POLICY IF EXISTS orders_owner               ON orders;
DROP POLICY IF EXISTS orders_seller              ON orders;
DROP POLICY IF EXISTS order_items_owner          ON order_items;
DROP POLICY IF EXISTS order_items_seller_select  ON order_items;
DROP POLICY IF EXISTS purchases_owner            ON purchases;
DROP POLICY IF EXISTS purchases_seller           ON purchases;
DROP POLICY IF EXISTS purchase_items_owner       ON purchase_items;
DROP POLICY IF EXISTS purchase_items_seller_select ON purchase_items;
DROP POLICY IF EXISTS customers_owner            ON customers;


-- =============================================================================
-- 2. HELPER FUNCTIONS
-- =============================================================================
-- SECURITY DEFINER so both functions bypass RLS when reading user_profiles,
-- avoiding a chicken-and-egg problem between the function and the table policy.

CREATE OR REPLACE FUNCTION public.current_seller_id()
RETURNS uuid LANGUAGE sql STABLE SECURITY DEFINER AS $$
  SELECT seller_id FROM user_profiles WHERE id = auth.uid()
$$;

CREATE OR REPLACE FUNCTION public.is_owner()
RETURNS boolean LANGUAGE sql STABLE SECURITY DEFINER AS $$
  SELECT EXISTS (
    SELECT 1 FROM user_profiles WHERE id = auth.uid() AND role = 'owner'
  )
$$;


-- =============================================================================
-- 3. PER-TABLE POLICIES
-- =============================================================================

-- -----------------------------------------------------------------------------
-- user_profiles
-- owner : full access to all rows
-- self  : SELECT and UPDATE own row only (no INSERT/DELETE via policy)
-- -----------------------------------------------------------------------------

ALTER TABLE user_profiles ENABLE ROW LEVEL SECURITY;

CREATE POLICY user_profiles_owner
  ON user_profiles FOR ALL
  TO authenticated
  USING      (public.is_owner())
  WITH CHECK (public.is_owner());

CREATE POLICY user_profiles_self_select
  ON user_profiles FOR SELECT
  TO authenticated
  USING (id = auth.uid());

CREATE POLICY user_profiles_self_update
  ON user_profiles FOR UPDATE
  TO authenticated
  USING      (id = auth.uid())
  WITH CHECK (id = auth.uid());

-- -----------------------------------------------------------------------------
-- sellers
-- owner  : full access
-- seller : SELECT only — their own row where id = current_seller_id()
-- -----------------------------------------------------------------------------

ALTER TABLE sellers ENABLE ROW LEVEL SECURITY;

CREATE POLICY sellers_owner
  ON sellers FOR ALL
  TO authenticated
  USING      (public.is_owner())
  WITH CHECK (public.is_owner());

CREATE POLICY sellers_seller_select
  ON sellers FOR SELECT
  TO authenticated
  USING (id = public.current_seller_id());

-- -----------------------------------------------------------------------------
-- inventory_items
-- owner  : full access
-- seller : full access to rows where seller_id = current_seller_id()
-- -----------------------------------------------------------------------------

ALTER TABLE inventory_items ENABLE ROW LEVEL SECURITY;

CREATE POLICY inventory_items_owner
  ON inventory_items FOR ALL
  TO authenticated
  USING      (public.is_owner())
  WITH CHECK (public.is_owner());

CREATE POLICY inventory_items_seller
  ON inventory_items FOR ALL
  TO authenticated
  USING      (seller_id = public.current_seller_id())
  WITH CHECK (seller_id = public.current_seller_id());

-- -----------------------------------------------------------------------------
-- suppliers
-- owner  : full access
-- seller : full access to rows where supplier.seller_id = current_seller_id()
-- -----------------------------------------------------------------------------

ALTER TABLE suppliers ENABLE ROW LEVEL SECURITY;

CREATE POLICY suppliers_owner
  ON suppliers FOR ALL
  TO authenticated
  USING      (public.is_owner())
  WITH CHECK (public.is_owner());

CREATE POLICY suppliers_seller
  ON suppliers FOR ALL
  TO authenticated
  USING      (seller_id = public.current_seller_id())
  WITH CHECK (seller_id = public.current_seller_id());

-- -----------------------------------------------------------------------------
-- locations
-- owner  : full access
-- seller : full access to rows where location.seller_id = current_seller_id()
-- -----------------------------------------------------------------------------

ALTER TABLE locations ENABLE ROW LEVEL SECURITY;

CREATE POLICY locations_owner
  ON locations FOR ALL
  TO authenticated
  USING      (public.is_owner())
  WITH CHECK (public.is_owner());

CREATE POLICY locations_seller
  ON locations FOR ALL
  TO authenticated
  USING      (seller_id = public.current_seller_id())
  WITH CHECK (seller_id = public.current_seller_id());

-- -----------------------------------------------------------------------------
-- item_movements
-- No seller_id column — scope via the linked inventory_item's seller_id.
-- owner  : full access
-- seller : full access to movements whose inventory_item belongs to them
-- -----------------------------------------------------------------------------

ALTER TABLE item_movements ENABLE ROW LEVEL SECURITY;

CREATE POLICY item_movements_owner
  ON item_movements FOR ALL
  TO authenticated
  USING      (public.is_owner())
  WITH CHECK (public.is_owner());

CREATE POLICY item_movements_seller
  ON item_movements FOR ALL
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM inventory_items
      WHERE id = item_movements.inventory_item_id
        AND seller_id = public.current_seller_id()
    )
  )
  WITH CHECK (
    EXISTS (
      SELECT 1 FROM inventory_items
      WHERE id = item_movements.inventory_item_id
        AND seller_id = public.current_seller_id()
    )
  );

-- -----------------------------------------------------------------------------
-- orders
-- owner  : full access
-- seller : full access to rows where order.seller_id = current_seller_id()
-- -----------------------------------------------------------------------------

ALTER TABLE orders ENABLE ROW LEVEL SECURITY;

CREATE POLICY orders_owner
  ON orders FOR ALL
  TO authenticated
  USING      (public.is_owner())
  WITH CHECK (public.is_owner());

CREATE POLICY orders_seller
  ON orders FOR ALL
  TO authenticated
  USING      (seller_id = public.current_seller_id())
  WITH CHECK (seller_id = public.current_seller_id());

-- -----------------------------------------------------------------------------
-- order_items
-- No seller_id column — scope via the parent order's seller_id.
-- owner  : full access
-- seller : SELECT only on order_items whose order belongs to them
-- -----------------------------------------------------------------------------

ALTER TABLE order_items ENABLE ROW LEVEL SECURITY;

CREATE POLICY order_items_owner
  ON order_items FOR ALL
  TO authenticated
  USING      (public.is_owner())
  WITH CHECK (public.is_owner());

CREATE POLICY order_items_seller_select
  ON order_items FOR SELECT
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM orders
      WHERE id = order_items.order_id
        AND seller_id = public.current_seller_id()
    )
  );

-- -----------------------------------------------------------------------------
-- purchases
-- owner  : full access
-- seller : full access to rows where purchase.seller_id = current_seller_id()
-- -----------------------------------------------------------------------------

ALTER TABLE purchases ENABLE ROW LEVEL SECURITY;

CREATE POLICY purchases_owner
  ON purchases FOR ALL
  TO authenticated
  USING      (public.is_owner())
  WITH CHECK (public.is_owner());

CREATE POLICY purchases_seller
  ON purchases FOR ALL
  TO authenticated
  USING      (seller_id = public.current_seller_id())
  WITH CHECK (seller_id = public.current_seller_id());

-- -----------------------------------------------------------------------------
-- purchase_items
-- No seller_id column — scope via the parent purchase's seller_id.
-- owner  : full access
-- seller : SELECT only on purchase_items whose purchase belongs to them
-- -----------------------------------------------------------------------------

ALTER TABLE purchase_items ENABLE ROW LEVEL SECURITY;

CREATE POLICY purchase_items_owner
  ON purchase_items FOR ALL
  TO authenticated
  USING      (public.is_owner())
  WITH CHECK (public.is_owner());

CREATE POLICY purchase_items_seller_select
  ON purchase_items FOR SELECT
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM purchases
      WHERE id = purchase_items.purchase_id
        AND seller_id = public.current_seller_id()
    )
  );

-- -----------------------------------------------------------------------------
-- customers
-- owner  : full access
-- seller : no access (no policy created — RLS blocks all non-owner reads/writes)
-- -----------------------------------------------------------------------------

ALTER TABLE customers ENABLE ROW LEVEL SECURITY;

CREATE POLICY customers_owner
  ON customers FOR ALL
  TO authenticated
  USING      (public.is_owner())
  WITH CHECK (public.is_owner());
