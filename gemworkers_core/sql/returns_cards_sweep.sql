-- =============================================================================
-- GemWorkers — Return cards in Messages + quiet-return reminder / auto-close
-- =============================================================================
-- Applied to live DB 2026-10-24
--
-- 1. messages.kind gains return_* kinds ('system' cards, like offer cards).
--    Shape rule: offer/counter cards keep offer_amount > 0; return cards are
--    'system' with no offer_id (offer_amount = refund amount on 'refunded').
-- 2. returns: reminder_sent_at; status 'expired' (auto-closed).
-- 3. Trigger _return_message_card: one card per return status change in the
--    stone's conversation with that buyer (created if missing — same as
--    offer cards). Buyer-safe text only (no seller identity, no internal note).
-- 4. _return_notify (copied from live, returns_setup.sql): also emails on
--    'expired'.
-- 5. buyer_conversations / buyer_unread_count (copied from live): the buyer's
--    own actions (return_requested, return_withdrawn) don't count as unread.
-- 6. sweep_quiet_returns() hourly (pg_cron):
--      approved ≥ 10 days, no tracking, no reminder yet → reminder email + card
--      approved ≥ 30 days, no tracking → 'expired' (email + card)
--    A return with a tracking number stays open (the stone may be on its way).
-- message-notify already skips kind <> 'text' (no "new message" nudges).
-- =============================================================================

BEGIN;

-- 1. Message kinds -------------------------------------------------------------
ALTER TABLE public.messages DROP CONSTRAINT IF EXISTS messages_kind_check;
ALTER TABLE public.messages ADD CONSTRAINT messages_kind_check
  CHECK (kind = ANY (ARRAY[
    'text',
    'offer_made','offer_accepted','offer_declined','offer_expired','offer_withdrawn',
    'offer_countered','counter_accepted','counter_declined','counter_expired',
    'return_requested','return_approved','return_rejected','return_received',
    'return_refunded','return_withdrawn','return_reminder','return_expired'
  ]));

ALTER TABLE public.messages DROP CONSTRAINT IF EXISTS messages_kind_shape_check;
ALTER TABLE public.messages ADD CONSTRAINT messages_kind_shape_check
  CHECK (
    CASE
      WHEN kind = 'text' THEN
        sender_role <> 'system' AND offer_id IS NULL AND offer_amount IS NULL
      WHEN kind LIKE 'return\_%' THEN
        sender_role = 'system' AND sender_user_id IS NULL AND offer_id IS NULL
        AND (offer_amount IS NULL OR offer_amount >= 0)
      ELSE
        sender_role = 'system' AND sender_user_id IS NULL AND offer_amount > 0
    END
  );

-- 2. Returns: reminder + expired ----------------------------------------------
ALTER TABLE public.returns ADD COLUMN IF NOT EXISTS reminder_sent_at timestamptz;
ALTER TABLE public.returns DROP CONSTRAINT IF EXISTS returns_status_check;
ALTER TABLE public.returns ADD CONSTRAINT returns_status_check
  CHECK (status IN ('requested','approved','received','refunded','rejected','withdrawn','expired'));

-- 3. Card writer ----------------------------------------------------------------
-- Writes one return card into the stone's conversation with this buyer.
CREATE OR REPLACE FUNCTION public._post_return_card(p_return_id uuid, p_kind text)
RETURNS void
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public, pg_temp
AS $$
DECLARE
  r         record;
  v_conv_id uuid;
  v_name    text;
  v_body    text;
