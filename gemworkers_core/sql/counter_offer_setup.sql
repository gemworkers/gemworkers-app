-- =============================================================================
-- GemWorkers — Counter-offer: schema + counter_offer() (plan step 6)
-- =============================================================================
-- Applied to live DB 2026-10-22
--
-- Decisions: one counter only; buyer can only accept/decline (step 7);
-- counter must be > buyer's offer and < listed price; expires after 48h
-- (sweep, step 8); blocked buyers can't make offers.
--
-- 1. storefront_offers: status gains 'countered'; new columns counter_price,
--    countered_at, counter_expires_at, countered_by_role. Shape checks.
--    offered_price stays the buyer's own amount; the counter is separate.
-- 2. submit_storefront_offer — LIVE definition copied exactly; changed:
--      - one-active-offer check: status IN ('pending', 'countered')
--      - NEW: buyer blocked in this stone's conversation → refused
-- 3. respond_to_offer — LIVE definition copied exactly; changed:
--      - auto-decline of the stone's other offers on accept:
--        status IN ('pending', 'countered')
--    Seller accept/decline still needs status = 'pending' (unchanged): once
--    countered, the buyer decides.
-- 4. counter_offer(p_offer_id, p_counter_price) — new. Seller of the offer
--    or owner; offer must be 'pending'; stone listed + available; exact
--    cents; offered_price < counter < selling_price. Sets status
--    'countered', expires now() + 48h.
-- 5. _offer_message_card trigger: counter cards
--      → countered                       offer_countered   (counter_price)
--      countered → accepted              counter_accepted  (counter_price)
--      countered → declined (buyer)      counter_declined  (counter_price)
--      countered → declined (system,
--                  stone sold elsewhere) offer_declined    (offered_price)
--      countered → expired               counter_expired   (counter_price)
-- 6. Buyer unread: counter_accepted / counter_declined are the buyer's own
--    actions → not unread, shown as "mine" (buyer_conversations,
--    buyer_unread_count re-stated from step 3 with the longer list).
--
-- offer-notify only reacts to pending→accepted/declined and
-- accepted→expired, so 'countered' sends no email until step 9.
--
-- Requires: message_offer_cards_trigger.sql (step 3).
-- One transaction. Safe to re-run.
-- =============================================================================

BEGIN;

-- ── 1. Schema ───────────────────────────────────────────────────────────────
ALTER TABLE public.storefront_offers
  ADD COLUMN IF NOT EXISTS counter_price      numeric(12,2),
  ADD COLUMN IF NOT EXISTS countered_at       timestamptz,
  ADD COLUMN IF NOT EXISTS counter_expires_at timestamptz,
  ADD COLUMN IF NOT EXISTS countered_by_role  text;

ALTER TABLE public.storefront_offers DROP CONSTRAINT IF EXISTS storefront_offers_status_check;
ALTER TABLE public.storefront_offers
  ADD CONSTRAINT storefront_offers_status_check
  CHECK (status IN ('pending', 'countered', 'accepted', 'declined', 'withdrawn', 'expired'));

ALTER TABLE public.storefront_offers DROP CONSTRAINT IF EXISTS storefront_offers_counter_shape_check;
ALTER TABLE public.storefront_offers
  ADD CONSTRAINT storefront_offers_counter_shape_check
  CHECK (
    (counter_price IS NULL
       AND countered_at IS NULL AND counter_expires_at IS NULL AND countered_by_role IS NULL
       AND status <> 'countered')
    OR
    (counter_price IS NOT NULL AND counter_price > offered_price
       AND countered_at IS NOT NULL AND counter_expires_at IS NOT NULL
       AND countered_by_role IN ('seller', 'owner'))
  );

-- Step-8 sweep looks these up.
CREATE INDEX IF NOT EXISTS idx_storefront_offers_counter_expires
  ON public.storefront_offers (counter_expires_at)
  WHERE status = 'countered';

