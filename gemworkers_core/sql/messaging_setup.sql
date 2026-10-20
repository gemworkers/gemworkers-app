-- =============================================================================
-- GemWorkers — Message portal (buyer ↔ GemWorkers staff, per stone)
-- =============================================================================
-- NOT YET APPLIED to the live DB.
--
-- 1. Tables
--      conversations — one per (stone, buyer): UNIQUE(inventory_item_id, buyer_id).
--                      seller_id and buyer_first_name are snapshots copied when
--                      the conversation is created. Per-side read markers:
--                      buyer_last_read_at / seller_last_read_at / owner_last_read_at.
--      messages      — body (1–2000 chars), sender_role buyer|seller|owner,
--                      at most one linked stone per message.
-- 2. RLS: seller reads own (seller_id = current_seller_id()); owner all
--    (is_owner()). Buyers have NO direct table access (no policy, and anon has
--    no grants at all).
-- 3. Buyer views buyer_conversations / buyer_messages (security definer views
--    filtered on auth.uid()). They never expose seller_id, seller name,
--    sender_user_id or sender_role — staff replies show as "GemWorkers".
-- 4. SECURITY DEFINER functions (fixed search_path). All writes go through them:
--      ask_about_stone, send_buyer_message, send_staff_message,
--      mark_conversation_read, message_stone_cards,
--      buyer_unread_count, staff_unread_count
--    Rules enforced inside: confirmed buyer email, trimmed body 1–2000 chars,
--    max one linked stone, no emails / phone numbers / non-gemworkers.com
--    links, rate limits, closed/blocked conversations refuse new messages.
--
-- Friendly errors: every rule raises SQLSTATE P0001 with a human-readable
-- MESSAGE (safe to show as-is) and a stable machine code in DETAIL
-- (e.g. 'contact_email', 'rate_too_fast') for clients that want to branch.
--
-- Requires: public.is_owner(), public.current_seller_id() (rls_policies.sql),
--           public.buyers (buyer_accounts.sql), orders.shipping_name
--           (all_customers_view.sql).
--
-- Safe to re-run: IF NOT EXISTS / DROP IF EXISTS / CREATE OR REPLACE, all in
-- one transaction.
-- =============================================================================

BEGIN;


-- =============================================================================
-- 1. TABLES + INDEXES
-- =============================================================================

CREATE TABLE IF NOT EXISTS public.conversations (
  id                  uuid        PRIMARY KEY DEFAULT gen_random_uuid(),
  inventory_item_id   uuid        REFERENCES public.inventory_items(id) ON DELETE SET NULL,
  buyer_id            uuid        NOT NULL REFERENCES public.buyers(id) ON DELETE CASCADE,
  seller_id           uuid        NOT NULL REFERENCES public.sellers(id),   -- snapshot at create
  buyer_first_name    text,                                                 -- snapshot at create
  status              text        NOT NULL DEFAULT 'open'
                                  CHECK (status IN ('open', 'closed', 'blocked')),
  created_at          timestamptz NOT NULL DEFAULT now(),
  last_message_at     timestamptz NOT NULL DEFAULT now(),
  buyer_last_read_at  timestamptz,
  seller_last_read_at timestamptz,
  owner_last_read_at  timestamptz,
  CONSTRAINT conversations_item_buyer_key UNIQUE (inventory_item_id, buyer_id)
);

CREATE TABLE IF NOT EXISTS public.messages (
  id                       uuid        PRIMARY KEY DEFAULT gen_random_uuid(),
  conversation_id          uuid        NOT NULL REFERENCES public.conversations(id) ON DELETE CASCADE,
  sender_role              text        NOT NULL CHECK (sender_role IN ('buyer', 'seller', 'owner')),
  sender_user_id           uuid        REFERENCES auth.users(id) ON DELETE SET NULL,
  body                     text        NOT NULL CHECK (char_length(body) BETWEEN 1 AND 2000),
  linked_inventory_item_id uuid        REFERENCES public.inventory_items(id) ON DELETE SET NULL,
  created_at               timestamptz NOT NULL DEFAULT now()
);

-- Inbox lists (newest first) + buyer new-conversation rate limit.
CREATE INDEX IF NOT EXISTS conversations_seller_last_idx
  ON public.conversations (seller_id, last_message_at DESC);
CREATE INDEX IF NOT EXISTS conversations_buyer_last_idx
  ON public.conversations (buyer_id, last_message_at DESC);
CREATE INDEX IF NOT EXISTS conversations_buyer_created_idx
  ON public.conversations (buyer_id, created_at DESC);

-- Thread loading, unread counts.
CREATE INDEX IF NOT EXISTS messages_conversation_created_idx
  ON public.messages (conversation_id, created_at);
-- Per-sender rate limits.
CREATE INDEX IF NOT EXISTS messages_sender_created_idx
  ON public.messages (sender_user_id, created_at DESC);
-- message_stone_cards lookups.
CREATE INDEX IF NOT EXISTS messages_linked_item_idx
  ON public.messages (linked_inventory_item_id)
  WHERE linked_inventory_item_id IS NOT NULL;


-- =============================================================================
-- 2. ROW LEVEL SECURITY
-- =============================================================================
-- Seller: SELECT own conversations + their messages.
-- Owner : FOR ALL (moderation: close/block, delete abusive messages).
-- Buyer : nothing — they read through the views in section 3.
-- INSERT is not granted to anyone: new messages must go through the functions
-- so the content rules, rate limits and last_message_at bookkeeping apply.