BEGIN
  SELECT rt.id, rt.buyer_id, rt.refund_amount, rt.decision_note, rt.deduction, rt.deduction_reason,
         o.seller_id, o.order_number,
         (SELECT oi.inventory_item_id FROM public.order_items oi WHERE oi.order_id = o.id LIMIT 1) AS item_id
  INTO   r
  FROM   public.returns rt JOIN public.orders o ON o.id = rt.order_id
  WHERE  rt.id = p_return_id;
  IF r.id IS NULL OR r.item_id IS NULL THEN RETURN; END IF;

  v_body := CASE p_kind
    WHEN 'return_requested' THEN 'Return requested for order ' || r.order_number || '.'
    WHEN 'return_approved'  THEN 'Return approved — please send the stone within 14 days. The address and steps are in My orders.'
                                 || COALESCE(' Note: ' || r.decision_note, '')
    WHEN 'return_rejected'  THEN 'Return declined.' || COALESCE(' Reason: ' || r.decision_note, '')
    WHEN 'return_received'  THEN 'We received the returned stone and are checking it. The refund follows within 14 days.'
    WHEN 'return_refunded'  THEN 'Refunded ' || public._offer_card_label(COALESCE(r.refund_amount, 0))
                                 || ' to the original payment method.'
                                 || CASE WHEN r.deduction > 0
                                         THEN ' Deduction: ' || public._offer_card_label(r.deduction)
                                              || COALESCE(' (' || r.deduction_reason || ')', '') || '.'
                                         ELSE '' END
    WHEN 'return_withdrawn' THEN 'Return cancelled.'
    WHEN 'return_reminder'  THEN 'Reminder: please send the stone back and add the tracking number in My orders. Returns without tracking close after 30 days.'
    WHEN 'return_expired'   THEN 'Return closed — the stone was not sent back within 30 days. Contact us if it is on its way.'
  END;
  IF v_body IS NULL THEN RETURN; END IF;

  SELECT id INTO v_conv_id
  FROM   public.conversations
  WHERE  inventory_item_id = r.item_id AND buyer_id = r.buyer_id;

  IF v_conv_id IS NULL THEN
    SELECT NULLIF(split_part(btrim(display_name), ' ', 1), '') INTO v_name
    FROM   public.buyers WHERE id = r.buyer_id;

    INSERT INTO public.conversations (inventory_item_id, buyer_id, seller_id, buyer_first_name)
    VALUES (r.item_id, r.buyer_id, r.seller_id, left(v_name, 50))
    ON CONFLICT (inventory_item_id, buyer_id) DO NOTHING
    RETURNING id INTO v_conv_id;

    IF v_conv_id IS NULL THEN
      SELECT id INTO v_conv_id FROM public.conversations
      WHERE  inventory_item_id = r.item_id AND buyer_id = r.buyer_id;
    END IF;
  END IF;

  INSERT INTO public.messages (conversation_id, sender_role, sender_user_id, body, kind, offer_id, offer_amount)
  VALUES (v_conv_id, 'system', NULL, left(v_body, 2000), p_kind, NULL,
          CASE WHEN p_kind = 'return_refunded' THEN r.refund_amount END);

  UPDATE public.conversations SET last_message_at = now() WHERE id = v_conv_id;
END;
$$;

CREATE OR REPLACE FUNCTION public._return_message_card()
RETURNS trigger
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public, pg_temp
AS $$
BEGIN
  IF TG_OP = 'UPDATE' AND OLD.status = NEW.status THEN
    RETURN NEW;
  END IF;
  BEGIN
    PERFORM public._post_return_card(NEW.id, 'return_' || NEW.status);
  EXCEPTION WHEN OTHERS THEN
    -- A card must never block the return itself.
    RAISE WARNING '[return card] return % status % failed: % (%)', NEW.id, NEW.status, SQLERRM, SQLSTATE;
  END;
  RETURN NEW;
END;
$$;

REVOKE ALL ON FUNCTION public._post_return_card(uuid, text) FROM PUBLIC, anon, authenticated;
REVOKE ALL ON FUNCTION public._return_message_card() FROM PUBLIC, anon, authenticated;

DROP TRIGGER IF EXISTS returns_message_card ON public.returns;
CREATE TRIGGER returns_message_card
  AFTER INSERT OR UPDATE OF status ON public.returns
  FOR EACH ROW EXECUTE FUNCTION public._return_message_card();

-- 4. Emails: + 'expired' (live definition from returns_setup.sql) -------------
CREATE OR REPLACE FUNCTION public._return_notify()
RETURNS trigger
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public, pg_temp
AS $$
DECLARE
  v_secret text;
BEGIN
  IF TG_OP = 'UPDATE' AND OLD.status = NEW.status THEN
    RETURN NEW;
  END IF;
  IF NEW.status NOT IN ('requested','approved','rejected','refunded','expired') THEN
    RETURN NEW;
  END IF;

  SELECT s.decrypted_secret INTO v_secret
  FROM   vault.decrypted_secrets s
  WHERE  s.name = 'offer_reminder_secret'
  LIMIT  1;

  IF v_secret IS NULL OR v_secret = '' THEN
    RAISE WARNING '[return notify] Vault secret offer_reminder_secret missing — no email for %', NEW.id;
    RETURN NEW;
  END IF;

  BEGIN
    PERFORM net.http_post(
      url                  := 'https://cvqzidqnwthzfodhzepz.supabase.co/functions/v1/offer-notify',
      body                 := jsonb_build_object('type', 'RETURN_EVENT', 'return_id', NEW.id, 'event', NEW.status),
      headers              := jsonb_build_object(
                                'Content-Type',      'application/json',
                                'x-reminder-secret', v_secret
                              ),
      timeout_milliseconds := 10000
    );
  EXCEPTION WHEN OTHERS THEN
    RAISE WARNING '[return notify] queue failed for %: %', NEW.id, SQLERRM;
  END;

  RETURN NEW;
