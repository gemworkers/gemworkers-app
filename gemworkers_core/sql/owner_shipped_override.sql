-- =============================================================================
-- GemWorkers — Owner escape hatch: ship any order as platform admin
-- =============================================================================
-- Gives the owner (user_profiles.role = 'owner') the ability to mark any
-- confirmed platform order as shipped, acting as an explicit admin override
-- when a seller is unresponsive. The action is recorded — shipped_by_owner
-- is stamped true on the row so the audit trail is unambiguous.
--
-- Two idempotent changes, applied in this order:
--
--   1. ADD COLUMN shipped_by_owner — must exist before the function UPDATE
--      references it. All existing rows default to false.
--
--   2. CREATE OR REPLACE FUNCTION mark_order_shipped — full rewrite preserving
--      every existing line verbatim. Only two changes from the original:
--        • Ownership guard widened: owner bypass added via AND NOT is_owner().
--        • UPDATE gains: shipped_by_owner = public.is_owner()
--          (true on the owner path, false for sellers — stamped unconditionally).
--
-- No other functions are touched. mark_order_received is unchanged.
-- orders_owner RLS is unchanged (owner already has full SELECT/UPDATE on orders).
-- Safe to re-run: ADD COLUMN IF NOT EXISTS + CREATE OR REPLACE.
-- =============================================================================


-- =============================================================================
-- 1. ADD COLUMN shipped_by_owner
-- =============================================================================

ALTER TABLE public.orders
  ADD COLUMN IF NOT EXISTS shipped_by_owner boolean NOT NULL DEFAULT false;


-- =============================================================================
-- 2. CREATE OR REPLACE FUNCTION mark_order_shipped
-- =============================================================================

CREATE OR REPLACE FUNCTION public.mark_order_shipped(
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

  -- Widened guard: the original IS DISTINCT FROM check is preserved verbatim.
  -- AND NOT is_owner() adds the owner bypass: when is_owner() returns true,
  -- the entire condition is false and the exception is not raised.
  -- For all sellers is_owner() returns false, so behaviour is unchanged.
  IF v_order.seller_id IS DISTINCT FROM public.current_seller_id()
     AND NOT public.is_owner()
  THEN
    RAISE EXCEPTION 'This order does not belong to your shop';
  END IF;

  IF v_order.status <> 'confirmed' THEN
    RAISE EXCEPTION 'Order cannot be shipped from status ''%'' — must be ''confirmed''',
      v_order.status;
  END IF;

  UPDATE orders
  SET
    status            = 'shipped',
    shipped_at        = now(),
    tracking_number   = p_tracking_number,
    shipped_by_owner  = public.is_owner()
  WHERE id = p_order_id;

  RETURN p_order_id;
END;
$$;

GRANT EXECUTE ON FUNCTION public.mark_order_shipped(uuid, text) TO authenticated;