ALTER TABLE public.conversations ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.messages      ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS conversations_seller_select ON public.conversations;
DROP POLICY IF EXISTS conversations_owner         ON public.conversations;
DROP POLICY IF EXISTS messages_seller_select      ON public.messages;
DROP POLICY IF EXISTS messages_owner              ON public.messages;

CREATE POLICY conversations_seller_select
  ON public.conversations FOR SELECT
  TO authenticated
  USING (seller_id = public.current_seller_id());

CREATE POLICY conversations_owner
  ON public.conversations FOR ALL
  TO authenticated
  USING      (public.is_owner())
  WITH CHECK (public.is_owner());

CREATE POLICY messages_seller_select
  ON public.messages FOR SELECT
  TO authenticated
  USING (EXISTS (
    SELECT 1 FROM public.conversations c
    WHERE  c.id = messages.conversation_id
      AND  c.seller_id = public.current_seller_id()
  ));

CREATE POLICY messages_owner
  ON public.messages FOR ALL
  TO authenticated
  USING      (public.is_owner())
  WITH CHECK (public.is_owner());

-- Supabase default privileges grant ALL on new tables to anon + authenticated.
REVOKE ALL ON public.conversations FROM anon, authenticated;
REVOKE ALL ON public.messages      FROM anon, authenticated;
GRANT SELECT, UPDATE, DELETE ON public.conversations TO authenticated;
GRANT SELECT, UPDATE, DELETE ON public.messages      TO authenticated;


-- =============================================================================
-- 3. BUYER VIEWS
-- =============================================================================
-- security_invoker = false → run as the view owner (bypass table RLS); the
-- WHERE on auth.uid() is the only filter, so each buyer sees only their own.
-- Blocked is shown to the buyer as 'closed'.

DROP VIEW IF EXISTS public.buyer_messages;
DROP VIEW IF EXISTS public.buyer_conversations;

CREATE VIEW public.buyer_conversations
WITH (security_invoker = false)
AS
SELECT
  c.id,
  c.inventory_item_id,
  c.buyer_first_name,
  CASE WHEN c.status = 'open' THEN 'open' ELSE 'closed' END AS status,
  c.created_at,
  c.last_message_at,
  c.buyer_last_read_at,
  (SELECT count(*)
   FROM   public.messages m
   WHERE  m.conversation_id = c.id
     AND  m.sender_role <> 'buyer'
     AND  m.created_at > COALESCE(c.buyer_last_read_at, '-infinity'::timestamptz)
  )::integer AS unread_count,
  last_msg.preview AS last_message_preview,
  last_msg.is_mine AS last_message_is_mine
FROM public.conversations c
LEFT JOIN LATERAL (
  SELECT left(m.body, 140)          AS preview,
         (m.sender_role = 'buyer')  AS is_mine
  FROM   public.messages m
  WHERE  m.conversation_id = c.id
  ORDER  BY m.created_at DESC
  LIMIT  1
) last_msg ON true
WHERE c.buyer_id = auth.uid();

CREATE VIEW public.buyer_messages
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
  m.created_at
FROM  public.messages      m
JOIN  public.conversations c ON c.id = m.conversation_id
WHERE c.buyer_id = auth.uid();

-- Supabase default privileges grant ALL on new relations; reduce to SELECT.
-- anon gets nothing (auth.uid() would be null anyway).
REVOKE ALL ON public.buyer_conversations FROM anon, authenticated;
REVOKE ALL ON public.buyer_messages      FROM anon, authenticated;
GRANT SELECT ON public.buyer_conversations TO authenticated;
GRANT SELECT ON public.buyer_messages      TO authenticated;


-- =============================================================================
-- 4. INTERNAL HELPERS (not callable by clients — EXECUTE revoked below)
-- =============================================================================
-- Plain (invoker) functions: they only ever run inside the SECURITY DEFINER
-- functions in section 5, so they inherit the definer's privileges.

-- ── 4a. Raise a friendly error ──────────────────────────────────────────────
CREATE OR REPLACE FUNCTION public._messaging_fail(p_code text, p_message text)
RETURNS void
LANGUAGE plpgsql
SET search_path = public, pg_temp
AS $$
BEGIN
  RAISE EXCEPTION USING ERRCODE = 'P0001', MESSAGE = p_message, DETAIL = p_code;
END;
$$;

-- ── 4b. Trim + validate a message body ──────────────────────────────────────
-- Returns the trimmed body. p_check_contact = false skips the email / phone /
-- link rules (used for the owner only).
CREATE OR REPLACE FUNCTION public._messaging_clean_body(p_body text, p_check_contact boolean DEFAULT true)
RETURNS text
LANGUAGE plpgsql
SET search_path = public, pg_temp
AS $$
DECLARE
  v_body  text;
  v_lower text;
  v_tok   text;
  v_host  text;
