-- =============================================================================
-- GemWorkers — Stone Lifecycle Fix: mark stone sold on payment confirmation
-- =============================================================================
-- BUG: When confirm_order_paid() advanced an order from 'pending_payment' to
-- 'confirmed', it left the stone in status='reserved' with is_listed=true.
-- The public_listings view filtered only on status <> 'sold', so a reserved
-- stone still passed that filter and remained visible on the storefront as
-- buyable — a second buyer could attempt to purchase a stone already paid for.
--
-- FIX (two parts, applied in Supabase SQL Editor 2026-06-27):
--   1. confirm_order_paid() now marks the stone sold (status='sold',
--      is_listed=false) in the same transaction as the order confirmation.
--   2. public_listings view now filters on status = 'available' (explicit
--      allowlist) rather than status <> 'sold' (implicit blocklist), so
--      reserved/sold/unlisted stones all stay off the storefront.
--
-- See also:
--   sql/payment_pending_states.sql  — original confirm_order_paid definition
--   sql/public_storefront_view.sql  — original public_listings definition
-- =============================================================================


-- =============================================================================
-- 1. UPDATED FUNCTION: confirm_order_paid(p_order_id uuid)
-- =============================================================================
-- Replaces the version in payment_pending_states.sql.
-- The only behavioural change is the new UPDATE at the end that marks the
-- stone(s) sold. Everything else (idempotency guard, status check, locking)
-- is unchanged.

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
  IF v_status <> 'pending_payment' THEN
    RAISE EXCEPTION
      'Cannot confirm order %: expected status ''pending_payment'', found ''%''',
      p_order_id, v_status;
  END IF;

  UPDATE orders
  SET    status = 'confirmed'
  WHERE  id = p_order_id;

  -- Mark the stone(s) sold so they disappear from the storefront immediately.
  -- Uses order_items as the link — avoids a separate parameter and supports
  -- multi-item orders if the schema ever grows that way.
  UPDATE inventory_items
  SET    status    = 'sold',
         is_listed = false
  WHERE  id IN (
    SELECT inventory_item_id
    FROM   order_items
    WHERE  order_id = p_order_id
  );
END;
$$;

GRANT EXECUTE ON FUNCTION public.confirm_order_paid(uuid) TO authenticated;
GRANT EXECUTE ON FUNCTION public.confirm_order_paid(uuid) TO service_role;


-- =============================================================================
-- 2. UPDATED VIEW: public_listings
-- =============================================================================
-- Replaces the version in public_storefront_view.sql.
-- Changes:
--   • WHERE status = 'available'  (was: status <> 'sold')
--     An explicit allowlist is safer — reserved/sold/unlisted stones are all
--     excluded without relying on every bad-state value being enumerated.
--   • Added i.product_type as the last column (needed by browse cards to
--     choose the correct spec display template per stone type).
-- Security model (unchanged): security_invoker = false; view runs as
-- postgres (BYPASSRLS). Anon gets SELECT on the view only, never on the table.

CREATE OR REPLACE VIEW public.public_listings
WITH (security_invoker = false)
AS
SELECT
    i.id,
    i.title,
    i.gem_type,
    i.variety,
    i.weight_value,
    i.weight_unit,
    i.origin_country,
    i.selling_price,
    i.seller_id,
    s.name               AS seller_name,
    (i.image_urls ->> 0) AS image_url,
    i.sale_method,
    i.shipping_cost,
    i.product_type
FROM  public.inventory_items i
JOIN  public.sellers         s ON s.id = i.seller_id
WHERE i.is_listed = true
  AND i.status    = 'available'   -- explicit allowlist; reserved/sold stones stay off storefront
  AND s.status    = 'active';

GRANT SELECT ON public.public_listings TO anon;
GRANT SELECT ON public.public_listings TO authenticated;


-- =============================================================================
-- 3. ONE-TIME DATA CLEANUP (migration — do not run again after first apply)
-- =============================================================================
-- Before this fix, stones were left as 'reserved' forever once their order
-- was confirmed/shipped/received/paid. This UPDATE corrects all pre-existing
-- rows that are already past the pending_payment stage.
--
-- Safe to run only ONCE. Running again is a no-op (WHERE status = 'reserved'
-- will match zero rows for confirmed orders after the first run).

UPDATE public.inventory_items
SET    status    = 'sold',
       is_listed = false
WHERE  id IN (
  SELECT oi.inventory_item_id
  FROM   public.order_items  oi
  JOIN   public.orders       o  ON o.id = oi.order_id
  WHERE  o.status IN ('confirmed', 'shipped', 'received', 'paid')
)
  AND status = 'reserved';
