BEGIN;

-- 1. Link offer orders to their offer + payment deadline
ALTER TABLE public.orders ADD COLUMN IF NOT EXISTS offer_id uuid REFERENCES public.storefront_offers(id);
ALTER TABLE public.orders ADD COLUMN IF NOT EXISTS payment_due_at timestamptz;

-- 2. Accepting an offer creates an UNPAID order with a 48h deadline
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

  IF v_offer.seller_id IS DISTINCT FROM public.current_seller_id() THEN
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
  v_rate       := COALESCE(v_seller_commission_rate, 0.10);
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

-- 3. Cancelling: offer orders stay open until their deadline; on cancel, the offer expires
CREATE OR REPLACE FUNCTION public.cancel_pending_payment_order(p_order_id uuid)
 RETURNS void
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO 'public'
AS $function$
DECLARE
  v_status         text;
  v_offer_id       uuid;
  v_payment_due_at timestamptz;
BEGIN
  SELECT status, offer_id, payment_due_at
  INTO   v_status, v_offer_id, v_payment_due_at
  FROM   orders
  WHERE  id = p_order_id
  FOR UPDATE;

  IF NOT FOUND THEN
    RAISE EXCEPTION 'Order not found: %', p_order_id;
  END IF;

  IF v_status = 'cancelled' THEN
    RETURN;
  END IF;

  IF v_status <> 'pending_payment' THEN
    RAISE EXCEPTION
      'Cannot cancel order %: expected status ''pending_payment'', found ''%''',
      p_order_id, v_status;
  END IF;

  -- Accepted-offer orders keep their window: backing out of Stripe must not
  -- cancel them. Only the deadline (via the sweep) releases them.
  IF v_offer_id IS NOT NULL AND v_payment_due_at IS NOT NULL AND v_payment_due_at > now() THEN
    RETURN;
  END IF;

  UPDATE orders
  SET    status = 'cancelled'
  WHERE  id = p_order_id;

  UPDATE inventory_items
  SET    status    = 'available',
         is_listed = true
  WHERE  id IN (
    SELECT inventory_item_id
    FROM   order_items
    WHERE  order_id = p_order_id
  );

  IF v_offer_id IS NOT NULL THEN
    UPDATE storefront_offers
    SET    status = 'expired'
    WHERE  id = v_offer_id
      AND  status = 'accepted';
  END IF;
END;
$function$;

-- 4. Sweep: offer orders use their own deadline, others keep 30 minutes
CREATE OR REPLACE FUNCTION public.sweep_expired_pending_orders()
 RETURNS void
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO 'public'
AS $function$
DECLARE
  v_threshold  interval := '30 minutes';
  v_order_id   uuid;
  v_cancelled  int := 0;
  v_skipped    int := 0;
BEGIN
  FOR v_order_id IN
    SELECT id
    FROM   orders
    WHERE  status = 'pending_payment'
      AND  COALESCE(payment_due_at, created_at + v_threshold) < now()
    ORDER BY created_at
  LOOP
    BEGIN
      PERFORM cancel_pending_payment_order(v_order_id);
      v_cancelled := v_cancelled + 1;
    EXCEPTION
      WHEN OTHERS THEN
        RAISE WARNING '[sweep_expired_pending_orders] skipped order %: %',
          v_order_id, SQLERRM;
        v_skipped := v_skipped + 1;
    END;
  END LOOP;

  RAISE NOTICE '[sweep_expired_pending_orders] done: % cancelled, % skipped',
    v_cancelled, v_skipped;
END;
$function$;

COMMIT;