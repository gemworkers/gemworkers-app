-- =============================================================================
-- GemWorkers — Message email nudges (throttle state)
-- =============================================================================
-- Applied to live DB 2026-10-21
--
-- 1. conversations.buyer_notified_at / seller_notified_at / owner_notified_at
--    — when that side was last emailed about new messages in the thread.
-- 2. claim_message_notification(p_conversation_id, p_role) RETURNS boolean
--    Atomically stamps <role>_notified_at = now() and returns true when that
--    side may be emailed now; false otherwise (or when the conversation does
--    not exist). A side may be emailed when ANY of:
--      - it has never been emailed for this conversation,
--      - the last email was more than 30 minutes ago,
--      - it has read the conversation since the last email
--        (<role>_last_read_at > <role>_notified_at).
--    The single UPDATE … RETURNING takes the row lock, so two webhooks firing
--    at once cannot both claim the same side.
--    Called only by the message-notify Edge Function (service_role).
--
-- Requires: messaging_setup.sql.
--
-- Safe to re-run: IF NOT EXISTS / CREATE OR REPLACE, all in one transaction.
-- =============================================================================

BEGIN;


-- =============================================================================
-- 1. COLUMNS
-- =============================================================================

ALTER TABLE public.conversations
  ADD COLUMN IF NOT EXISTS buyer_notified_at  timestamptz,
  ADD COLUMN IF NOT EXISTS seller_notified_at timestamptz,
  ADD COLUMN IF NOT EXISTS owner_notified_at  timestamptz;


-- =============================================================================
-- 2. claim_message_notification
-- =============================================================================

CREATE OR REPLACE FUNCTION public.claim_message_notification(
  p_conversation_id uuid,
  p_role            text
)
RETURNS boolean
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public, pg_temp
AS $$
DECLARE
  v_claimed boolean;
BEGIN
  IF p_role IS NULL OR p_role NOT IN ('buyer', 'seller', 'owner') THEN
    RAISE EXCEPTION 'claim_message_notification: invalid role %', p_role;
  END IF;

  UPDATE public.conversations c
  SET    buyer_notified_at  = CASE WHEN p_role = 'buyer'  THEN now() ELSE c.buyer_notified_at  END,
         seller_notified_at = CASE WHEN p_role = 'seller' THEN now() ELSE c.seller_notified_at END,
         owner_notified_at  = CASE WHEN p_role = 'owner'  THEN now() ELSE c.owner_notified_at  END
  WHERE  c.id = p_conversation_id
    AND  CASE p_role
           WHEN 'buyer' THEN
                c.buyer_notified_at IS NULL
             OR c.buyer_notified_at < now() - interval '30 minutes'
             OR c.buyer_last_read_at > c.buyer_notified_at
           WHEN 'seller' THEN
                c.seller_notified_at IS NULL
             OR c.seller_notified_at < now() - interval '30 minutes'
             OR c.seller_last_read_at > c.seller_notified_at
           WHEN 'owner' THEN
                c.owner_notified_at IS NULL
             OR c.owner_notified_at < now() - interval '30 minutes'
             OR c.owner_last_read_at > c.owner_notified_at
         END
  RETURNING true INTO v_claimed;

  RETURN COALESCE(v_claimed, false);
END;
$$;

REVOKE ALL     ON FUNCTION public.claim_message_notification(uuid, text) FROM PUBLIC, anon, authenticated;
GRANT  EXECUTE ON FUNCTION public.claim_message_notification(uuid, text) TO service_role;


COMMIT;


-- =============================================================================
-- VERIFICATION (run separately after applying)
-- =============================================================================
--
-- Columns exist:
--   SELECT column_name, data_type
--   FROM   information_schema.columns
--   WHERE  table_schema = 'public' AND table_name = 'conversations'
--     AND  column_name LIKE '%\_notified\_at'
--   ORDER  BY 1;
--   -- expect 3 rows, timestamptz
--
-- Function is SECURITY DEFINER with a fixed search_path:
--   SELECT p.prosecdef, p.proconfig
--   FROM   pg_proc p
--   WHERE  p.proname = 'claim_message_notification';
--   -- expect: true | {"search_path=public, pg_temp"}
--
-- Only service_role (and postgres) can execute it:
--   SELECT grantee, privilege_type
--   FROM   information_schema.routine_privileges
--   WHERE  routine_schema = 'public' AND routine_name = 'claim_message_notification'
--   ORDER  BY 1;
--   -- expect postgres + service_role only; no PUBLIC / anon / authenticated
--
--   SELECT has_function_privilege('anon',          'public.claim_message_notification(uuid, text)', 'EXECUTE'),
--          has_function_privilege('authenticated', 'public.claim_message_notification(uuid, text)', 'EXECUTE'),
--          has_function_privilege('service_role',  'public.claim_message_notification(uuid, text)', 'EXECUTE');
--   -- expect: false | false | true
--
-- Throttle dry-run on a real conversation (wrapped in a transaction so
-- nothing sticks). Replace <conversation_id>.
--   BEGIN;
--   SELECT public.claim_message_notification('<conversation_id>', 'seller');  -- true (first / stale)
--   SELECT public.claim_message_notification('<conversation_id>', 'seller');  -- false (within 30 min)
--   UPDATE public.conversations SET seller_last_read_at = now() + interval '1 second'
--   WHERE  id = '<conversation_id>';
--   SELECT public.claim_message_notification('<conversation_id>', 'seller');  -- true (read since)
--   SELECT public.claim_message_notification(gen_random_uuid(), 'buyer');      -- false (no such row)
--   ROLLBACK;
-- =============================================================================
