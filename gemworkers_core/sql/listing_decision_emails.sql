-- =============================================================================
-- GemWorkers — Emails for listing approval (approve / reject / new request)
-- =============================================================================
-- Applied to live DB 2026-10-23
--
-- 1. inventory_items.listing_review_note — optional reason the owner gives
--    when rejecting (staff only; not in any public view). Cleared by the
--    admin when a stone is approved or sent again.
-- 2. Trigger inventory_listing_decision_notify (AFTER UPDATE, only when
--    listing_requested_at changes — it is set/cleared by the
--    inventory_listing_approval BEFORE trigger, so no "OF column" list):
--      NULL → set              : seller asked → email the OWNER
--      set  → NULL by the owner: approved (is_listed) / rejected (not listed)
--                                → email the SELLER
--      set  → NULL by the seller (withdrew the request) → no email
--    "By the owner" = public.is_owner() for the JWT caller.
--    Posts {"type":"LISTING_EVENT","item_id","event"} to offer-notify with the
--    existing Vault secret 'offer_reminder_secret' (x-reminder-secret), like
--    the payment reminder. net.http_post is queued inside the transaction.
--    Missing secret → warning, no email, the update still goes through.
-- =============================================================================

BEGIN;

ALTER TABLE public.inventory_items
  ADD COLUMN IF NOT EXISTS listing_review_note text
  CHECK (listing_review_note IS NULL OR char_length(listing_review_note) <= 500);

CREATE OR REPLACE FUNCTION public._listing_decision_notify()
RETURNS trigger
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public, pg_temp
AS $$
DECLARE
  v_event  text;
  v_secret text;
BEGIN
  IF OLD.listing_requested_at IS NULL AND NEW.listing_requested_at IS NOT NULL THEN
    v_event := 'requested';
  ELSIF OLD.listing_requested_at IS NOT NULL AND NEW.listing_requested_at IS NULL
        AND public.is_owner() THEN
    v_event := CASE WHEN NEW.is_listed THEN 'approved' ELSE 'rejected' END;
  ELSE
    RETURN NEW;
  END IF;

  SELECT s.decrypted_secret INTO v_secret
  FROM   vault.decrypted_secrets s
  WHERE  s.name = 'offer_reminder_secret'
  LIMIT  1;

  IF v_secret IS NULL OR v_secret = '' THEN
    RAISE WARNING '[listing notify] Vault secret offer_reminder_secret missing — no email for %', NEW.id;
    RETURN NEW;
  END IF;

  BEGIN
    PERFORM net.http_post(
      url                  := 'https://cvqzidqnwthzfodhzepz.supabase.co/functions/v1/offer-notify',
      body                 := jsonb_build_object('type', 'LISTING_EVENT', 'item_id', NEW.id, 'event', v_event),
      headers              := jsonb_build_object(
                                'Content-Type',      'application/json',
                                'x-reminder-secret', v_secret
                              ),
      timeout_milliseconds := 10000
    );
  EXCEPTION WHEN OTHERS THEN
    RAISE WARNING '[listing notify] queue failed for %: %', NEW.id, SQLERRM;
  END;

  RETURN NEW;
END;
$$;

REVOKE ALL ON FUNCTION public._listing_decision_notify() FROM PUBLIC, anon, authenticated;

DROP TRIGGER IF EXISTS inventory_listing_decision_notify ON public.inventory_items;
CREATE TRIGGER inventory_listing_decision_notify
  AFTER UPDATE ON public.inventory_items
  FOR EACH ROW
  WHEN (OLD.listing_requested_at IS DISTINCT FROM NEW.listing_requested_at)
  EXECUTE FUNCTION public._listing_decision_notify();

COMMIT;

-- VERIFICATION (read-only):
--   SELECT tgname FROM pg_trigger WHERE tgrelid = 'public.inventory_items'::regclass;
--   SELECT column_name FROM information_schema.columns
--   WHERE  table_name = 'inventory_items' AND column_name = 'listing_review_note';
