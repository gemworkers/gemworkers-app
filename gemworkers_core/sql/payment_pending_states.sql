-- =============================================================================
-- GemWorkers — Payment-Pending States
-- =============================================================================
-- Inserts 'pending_payment' between order creation and seller confirmation,
-- so a platform order only becomes 'confirmed' after Stripe payment succeeds.
--
-- Before this migration the lifecycle was:
--   buyer clicks → create_platform_order() → 'confirmed' immediately
--
-- After this migration:
--   buyer clicks → create_platform_order() → 'pending_payment'
--                → Stripe succeeds → confirm_order_paid() → 'confirmed'
--                → Stripe fails   → cancel_pending_payment_order() → 'cancelled'
--                                   (stone also restored to 'available')
--
-- Three changes, all idempotent and safe on the live DB:
--   1. Expand orders_status_check to include 'pending_payment'.
--   2. CREATE OR REPLACE create_platform_order — one-line change: 'pending_payment'.
--   3. CREATE FUNCTION confirm_order_paid   — webhook success path.
--   4. CREATE FUNCTION cancel_pending_payment_order — webhook failure / rollback path.
--      Added here because the audit confirmed no code path currently restores a
--      reserved stone to 'available' on cancellation; without this function a
--      failed payment permanently removes the stone from the storefront.
--
-- Idempotent:
--   Constraint: DROP CONSTRAINT IF EXISTS + ADD CONSTRAINT.
--   Functions:  CREATE OR REPLACE where supported; DROP IF EXISTS + CREATE otherwise.
-- =============================================================================


-- =============================================================================
-- 1. EXPAND orders.status CHECK CONSTRAINT
-- =============================================================================
-- Prior definition (from order_lifecycle_setup.sql):
--   ('draft', 'confirmed', 'shipped', 'received', 'paid', 'cancelled')
-- All six existing values are preserved. Only 'pending_payment' is added.
-- All existing rows remain valid — their status values are still in the set.

ALTER TABLE public.orders
  DROP CONSTRAINT IF EXISTS orders_status_check;

ALTER TABLE public.orders
  ADD CONSTRAINT orders_status_check
  CHECK (status IN (
    'draft',
    'pending_payment',   -- order created; awaiting Stripe payment confirmation
    'confirmed',         -- payment confirmed; seller prepares shipment
    'shipped',
    'received',
    'paid',
    'cancelled'
  ));


-- =============================================================================
-- 2. REWRITE create_platform_order (CREATE OR REPLACE)
-- =============================================================================
-- Copied verbatim from order_total_math.sql with ONE change:
-- the orders INSERT uses status = 'pending_payment' instead of 'confirmed'.
--
-- Everything else is identical:
--   • FOR UPDATE row lock (concurrent-buy protection)
--   • Five validation checks (not found / unlisted / not available /
--     inactive seller / no price)
--   • Stone reservation UPDATE (status = 'reserved') in the same transaction
--   • Exact money math: v_rate = COALESCE(NULLIF(seller_commission_rate,0),0.10),
--     v_commission = ROUND(v_item_price * v_rate, 2), v_payout = v_total - v_commission
--   • order_items INSERT (price_at_sale = item price, shipping not a line item)
--   • RETURN of the order UUID

CREATE OR REPLACE FUNCTION public.create_platform_order(p_inventory_item_id uuid)
RETURNS uuid
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_item        record;
  v_order_id    uuid;
  v_item_price  numeric;
  v_shipping    numeric;
  v_total       numeric;
  v_rate        numeric;
  v_commission  numeric;
  v_payout      numeric;
BEGIN
  -- a) Lock the row so a concurrent call on the same stone loses the race.
  SELECT i.id, i.selling_price, i.seller_id, i.status, i.is_listed,
         s.status          AS seller_status,
         i.shipping_cost,
         s.commission_rate AS seller_commission_rate
  INTO   v_item
  FROM   inventory_items i
  JOIN   sellers         s ON s.id = i.seller_id
  WHERE  i.id = p_inventory_item_id
  FOR UPDATE;

  IF NOT FOUND THEN
    RAISE EXCEPTION 'Item not found';
  END IF;
  IF NOT v_item.is_listed THEN
    RAISE EXCEPTION 'Item is not listed for sale';
  END IF;
  IF v_item.status <> 'available' THEN
    RAISE EXCEPTION 'Item is not available (status: %)', v_item.status;
  END IF;
  IF v_item.seller_status <> 'active' THEN
    RAISE EXCEPTION 'Seller is not active';
  END IF;
  IF v_item.selling_price IS NULL THEN
    RAISE EXCEPTION 'Item has no listed price';
  END IF;

  -- b) Reserve the stone immediately — same transaction as the order INSERT, so
  --    if anything below raises an exception, both writes are rolled back together.
  UPDATE inventory_items
  SET    status = 'reserved'
  WHERE  id = p_inventory_item_id;

  -- Money math — identical to order_total_math.sql:
  v_item_price := v_item.selling_price;
  v_shipping   := COALESCE(v_item.shipping_cost, 0);
  v_total      := v_item_price + v_shipping;
  v_rate       := COALESCE(NULLIF(v_item.seller_commission_rate, 0), 0.10);
  v_commission := ROUND(v_item_price * v_rate, 2);
  v_payout     := v_total - v_commission;

  -- c) Create the order.
  --    *** ONLY CHANGE FROM order_total_math.sql: 'pending_payment' not 'confirmed' ***
  INSERT INTO orders (
    buyer_id,          seller_id,          sale_channel,
    status,            order_total,        shipping_cost,
    commission_rate,   commission_amount,  seller_payout
  )
  VALUES (
    auth.uid(),        v_item.seller_id,   'platform',
    'pending_payment', v_total,            v_shipping,
    v_rate,            v_commission,       v_payout
  )
  RETURNING id INTO v_order_id;

  -- d) Line item — price_at_sale locks the item price at this moment in time.
  --    Shipping is not a line item; it lives on orders.shipping_cost.
  INSERT INTO order_items (order_id, inventory_item_id, price_at_sale, quantity)
  VALUES (v_order_id, p_inventory_item_id, v_item_price, 1);

  RETURN v_order_id;
