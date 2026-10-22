-- =============================================================================
-- GemWorkers — Offer cards in the conversation: trigger (plan step 3)
-- =============================================================================
-- Applied to live DB 2026-10-22
--
-- 1. _offer_card_label(amount) — "€55" / "€49.80" (same display rule as
--    lib/money.ts). Internal, no client EXECUTE.
-- 2. _offer_message_card() trigger on storefront_offers
--      INSERT (pending)                 → offer_made
--      status pending → accepted        → offer_accepted
--                     → declined        → offer_declined
--                     → expired         → offer_expired
--                     → withdrawn       → offer_withdrawn
--    Finds the (stone, buyer) conversation or creates it (seller_id from the
--    offer, buyer_first_name = first word of buyers.display_name). Inserts a
--    'system' card (sender_user_id NULL) and bumps last_message_at only —
--    NO read marker moves. ON CONFLICT (offer_id, kind) DO NOTHING.
--    Any error is swallowed (WARNING) so a card can never block an offer,
--    acceptance, payment or the sweep.
--    Counter kinds are added to this trigger in steps 6–8.
-- 3. Buyer unread: cards for the buyer's own actions (offer_made,
--    offer_withdrawn) don't count as unread and show as "mine" in the inbox
--    preview. buyer_conversations (same columns, CREATE OR REPLACE) and
--    buyer_unread_count() (live prosrc copied, one line added).
--    Staff unread is unchanged: it only counts sender_role = 'buyer', so cards
--    never count for staff (the Offers page has its own badge).
--
-- message-notify v7 skips kind <> 'text', so cards send no message email;
-- offer-notify keeps sending the offer emails as before.
--
-- Requires: message_offer_cards_schema.sql (step 2).
-- Safe to re-run: one transaction, CREATE OR REPLACE / DROP IF EXISTS.
-- =============================================================================

BEGIN;

-- ── 1. Money label ──────────────────────────────────────────────────────────
CREATE OR REPLACE FUNCTION public._offer_card_label(p_amount numeric)
RETURNS text
LANGUAGE sql
IMMUTABLE
SET search_path = public, pg_temp
AS $$
  SELECT '€' || CASE WHEN p_amount = trunc(p_amount)
                     THEN trunc(p_amount)::text
                     ELSE to_char(p_amount, 'FM999999999990.00')
                END;
$$;

-- ── 2. Card trigger ─────────────────────────────────────────────────────────
CREATE OR REPLACE FUNCTION public._offer_message_card()
RETURNS trigger
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public, pg_temp
AS $$
DECLARE
  v_kind    text;
  v_body    text;
  v_label   text;
  v_conv_id uuid;
  v_name    text;
BEGIN
  IF TG_OP = 'INSERT' THEN
    IF NEW.status <> 'pending' THEN
      RETURN NEW;
    END IF;
    v_kind := 'offer_made';
  ELSIF NEW.status IS DISTINCT FROM OLD.status THEN
    v_kind := CASE NEW.status
                WHEN 'accepted'  THEN 'offer_accepted'
                WHEN 'declined'  THEN 'offer_declined'
                WHEN 'expired'   THEN 'offer_expired'
                WHEN 'withdrawn' THEN 'offer_withdrawn'
              END;
  END IF;

  IF v_kind IS NULL THEN
    RETURN NEW;
  END IF;

  BEGIN
    v_label := public._offer_card_label(NEW.offered_price);
    v_body  := CASE v_kind
                 WHEN 'offer_made'      THEN 'Offer made: '      || v_label
                 WHEN 'offer_accepted'  THEN 'Offer accepted: '  || v_label
                 WHEN 'offer_declined'  THEN 'Offer declined: '  || v_label
                 WHEN 'offer_expired'   THEN 'Offer expired: '   || v_label
                 WHEN 'offer_withdrawn' THEN 'Offer withdrawn: ' || v_label
               END;

    SELECT id INTO v_conv_id
    FROM   public.conversations
    WHERE  inventory_item_id = NEW.inventory_item_id
      AND  buyer_id          = NEW.buyer_id;

    IF v_conv_id IS NULL THEN
      SELECT NULLIF(split_part(btrim(display_name), ' ', 1), '')
      INTO   v_name
      FROM   public.buyers
      WHERE  id = NEW.buyer_id;

      INSERT INTO public.conversations (inventory_item_id, buyer_id, seller_id, buyer_first_name)
      VALUES (NEW.inventory_item_id, NEW.buyer_id, NEW.seller_id, left(v_name, 50))
      ON CONFLICT (inventory_item_id, buyer_id) DO NOTHING
      RETURNING id INTO v_conv_id;

      IF v_conv_id IS NULL THEN
        SELECT id INTO v_conv_id
        FROM   public.conversations
        WHERE  inventory_item_id = NEW.inventory_item_id
          AND  buyer_id          = NEW.buyer_id;
      END IF;
    END IF;

    INSERT INTO public.messages
      (conversation_id, sender_role, sender_user_id, body, kind, offer_id, offer_amount)
    VALUES
      (v_conv_id, 'system', NULL, v_body, v_kind, NEW.id, NEW.offered_price)
    ON CONFLICT (offer_id, kind) WHERE offer_id IS NOT NULL DO NOTHING;

    UPDATE public.conversations
    SET    last_message_at = now()
    WHERE  id = v_conv_id;
  EXCEPTION WHEN OTHERS THEN
    RAISE WARNING '[offer card] offer % kind % failed: % (%)', NEW.id, v_kind, SQLERRM, SQLSTATE;
  END;

  RETURN NEW;
