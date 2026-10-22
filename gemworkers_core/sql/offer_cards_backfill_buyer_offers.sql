-- =============================================================================
-- GemWorkers — Offers in the conversation, final part A (plan step 12)
-- =============================================================================
-- Applied to live DB 2026-10-22
--
-- 1. Backfill offer cards for offers older than the step-3 trigger (only
--    offers never countered — every counter already has its cards). Missing
--    kinds only (ON CONFLICT (offer_id, kind) DO NOTHING), at the historical
--    times:
--      every offer      → offer_made      at created_at
--      accepted         → offer_accepted  at responded_at
--      declined         → offer_declined  at responded_at
--      expired          → offer_accepted  at responded_at
--                         + offer_expired at the order's payment_due_at
--                           (fallback responded_at + 48h)
--      withdrawn        → offer_withdrawn at responded_at / created_at
--    Conversations are created when missing (marked read for the buyer, so
--    old history doesn't show as unread); last_message_at moves forward only.
-- 2. buyer_offers view — what a buyer may see of their own offers. No
--    seller_id, seller_note, buyer_note, responded_by_role, notify stamps.
--    (security definer view filtered on auth.uid(), like buyer_messages.)
-- 3. withdraw_offer(p_offer_id) — replaces the store's direct UPDATE.
--    Buyer only, status 'pending' only (a countered offer is answered with
--    accept / decline instead).
-- 4. Stone marked SOLD (paid order via confirm_order_paid, or marked sold in
--    admin) → its open offers (pending / countered) are declined by 'system'
--    with the same values respond_to_offer uses. Reserved is NOT enough: an
--    unpaid Buy-now/cart reservation can still be released.
--    offer-notify sends the buyer "reserved by another buyer"; cards:
--    offer_declined.
--
-- Part B (separate file, after the store reads buyer_offers + withdraw_offer)
-- drops the buyer's direct SELECT/UPDATE policies on storefront_offers.
--
-- Requires: steps 2–9.
-- =============================================================================

BEGIN;

-- ── 1. Backfill ─────────────────────────────────────────────────────────────
DO $$
DECLARE
  o        record;
  v_conv   uuid;
  v_name   text;
  v_new    boolean;
  v_label  text;
  v_due    timestamptz;
  v_last   timestamptz;
BEGIN
  FOR o IN
    SELECT *
    FROM   public.storefront_offers
    WHERE  counter_price IS NULL
    ORDER  BY created_at
  LOOP
    v_new := false;

    SELECT id INTO v_conv
    FROM   public.conversations
    WHERE  inventory_item_id = o.inventory_item_id AND buyer_id = o.buyer_id;

    IF v_conv IS NULL THEN
      SELECT NULLIF(split_part(btrim(display_name), ' ', 1), '')
      INTO   v_name
      FROM   public.buyers WHERE id = o.buyer_id;

      INSERT INTO public.conversations
        (inventory_item_id, buyer_id, seller_id, buyer_first_name, created_at, buyer_last_read_at)
      VALUES
        (o.inventory_item_id, o.buyer_id, o.seller_id, left(v_name, 50), o.created_at, now())
      RETURNING id INTO v_conv;
      v_new := true;
    END IF;

    v_label := public._offer_card_label(o.offered_price);

    INSERT INTO public.messages
      (conversation_id, sender_role, sender_user_id, body, kind, offer_id, offer_amount, created_at)
    VALUES
      (v_conv, 'system', NULL, 'Offer made: ' || v_label, 'offer_made', o.id, o.offered_price, o.created_at)
    ON CONFLICT (offer_id, kind) WHERE offer_id IS NOT NULL DO NOTHING;
    v_last := o.created_at;

    IF o.status IN ('accepted', 'expired') THEN
      INSERT INTO public.messages
        (conversation_id, sender_role, sender_user_id, body, kind, offer_id, offer_amount, created_at)
      VALUES
        (v_conv, 'system', NULL, 'Offer accepted: ' || v_label, 'offer_accepted', o.id, o.offered_price,
         COALESCE(o.responded_at, o.created_at + interval '1 second'))
      ON CONFLICT (offer_id, kind) WHERE offer_id IS NOT NULL DO NOTHING;
      v_last := GREATEST(v_last, COALESCE(o.responded_at, o.created_at + interval '1 second'));
    END IF;

    IF o.status = 'expired' THEN
      SELECT max(payment_due_at) INTO v_due FROM public.orders WHERE offer_id = o.id;
      v_due := COALESCE(v_due, COALESCE(o.responded_at, o.created_at) + interval '48 hours');
      INSERT INTO public.messages
        (conversation_id, sender_role, sender_user_id, body, kind, offer_id, offer_amount, created_at)
      VALUES
        (v_conv, 'system', NULL, 'Offer expired: ' || v_label, 'offer_expired', o.id, o.offered_price, v_due)
      ON CONFLICT (offer_id, kind) WHERE offer_id IS NOT NULL DO NOTHING;
      v_last := GREATEST(v_last, v_due);
    END IF;

    IF o.status = 'declined' THEN
      INSERT INTO public.messages
        (conversation_id, sender_role, sender_user_id, body, kind, offer_id, offer_amount, created_at)
      VALUES
        (v_conv, 'system', NULL, 'Offer declined: ' || v_label, 'offer_declined', o.id, o.offered_price,
         COALESCE(o.responded_at, o.created_at + interval '1 second'))
      ON CONFLICT (offer_id, kind) WHERE offer_id IS NOT NULL DO NOTHING;
      v_last := GREATEST(v_last, COALESCE(o.responded_at, o.created_at + interval '1 second'));
    END IF;

    IF o.status = 'withdrawn' THEN
      INSERT INTO public.messages
        (conversation_id, sender_role, sender_user_id, body, kind, offer_id, offer_amount, created_at)
      VALUES
        (v_conv, 'system', NULL, 'Offer withdrawn: ' || v_label, 'offer_withdrawn', o.id, o.offered_price,
         COALESCE(o.responded_at, o.created_at + interval '1 second'))
      ON CONFLICT (offer_id, kind) WHERE offer_id IS NOT NULL DO NOTHING;
    END IF;

    UPDATE public.conversations
    SET    last_message_at = CASE WHEN v_new THEN v_last ELSE GREATEST(last_message_at, v_last) END
    WHERE  id = v_conv;
  END LOOP;
END;
$$;

-- ── 2. buyer_offers ─────────────────────────────────────────────────────────
CREATE OR REPLACE VIEW public.buyer_offers
WITH (security_invoker = false)
AS
SELECT
  o.id,
  o.inventory_item_id,
  o.offered_price,
  o.status,
  o.counter_price,
  o.counter_expires_at,
  o.created_at,
  o.responded_at
FROM public.storefront_offers o
WHERE o.buyer_id = auth.uid();

REVOKE ALL ON public.buyer_offers FROM anon, authenticated;
GRANT SELECT ON public.buyer_offers TO authenticated;

-- ── 3. withdraw_offer ───────────────────────────────────────────────────────
CREATE OR REPLACE FUNCTION public.withdraw_offer(p_offer_id uuid)
RETURNS void
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public, pg_temp
AS $$
BEGIN
  IF auth.uid() IS NULL THEN
    RAISE EXCEPTION 'You must be logged in.';
  END IF;

  UPDATE storefront_offers
  SET    status = 'withdrawn'
  WHERE  id       = p_offer_id
    AND  buyer_id = auth.uid()
    AND  status   = 'pending';

  IF NOT FOUND THEN
    RAISE EXCEPTION 'Could not withdraw — the offer may already be resolved.';
  END IF;
END;
$$;

REVOKE ALL ON FUNCTION public.withdraw_offer(uuid) FROM PUBLIC, anon;
GRANT EXECUTE ON FUNCTION public.withdraw_offer(uuid) TO authenticated;

-- ── 4. Stone sold → decline its open offers ─────────────────────────────────
CREATE OR REPLACE FUNCTION public._decline_offers_on_sold()
RETURNS trigger
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public, pg_temp
AS $$
BEGIN
  UPDATE storefront_offers
  SET    status = 'declined', responded_at = now(),
         seller_note = 'Stone is no longer available',
         responded_by_role = 'system'
  WHERE  inventory_item_id = NEW.id
    AND  status            IN ('pending', 'countered');
  RETURN NEW;
END;
$$;

REVOKE ALL ON FUNCTION public._decline_offers_on_sold() FROM PUBLIC, anon, authenticated;

DROP TRIGGER IF EXISTS inventory_sold_declines_offers ON public.inventory_items;
CREATE TRIGGER inventory_sold_declines_offers
  AFTER UPDATE OF status ON public.inventory_items
  FOR EACH ROW
  WHEN (NEW.status = 'sold' AND OLD.status IS DISTINCT FROM 'sold')
  EXECUTE FUNCTION public._decline_offers_on_sold();

COMMIT;


-- =============================================================================
-- VERIFICATION (read-only)
-- =============================================================================
--   SELECT o.status, count(m.id) AS cards
--   FROM   storefront_offers o LEFT JOIN messages m ON m.offer_id = o.id
--   GROUP  BY o.id, o.status ORDER BY 1;
--
--   SELECT pg_get_viewdef('public.buyer_offers'::regclass, true);
--   SELECT tgname FROM pg_trigger WHERE tgrelid = 'public.inventory_items'::regclass;
-- =============================================================================