END;
$$;

GRANT EXECUTE ON FUNCTION public.create_platform_order(uuid) TO authenticated;


-- =============================================================================
-- 3. FUNCTION confirm_order_paid(p_order_id uuid)
-- =============================================================================
-- Called by the Stripe webhook Route Handler (server-side, service-role key)
-- after a payment_intent.succeeded event.
--
-- Transitions: pending_payment → confirmed
-- Idempotent:  calling again on an already-confirmed order is a safe no-op
--              (Stripe webhooks can fire more than once for the same event).
--
-- The stone stays 'reserved' — the existing downstream flow is unchanged:
--   confirmed → shipped (seller) → received (buyer) → paid (owner).
--
-- SECURITY DEFINER: the function runs as its owner (postgres / BYPASSRLS).
-- The webhook caller needs only EXECUTE, not UPDATE on orders.

DROP FUNCTION IF EXISTS public.confirm_order_paid(uuid);

CREATE FUNCTION public.confirm_order_paid(p_order_id uuid)
RETURNS void
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_status text;
BEGIN
  -- Lock the row to prevent a concurrent confirm or cancel on the same order.
  SELECT status
  INTO   v_status
  FROM   orders
  WHERE  id = p_order_id
  FOR UPDATE;

  IF NOT FOUND THEN
    RAISE EXCEPTION 'Order not found: %', p_order_id;
  END IF;

  -- Idempotent fast-path: webhook fired twice, order already confirmed.
  IF v_status = 'confirmed' THEN
    RETURN;
  END IF;

  -- Guard: only advance from pending_payment.
  -- Any other status (cancelled, shipped, received, paid, draft) means
  -- something has gone wrong with sequencing — surface it explicitly.
  IF v_status <> 'pending_payment' THEN
    RAISE EXCEPTION
      'Cannot confirm order %: expected status ''pending_payment'', found ''%''',
      p_order_id, v_status;
  END IF;

  UPDATE orders
  SET    status = 'confirmed'
  WHERE  id = p_order_id;

  -- Stone remains 'reserved'; no inventory change needed here.
END;
$$;

-- Grant to both roles: authenticated covers direct RPC calls during development;
-- service_role (used by the webhook Route Handler) can call this regardless of
-- grants, but explicit grant documents the intent.
GRANT EXECUTE ON FUNCTION public.confirm_order_paid(uuid) TO authenticated;
GRANT EXECUTE ON FUNCTION public.confirm_order_paid(uuid) TO service_role;


-- =============================================================================
-- 4. FUNCTION cancel_pending_payment_order(p_order_id uuid)
-- =============================================================================
-- Called by the Stripe webhook Route Handler after a payment_intent.payment_failed
-- or payment_intent.canceled event, OR by a cleanup job for timed-out sessions.
--
-- Atomically:
--   a) Verifies the order is still 'pending_payment'.
--   b) Cancels the order (status → 'cancelled').
--   c) Returns the stone to 'available' via the order_items link, so it
--      immediately reappears on the storefront for other buyers.
--
-- Without this function, a failed payment permanently leaves the stone as
-- 'reserved' with no path back to the storefront — the gap confirmed in the
-- pre-implementation audit (cancelOrder() in OrderRepository only restores
-- inventory when cancelling a 'paid' order, never a 'confirmed' one; and
-- no SQL function anywhere sets reserved → available).
--
-- Idempotent: calling again on an already-cancelled order is a safe no-op.

DROP FUNCTION IF EXISTS public.cancel_pending_payment_order(uuid);

CREATE FUNCTION public.cancel_pending_payment_order(p_order_id uuid)
RETURNS void
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_status text;
BEGIN
  -- Lock the order row first to prevent a concurrent confirm racing this cancel.
  SELECT status
  INTO   v_status
  FROM   orders
  WHERE  id = p_order_id
  FOR UPDATE;

  IF NOT FOUND THEN
    RAISE EXCEPTION 'Order not found: %', p_order_id;
  END IF;

  -- Idempotent fast-path: already cancelled (e.g. webhook fired twice).
  IF v_status = 'cancelled' THEN
    RETURN;
  END IF;

  -- Guard: only cancel from pending_payment.
  -- A 'confirmed' order means payment already succeeded and the seller was
  -- notified — do not silently undo that. Surface the conflict.
  IF v_status <> 'pending_payment' THEN
    RAISE EXCEPTION
      'Cannot cancel order %: expected status ''pending_payment'', found ''%''',
      p_order_id, v_status;
  END IF;

  -- b) Cancel the order.
  UPDATE orders
  SET    status = 'cancelled'
  WHERE  id = p_order_id;

  -- c) Release the stone. Uses order_items as the link — avoids needing to
  --    pass the inventory_item_id separately, and works if the schema ever
  --    supports multi-item orders.
  UPDATE inventory_items
  SET    status    = 'available',
         is_listed = true          -- restore storefront visibility
  WHERE  id IN (
    SELECT inventory_item_id
    FROM   order_items
    WHERE  order_id = p_order_id
  );
END;
$$;

GRANT EXECUTE ON FUNCTION public.cancel_pending_payment_order(uuid) TO authenticated;
GRANT EXECUTE ON FUNCTION public.cancel_pending_payment_order(uuid) TO service_role;
