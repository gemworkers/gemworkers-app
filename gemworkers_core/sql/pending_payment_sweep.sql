-- =============================================================================
-- GemWorkers — Pending-Payment Sweep
-- =============================================================================
-- Releases stones from orders that have been stuck in 'pending_payment' for
-- longer than 30 minutes. Runs every 5 minutes via pg_cron.
--
-- The normal release paths are:
--   • Stripe webhook checkout.session.expired   → cancel_pending_payment_order()
--   • Buyer cancels at checkout page            → cancelPendingOrder() Server Action
-- This sweep is a safety net for any order that falls through both paths
-- (e.g. missed webhook, server restart during redirect, network failure).
--
-- Idempotent: safe to run more than once on the live DB.
--   • CREATE EXTENSION IF NOT EXISTS
--   • CREATE OR REPLACE FUNCTION
--   • cron.unschedule before cron.schedule
-- =============================================================================


-- =============================================================================
-- 1. ENABLE pg_cron EXTENSION
-- =============================================================================
-- pg_cron is Supabase's built-in cron scheduler. It must be enabled once.
-- REQUIRES: the postgres (superuser) role in the Supabase SQL Editor.
-- The extension installs into the 'cron' schema automatically; Supabase
-- projects have this enabled by default in newer projects. If it fails with
-- "extension already exists", it is already active and you can skip this line.

CREATE EXTENSION IF NOT EXISTS pg_cron;


-- =============================================================================
-- 2. SWEEP FUNCTION: sweep_expired_pending_orders()
-- =============================================================================
-- Finds every order that has been in 'pending_payment' for more than
-- 30 minutes and calls cancel_pending_payment_order() on each one.
--
-- Each call runs in its own nested exception block so that a single failure
-- (e.g. the webhook just confirmed that order milliseconds before the sweep
-- ran, causing the function to raise 'Cannot cancel order: found confirmed')
-- is logged as a WARNING and skipped. The loop always continues to the next
-- order — one bad row never aborts the whole sweep.
--
-- SECURITY DEFINER: runs as the postgres owner (BYPASSRLS). The scheduler
-- invokes this function with no user session, so it needs elevated rights
-- to call cancel_pending_payment_order which itself is SECURITY DEFINER.

CREATE OR REPLACE FUNCTION public.sweep_expired_pending_orders()
RETURNS void
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  -- Threshold: how long an order may stay in 'pending_payment' before the
  -- sweep cancels it. 30 minutes gives Stripe enough time to redirect the
  -- buyer back and for the webhook to fire, while not waiting the full ~24h
  -- Stripe session expiry.
  v_threshold  interval := '30 minutes';

  v_order_id   uuid;
  v_cancelled  int := 0;
  v_skipped    int := 0;
BEGIN
  FOR v_order_id IN
    SELECT id
    FROM   orders
    WHERE  status     = 'pending_payment'
      AND  created_at < now() - v_threshold
    ORDER BY created_at   -- oldest first
  LOOP
    BEGIN
      -- Each call is atomic: sets order→'cancelled' and stone→'available'.
      -- cancel_pending_payment_order is idempotent for already-cancelled rows
      -- and raises for rows in any other status (e.g. just confirmed).
      PERFORM cancel_pending_payment_order(v_order_id);
      v_cancelled := v_cancelled + 1;
    EXCEPTION
      WHEN OTHERS THEN
        -- Log and skip — do NOT re-raise. One failing order must not abort
        -- the sweep and leave the remaining expired orders unreleased.
        RAISE WARNING '[sweep_expired_pending_orders] skipped order %: %',
          v_order_id, SQLERRM;
        v_skipped := v_skipped + 1;
    END;
  END LOOP;

  RAISE NOTICE '[sweep_expired_pending_orders] done: % cancelled, % skipped',
    v_cancelled, v_skipped;
END;
$$;

GRANT EXECUTE ON FUNCTION public.sweep_expired_pending_orders() TO service_role;
GRANT EXECUTE ON FUNCTION public.sweep_expired_pending_orders() TO postgres;


-- =============================================================================
-- 3. SCHEDULE VIA pg_cron (idempotent)
-- =============================================================================
-- Unschedule first so that re-running this file never creates a duplicate job.
-- cron.unschedule raises if the job name does not exist, so wrap in a DO block.

DO $$
BEGIN
  PERFORM cron.unschedule('gemworkers_pending_payment_sweep');
EXCEPTION
  WHEN OTHERS THEN
    NULL;  -- job did not exist yet; safe to continue
END;
$$;

SELECT cron.schedule(
  'gemworkers_pending_payment_sweep',   -- job name (unique key)
  '*/5 * * * *',                        -- every 5 minutes
  $$
    SELECT public.sweep_expired_pending_orders();
  $$
);