BEGIN
  v_body := regexp_replace(COALESCE(p_body, ''), '^[[:space:]]+|[[:space:]]+$', '', 'g');

  IF char_length(v_body) = 0 THEN
    PERFORM public._messaging_fail('body_empty', 'Please write a message before sending.');
  END IF;
  IF char_length(v_body) > 2000 THEN
    PERFORM public._messaging_fail('body_too_long',
      'Messages can be up to 2000 characters. Please shorten yours a little.');
  END IF;

  IF NOT p_check_contact THEN
    RETURN v_body;
  END IF;

  v_lower := lower(v_body);

  -- Email addresses
  IF v_lower ~ '[a-z0-9._%+-]+@[a-z0-9-]+(\.[a-z0-9-]+)*\.[a-z]{2,}' THEN
    PERFORM public._messaging_fail('contact_email',
      'For your safety, please don''t share email addresses here. Keep the conversation on GemWorkers and we''ll take care of the rest.');
  END IF;

  -- Phone numbers: take each whole number (digits joined by spaces, dashes,
  -- dots or brackets, optional leading +), then judge it by how it STARTS:
  -- "+" or "0" (covers "00") followed by at least 8 more digits. A 0 inside a
  -- longer number ("1 500 000", "2141 0345 67") is never a start, so
  -- certificate numbers, SKUs, dates and prices pass.
  FOR v_tok IN
    SELECT (regexp_matches(
      v_body,
      '((?:\+[[:space:]]*)?[0-9](?:[[:space:].()-]*[0-9])*)',
      'g'))[1]
  LOOP
    IF regexp_replace(v_tok, '[^0-9+]', '', 'g') ~ '^(\+[0-9]{8,}|0[0-9]{8,})' THEN
      PERFORM public._messaging_fail('contact_phone',
        'For your safety, please don''t share phone numbers here. Keep the conversation on GemWorkers and we''ll take care of the rest.');
    END IF;
  END LOOP;

  -- Links: anything with a scheme (x://), anything starting www., or a bare
  -- domain on a common TLD. Only gemworkers.com (and its subdomains) allowed.
  FOR v_tok IN
    SELECT (regexp_matches(
      v_lower,
      '((?:[a-z][a-z0-9+.-]*://|www\.)[^[:space:]<>"]+'
      || '|[a-z0-9-]+(?:\.[a-z0-9-]+)*\.(?:com|net|org|io|co|me|info|biz|app|dev|shop|store|link|site|online|xyz|ly|gg|to|tv|us|uk|nl|de|fr|be|th|in|lk|my|sg|hk|cn|ru|au|ca)(?![a-z0-9-])[^[:space:]<>"]*)',
      'g'))[1]
  LOOP
    -- userinfo tricks (https://gemworkers.com@evil.example) → refuse outright
    IF position('@' IN v_tok) > 0 THEN
      PERFORM public._messaging_fail('contact_link',
        'Links to other websites aren''t allowed in messages. You''re welcome to share links to gemworkers.com.');
    END IF;

    v_host := regexp_replace(v_tok,  '^[a-z][a-z0-9+.-]*://', '');
    v_host := regexp_replace(v_host, '[/?#:\\].*$', '');
    v_host := rtrim(v_host, '.,;!?)]}''"');

    IF NOT (v_host = 'gemworkers.com' OR v_host LIKE '%.gemworkers.com') THEN
      PERFORM public._messaging_fail('contact_link',
        'Links to other websites aren''t allowed in messages. You''re welcome to share links to gemworkers.com.');
    END IF;
  END LOOP;

  RETURN v_body;
END;
$$;

-- ── 4c. Per-user lock: serialises one user's sends so rate limits can't be
--        raced by firing requests in parallel. Released at transaction end.
CREATE OR REPLACE FUNCTION public._messaging_lock(p_user_id uuid)
RETURNS void
LANGUAGE plpgsql
SET search_path = public, pg_temp
AS $$
BEGIN
  PERFORM pg_advisory_xact_lock(hashtextextended('gw_messaging:' || p_user_id::text, 0));
END;
$$;

-- ── 4d. Rate limits ─────────────────────────────────────────────────────────
--   buyer : 5 new conversations / 24 h, 30 messages / hour, 5 s between sends
--   staff : 300 messages / hour, 1 s between sends
CREATE OR REPLACE FUNCTION public._messaging_rate_check(
  p_user_id          uuid,
  p_is_buyer         boolean,
  p_new_conversation boolean DEFAULT false
)
RETURNS void
LANGUAGE plpgsql
SET search_path = public, pg_temp
AS $$
DECLARE
  v_gap        interval := CASE WHEN p_is_buyer THEN interval '5 seconds' ELSE interval '1 second' END;
  v_per_hour   integer  := CASE WHEN p_is_buyer THEN 30 ELSE 300 END;
  v_new_convs  integer;
  v_count      integer;
  v_last       timestamptz;
BEGIN
  IF p_new_conversation THEN
    SELECT count(*) INTO v_new_convs
    FROM   public.conversations
    WHERE  buyer_id = p_user_id
      AND  created_at > now() - interval '24 hours';

    IF v_new_convs >= 5 THEN
      PERFORM public._messaging_fail('rate_new_conversations',
        'You''ve started 5 new conversations today. Please continue in an existing conversation or try again tomorrow.');
    END IF;
  END IF;

  SELECT count(*), max(created_at) INTO v_count, v_last
  FROM   public.messages
  WHERE  sender_user_id = p_user_id
    AND  created_at > now() - interval '1 hour';

  IF v_last IS NOT NULL AND v_last > now() - v_gap THEN
    PERFORM public._messaging_fail('rate_too_fast',
      'You''re sending messages a little fast. Please wait a few seconds and try again.');
  END IF;

  IF v_count >= v_per_hour THEN
    PERFORM public._messaging_fail('rate_hourly',
      'You''ve sent a lot of messages in the last hour. Please take a short break and try again later.');
  END IF;
END;
$$;

-- ── 4e. Caller must be a storefront buyer with a confirmed email ───────────
CREATE OR REPLACE FUNCTION public._messaging_require_buyer()
RETURNS uuid
LANGUAGE plpgsql
SET search_path = public, pg_temp
AS $$
DECLARE
  v_uid       uuid := auth.uid();
  v_confirmed timestamptz;
BEGIN
  IF v_uid IS NULL THEN
    PERFORM public._messaging_fail('not_signed_in', 'Please sign in to send a message.');
  END IF;

  IF NOT EXISTS (SELECT 1 FROM public.buyers WHERE id = v_uid) THEN
    PERFORM public._messaging_fail('not_a_buyer',
      'Only customer accounts can send messages here.');
  END IF;

  SELECT email_confirmed_at INTO v_confirmed FROM auth.users WHERE id = v_uid;
  IF v_confirmed IS NULL THEN
    PERFORM public._messaging_fail('email_unconfirmed',
      'Please confirm your email address before sending messages. Check your inbox for the confirmation link.');
  END IF;

  RETURN v_uid;
END;
$$;

-- ── 4f. Stone a buyer may link: publicly visible (listed, available or
--        reserved, active seller) — same rule as public_listing_details.
CREATE OR REPLACE FUNCTION public._messaging_check_buyer_link(p_item_id uuid)
RETURNS void
LANGUAGE plpgsql
SET search_path = public, pg_temp
AS $$
BEGIN
  IF p_item_id IS NULL THEN
    RETURN;
  END IF;

  IF NOT EXISTS (
    SELECT 1
    FROM   public.inventory_items i
    JOIN   public.sellers         s ON s.id = i.seller_id
    WHERE  i.id = p_item_id
      AND  i.is_listed = true
      AND  i.status IN ('available', 'reserved')
      AND  s.status = 'active'
  ) THEN
    PERFORM public._messaging_fail('link_unavailable',
      'The stone you attached is no longer available. Please remove it and try again.');
  END IF;
END;
$$;

-- ── 4g. Insert a message + bump the conversation ────────────────────────────
-- Also moves the sender's own read marker forward (they've seen the thread).
CREATE OR REPLACE FUNCTION public._messaging_post(
  p_conversation_id uuid,
  p_sender_role     text,
  p_sender_user_id  uuid,
  p_body            text,
  p_linked_item_id  uuid
)
RETURNS uuid
LANGUAGE plpgsql
SET search_path = public, pg_temp
AS $$
DECLARE
  v_message_id uuid;
BEGIN
  INSERT INTO public.messages (conversation_id, sender_role, sender_user_id, body, linked_inventory_item_id)
  VALUES (p_conversation_id, p_sender_role, p_sender_user_id, p_body, p_linked_item_id)
  RETURNING id INTO v_message_id;

  UPDATE public.conversations
  SET    last_message_at     = now(),
         buyer_last_read_at  = CASE WHEN p_sender_role = 'buyer'  THEN now() ELSE buyer_last_read_at  END,
         seller_last_read_at = CASE WHEN p_sender_role = 'seller' THEN now() ELSE seller_last_read_at END,
         owner_last_read_at  = CASE WHEN p_sender_role = 'owner'  THEN now() ELSE owner_last_read_at  END
  WHERE  id = p_conversation_id;

  RETURN v_message_id;
END;
$$;


-- =============================================================================
-- 5. PUBLIC FUNCTIONS (SECURITY DEFINER, fixed search_path)
-- =============================================================================

-- ── 5a. ask_about_stone ─────────────────────────────────────────────────────
-- Buyer starts (or continues) the conversation about a stone.
-- Returns { conversation_id, message_id, created }.
CREATE OR REPLACE FUNCTION public.ask_about_stone(
  p_inventory_item_id uuid,
  p_body              text,
  p_linked_item_id    uuid DEFAULT NULL,
  p_first_name        text DEFAULT NULL
)
RETURNS json
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public, pg_temp
AS $$
DECLARE
  v_uid        uuid;
  v_body       text;
  v_conv       record;
  v_conv_id    uuid;
  v_seller_id  uuid;
  v_name       text;
  v_created    boolean := false;
  v_message_id uuid;
BEGIN
  v_uid := public._messaging_require_buyer();
  PERFORM public._messaging_lock(v_uid);

  v_body := public._messaging_clean_body(p_body);
  PERFORM public._messaging_check_buyer_link(p_linked_item_id);

  SELECT id, status INTO v_conv
  FROM   public.conversations
  WHERE  inventory_item_id = p_inventory_item_id
    AND  buyer_id = v_uid
  FOR UPDATE;

  IF FOUND THEN
    -- Existing conversation: just append.
    IF v_conv.status <> 'open' THEN
      PERFORM public._messaging_fail('conversation_closed',
        'This conversation is closed, so new messages can''t be sent.');
    END IF;
    PERFORM public._messaging_rate_check(v_uid, true, false);
    v_conv_id := v_conv.id;
  ELSE
    -- New conversation: the stone must be publicly visible right now.
    SELECT i.seller_id INTO v_seller_id
    FROM   public.inventory_items i
    JOIN   public.sellers         s ON s.id = i.seller_id
    WHERE  i.id = p_inventory_item_id
      AND  i.is_listed = true
      AND  i.status IN ('available', 'reserved')
      AND  s.status = 'active';

    IF v_seller_id IS NULL THEN
      PERFORM public._messaging_fail('stone_unavailable',
        'This stone is no longer available, so we can''t start a conversation about it.');
    END IF;

    PERFORM public._messaging_rate_check(v_uid, true, true);

    -- First name: param → first word of buyers.display_name → first word of
    -- the latest order's shipping_name.
    v_name := NULLIF(regexp_replace(COALESCE(p_first_name, ''), '^[[:space:]]+|[[:space:]]+$', '', 'g'), '');

    IF v_name IS NOT NULL THEN
      v_name := left(regexp_replace(v_name, '[[:space:]]+', ' ', 'g'), 50);
      IF v_name ~ '[0-9@/]' OR lower(v_name) ~ '\.[a-z]{2,}' THEN
        PERFORM public._messaging_fail('first_name_invalid', 'Please enter just your first name.');
      END IF;

      UPDATE public.buyers
      SET    display_name = v_name
      WHERE  id = v_uid
        AND  NULLIF(btrim(display_name), '') IS NULL;
    ELSE
      SELECT NULLIF(split_part(btrim(display_name), ' ', 1), '')
      INTO   v_name
      FROM   public.buyers
      WHERE  id = v_uid;

      IF v_name IS NULL THEN
        SELECT NULLIF(split_part(btrim(o.shipping_name), ' ', 1), '')
        INTO   v_name
        FROM   public.orders o
        WHERE  o.buyer_id = v_uid
          AND  NULLIF(btrim(o.shipping_name), '') IS NOT NULL
        ORDER  BY COALESCE(o.paid_at, o.created_at) DESC
        LIMIT  1;
      END IF;
    END IF;

    INSERT INTO public.conversations (inventory_item_id, buyer_id, seller_id, buyer_first_name)
    VALUES (p_inventory_item_id, v_uid, v_seller_id, v_name)
    ON CONFLICT (inventory_item_id, buyer_id) DO NOTHING
    RETURNING id INTO v_conv_id;

    IF v_conv_id IS NULL THEN
      -- Lost a race with ourselves (lock should prevent this) — reuse the row.
      SELECT id INTO v_conv_id
      FROM   public.conversations
      WHERE  inventory_item_id = p_inventory_item_id AND buyer_id = v_uid;
    ELSE
      v_created := true;
    END IF;
  END IF;

  v_message_id := public._messaging_post(v_conv_id, 'buyer', v_uid, v_body, p_linked_item_id);

  RETURN json_build_object(
    'conversation_id', v_conv_id,
    'message_id',      v_message_id,
    'created',         v_created
  );
END;
$$;

-- ── 5b. send_buyer_message ──────────────────────────────────────────────────
-- Returns { conversation_id, message_id }.
CREATE OR REPLACE FUNCTION public.send_buyer_message(
  p_conversation_id uuid,
  p_body            text,
  p_linked_item_id  uuid DEFAULT NULL
)
RETURNS json
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public, pg_temp
AS $$
DECLARE
  v_uid        uuid;
  v_body       text;
  v_conv       record;
  v_message_id uuid;
BEGIN
  v_uid := public._messaging_require_buyer();
  PERFORM public._messaging_lock(v_uid);

  SELECT id, buyer_id, status INTO v_conv
  FROM   public.conversations
  WHERE  id = p_conversation_id
  FOR UPDATE;

  IF NOT FOUND OR v_conv.buyer_id IS DISTINCT FROM v_uid THEN
    PERFORM public._messaging_fail('conversation_not_found', 'We couldn''t find that conversation.');
  END IF;

  IF v_conv.status <> 'open' THEN
    PERFORM public._messaging_fail('conversation_closed',
      'This conversation is closed, so new messages can''t be sent.');
  END IF;

  v_body := public._messaging_clean_body(p_body);
  PERFORM public._messaging_check_buyer_link(p_linked_item_id);
  PERFORM public._messaging_rate_check(v_uid, true, false);

  v_message_id := public._messaging_post(p_conversation_id, 'buyer', v_uid, v_body, p_linked_item_id);

  RETURN json_build_object('conversation_id', p_conversation_id, 'message_id', v_message_id);
END;
$$;

-- ── 5c. send_staff_message ──────────────────────────────────────────────────
-- Seller of that conversation's stone, or the owner (any conversation).
-- Linked stone: listed + available; sellers only their own, owner any.
-- Returns { conversation_id, message_id }.
CREATE OR REPLACE FUNCTION public.send_staff_message(
  p_conversation_id uuid,
  p_body            text,
  p_linked_item_id  uuid DEFAULT NULL
)
RETURNS json
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public, pg_temp
AS $$
DECLARE
  v_uid        uuid := auth.uid();
  v_owner      boolean;
  v_seller     uuid;
  v_conv       record;
  v_item       record;
  v_body       text;
  v_message_id uuid;
BEGIN
  IF v_uid IS NULL THEN
    PERFORM public._messaging_fail('not_signed_in', 'Please sign in to send a message.');
  END IF;

  v_owner  := public.is_owner();
  v_seller := public.current_seller_id();

  IF NOT v_owner AND v_seller IS NULL THEN
    PERFORM public._messaging_fail('not_staff', 'Only GemWorkers staff can reply here.');
  END IF;

  PERFORM public._messaging_lock(v_uid);

  SELECT id, seller_id, status INTO v_conv
  FROM   public.conversations
  WHERE  id = p_conversation_id
  FOR UPDATE;

  IF NOT FOUND OR (NOT v_owner AND v_conv.seller_id IS DISTINCT FROM v_seller) THEN
    PERFORM public._messaging_fail('conversation_not_found', 'We couldn''t find that conversation.');
  END IF;

  IF v_conv.status <> 'open' THEN
    PERFORM public._messaging_fail('conversation_closed',
      'This conversation is closed, so new messages can''t be sent.');
  END IF;

  -- Owner is exempt from the contact-info filter (may share support details).
  v_body := public._messaging_clean_body(p_body, NOT v_owner);

  IF p_linked_item_id IS NOT NULL THEN
    SELECT i.seller_id, i.status, i.is_listed INTO v_item
    FROM   public.inventory_items i
    WHERE  i.id = p_linked_item_id;

    IF NOT FOUND OR v_item.status <> 'available' OR v_item.is_listed IS NOT TRUE THEN
      PERFORM public._messaging_fail('link_unavailable',
        'You can only attach stones that are listed and available.');
    END IF;

    IF NOT v_owner AND v_item.seller_id IS DISTINCT FROM v_seller THEN
      PERFORM public._messaging_fail('link_not_own',
        'You can only attach stones from your own shop.');
    END IF;
  END IF;

  PERFORM public._messaging_rate_check(v_uid, false, false);

  v_message_id := public._messaging_post(
    p_conversation_id,
    CASE WHEN v_owner THEN 'owner' ELSE 'seller' END,
    v_uid, v_body, p_linked_item_id);

  RETURN json_build_object('conversation_id', p_conversation_id, 'message_id', v_message_id);
END;
$$;

-- ── 5d. mark_conversation_read ──────────────────────────────────────────────
-- Moves the caller's own side marker: buyer / owner / seller.
CREATE OR REPLACE FUNCTION public.mark_conversation_read(p_conversation_id uuid)
RETURNS void
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public, pg_temp
AS $$
DECLARE
  v_uid  uuid := auth.uid();
  v_conv record;
BEGIN
  IF v_uid IS NULL THEN
    PERFORM public._messaging_fail('not_signed_in', 'Please sign in.');
  END IF;

  SELECT id, buyer_id, seller_id INTO v_conv
  FROM   public.conversations
  WHERE  id = p_conversation_id;

  IF NOT FOUND THEN
    PERFORM public._messaging_fail('conversation_not_found', 'We couldn''t find that conversation.');
  END IF;

  IF v_conv.buyer_id = v_uid THEN
    UPDATE public.conversations SET buyer_last_read_at  = now() WHERE id = p_conversation_id;
  ELSIF public.is_owner() THEN
    UPDATE public.conversations SET owner_last_read_at  = now() WHERE id = p_conversation_id;
  ELSIF v_conv.seller_id = public.current_seller_id() THEN
    UPDATE public.conversations SET seller_last_read_at = now() WHERE id = p_conversation_id;
  ELSE
    PERFORM public._messaging_fail('conversation_not_found', 'We couldn''t find that conversation.');
  END IF;
END;
$$;

-- ── 5e. message_stone_cards ─────────────────────────────────────────────────
-- Card data for stones that appear in the caller's own conversations (the
-- conversation's stone or a linked stone). Ids outside that set are silently
-- dropped. status: available | reserved | unavailable. No seller fields.
-- Price is null when unavailable.
CREATE OR REPLACE FUNCTION public.message_stone_cards(p_ids uuid[])
RETURNS TABLE (
  id            uuid,
  title         text,
  image_url     text,
  selling_price numeric,
  product_type  text,
  status        text
)
LANGUAGE plpgsql
STABLE
SECURITY DEFINER
SET search_path = public, pg_temp
AS $$
#variable_conflict use_column
DECLARE
  v_uid    uuid := auth.uid();
  v_owner  boolean;
  v_seller uuid;
BEGIN
  IF v_uid IS NULL OR p_ids IS NULL OR cardinality(p_ids) = 0 THEN
    RETURN;
  END IF;
  IF cardinality(p_ids) > 100 THEN
    PERFORM public._messaging_fail('too_many_ids', 'Too many stones requested at once.');
  END IF;

  v_owner  := public.is_owner();
  v_seller := public.current_seller_id();

  RETURN QUERY
  WITH my_convs AS (
    SELECT c.id, c.inventory_item_id
    FROM   public.conversations c
    WHERE  c.buyer_id = v_uid
       OR  v_owner
       OR  (v_seller IS NOT NULL AND c.seller_id = v_seller)
  ),
  allowed AS (
    SELECT mc.inventory_item_id AS item_id
    FROM   my_convs mc
    WHERE  mc.inventory_item_id = ANY (p_ids)
    UNION
    SELECT m.linked_inventory_item_id
    FROM   public.messages m
    JOIN   my_convs mc ON mc.id = m.conversation_id
    WHERE  m.linked_inventory_item_id = ANY (p_ids)
  )
  SELECT
    i.id,
    i.title::text,
    (i.image_urls ->> 0)::text,
    CASE WHEN st.card_status = 'unavailable' THEN NULL ELSE i.selling_price END::numeric,
    i.product_type::text,
    st.card_status
  FROM   allowed a
  JOIN   public.inventory_items i ON i.id = a.item_id
  LEFT   JOIN public.sellers    s ON s.id = i.seller_id
  CROSS  JOIN LATERAL (
    SELECT CASE
             WHEN i.is_listed AND s.status = 'active' AND i.status = 'available' THEN 'available'
             WHEN i.is_listed AND s.status = 'active' AND i.status = 'reserved'  THEN 'reserved'
             ELSE 'unavailable'
           END::text AS card_status
  ) st;
END;
$$;

-- ── 5f. buyer_unread_count ──────────────────────────────────────────────────
-- Returns { conversations, messages } unread by the calling buyer.
CREATE OR REPLACE FUNCTION public.buyer_unread_count()
RETURNS json
LANGUAGE plpgsql
STABLE
SECURITY DEFINER
SET search_path = public, pg_temp
AS $$
DECLARE
  v_uid   uuid := auth.uid();
  v_convs integer := 0;
  v_msgs  integer := 0;
BEGIN
  IF v_uid IS NOT NULL THEN
    SELECT count(DISTINCT c.id), count(m.id) INTO v_convs, v_msgs
    FROM   public.conversations c
    JOIN   public.messages      m ON m.conversation_id = c.id
    WHERE  c.buyer_id = v_uid
      AND  m.sender_role <> 'buyer'
      AND  m.created_at > COALESCE(c.buyer_last_read_at, '-infinity'::timestamptz);
  END IF;

  RETURN json_build_object('conversations', v_convs, 'messages', v_msgs);
END;
$$;

-- ── 5g. staff_unread_count ──────────────────────────────────────────────────
-- Owner: all conversations against owner_last_read_at.
-- Seller: own conversations against seller_last_read_at.
-- Returns { conversations, messages }.
CREATE OR REPLACE FUNCTION public.staff_unread_count()
RETURNS json
LANGUAGE plpgsql
STABLE
SECURITY DEFINER
SET search_path = public, pg_temp
AS $$
DECLARE
  v_seller uuid;
  v_convs  integer := 0;
  v_msgs   integer := 0;
BEGIN
  IF auth.uid() IS NULL THEN
    RETURN json_build_object('conversations', 0, 'messages', 0);
  END IF;

  IF public.is_owner() THEN
    SELECT count(DISTINCT c.id), count(m.id) INTO v_convs, v_msgs
    FROM   public.conversations c
    JOIN   public.messages      m ON m.conversation_id = c.id
    WHERE  m.sender_role = 'buyer'
      AND  m.created_at > COALESCE(c.owner_last_read_at, '-infinity'::timestamptz);
  ELSE
    v_seller := public.current_seller_id();
    IF v_seller IS NOT NULL THEN
      SELECT count(DISTINCT c.id), count(m.id) INTO v_convs, v_msgs
      FROM   public.conversations c
      JOIN   public.messages      m ON m.conversation_id = c.id
      WHERE  c.seller_id = v_seller
        AND  m.sender_role = 'buyer'
        AND  m.created_at > COALESCE(c.seller_last_read_at, '-infinity'::timestamptz);
    END IF;
  END IF;

  RETURN json_build_object('conversations', v_convs, 'messages', v_msgs);
END;
$$;


-- =============================================================================
-- 6. EXECUTE GRANTS
-- =============================================================================
-- Supabase default privileges grant EXECUTE on new functions to anon and
-- authenticated directly (not only via PUBLIC), so revoke from all three.

-- Internal helpers: nobody but the definer functions above.
REVOKE ALL ON FUNCTION public._messaging_fail(text, text)                          FROM PUBLIC, anon, authenticated;
REVOKE ALL ON FUNCTION public._messaging_clean_body(text, boolean)                 FROM PUBLIC, anon, authenticated;
REVOKE ALL ON FUNCTION public._messaging_lock(uuid)                                FROM PUBLIC, anon, authenticated;
REVOKE ALL ON FUNCTION public._messaging_rate_check(uuid, boolean, boolean)        FROM PUBLIC, anon, authenticated;
REVOKE ALL ON FUNCTION public._messaging_require_buyer()                           FROM PUBLIC, anon, authenticated;
REVOKE ALL ON FUNCTION public._messaging_check_buyer_link(uuid)                    FROM PUBLIC, anon, authenticated;
REVOKE ALL ON FUNCTION public._messaging_post(uuid, text, uuid, text, uuid)        FROM PUBLIC, anon, authenticated;

-- Client-facing: signed-in users only.
REVOKE ALL ON FUNCTION public.ask_about_stone(uuid, text, uuid, text)   FROM PUBLIC, anon;
REVOKE ALL ON FUNCTION public.send_buyer_message(uuid, text, uuid)      FROM PUBLIC, anon;
REVOKE ALL ON FUNCTION public.send_staff_message(uuid, text, uuid)      FROM PUBLIC, anon;
REVOKE ALL ON FUNCTION public.mark_conversation_read(uuid)              FROM PUBLIC, anon;
REVOKE ALL ON FUNCTION public.message_stone_cards(uuid[])               FROM PUBLIC, anon;
REVOKE ALL ON FUNCTION public.buyer_unread_count()                      FROM PUBLIC, anon;
REVOKE ALL ON FUNCTION public.staff_unread_count()                      FROM PUBLIC, anon;

GRANT EXECUTE ON FUNCTION public.ask_about_stone(uuid, text, uuid, text) TO authenticated;
GRANT EXECUTE ON FUNCTION public.send_buyer_message(uuid, text, uuid)    TO authenticated;
GRANT EXECUTE ON FUNCTION public.send_staff_message(uuid, text, uuid)    TO authenticated;
GRANT EXECUTE ON FUNCTION public.mark_conversation_read(uuid)            TO authenticated;
GRANT EXECUTE ON FUNCTION public.message_stone_cards(uuid[])             TO authenticated;
GRANT EXECUTE ON FUNCTION public.buyer_unread_count()                    TO authenticated;
GRANT EXECUTE ON FUNCTION public.staff_unread_count()                    TO authenticated;

COMMIT;


-- =============================================================================
-- VERIFICATION (run after applying; read-only)
-- =============================================================================
-- Tables + columns:
--
--   SELECT table_name, column_name, data_type, is_nullable, column_default
--   FROM   information_schema.columns
--   WHERE  table_schema = 'public'
--     AND  table_name IN ('conversations', 'messages')
--   ORDER  BY table_name, ordinal_position;
--
-- Constraints (expect conversations_item_buyer_key UNIQUE + the CHECKs):
--
--   SELECT conrelid::regclass AS tbl, conname, pg_get_constraintdef(oid)
--   FROM   pg_constraint
--   WHERE  conrelid IN ('public.conversations'::regclass, 'public.messages'::regclass)
--   ORDER  BY 1, 2;
--
-- Indexes:
--
--   SELECT tablename, indexname, indexdef
--   FROM   pg_indexes
--   WHERE  schemaname = 'public' AND tablename IN ('conversations', 'messages')
--   ORDER  BY 1, 2;
--
-- RLS on + policies (expect *_seller_select and *_owner on each table):
--
--   SELECT relname, relrowsecurity
--   FROM   pg_class
--   WHERE  relname IN ('conversations', 'messages');
--
--   SELECT tablename, policyname, cmd, roles, qual, with_check
--   FROM   pg_policies
--   WHERE  schemaname = 'public' AND tablename IN ('conversations', 'messages')
--   ORDER  BY 1, 2;
--
-- Table / view grants (expect no anon rows; authenticated: SELECT/UPDATE/DELETE
-- on tables, SELECT only on the two views):
--
--   SELECT table_name, grantee, privilege_type
--   FROM   information_schema.role_table_grants
--   WHERE  table_schema = 'public'
--     AND  table_name IN ('conversations', 'messages', 'buyer_conversations', 'buyer_messages')
--     AND  grantee IN ('anon', 'authenticated')
--   ORDER  BY 1, 2, 3;
--
-- Views (expect no seller_id / sender_user_id / sender_role in the select list;
-- reloptions absent or security_invoker=false):
--
--   SELECT pg_get_viewdef('public.buyer_conversations'::regclass, true);
--   SELECT pg_get_viewdef('public.buyer_messages'::regclass, true);
--
--   SELECT relname, reloptions
--   FROM   pg_class
--   WHERE  relname IN ('buyer_conversations', 'buyer_messages');
--
-- Functions — security definer flag, search_path, and source:
--
--   SELECT p.proname,
--          pg_get_function_identity_arguments(p.oid) AS args,
--          p.prosecdef                               AS security_definer,
--          p.proconfig                               AS settings
--   FROM   pg_proc p
--   JOIN   pg_namespace n ON n.oid = p.pronamespace
--   WHERE  n.nspname = 'public'
--     AND  (p.proname LIKE '\_messaging\_%'
--           OR p.proname IN ('ask_about_stone', 'send_buyer_message', 'send_staff_message',
--                            'mark_conversation_read', 'message_stone_cards',
--                            'buyer_unread_count', 'staff_unread_count'))
--   ORDER  BY 1;
--
--   SELECT proname, prosrc
--   FROM   pg_proc
--   WHERE  pronamespace = 'public'::regnamespace
--     AND  proname IN ('ask_about_stone', 'send_buyer_message', 'send_staff_message',
--                      'mark_conversation_read', 'message_stone_cards',
--                      'buyer_unread_count', 'staff_unread_count',
--                      '_messaging_clean_body', '_messaging_rate_check');
--
-- Function EXECUTE grants (expect authenticated on the 7 public ones only;
-- no anon anywhere; no rows for _messaging_* except postgres/service_role):
--
--   SELECT routine_name, grantee, privilege_type
--   FROM   information_schema.routine_privileges
--   WHERE  routine_schema = 'public'
--     AND  (routine_name LIKE '\_messaging\_%'
--           OR routine_name IN ('ask_about_stone', 'send_buyer_message', 'send_staff_message',
--                               'mark_conversation_read', 'message_stone_cards',
--                               'buyer_unread_count', 'staff_unread_count'))
--   ORDER  BY 1, 2;
--
-- Content filter dry-run. Run as postgres in the SQL editor; each call raises
-- on failure, so run them one at a time. Expected result after each line.
--
--   SELECT public._messaging_clean_body('  Is this 2.35 ct sapphire heated?  ');  -- ok
--   SELECT public._messaging_clean_body('mail me at jane@example.com');           -- contact_email
--   SELECT public._messaging_clean_body('see instagram.com/mystones');            -- contact_link
--   SELECT public._messaging_clean_body('like https://www.gemworkers.com/stone/abc'); -- ok
--
--   Phone rule — must pass:
--   SELECT public._messaging_clean_body('Report 2141234567');                     -- ok
--   SELECT public._messaging_clean_body('GIA 2141 2345 67');                      -- ok
--   SELECT public._messaging_clean_body('GIA 2141 0345 67');                      -- ok
--   SELECT public._messaging_clean_body('SKU GW-L-TOUR-01002');                   -- ok
--   SELECT public._messaging_clean_body('Shipped 2026-10-20');                    -- ok
--   SELECT public._messaging_clean_body('Price 1 500 000 THB');                   -- ok
--
--   Phone rule — must block (contact_phone):
--   SELECT public._messaging_clean_body('call +66 81 234 5678');
--   SELECT public._messaging_clean_body('call 0612345678');
--   SELECT public._messaging_clean_body('call 06-12 34 56 78');
--   SELECT public._messaging_clean_body('call 0300 1234567');
--   SELECT public._messaging_clean_body('call 0031 6 1234 5678');
-- =============================================================================
