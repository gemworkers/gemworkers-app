-- =============================================================================
-- GemWorkers — respond_to_counter(): buyer accepts or declines (plan step 7)
-- =============================================================================
-- Applied to live DB 2026-10-22
--
-- respond_to_counter(p_offer_id, p_action 'accepted' | 'declined') → json
--   { offer_id, order_id } (order_id null on decline).
--
-- Rules:
--   - caller must be the offer's buyer
--   - offer must be 'countered' and counter_expires_at still in the future
--     (the step-8 sweep marks late ones 'expired')
--   - accept is refused while the buyer is blocked in this stone's
--     conversation; decline is always allowed
--   - decline: status 'declined', responded_at; responded_by_role stays NULL
--     (buyer) → card 'counter_declined'
--   - accept: the ACCEPT PATH OF LIVE respond_to_offer COPIED VERBATIM
--     (item lock + available check, reserve, commission / payout maths,
--     orders + order_items insert with 48h payment window, auto-decline the
--     stone's other open offers). Only two changes:
--       v_item_price := v_offer.offered_price;
--     → v_item_price := v_offer.counter_price;
--     and the offer UPDATE sets only status = 'accepted', responded_at = now()
--     (no seller_note / responded_by_role — the buyer accepted, not staff).
--     → card 'counter_accepted'. Payment charges orders.order_total, so the
--     buyer pays the counter price + shipping.
--
-- offer-notify ignores countered→accepted/declined until step 9.
--
-- Requires: counter_offer_setup.sql (step 6).
-- =============================================================================

BEGIN;

CREATE OR REPLACE FUNCTION public.respond_to_counter(p_offer_id uuid, p_action text)
RETURNS json
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public, pg_temp
AS $$
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
  IF p_action IS NULL OR p_action NOT IN ('accepted', 'declined') THEN
    RAISE EXCEPTION 'p_action must be ''accepted'' or ''declined''';
  END IF;

  SELECT o.id, o.buyer_id, o.inventory_item_id, o.seller_id,
         o.offered_price, o.counter_price, o.counter_expires_at, o.status
  INTO   v_offer
  FROM   storefront_offers o
  WHERE  o.id = p_offer_id
  FOR UPDATE;

  IF NOT FOUND OR auth.uid() IS NULL OR v_offer.buyer_id IS DISTINCT FROM auth.uid() THEN
    RAISE EXCEPTION 'Offer not found';
  END IF;

  IF v_offer.status <> 'countered' THEN
    RAISE EXCEPTION 'This counter-offer is no longer open (status: %)', v_offer.status;
  END IF;

  IF v_offer.counter_expires_at <= now() THEN
    RAISE EXCEPTION 'This counter-offer has expired';
  END IF;

  IF p_action = 'declined' THEN
    UPDATE storefront_offers
    SET    status = 'declined', responded_at = now()
    WHERE  id = p_offer_id;

    RETURN json_build_object('offer_id', p_offer_id, 'order_id', null);
  END IF;

  IF EXISTS (
    SELECT 1 FROM conversations
    WHERE  buyer_id          = v_offer.buyer_id
      AND  inventory_item_id = v_offer.inventory_item_id
      AND  status            = 'blocked'
  ) THEN
    RAISE EXCEPTION 'Offers on this stone aren''t available for your account';
  END IF;

  -- ── Accept path: live respond_to_offer, verbatim except the two lines above ──
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

  v_item_price := v_offer.counter_price;
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
  SET    status = 'accepted', responded_at = now()
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
$$;

REVOKE ALL ON FUNCTION public.respond_to_counter(uuid, text) FROM PUBLIC, anon;
GRANT EXECUTE ON FUNCTION public.respond_to_counter(uuid, text) TO authenticated;

COMMIT;


-- =============================================================================
-- VERIFICATION (read-only)
-- =============================================================================
--   SELECT proname, prosecdef, proconfig
--   FROM   pg_proc WHERE proname = 'respond_to_counter';
--
--   SELECT grantee, privilege_type FROM information_schema.routine_privileges
--   WHERE  routine_name = 'respond_to_counter' AND grantee IN ('anon', 'authenticated');
-- =============================================================================