-- ── 2 + 3. Live functions, copied exactly (see diff in header) ──────────────

CREATE OR REPLACE FUNCTION public.submit_storefront_offer(p_inventory_item_id uuid, p_offered_price numeric, p_buyer_note text DEFAULT ''::text)
 RETURNS uuid
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO 'public'
AS $function$
DECLARE
  v_item     record;
  v_offer_id uuid;
BEGIN
  -- Read item + seller status + sale_method.
  -- sale_method is the only addition vs the original SELECT.
  SELECT i.id, i.seller_id, i.is_listed, i.status, i.sale_method,
         s.status AS seller_status
  INTO   v_item
  FROM   inventory_items i
  JOIN   sellers         s ON s.id = i.seller_id
  WHERE  i.id = p_inventory_item_id;

  IF NOT FOUND THEN
    RAISE EXCEPTION 'Item not found';
  END IF;
  IF NOT v_item.is_listed THEN
    RAISE EXCEPTION 'Item is not listed for sale';
  END IF;
  IF v_item.status <> 'available' THEN
    RAISE EXCEPTION 'Item is not available for offers (status: %)', v_item.status;
  END IF;
  IF v_item.seller_status <> 'active' THEN
    RAISE EXCEPTION 'Seller is not active';
  END IF;

  -- â”€â”€ NEW: reject offers on buy_now-only stones â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
  IF v_item.sale_method = 'buy_now' THEN
    RAISE EXCEPTION 'This item is not accepting offers';
  END IF;
  -- â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€

  IF p_offered_price <= 0 THEN
    RAISE EXCEPTION 'Offered price must be greater than zero';
  END IF;

  -- Offers are in whole cents: reject anything with more than 2 decimals
  -- rather than silently rounding the buyer's amount.
  IF p_offered_price <> round(p_offered_price, 2) THEN
    RAISE EXCEPTION 'Please enter your offer in euros and cents (at most 2 decimals), e.g. 49.80';
  END IF;

  -- One active offer per buyer per stone.
  IF EXISTS (
    SELECT 1 FROM storefront_offers
    WHERE  buyer_id          = auth.uid()
      AND  inventory_item_id = p_inventory_item_id
      AND  status            IN ('pending', 'countered')
  ) THEN
    RAISE EXCEPTION 'You already have a pending offer on this item';
  END IF;

  -- Blocked in this stone's conversation → no offers on this stone.
  IF EXISTS (
    SELECT 1 FROM conversations
    WHERE  buyer_id          = auth.uid()
      AND  inventory_item_id = p_inventory_item_id
      AND  status            = 'blocked'
  ) THEN
    RAISE EXCEPTION 'Offers on this stone aren''t available for your account';
  END IF;

  INSERT INTO storefront_offers (
    buyer_id,    inventory_item_id,       seller_id,
    offered_price, buyer_note
  )
  VALUES (
    auth.uid(),  p_inventory_item_id,     v_item.seller_id,
    p_offered_price, COALESCE(p_buyer_note, '')
  )
  RETURNING id INTO v_offer_id;

  RETURN v_offer_id;
END;
$function$;

CREATE OR REPLACE FUNCTION public.respond_to_offer(p_offer_id uuid, p_action text, p_seller_note text DEFAULT ''::text)
 RETURNS json
 LANGUAGE plpgsql
 SECURITY DEFINER
AS $function$
DECLARE
  v_offer                  record;
  v_item                   record;
  v_order_id               uuid;
  v_seller_commission_rate numeric;
  v_item_price             numeric;
  v_shipping               numeric;
  v_total                  numeric;
  v_rate                   numeric;
  v_commission             numeric;
  v_payout                 numeric;