END;
$$;

-- 5. Buyer unread: own return actions are not "unread" (live definitions) -----
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
     AND  m.kind <> ALL (ARRAY['offer_made','offer_withdrawn','counter_accepted','counter_declined',
                               'return_requested','return_withdrawn'])
     AND  m.created_at > COALESCE(c.buyer_last_read_at, '-infinity'::timestamptz)
  )::integer AS unread_count,
  last_msg.preview AS last_message_preview,
  last_msg.is_mine AS last_message_is_mine
FROM public.conversations c
LEFT JOIN LATERAL (
  SELECT left(m.body, 140) AS preview,
         (m.sender_role = 'buyer'
          OR m.kind = ANY (ARRAY['offer_made','offer_withdrawn','counter_accepted','counter_declined',
                                 'return_requested','return_withdrawn'])) AS is_mine
  FROM   public.messages m
  WHERE  m.conversation_id = c.id
  ORDER  BY m.created_at DESC
  LIMIT  1
) last_msg ON true
WHERE c.buyer_id = auth.uid();

REVOKE ALL ON public.buyer_conversations FROM anon, authenticated;
GRANT SELECT ON public.buyer_conversations TO authenticated;

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
      AND  m.kind NOT IN ('offer_made', 'offer_withdrawn', 'counter_accepted', 'counter_declined',
                          'return_requested', 'return_withdrawn')
      AND  m.created_at > COALESCE(c.buyer_last_read_at, '-infinity'::timestamptz);
  END IF;

  RETURN json_build_object('conversations', v_convs, 'messages', v_msgs);
END;
$$;

-- 6. Quiet returns: reminder at 10 days, close at 30 (no tracking) -----------
CREATE OR REPLACE FUNCTION public.sweep_quiet_returns()
RETURNS void
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public, pg_temp
AS $$
DECLARE
  r        record;
  v_secret text;
BEGIN
  -- Close first, so a return never gets a reminder and a close in one run.
  UPDATE public.returns
  SET    status = 'expired', updated_at = now()
  WHERE  status = 'approved'
    AND  approved_at < now() - interval '30 days'
    AND  (return_tracking IS NULL OR trim(return_tracking) = '');

  SELECT s.decrypted_secret INTO v_secret
  FROM   vault.decrypted_secrets s WHERE s.name = 'offer_reminder_secret' LIMIT 1;

  FOR r IN
    SELECT id FROM public.returns
    WHERE  status = 'approved'
      AND  reminder_sent_at IS NULL
      AND  approved_at < now() - interval '10 days'
      AND  (return_tracking IS NULL OR trim(return_tracking) = '')
    FOR UPDATE SKIP LOCKED
  LOOP
    UPDATE public.returns SET reminder_sent_at = now() WHERE id = r.id;
    BEGIN
      PERFORM public._post_return_card(r.id, 'return_reminder');
    EXCEPTION WHEN OTHERS THEN
      RAISE WARNING '[return sweep] card for % failed: %', r.id, SQLERRM;
    END;
    IF v_secret IS NOT NULL AND v_secret <> '' THEN
      BEGIN
        PERFORM net.http_post(
          url                  := 'https://cvqzidqnwthzfodhzepz.supabase.co/functions/v1/offer-notify',
          body                 := jsonb_build_object('type', 'RETURN_EVENT', 'return_id', r.id, 'event', 'reminder'),
          headers              := jsonb_build_object('Content-Type', 'application/json', 'x-reminder-secret', v_secret),
          timeout_milliseconds := 10000
        );
      EXCEPTION WHEN OTHERS THEN
        RAISE WARNING '[return sweep] reminder email for % failed: %', r.id, SQLERRM;
      END;
    END IF;
  END LOOP;
END;
$$;

REVOKE ALL ON FUNCTION public.sweep_quiet_returns() FROM PUBLIC, anon, authenticated;

SELECT cron.unschedule('gemworkers_quiet_returns')
WHERE  EXISTS (SELECT 1 FROM cron.job WHERE jobname = 'gemworkers_quiet_returns');
SELECT cron.schedule(
  'gemworkers_quiet_returns',
  '7 * * * *',
  $$
    SELECT public.sweep_quiet_returns();
  $$
);

COMMIT;

-- VERIFICATION (read-only):
--   SELECT jobname, schedule FROM cron.job WHERE jobname = 'gemworkers_quiet_returns';
--   SELECT kind, body FROM messages WHERE kind LIKE 'return_%' ORDER BY created_at;
