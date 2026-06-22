-- =============================================================================
-- GemWorkers — Cart Checkout Groups
-- =============================================================================
-- Adds a checkout_group_id column to orders and two group-level functions that
-- confirm or cancel every order in a cart checkout as a unit.
--
-- A cart checkout creates several pending_payment orders in one go and stamps
-- them all with the same checkout_group_id UUID. The Stripe webhook then calls
-- confirm_order_group / cancel_order_group with that UUID rather than iterating
-- over individual order IDs.
--
-- Delegates per-order logic entirely to confirm_order_paid() and
-- cancel_pending_payment_order() (payment_pending_states.sql), so transition
-- rules live in exactly one place.
--
-- Idempotent: safe to re-run on the live DB.
-- =============================================================================


-- =============================================================================
-- 1. GROUPING COLUMN
-- =============================================================================
-- NULL for single-stone (non-cart) orders — existing rows are unaffected.
-- A cart checkout stamps the same UUID on every order it creates before
-- initiating the Stripe session, so the webhook can look them all up at once.

ALTER TABLE public.orders
  ADD COLUMN IF NOT EXISTS checkout_group_id uuid;

COMMENT ON COLUMN public.orders.checkout_group_id IS
  'Groups several pending_payment orders created by one cart checkout so the '
  'webhook can confirm or cancel them together. NULL for single-stone orders.';

-- Index makes the group-lookup fast regardless of table size.
CREATE INDEX IF NOT EXISTS orders_checkout_group_idx
  ON public.orders (checkout_group_id);


-- =============================================================================
-- 2. confirm_order_group(p_group_id uuid)
-- =============================================================================
-- Called by the Stripe webhook after a successful cart payment.
-- Iterates every order sharing this group id and confirms each one by
-- delegating to confirm_order_paid(), which owns the transition rules:
--   pending_payment → confirmed   normal path
--   already confirmed             no-op (idempotent; webhook can fire twice)
--   any other status              RAISE inside confirm_order_paid, caught here
--
-- Per-order exception isolation: one bad order emits a WARNING and is skipped;
-- the rest of the group still get confirmed.
-- Unknown group id → WARNING + return (avoids a 500 in the webhook).

DROP FUNCTION IF EXISTS public.confirm_order_group(uuid);

CREATE FUNCTION public.confirm_order_group(p_group_id uuid)
RETURNS void
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_order  record;
  v_count  int := 0;
BEGIN
  FOR v_order IN
    SELECT id FROM orders WHERE checkout_group_id = p_group_id
  LOOP
    v_count := v_count + 1;
    BEGIN
      PERFORM public.confirm_order_paid(v_order.id);
    EXCEPTION WHEN OTHERS THEN
      RAISE WARNING
        'confirm_order_group: order % in group % could not be confirmed: %',
        v_order.id, p_group_id, SQLERRM;
    END;
  END LOOP;

  IF v_count = 0 THEN
    RAISE WARNING
      'confirm_order_group: no orders found for group %', p_group_id;
  END IF;
END;
$$;

GRANT EXECUTE ON FUNCTION public.confirm_order_group(uuid) TO service_role;
GRANT EXECUTE ON FUNCTION public.confirm_order_group(uuid) TO authenticated;


-- =============================================================================
-- 3. cancel_order_group(p_group_id uuid)
-- =============================================================================
-- Called by the Stripe webhook after a failed or expired cart payment.
-- Iterates every order sharing this group id and cancels each one by
-- delegating to cancel_pending_payment_order(), which owns the transition
-- rules:
--   pending_payment  → cancelled + stone restored to available   normal path
--   already cancelled                → no-op (idempotent)
--   confirmed (payment already good) → RAISE inside cancel_pending_payment_order,
--                                      caught here — we must never undo a paid
--                                      order, so the warning is intentionally loud.
--
-- Per-order exception isolation: one failure emits a WARNING and is skipped;
-- the rest of the group still get cancelled and their stones released.
-- Unknown group id → WARNING + return.

DROP FUNCTION IF EXISTS public.cancel_order_group(uuid);

CREATE FUNCTION public.cancel_order_group(p_group_id uuid)
RETURNS void
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_order  record;
  v_count  int := 0;
BEGIN
  FOR v_order IN
    SELECT id FROM orders WHERE checkout_group_id = p_group_id
  LOOP
    v_count := v_count + 1;
    BEGIN
      PERFORM public.cancel_pending_payment_order(v_order.id);
    EXCEPTION WHEN OTHERS THEN
      RAISE WARNING
        'cancel_order_group: order % in group % could not be cancelled: %',
        v_order.id, p_group_id, SQLERRM;
    END;
  END LOOP;

  IF v_count = 0 THEN
    RAISE WARNING
      'cancel_order_group: no orders found for group %', p_group_id;
  END IF;
END;
$$;

GRANT EXECUTE ON FUNCTION public.cancel_order_group(uuid) TO service_role;
GRANT EXECUTE ON FUNCTION public.cancel_order_group(uuid) TO authenticated;
