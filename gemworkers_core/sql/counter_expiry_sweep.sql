-- =============================================================================
-- GemWorkers — Counter-offer expiry in the sweep (plan step 8)
-- =============================================================================
-- Applied to live DB 2026-10-22
--
-- sweep_expired_pending_orders() — LIVE definition copied exactly (cron
-- gemworkers_pending_payment_sweep, every 5 min). Changed:
--   + v_counters counter
--   + after the order loop: countered offers with counter_expires_at <= now()
--     → status 'expired' (own BEGIN/EXCEPTION so it can never stop the order
--     sweep). The offer trigger writes the 'counter_expired' card.
--   ~ final NOTICE also reports counters expired
-- The order part is untouched. respond_to_counter already refuses a counter
-- once counter_expires_at has passed, so the ≤5 min gap is harmless.
-- offer-notify ignores countered→expired until step 9.
--
-- Requires: counter_offer_setup.sql (step 6).
-- =============================================================================

BEGIN;

CREATE OR REPLACE FUNCTION public.sweep_expired_pending_orders()
 RETURNS void
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO 'public'
AS $function$
DECLARE
  v_threshold  interval := '30 minutes';
  v_order_id   uuid;
  v_cancelled  int := 0;
  v_skipped    int := 0;
  v_counters   int := 0;
BEGIN
  FOR v_order_id IN
    SELECT id
    FROM   orders
    WHERE  status = 'pending_payment'
      AND  COALESCE(payment_due_at, created_at + v_threshold) < now()
    ORDER BY created_at
  LOOP
    BEGIN
      PERFORM cancel_pending_payment_order(v_order_id);
      v_cancelled := v_cancelled + 1;
    EXCEPTION
      WHEN OTHERS THEN
        RAISE WARNING '[sweep_expired_pending_orders] skipped order %: %',
          v_order_id, SQLERRM;
        v_skipped := v_skipped + 1;
    END;
  END LOOP;

  -- Counter-offers past their 48h window → expired (card: counter_expired).
  BEGIN
    UPDATE storefront_offers
    SET    status = 'expired'
    WHERE  status = 'countered'
      AND  counter_expires_at <= now();
    GET DIAGNOSTICS v_counters = ROW_COUNT;
  EXCEPTION
    WHEN OTHERS THEN
      RAISE WARNING '[sweep_expired_pending_orders] counter expiry failed: %', SQLERRM;
  END;

  RAISE NOTICE '[sweep_expired_pending_orders] done: % cancelled, % skipped, % counters expired',
    v_cancelled, v_skipped, v_counters;
END;
$function$
;

COMMIT;


-- VERIFICATION (read-only):
--   SELECT prosrc LIKE '%counter_expires_at%' FROM pg_proc WHERE proname = 'sweep_expired_pending_orders';
