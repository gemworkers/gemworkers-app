-- =============================================================================
-- GemWorkers — No default commission: NULL commission_rate = 0%
-- =============================================================================
-- Applied to the live DB 2026-10-18 and verified.
--
-- Decision 2026-10-18: there is NO default commission. A missing (NULL)
-- sellers.commission_rate means 0%.
--
-- 1. create_platform_order — copied verbatim from the LIVE definition
--    (pg_get_functiondef, fetched 2026-10-18).
-- 2. respond_to_offer — copied verbatim from sql/respond_to_offer_owner_override.sql
--    (live differs only by one comment line).
-- The ONLY change in each function:
--      COALESCE(<seller rate>, 0.10)  →  COALESCE(<seller rate>, 0)
-- 3. sellers.commission_rate column default → 0.
--
-- CREATE OR REPLACE keeps the existing EXECUTE grants.
-- =============================================================================

BEGIN;

-- ── 1. create_platform_order ─────────────────────────────────────────────────
CREATE OR REPLACE FUNCTION public.create_platform_order(p_inventory_item_id uuid)
 RETURNS uuid
 LANGUAGE plpgsql
 SECURITY DEFINER
AS $function$
DECLARE
  v_item        record;
  v_order_id    uuid;
  v_item_price  numeric;
  v_shipping    numeric;
  v_total       numeric;
  v_rate        numeric;
  v_commission  numeric;
  v_payout      numeric;
BEGIN
  SELECT i.id, i.selling_price, i.seller_id, i.status, i.is_listed,
         s.status          AS seller_status,
         i.shipping_cost,
         s.commission_rate AS seller_commission_rate
  INTO   v_item
  FROM   inventory_items i
  JOIN   sellers         s ON s.id = i.seller_id
  WHERE  i.id = p_inventory_item_id
  FOR UPDATE;

  IF NOT FOUND THEN
    RAISE EXCEPTION 'Item not found';
  END IF;
  IF NOT v_item.is_listed THEN
    RAISE EXCEPTION 'Item is not listed for sale';
  END IF;
  IF v_item.status <> 'available' THEN
    RAISE EXCEPTION 'Item is not available (status: %)', v_item.status;
  END IF;
  IF v_item.seller_status <> 'active' THEN
    RAISE EXCEPTION 'Seller is not active';
  END IF;
  IF v_item.selling_price IS NULL THEN
    RAISE EXCEPTION 'Item has no listed price';
  END IF;

  UPDATE inventory_items
  SET    status = 'reserved'
  WHERE  id = p_inventory_item_id;

  v_item_price := v_item.selling_price;
  v_shipping   := COALESCE(v_item.shipping_cost, 0);
  v_total      := v_item_price + v_shipping;
  -- No default commission: NULL rate means 0%.
  v_rate       := COALESCE(v_item.seller_commission_rate, 0);
  v_commission := ROUND(v_item_price * v_rate, 2);
  v_payout     := v_total - v_commission;

  INSERT INTO orders (
    buyer_id,          seller_id,          sale_channel,
    status,            order_total,        shipping_cost,
    commission_rate,   commission_amount,  seller_payout
  )
  VALUES (
    auth.uid(),        v_item.seller_id,   'platform',
    'pending_payment', v_total,            v_shipping,
    v_rate,            v_commission,       v_payout
  )
  RETURNING id INTO v_order_id;

  INSERT INTO order_items (order_id, inventory_item_id, price_at_sale, quantity)
  VALUES (v_order_id, p_inventory_item_id, v_item_price, 1);

  RETURN v_order_id;
END;
$function$;

-- ── 2. respond_to_offer ──────────────────────────────────────────────────────
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
           seller_note = COALESCE(p_seller_note, '')
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
         seller_note = COALESCE(p_seller_note, '')
  WHERE  id = p_offer_id;

  UPDATE storefront_offers
  SET    status = 'declined', responded_at = now(),
         seller_note = 'Stone is no longer available'
  WHERE  inventory_item_id = v_offer.inventory_item_id
    AND  status            = 'pending'
    AND  id                <> p_offer_id;

  RETURN json_build_object('offer_id', p_offer_id, 'order_id', v_order_id);
END;
$function$;

-- ── 3. Column default ────────────────────────────────────────────────────────
ALTER TABLE sellers ALTER COLUMN commission_rate SET DEFAULT 0;

-- ── 4. Data fix: lagoon tourmaline had no seller (sold via ORD-00038, GW1-Thailand) ──
UPDATE inventory_items SET seller_id = (SELECT id FROM sellers WHERE name = 'GW1-Thailand') WHERE id = '35383538-6981-444c-86fc-1522051ad5c0' AND seller_id IS NULL;

COMMIT;