BEGIN
  IF p_action NOT IN ('accepted', 'declined') THEN
    RAISE EXCEPTION 'p_action must be ''accepted'' or ''declined''';
  END IF;

  SELECT o.id, o.buyer_id, o.inventory_item_id, o.seller_id,
         o.offered_price, o.status
  INTO   v_offer
  FROM   storefront_offers o
  WHERE  o.id = p_offer_id
  FOR UPDATE;

  IF NOT FOUND THEN
    RAISE EXCEPTION 'Offer not found';
  END IF;

  IF v_offer.seller_id IS DISTINCT FROM public.current_seller_id()
     AND NOT public.is_owner() THEN
    RAISE EXCEPTION 'This offer does not belong to your shop';
  END IF;

  IF v_offer.status <> 'pending' THEN
    RAISE EXCEPTION 'Offer is no longer pending (status: %)', v_offer.status;
  END IF;

  IF p_action = 'declined' THEN
    UPDATE storefront_offers
    SET    status = 'declined', responded_at = now(),
           seller_note = COALESCE(p_seller_note, ''),
           responded_by_role = CASE WHEN v_offer.seller_id IS NOT DISTINCT FROM public.current_seller_id()
                                    THEN 'seller' ELSE 'owner' END
    WHERE  id = p_offer_id;

    RETURN json_build_object('offer_id', p_offer_id, 'order_id', null);
  END IF;

  SELECT id, status, shipping_cost
  INTO   v_item
  FROM   inventory_items
  WHERE  id = v_offer.inventory_item_id
  FOR UPDATE;

  IF v_item.status <> 'available' THEN
    RAISE EXCEPTION 'Item is no longer available (status: %)', v_item.status;
  END IF;

  SELECT commission_rate
  INTO   v_seller_commission_rate
  FROM   sellers
  WHERE  id = v_offer.seller_id;

  UPDATE inventory_items
  SET    status = 'reserved'
  WHERE  id = v_offer.inventory_item_id;

  v_item_price := v_offer.offered_price;
  v_shipping   := COALESCE(v_item.shipping_cost, 0);
  v_total      := v_item_price + v_shipping;
  -- No default commission: NULL rate means 0%.
  v_rate       := COALESCE(v_seller_commission_rate, 0);
  v_commission := ROUND(v_item_price * v_rate, 2);
  v_payout     := v_total - v_commission;

  INSERT INTO orders (
    buyer_id,         seller_id,          sale_channel,
    status,           order_total,        shipping_cost,
    commission_rate,  commission_amount,  seller_payout,
    offer_id,         payment_due_at
  )
  VALUES (
    v_offer.buyer_id, v_offer.seller_id,  'platform',
    'pending_payment', v_total,           v_shipping,
    v_rate,           v_commission,       v_payout,
    p_offer_id,       now() + interval '48 hours'
  )
  RETURNING id INTO v_order_id;

  INSERT INTO order_items (order_id, inventory_item_id, price_at_sale, quantity)
  VALUES (v_order_id, v_offer.inventory_item_id, v_item_price, 1);

  UPDATE storefront_offers
  SET    status = 'accepted', responded_at = now(),
         seller_note = COALESCE(p_seller_note, ''),
         responded_by_role = CASE WHEN v_offer.seller_id IS NOT DISTINCT FROM public.current_seller_id()
                                  THEN 'seller' ELSE 'owner' END
  WHERE  id = p_offer_id;

  UPDATE storefront_offers
  SET    status = 'declined', responded_at = now(),
         seller_note = 'Stone is no longer available',
         responded_by_role = 'system'
  WHERE  inventory_item_id = v_offer.inventory_item_id
    AND  status            IN ('pending', 'countered')
    AND  id                <> p_offer_id;

  RETURN json_build_object('offer_id', p_offer_id, 'order_id', v_order_id);
END;
$function$;

-- ── 4. counter_offer ────────────────────────────────────────────────────────
-- Returns { offer_id, counter_price, counter_expires_at }.
CREATE OR REPLACE FUNCTION public.counter_offer(p_offer_id uuid, p_counter_price numeric)
RETURNS json
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public, pg_temp
AS $$
DECLARE
  v_offer   record;
  v_item    record;
  v_role    text;
  v_expires timestamptz := now() + interval '48 hours';
