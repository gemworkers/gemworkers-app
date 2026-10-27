-- =============================================================================
-- GemWorkers — Message about an order (buyer ↔ GemWorkers)
-- =============================================================================
-- Applied to live DB 2026-10-27
--
-- Zakaria 2026-10-27: "Message us about this order" in My orders and
-- "Message buyer" on the admin order page. Uses the existing per-stone
-- conversations (one per buyer + stone): order_conversation(order) returns
-- that conversation, creating it when there is none yet. Needed because
-- ask_about_stone only starts conversations about stones still on sale, and
-- staff could not start one at all. Messages are then sent with the existing
-- functions (send_buyer_message / staff reply) with all their rules
-- (contact info blocked, rate limits, closed/blocked conversations).
-- Allowed: the order's buyer, the order's seller, the owner — paid platform
-- orders only.
-- =============================================================================

BEGIN;

CREATE OR REPLACE FUNCTION public.order_conversation(p_order_id uuid)
RETURNS uuid
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public, pg_temp
AS $$
DECLARE
  o       record;
  v_stone uuid;
  v_conv  uuid;
  v_name  text;
BEGIN
  SELECT id, buyer_id, seller_id, sale_channel, paid_at, shipping_name
  INTO   o
  FROM   orders
  WHERE  id = p_order_id;

  IF o.id IS NULL OR o.sale_channel IS DISTINCT FROM 'platform' OR o.paid_at IS NULL OR o.buyer_id IS NULL THEN
    RAISE EXCEPTION 'Messages are only possible for paid shop orders.';
  END IF;
  IF auth.uid() IS DISTINCT FROM o.buyer_id
     AND o.seller_id IS DISTINCT FROM public.current_seller_id()
     AND NOT public.is_owner() THEN
    RAISE EXCEPTION 'This order is not yours.';
  END IF;

  SELECT inventory_item_id INTO v_stone
  FROM   order_items WHERE order_id = o.id
  ORDER  BY created_at LIMIT 1;
  IF v_stone IS NULL THEN
    RAISE EXCEPTION 'This order has no stone.';
  END IF;

  SELECT id INTO v_conv
  FROM   conversations
  WHERE  inventory_item_id = v_stone AND buyer_id = o.buyer_id;
  IF v_conv IS NOT NULL THEN
    RETURN v_conv;
  END IF;

  -- First name: buyer's display name, else the order's shipping name.
  SELECT NULLIF(split_part(btrim(display_name), ' ', 1), '') INTO v_name
  FROM   buyers WHERE id = o.buyer_id;
  v_name := left(coalesce(v_name, NULLIF(split_part(btrim(o.shipping_name), ' ', 1), '')), 50);

  INSERT INTO conversations (inventory_item_id, buyer_id, seller_id, buyer_first_name)
  VALUES (v_stone, o.buyer_id, o.seller_id, v_name)
  ON CONFLICT (inventory_item_id, buyer_id) DO NOTHING
  RETURNING id INTO v_conv;

  IF v_conv IS NULL THEN
    SELECT id INTO v_conv FROM conversations
    WHERE  inventory_item_id = v_stone AND buyer_id = o.buyer_id;
  END IF;
  RETURN v_conv;
END;
$$;
REVOKE ALL ON FUNCTION public.order_conversation(uuid) FROM PUBLIC, anon;
GRANT EXECUTE ON FUNCTION public.order_conversation(uuid) TO authenticated;

COMMIT;
