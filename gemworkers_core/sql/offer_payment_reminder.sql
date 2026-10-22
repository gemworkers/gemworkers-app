-- =============================================================================
-- GemWorkers — Offer email notifications (part 2: payment reminder)
-- =============================================================================
-- Applied to live DB 2026-10-21
--
-- Emails the buyer once, ~12 h before an accepted offer's payment window ends.
--
-- 1. orders.payment_reminder_sent_at — stamped when the reminder is queued.
--
-- 2. send_offer_payment_reminders() RETURNS int (reminders queued)
--    Picks offer orders still in 'pending_payment', not yet reminded, whose
--    payment_due_at is 11–13 h away. A single UPDATE … RETURNING stamps
--    payment_reminder_sent_at and drives the loop, so a row is stamped and
--    queued exactly once even if two runs overlap (the second waits on the
--    row lock, re-checks IS NULL and skips it). net.http_post only queues the
--    request inside this transaction, so stamp + request commit or roll back
--    together.
--    Each order is POSTed to offer-notify as
--      {"type":"PAYMENT_REMINDER","order_id":"…"}
--    with header x-reminder-secret read from Supabase Vault
--    (name 'offer_reminder_secret'). If the Vault secret is missing nothing
--    is stamped, so reminders go out once it is added.
--    The Edge Function re-checks the order is still pending_payment.
--    Trade-off: if offer-notify or Resend fails, that reminder is not retried.
--
-- 3. pg_cron job 'gemworkers_offer_payment_reminder', every 15 minutes.
--    The 2 h window gives each order ~8 chances to be picked up.
--
-- Requires: offer_payment_window.sql, offer_notify.sql, the pg_net extension
--           (already used by the Database Webhooks), pg_cron (see
--           pending_payment_sweep.sql), and the Vault secret
--           'offer_reminder_secret' (inserted separately — never in this file).
--
-- Safe to re-run: IF NOT EXISTS / CREATE OR REPLACE / unschedule-then-schedule,
-- all in one transaction.
-- =============================================================================

BEGIN;


-- =============================================================================
-- 1. COLUMN
-- =============================================================================

ALTER TABLE public.orders
  ADD COLUMN IF NOT EXISTS payment_reminder_sent_at timestamptz;


-- =============================================================================
-- 2. send_offer_payment_reminders
-- =============================================================================

CREATE OR REPLACE FUNCTION public.send_offer_payment_reminders()
RETURNS int
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public, pg_temp
AS $$
DECLARE
  v_secret   text;
  v_order_id uuid;
  v_queued   int := 0;
BEGIN
  SELECT s.decrypted_secret
  INTO   v_secret
  FROM   vault.decrypted_secrets s
  WHERE  s.name = 'offer_reminder_secret'
  LIMIT  1;

  IF v_secret IS NULL OR v_secret = '' THEN
    -- Don't stamp anything: the reminders go out once the secret exists.
    RAISE WARNING '[send_offer_payment_reminders] Vault secret offer_reminder_secret missing — nothing sent';
    RETURN 0;
  END IF;

  FOR v_order_id IN
    UPDATE public.orders o
    SET    payment_reminder_sent_at = now()
    WHERE  o.status = 'pending_payment'
      AND  o.offer_id IS NOT NULL
      AND  o.payment_reminder_sent_at IS NULL
      AND  o.payment_due_at BETWEEN now() + interval '11 hours'
                                AND now() + interval '13 hours'
    RETURNING o.id
  LOOP
    PERFORM net.http_post(
      url                  := 'https://cvqzidqnwthzfodhzepz.supabase.co/functions/v1/offer-notify',
      body                 := jsonb_build_object('type', 'PAYMENT_REMINDER', 'order_id', v_order_id),
      headers              := jsonb_build_object(
                                'Content-Type',      'application/json',
                                'x-reminder-secret', v_secret
                              ),
      timeout_milliseconds := 10000
    );
    v_queued := v_queued + 1;
  END LOOP;

  RAISE NOTICE '[send_offer_payment_reminders] done: % queued', v_queued;
  RETURN v_queued;
END;
$$;

REVOKE ALL     ON FUNCTION public.send_offer_payment_reminders() FROM PUBLIC, anon, authenticated;
GRANT  EXECUTE ON FUNCTION public.send_offer_payment_reminders() TO service_role;
GRANT  EXECUTE ON FUNCTION public.send_offer_payment_reminders() TO postgres;