BEGIN
  IF p_counter_price IS NULL OR p_counter_price <= 0 THEN
    RAISE EXCEPTION 'Counter-offer must be greater than zero';
  END IF;
  IF p_counter_price <> round(p_counter_price, 2) THEN
    RAISE EXCEPTION 'Please enter the counter-offer in euros and cents (at most 2 decimals), e.g. 49.80';
  END IF;

  SELECT o.id, o.inventory_item_id, o.seller_id, o.offered_price, o.status
  INTO   v_offer
  FROM   storefront_offers o
  WHERE  o.id = p_offer_id
  FOR UPDATE;

  IF NOT FOUND THEN
    RAISE EXCEPTION 'Offer not found';
  END IF;

  IF v_offer.seller_id IS DISTINCT FROM public.current_seller_id()
     AND NOT public.is_owner() THEN
    RAISE EXCEPTION 'This offer does not belong to your shop';
  END IF;

  IF v_offer.status = 'countered' THEN
    RAISE EXCEPTION 'A counter-offer has already been sent for this offer';
  END IF;
  IF v_offer.status <> 'pending' THEN
    RAISE EXCEPTION 'Offer is no longer pending (status: %)', v_offer.status;
  END IF;

  SELECT id, status, is_listed, selling_price
  INTO   v_item
  FROM   inventory_items
  WHERE  id = v_offer.inventory_item_id
  FOR UPDATE;

  IF NOT FOUND OR v_item.status <> 'available' OR v_item.is_listed IS NOT TRUE THEN
    RAISE EXCEPTION 'Item is no longer available (status: %)', COALESCE(v_item.status, 'missing');
  END IF;

  IF p_counter_price <= v_offer.offered_price THEN
    RAISE EXCEPTION 'Counter-offer must be higher than the buyer''s offer (%)',
      public._offer_card_label(v_offer.offered_price);
  END IF;
  IF v_item.selling_price IS NULL OR p_counter_price >= v_item.selling_price THEN
    RAISE EXCEPTION 'Counter-offer must be lower than the listed price (%)',
      COALESCE(public._offer_card_label(v_item.selling_price), 'not set');
  END IF;

  v_role := CASE WHEN v_offer.seller_id IS NOT DISTINCT FROM public.current_seller_id()
                 THEN 'seller' ELSE 'owner' END;

  UPDATE storefront_offers
  SET    status             = 'countered',
         counter_price      = p_counter_price,
         countered_at       = now(),
         counter_expires_at = v_expires,
         countered_by_role  = v_role
  WHERE  id = p_offer_id;

  RETURN json_build_object(
    'offer_id',           p_offer_id,
    'counter_price',      p_counter_price,
    'counter_expires_at', v_expires
  );
END;
$$;

REVOKE ALL ON FUNCTION public.counter_offer(uuid, numeric) FROM PUBLIC, anon;
GRANT EXECUTE ON FUNCTION public.counter_offer(uuid, numeric) TO authenticated;

