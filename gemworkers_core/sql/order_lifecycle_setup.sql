-- =============================================================================
-- GemWorkers — Order Lifecycle: shipped → received
-- =============================================================================
-- Extends the orders table with two new status values and three timestamp/
-- tracking columns, then adds SECURITY DEFINER functions for each transition.
--
-- Lifecycle for platform orders:
--   confirmed → shipped (seller marks, optionally with tracking number)
--   shipped   → received (buyer marks via storefront)
--
-- Manual orders are unaffected: draft → confirmed → paid remains valid.
-- All four existing status values are kept in the CHECK constraint.
--
-- Idempotent: safe to run repeatedly on the live DB.
--   • DROP CONSTRAINT IF EXISTS / ADD CONSTRAINT (mirrors status_constraint_v2.sql)
--   • ADD COLUMN IF NOT EXISTS
--   • DROP FUNCTION IF EXISTS before each CREATE FUNCTION
-- =============================================================================


-- =============================================================================
-- 1. EXTEND orders.status CHECK CONSTRAINT
-- =============================================================================
-- Auto-named by PostgreSQL as 'orders_status_check' (from orders_setup.sql).
-- Drop and recreate with two additional values: 'shipped', 'received'.
-- All existing rows remain valid — their status values are still in the set.

ALTER TABLE public.orders
  DROP CONSTRAINT IF EXISTS orders_status_check;

ALTER TABLE public.orders
  ADD CONSTRAINT orders_status_check
  CHECK (status IN ('draft', 'confirmed', 'shipped', 'received', 'paid', 'cancelled'));


-- =============================================================================
-- 2. NEW COLUMNS — nullable, no defaults, append-only
-- =============================================================================
-- All three are NULL on every existing row:
--   tracking_number — free text the seller enters at shipment time (optional).
--   shipped_at      — stamped by mark_order_shipped(); NULL until shipped.
--   received_at     — stamped by mark_order_received(); NULL until received.

ALTER TABLE public.orders
  ADD COLUMN IF NOT EXISTS tracking_number text,
  ADD COLUMN IF NOT EXISTS shipped_at      timestamptz,
  ADD COLUMN IF NOT EXISTS received_at     timestamptz;


-- =============================================================================
-- 3. FUNCTION: mark_order_shipped
-- =============================================================================
-- Called by the authenticated seller to advance a confirmed order to shipped.
--
-- Validates:
--   • The order exists.
--   • The caller is the seller who owns this order. Uses IS DISTINCT FROM so
--     that callers with a NULL current_seller_id() (buyers, owner) are correctly
--     blocked — mirrors the same guard in respond_to_offer().
--   • The order is currently 'confirmed'; any other state is rejected.
--
-- On success: sets status = 'shipped', shipped_at = now(),
--             tracking_number = p_tracking_number (NULL is valid → no tracking).
-- Returns the order UUID so the caller can confirm which row was updated.

DROP FUNCTION IF EXISTS public.mark_order_shipped(uuid, text);

CREATE FUNCTION public.mark_order_shipped(
  p_order_id         uuid,
  p_tracking_number  text DEFAULT NULL
)
RETURNS uuid
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_order record;
BEGIN
  -- Lock the row to prevent concurrent transitions on the same order.
  SELECT id, seller_id, status
  INTO   v_order
  FROM   orders
  WHERE  id = p_order_id
  FOR UPDATE;

  IF NOT FOUND THEN
    RAISE EXCEPTION 'Order not found';
  END IF;

  -- IS DISTINCT FROM correctly blocks callers whose current_seller_id() is NULL
  -- (buyers have no seller_id; the owner helper also returns NULL for non-sellers).
  IF v_order.seller_id IS DISTINCT FROM public.current_seller_id() THEN
    RAISE EXCEPTION 'This order does not belong to your shop';
  END IF;

  IF v_order.status <> 'confirmed' THEN
    RAISE EXCEPTION 'Order cannot be shipped from status ''%'' — must be ''confirmed''',
      v_order.status;
  END IF;

  UPDATE orders
  SET
    status           = 'shipped',
    shipped_at       = now(),
    tracking_number  = p_tracking_number
  WHERE id = p_order_id;

  RETURN p_order_id;
END;
$$;

GRANT EXECUTE ON FUNCTION public.mark_order_shipped(uuid, text) TO authenticated;


-- =============================================================================
-- 4. FUNCTION: mark_order_received
-- =============================================================================
-- Called by the authenticated buyer to confirm delivery of a shipped order.
--
-- Buyers have no UPDATE policy on orders (only SELECT via orders_buyer_select).
-- This SECURITY DEFINER function is the only write path available to buyers,
-- mirroring how create_platform_order() is the only INSERT path.
--
-- Validates:
--   • The order exists.
--   • The caller is the buyer on this order (auth.uid() = buyer_id).
--   • The order is currently 'shipped'; confirming receipt of an unshipped
--     order is not permitted.
--
-- On success: sets status = 'received', received_at = now().
-- Returns the order UUID so the caller can confirm which row was updated.

DROP FUNCTION IF EXISTS public.mark_order_received(uuid);

CREATE FUNCTION public.mark_order_received(p_order_id uuid)
RETURNS uuid
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_order record;
BEGIN
  -- Lock the row to prevent concurrent transitions on the same order.
  SELECT id, buyer_id, status
  INTO   v_order
  FROM   orders
  WHERE  id = p_order_id
  FOR UPDATE;

  IF NOT FOUND THEN
    RAISE EXCEPTION 'Order not found';
  END IF;

  IF v_order.buyer_id IS DISTINCT FROM auth.uid() THEN
    RAISE EXCEPTION 'This order does not belong to you';
  END IF;

  IF v_order.status <> 'shipped' THEN
    RAISE EXCEPTION 'Order has not been shipped yet (status: ''%'')', v_order.status;
  END IF;

  UPDATE orders
  SET
    status      = 'received',
    received_at = now()
  WHERE id = p_order_id;

  RETURN p_order_id;
END;
$$;

GRANT EXECUTE ON FUNCTION public.mark_order_received(uuid) TO authenticated;