-- =============================================================================
-- 3. SCHEDULE VIA pg_cron (idempotent)
-- =============================================================================
-- cron.unschedule raises if the job does not exist yet, so wrap it.

DO $$
BEGIN
  PERFORM cron.unschedule('gemworkers_offer_payment_reminder');
EXCEPTION
  WHEN OTHERS THEN
    NULL;  -- job did not exist yet; safe to continue
END;
$$;

SELECT cron.schedule(
  'gemworkers_offer_payment_reminder',  -- job name (unique key)
  '*/15 * * * *',                       -- every 15 minutes
  $$
    SELECT public.send_offer_payment_reminders();
  $$
);


COMMIT;


-- =============================================================================
-- VERIFICATION (run separately after applying)
-- =============================================================================
--
-- Column exists:
--   SELECT column_name, data_type
--   FROM   information_schema.columns
--   WHERE  table_schema = 'public' AND table_name = 'orders'
--     AND  column_name = 'payment_reminder_sent_at';
--   -- expect 1 row: payment_reminder_sent_at | timestamp with time zone
--
-- Function is SECURITY DEFINER with a fixed search_path:
--   SELECT p.prosecdef, p.proconfig
--   FROM   pg_proc p
--   WHERE  p.proname = 'send_offer_payment_reminders';
--   -- expect: true | {"search_path=public, pg_temp"}
--
-- Only service_role (and postgres) can execute it:
--   SELECT has_function_privilege('anon',          'public.send_offer_payment_reminders()', 'EXECUTE'),
--          has_function_privilege('authenticated', 'public.send_offer_payment_reminders()', 'EXECUTE'),
--          has_function_privilege('service_role',  'public.send_offer_payment_reminders()', 'EXECUTE');
--   -- expect: false | false | true
--
-- Vault secret present (shows only the name, never the value):
--   SELECT name, created_at FROM vault.secrets WHERE name = 'offer_reminder_secret';
--   -- expect 1 row
--
-- Cron job scheduled exactly once:
--   SELECT jobid, jobname, schedule, command, active
--   FROM   cron.job
--   WHERE  jobname = 'gemworkers_offer_payment_reminder';
--   -- expect 1 row, '*/15 * * * *', active = true
--
-- Recent cron runs:
--   SELECT start_time, status, return_message
--   FROM   cron.job_run_details
--   WHERE  jobid = (SELECT jobid FROM cron.job WHERE jobname = 'gemworkers_offer_payment_reminder')
--   ORDER  BY start_time DESC
--   LIMIT  10;
--
-- Stamped reminders:
--   SELECT id, status, offer_id, payment_due_at, payment_reminder_sent_at
--   FROM   orders
--   WHERE  payment_reminder_sent_at IS NOT NULL
--   ORDER  BY payment_reminder_sent_at DESC
--   LIMIT  10;
--
-- pg_net responses (status 200 + {"ok":true,"emailsSent":1} expected):
--   SELECT id, status_code, content, error_msg, created
--   FROM   net._http_response
--   ORDER  BY created DESC
--   LIMIT  10;
-- =============================================================================


-- =============================================================================
-- MANUAL TEST (run separately — sends a real email to the test buyer)
-- =============================================================================
-- Pick a TEST offer order that is still pending_payment. Moving its deadline
-- to now()+12h shortens/extends that buyer's real payment window, so only do
-- this on a test order.
--
--   SELECT id, status, offer_id, payment_due_at, payment_reminder_sent_at
--   FROM   orders
--   WHERE  status = 'pending_payment' AND offer_id IS NOT NULL
--   ORDER  BY created_at DESC;
--
--   UPDATE orders
--   SET    payment_due_at           = now() + interval '12 hours',
--          payment_reminder_sent_at = NULL
--   WHERE  id = '<test_order_id>';
--
--   SELECT public.send_offer_payment_reminders();   -- expect 1
--   SELECT public.send_offer_payment_reminders();   -- expect 0 (already stamped)
--
--   -- A few seconds later, check the call went through:
--   SELECT status_code, content, error_msg
--   FROM   net._http_response
--   ORDER  BY created DESC
--   LIMIT  1;
--   -- expect 200 | {"ok":true,"emailsSent":1}
-- =============================================================================