-- ── 5. Card trigger (step 3 function; counter kinds added) ──────────────────
CREATE OR REPLACE FUNCTION public._offer_message_card()
RETURNS trigger
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public, pg_temp
AS $$
DECLARE
  v_kind    text;
  v_amount  numeric;
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
    IF NEW.status = 'countered' THEN
      v_kind := 'offer_countered';
    ELSIF OLD.status = 'countered' THEN
      v_kind := CASE
                  WHEN NEW.status = 'accepted'  THEN 'counter_accepted'
                  WHEN NEW.status = 'declined' AND NEW.responded_by_role = 'system'
                                                THEN 'offer_declined'
                  WHEN NEW.status = 'declined'  THEN 'counter_declined'
                  WHEN NEW.status = 'expired'   THEN 'counter_expired'
                  WHEN NEW.status = 'withdrawn' THEN 'offer_withdrawn'
                END;
    ELSE
      v_kind := CASE NEW.status
                  WHEN 'accepted'  THEN 'offer_accepted'
                  WHEN 'declined'  THEN 'offer_declined'
                  WHEN 'expired'   THEN 'offer_expired'
                  WHEN 'withdrawn' THEN 'offer_withdrawn'
                END;
    END IF;
  END IF;

  IF v_kind IS NULL THEN
    RETURN NEW;
  END IF;

  BEGIN
    v_amount := CASE WHEN v_kind IN ('offer_countered', 'counter_accepted',
                                     'counter_declined', 'counter_expired')
                     THEN NEW.counter_price
                     ELSE NEW.offered_price
                END;
    v_label := public._offer_card_label(v_amount);
    v_body  := CASE v_kind
                 WHEN 'offer_made'       THEN 'Offer made: '               || v_label
                 WHEN 'offer_accepted'   THEN 'Offer accepted: '           || v_label
                 WHEN 'offer_declined'   THEN 'Offer declined: '           || v_label
                 WHEN 'offer_expired'    THEN 'Offer expired: '            || v_label
                 WHEN 'offer_withdrawn'  THEN 'Offer withdrawn: '          || v_label
                 WHEN 'offer_countered'  THEN 'Counter-offer: '            || v_label
                 WHEN 'counter_accepted' THEN 'Counter-offer accepted: '   || v_label
                 WHEN 'counter_declined' THEN 'Counter-offer declined: '   || v_label
                 WHEN 'counter_expired'  THEN 'Counter-offer expired: '    || v_label
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
      (v_conv_id, 'system', NULL, v_body, v_kind, NEW.id, v_amount)
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

REVOKE ALL ON FUNCTION public._offer_message_card() FROM PUBLIC, anon, authenticated;

-- ── 6a. buyer_conversations (step 3 definition; longer "own action" list) ───
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
     AND  m.kind NOT IN ('offer_made', 'offer_withdrawn', 'counter_accepted', 'counter_declined')
     AND  m.created_at > COALESCE(c.buyer_last_read_at, '-infinity'::timestamptz)
  )::integer AS unread_count,
  last_msg.preview AS last_message_preview,
  last_msg.is_mine AS last_message_is_mine
FROM public.conversations c
LEFT JOIN LATERAL (
  SELECT left(m.body, 140)          AS preview,
         (m.sender_role = 'buyer'
          OR m.kind IN ('offer_made', 'offer_withdrawn', 'counter_accepted', 'counter_declined')) AS is_mine
  FROM   public.messages m
  WHERE  m.conversation_id = c.id
  ORDER  BY m.created_at DESC
  LIMIT  1
) last_msg ON true
WHERE c.buyer_id = auth.uid();

REVOKE ALL ON public.buyer_conversations FROM anon, authenticated;
GRANT SELECT ON public.buyer_conversations TO authenticated;

-- ── 6b. buyer_unread_count (step 3 definition; longer list) ────────────────
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
      AND  m.kind NOT IN ('offer_made', 'offer_withdrawn', 'counter_accepted', 'counter_declined')
      AND  m.created_at > COALESCE(c.buyer_last_read_at, '-infinity'::timestamptz);
  END IF;

  RETURN json_build_object('conversations', v_convs, 'messages', v_msgs);
END;
$$;

COMMIT;


-- =============================================================================
-- VERIFICATION (read-only)
-- =============================================================================
--   SELECT conname, pg_get_constraintdef(oid) FROM pg_constraint
--   WHERE  conrelid = 'public.storefront_offers'::regclass AND contype = 'c';
--
--   SELECT proname, prosrc LIKE '%''countered''%' AS has_countered
--   FROM   pg_proc
--   WHERE  proname IN ('submit_storefront_offer', 'respond_to_offer', 'counter_offer',
--                      '_offer_message_card');
-- =============================================================================
