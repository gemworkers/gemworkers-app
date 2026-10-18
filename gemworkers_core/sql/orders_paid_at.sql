-- =============================================================================
-- GemWorkers — orders.paid_at (exact payment time)
-- =============================================================================
-- Applied to live DB 2026-10-18
--
-- 1. orders.paid_at timestamptz.
-- 2. Trigger orders_set_paid_at stamps paid_at = now() when an order moves
--    pending_payment → confirmed (Stripe payment) and paid_at is still NULL.
-- 3. Backfill: paid_at = created_at for orders already confirmed / shipped /
--    received / paid (closest known approximation for historical orders).
--
-- Function and trigger below match the live definitions
-- (pg_get_functiondef / pg_get_triggerdef, 2026-10-18).
-- Used by the admin Orders & Shipping page for "Paid {date}" and "Ship by".
-- =============================================================================

BEGIN;

-- ── 1. Column ────────────────────────────────────────────────────────────────
ALTER TABLE orders ADD COLUMN IF NOT EXISTS paid_at timestamptz;

-- ── 2. Trigger ───────────────────────────────────────────────────────────────
CREATE OR REPLACE FUNCTION public.set_order_paid_at()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
BEGIN
  IF NEW.status = 'confirmed'
     AND OLD.status = 'pending_payment'
     AND NEW.paid_at IS NULL THEN
    NEW.paid_at := now();
  END IF;
  RETURN NEW;
END;
$function$;

DROP TRIGGER IF EXISTS orders_set_paid_at ON public.orders;
CREATE TRIGGER orders_set_paid_at
  BEFORE UPDATE OF status ON public.orders
  FOR EACH ROW EXECUTE FUNCTION set_order_paid_at();

-- ── 3. Backfill ──────────────────────────────────────────────────────────────
UPDATE orders
SET    paid_at = created_at
WHERE  paid_at IS NULL
  AND  status IN ('confirmed', 'shipped', 'received', 'paid');

COMMIT;
