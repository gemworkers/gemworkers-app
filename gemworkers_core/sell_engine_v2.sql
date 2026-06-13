-- =============================================================================
-- GemWorkers — Sell Engine v2
-- =============================================================================
-- Safe to re-run: column additions use ADD COLUMN IF NOT EXISTS.
--
-- Sections:
--   1. New columns on customers
--   2. New columns on orders
--   3. Indexes
--   4. RLS: seller INSERT on order_items
--   5. SECURITY DEFINER function: handle_sale_customer
-- =============================================================================


-- =============================================================================
-- 1. NEW COLUMNS — customers
-- =============================================================================
-- Owner-side intelligence fields. Populated automatically by
-- handle_sale_customer() whenever a sale is linked to a named buyer.

ALTER TABLE customers
  ADD COLUMN IF NOT EXISTS total_spent      numeric(14,2) NOT NULL DEFAULT 0,
  ADD COLUMN IF NOT EXISTS order_count      integer       NOT NULL DEFAULT 0,
  ADD COLUMN IF NOT EXISTS first_order_date date,
  ADD COLUMN IF NOT EXISTS last_order_date  date,
  ADD COLUMN IF NOT EXISTS auto_tier        text;
  -- auto_tier: 'Silver' (< 5 000) | 'Gold' (5 000–14 999.99)
  --            | 'Premium' (15 000–49 999.99) | 'Collector' (>= 50 000)


-- =============================================================================
-- 2. NEW COLUMNS — orders
-- =============================================================================
-- seller_id was added in a prior migration; ADD COLUMN IF NOT EXISTS is a
-- safe no-op if it already exists on the table.

ALTER TABLE orders
  ADD COLUMN IF NOT EXISTS seller_id         uuid           REFERENCES sellers(id) ON DELETE SET NULL,
  ADD COLUMN IF NOT EXISTS sale_channel      text           NOT NULL DEFAULT 'manual',
  ADD COLUMN IF NOT EXISTS commission_rate   numeric(7,4)   NOT NULL DEFAULT 0,
  ADD COLUMN IF NOT EXISTS commission_amount numeric(12,2)  NOT NULL DEFAULT 0,
  ADD COLUMN IF NOT EXISTS seller_payout     numeric(12,2)  NOT NULL DEFAULT 0,
  ADD COLUMN IF NOT EXISTS order_total       numeric(12,2)  NOT NULL DEFAULT 0;

-- Add sale_channel check constraint idempotently.
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1
    FROM   information_schema.check_constraints
    WHERE  constraint_name = 'orders_sale_channel_check'
  ) THEN
    ALTER TABLE orders
      ADD CONSTRAINT orders_sale_channel_check
      CHECK (sale_channel IN ('platform', 'manual'));
  END IF;
END;
$$;


-- =============================================================================
-- 3. INDEXES
-- =============================================================================

CREATE INDEX IF NOT EXISTS idx_orders_seller_id_v2       ON orders    (seller_id);
CREATE INDEX IF NOT EXISTS idx_customers_auto_tier        ON customers (auto_tier);
CREATE INDEX IF NOT EXISTS idx_customers_last_order_date  ON customers (last_order_date DESC);


-- =============================================================================
-- 4. RLS — seller INSERT on order_items
-- =============================================================================
-- The existing order_items_seller_select policy only covers SELECT. Sellers
-- need INSERT so the sell engine can write line items for their own orders.

DROP POLICY IF EXISTS order_items_seller_insert ON order_items;
CREATE POLICY order_items_seller_insert
  ON order_items FOR INSERT
  TO authenticated
  WITH CHECK (
    EXISTS (
      SELECT 1 FROM orders
      WHERE  id        = order_items.order_id
        AND  seller_id = public.current_seller_id()
    )
  );


-- =============================================================================
-- 5. FUNCTION: handle_sale_customer
-- =============================================================================
-- Called via supabase.rpc() from the Dart sell engine after the order row
-- and order_items are committed.
--
-- Runs as SECURITY DEFINER → bypasses RLS on the customers table.
-- Sellers can trigger this function without being able to browse customers.
--
-- Flow:
--   a) Find existing customer by email (case-insensitive) then by phone.
--   b) Create a new customer record if none found.
--   c) Link order.customer_id to the found/created customer.
--   d) Recalculate customer stats from all PAID orders for that customer.
--   e) Compute auto_tier from updated total_spent.
--   f) Persist updated stats; return the customer UUID.

DROP FUNCTION IF EXISTS public.handle_sale_customer(text, text, text, uuid);

CREATE FUNCTION public.handle_sale_customer(
  p_name     text,
  p_email    text,
  p_phone    text,
  p_order_id uuid
)
RETURNS uuid
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_customer_id    uuid;
  v_total_spent    numeric(14,2);
  v_order_count    integer;
  v_first_date     date;
  v_last_date      date;
  v_auto_tier      text;
BEGIN
  -- ── a) Find existing customer ────────────────────────────────────────────
  IF p_email <> '' THEN
    SELECT id INTO v_customer_id
    FROM   customers
    WHERE  lower(email) = lower(p_email)
    LIMIT  1;
  END IF;

  IF v_customer_id IS NULL AND p_phone <> '' THEN
    SELECT id INTO v_customer_id
    FROM   customers
    WHERE  phone = p_phone
    LIMIT  1;
  END IF;

  -- ── b) Create new customer if not found ─────────────────────────────────
  IF v_customer_id IS NULL THEN
    INSERT INTO customers (name, email, phone)
    VALUES (
      COALESCE(NULLIF(TRIM(p_name), ''), 'Unknown'),
      p_email,
      p_phone
    )
    RETURNING id INTO v_customer_id;
  END IF;

  -- ── c) Link this order to the customer ──────────────────────────────────
  UPDATE orders
  SET    customer_id = v_customer_id
  WHERE  id = p_order_id;

  -- ── d) Recalculate stats from all paid orders ────────────────────────────
  SELECT
    COALESCE(SUM(order_total), 0),
    COUNT(*),
    MIN(order_date),
    MAX(order_date)
  INTO
    v_total_spent,
    v_order_count,
    v_first_date,
    v_last_date
  FROM orders
  WHERE  customer_id = v_customer_id
    AND  status = 'paid';

  -- ── e) Compute auto_tier ─────────────────────────────────────────────────
  IF    v_total_spent >= 50000 THEN v_auto_tier := 'Collector';
  ELSIF v_total_spent >= 15000 THEN v_auto_tier := 'Premium';
  ELSIF v_total_spent >= 5000  THEN v_auto_tier := 'Gold';
  ELSE                              v_auto_tier := 'Silver';
  END IF;

  -- ── f) Persist ───────────────────────────────────────────────────────────
  UPDATE customers
  SET
    total_spent      = v_total_spent,
    order_count      = v_order_count,
    first_order_date = v_first_date,
    last_order_date  = v_last_date,
    auto_tier        = v_auto_tier
  WHERE id = v_customer_id;

  RETURN v_customer_id;
END;
$$;

-- Sellers invoke this via rpc(), so grant execute to authenticated role.
GRANT EXECUTE
  ON FUNCTION public.handle_sale_customer(text, text, text, uuid)
  TO authenticated;