END;
$$;

DROP TRIGGER IF EXISTS offer_message_card ON public.storefront_offers;
CREATE TRIGGER offer_message_card
  AFTER INSERT OR UPDATE OF status ON public.storefront_offers
  FOR EACH ROW EXECUTE FUNCTION public._offer_message_card();

REVOKE ALL ON FUNCTION public._offer_card_label(numeric) FROM PUBLIC, anon, authenticated;
REVOKE ALL ON FUNCTION public._offer_message_card()      FROM PUBLIC, anon, authenticated;

-- ── 3a. buyer_conversations ─────────────────────────────────────────────────
-- Live definition; changed: unread_count skips the buyer's own cards,
-- last_message_is_mine is true for them.
CREATE OR REPLACE VIEW public.buyer_conversations
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
     AND  m.kind NOT IN ('offer_made', 'offer_withdrawn')
     AND  m.created_at > COALESCE(c.buyer_last_read_at, '-infinity'::timestamptz)
  )::integer AS unread_count,
  last_msg.preview AS last_message_preview,
  last_msg.is_mine AS last_message_is_mine
FROM public.conversations c
LEFT JOIN LATERAL (
  SELECT left(m.body, 140)          AS preview,
         (m.sender_role = 'buyer'
          OR m.kind IN ('offer_made', 'offer_withdrawn')) AS is_mine
  FROM   public.messages m
  WHERE  m.conversation_id = c.id
  ORDER  BY m.created_at DESC
  LIMIT  1
) last_msg ON true
WHERE c.buyer_id = auth.uid();

REVOKE ALL ON public.buyer_conversations FROM anon, authenticated;
GRANT SELECT ON public.buyer_conversations TO authenticated;

-- ── 3b. buyer_unread_count ──────────────────────────────────────────────────
-- Live prosrc; one line added (kind NOT IN ...).
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
      AND  m.kind NOT IN ('offer_made', 'offer_withdrawn')
      AND  m.created_at > COALESCE(c.buyer_last_read_at, '-infinity'::timestamptz);
  END IF;

  RETURN json_build_object('conversations', v_convs, 'messages', v_msgs);
END;
$$;

COMMIT;


-- =============================================================================
-- VERIFICATION (read-only)
-- =============================================================================
--   SELECT tgname, pg_get_triggerdef(oid)
--   FROM   pg_trigger
--   WHERE  tgrelid = 'public.storefront_offers'::regclass AND NOT tgisinternal;
--
--   SELECT public._offer_card_label(55), public._offer_card_label(49.8);  -- €55 | €49.80
--
--   SELECT pg_get_viewdef('public.buyer_conversations'::regclass, true);
--   SELECT prosrc FROM pg_proc WHERE proname = 'buyer_unread_count';
--
-- After making a test offer on the store:
--   SELECT m.kind, m.sender_role, m.body, m.offer_amount, m.created_at
--   FROM   public.messages m
--   WHERE  m.kind <> 'text'
--   ORDER  BY m.created_at DESC;
-- =============================================================================
