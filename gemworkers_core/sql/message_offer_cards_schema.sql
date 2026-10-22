-- =============================================================================
-- GemWorkers — Offer cards in the conversation: schema (plan step 2)
-- =============================================================================
-- Applied to live DB 2026-10-22
--
-- 1. messages.kind          'text' (normal message) or an offer event:
--                           offer_made | offer_accepted | offer_declined |
--                           offer_expired | offer_withdrawn | offer_countered |
--                           counter_accepted | counter_declined | counter_expired
--    messages.offer_id      the storefront_offers row the card is about
--    messages.offer_amount  amount shown on the card (exact cents)
-- 2. sender_role gains 'system' (cards are written by a trigger in step 3,
--    sender_user_id NULL). Rule: system ⇔ card, buyer/seller/owner ⇔ text.
-- 3. One card per (offer, event) — makes the step-3 trigger and the step-12
--    backfill safe to re-run.
-- 4. buyer_messages: kind, offer_id, offer_amount appended (CREATE OR REPLACE,
--    existing columns unchanged — this fails loudly if the live view differs).
--
-- Existing rows become kind = 'text' via the column default. Nothing writes
-- cards yet, so behaviour is unchanged until step 3.
-- message-notify (v7) already skips kind <> 'text'.
--
-- Safe to re-run: one transaction, IF NOT EXISTS / DROP IF EXISTS.
-- =============================================================================

BEGIN;

-- ── 1. New columns ──────────────────────────────────────────────────────────
ALTER TABLE public.messages
  ADD COLUMN IF NOT EXISTS kind         text          NOT NULL DEFAULT 'text',
  ADD COLUMN IF NOT EXISTS offer_id     uuid          REFERENCES public.storefront_offers(id) ON DELETE SET NULL,
  ADD COLUMN IF NOT EXISTS offer_amount numeric(12,2);

-- ── 2. sender_role: drop the old CHECK whatever its name, add the new one ──
DO $$
DECLARE
  v_name text;
BEGIN
  FOR v_name IN
    SELECT conname
    FROM   pg_constraint
    WHERE  conrelid = 'public.messages'::regclass
      AND  contype  = 'c'
      AND  pg_get_constraintdef(oid) LIKE '%sender_role%'
  LOOP
    EXECUTE format('ALTER TABLE public.messages DROP CONSTRAINT %I', v_name);
  END LOOP;
END;
$$;

ALTER TABLE public.messages
  ADD CONSTRAINT messages_sender_role_check
  CHECK (sender_role IN ('buyer', 'seller', 'owner', 'system'));

ALTER TABLE public.messages DROP CONSTRAINT IF EXISTS messages_kind_check;
ALTER TABLE public.messages
  ADD CONSTRAINT messages_kind_check
  CHECK (kind IN ('text',
                  'offer_made', 'offer_accepted', 'offer_declined',
                  'offer_expired', 'offer_withdrawn', 'offer_countered',
                  'counter_accepted', 'counter_declined', 'counter_expired'));

-- Text rows carry no offer data; cards are always system rows with an amount.
-- (offer_id may become NULL later via ON DELETE SET NULL, so it isn't required.)
ALTER TABLE public.messages DROP CONSTRAINT IF EXISTS messages_kind_shape_check;
ALTER TABLE public.messages
  ADD CONSTRAINT messages_kind_shape_check
  CHECK (
    CASE WHEN kind = 'text'
         THEN sender_role <> 'system' AND offer_id IS NULL AND offer_amount IS NULL
         ELSE sender_role =  'system' AND sender_user_id IS NULL AND offer_amount > 0
    END
  );

-- ── 3. One card per (offer, event) ──────────────────────────────────────────
CREATE UNIQUE INDEX IF NOT EXISTS messages_offer_kind_key
  ON public.messages (offer_id, kind)
  WHERE offer_id IS NOT NULL;

-- ── 4. buyer_messages: append the card columns ─────────────────────────────
-- Same definition as messaging_setup.sql; only the last three columns are new.
-- 'system' rows already show as is_mine = false, sender_name 'GemWorkers'.
CREATE OR REPLACE VIEW public.buyer_messages
WITH (security_invoker = false)
AS
SELECT
  m.id,
  m.conversation_id,
  (m.sender_role = 'buyer') AS is_mine,
  CASE WHEN m.sender_role = 'buyer'
       THEN COALESCE(c.buyer_first_name, 'You')
       ELSE 'GemWorkers'
  END                        AS sender_name,
  m.body,
  m.linked_inventory_item_id,
  m.created_at,
  m.kind,
  m.offer_id,
  m.offer_amount
FROM  public.messages      m
JOIN  public.conversations c ON c.id = m.conversation_id
WHERE c.buyer_id = auth.uid();

-- CREATE OR REPLACE keeps grants, but restate them so a re-run is exact.
REVOKE ALL ON public.buyer_messages FROM anon, authenticated;
GRANT SELECT ON public.buyer_messages TO authenticated;

COMMIT;


-- =============================================================================
-- VERIFICATION (read-only)
-- =============================================================================
--   SELECT column_name, data_type, is_nullable, column_default
--   FROM   information_schema.columns
--   WHERE  table_schema = 'public' AND table_name = 'messages'
--   ORDER  BY ordinal_position;
--
--   SELECT conname, pg_get_constraintdef(oid)
--   FROM   pg_constraint
--   WHERE  conrelid = 'public.messages'::regclass
--   ORDER  BY 1;
--
--   SELECT pg_get_viewdef('public.buyer_messages'::regclass, true);
--
--   SELECT kind, sender_role, count(*) FROM public.messages GROUP BY 1, 2;
-- =============================================================================
