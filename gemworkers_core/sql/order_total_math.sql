-- =============================================================================
-- GemWorkers — Order Total Math
-- =============================================================================
-- Records the real money breakdown on platform orders at the moment of sale.
-- Before this migration every platform order had order_total = item price and
-- commission_rate / commission_amount / seller_payout all hardcoded to 0.
--
-- After this migration:
--   order_total      = item_price + shipping          (what the buyer pays)
--   commission_rate  = seller's rate (or 0.10 default)
--   commission_amount = ROUND(item_price * rate, 2)  — item price ONLY
--   seller_payout    = order_total - commission_amount (seller keeps full shipping)
--   orders.shipping_cost = snapshot of item.shipping_cost at sale time
--
-- Three changes, all idempotent and safe on the live DB:
--   1. ADD COLUMN IF NOT EXISTS shipping_cost on orders.
--   2. CREATE OR REPLACE FUNCTION create_platform_order (money math added).
--   3. CREATE OR REPLACE FUNCTION respond_to_offer (accept path money math added;
--      decline path zero changes).
--
-- Uses CREATE OR REPLACE (not DROP + CREATE) so a failed apply leaves the
-- existing function callable.
-- =============================================================================


-- =============================================================================
-- 1. orders.shipping_cost — at-sale snapshot
-- =============================================================================
-- Nullable with no DEFAULT:
--   • All existing rows → NULL (pre-migration orders unaffected).
--   • Manual Flutter orders that don't go through these functions → NULL.
--   • Platform orders (buy-now and accepted offers) → set by the functions below.

ALTER TABLE public.orders
  ADD COLUMN IF NOT EXISTS shipping_cost numeric(10,2);


-- =============================================================================
-- 2. FUNCTION: create_platform_order (full rewrite — money math added)
-- =============================================================================
-- All existing behaviour is preserved verbatim:
--   a) FOR UPDATE row lock to prevent race.
--   b–f) Six validation RAISE EXCEPTION blocks unchanged.
--   g) Stone reservation UPDATE unchanged.
--   h) order_items INSERT: price_at_sale = item price (shipping is NOT a line item).
--
-- Added: wider opening SELECT (+shipping_cost, +seller commission_rate);
--        money variable block; populated orders INSERT columns.

CREATE OR REPLACE FUNCTION public.create_platform_order(p_inventory_item_id uuid)
RETURNS uuid
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
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
  -- a) Lock the row so a concurrent call on the same stone loses the race.
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

  -- b) Reserve the stone — takes it off-market immediately.
  UPDATE inventory_items
  SET    status = 'reserved'
  WHERE  id = p_inventory_item_id;

  -- Money math: commission on item price ONLY; seller keeps the full shipping amount.
  -- v_rate defaults to 10 % when the seller has no rate configured (mirrors Flutter
  -- listing sheet constant _kDefaultCommission = 0.10).
  v_item_price := v_item.selling_price;
  v_shipping   := COALESCE(v_item.shipping_cost, 0);
  v_total      := v_item_price + v_shipping;
  v_rate       := COALESCE(NULLIF(v_item.seller_commission_rate, 0), 0.10);
  v_commission := ROUND(v_item_price * v_rate, 2);
  v_payout     := v_total - v_commission;

  -- c) Create the order. order_number is auto-assigned by the ORD-XXXXX sequence.
  INSERT INTO orders (
    buyer_id,         seller_id,          sale_channel,
    status,           order_total,        shipping_cost,
    commission_rate,  commission_amount,  seller_payout
  )
  VALUES (
    auth.uid(),       v_item.seller_id,   'platform',
    'confirmed',      v_total,            v_shipping,
    v_rate,           v_commission,       v_payout
  )
  RETURNING id INTO v_order_id;

  -- d) Line item — price_at_sale locks the item price at this moment in time.
  --    Shipping is not a line item; it lives on orders.shipping_cost above.
  INSERT INTO order_items (order_id, inventory_item_id, price_at_sale, quantity)
  VALUES (v_order_id, p_inventory_item_id, v_item_price, 1);

  RETURN v_order_id;
END;
$$;

GRANT EXECUTE ON FUNCTION public.create_platform_order(uuid) TO authenticated;


-- =============================================================================
-- 3. FUNCTION: respond_to_offer (full rewrite — accept path money math added)
-- =============================================================================
-- All existing behaviour is preserved verbatim:
--   • Offer row lock (FOR UPDATE).
--   • IS DISTINCT FROM seller check (blocks buyers, owner, NULL callers).
--   • status = 'pending' check.
--   • DECLINE path: zero changes — returns early unchanged.
--   • ACCEPT path: item re-lock, availability check, reservation, order_items
--     INSERT, offer status update, auto-decline of all other pending offers.
--
-- Added (accept path only): shipping_cost read from item re-lock SELECT;
--   separate SELECT for seller commission_rate; money variable block;
--   populated orders INSERT columns.

CREATE OR REPLACE FUNCTION public.respond_to_offer(
  p_offer_id    uuid,
  p_action      text,
  p_seller_note text DEFAULT ''
)
RETURNS json
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
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
  IF p_action NOT IN ('accepted', 'declined') THEN
    RAISE EXCEPTION 'p_action must be ''accepted'' or ''declined''';
  END IF;

  -- Lock the offer row.
  SELECT o.id, o.buyer_id, o.inventory_item_id, o.seller_id,
         o.offered_price, o.status
  INTO   v_offer
  FROM   storefront_offers o
  WHERE  o.id = p_offer_id
  FOR UPDATE;

  IF NOT FOUND THEN
    RAISE EXCEPTION 'Offer not found';
  END IF;

  -- IS DISTINCT FROM handles the case where current_seller_id() returns NULL
  -- (buyer or owner calling this function), correctly blocking them.
  IF v_offer.seller_id IS DISTINCT FROM public.current_seller_id() THEN
    RAISE EXCEPTION 'This offer does not belong to your shop';
  END IF;

  IF v_offer.status <> 'pending' THEN
    RAISE EXCEPTION 'Offer is no longer pending (status: %)', v_offer.status;
  END IF;

  -- ── DECLINE ────────────────────────────────────────────────────────────────
  -- Zero changes from original.
  IF p_action = 'declined' THEN
    UPDATE storefront_offers
    SET    status = 'declined', responded_at = now(),
           seller_note = COALESCE(p_seller_note, '')
    WHERE  id = p_offer_id;

    RETURN json_build_object('offer_id', p_offer_id, 'order_id', null);
  END IF;

  -- ── ACCEPT ─────────────────────────────────────────────────────────────────

  -- a) Lock the inventory row. Also read shipping_cost for the order snapshot.
  SELECT id, status, shipping_cost
  INTO   v_item
  FROM   inventory_items
  WHERE  id = v_offer.inventory_item_id
  FOR UPDATE;

  IF v_item.status <> 'available' THEN
    RAISE EXCEPTION 'Item is no longer available (status: %)', v_item.status;
  END IF;

  -- Read the seller's commission rate. Denormalized seller_id on the offer row
  -- means no extra join is needed.
  SELECT commission_rate
  INTO   v_seller_commission_rate
  FROM   sellers
  WHERE  id = v_offer.seller_id;

  -- b) Reserve.
  UPDATE inventory_items
  SET    status = 'reserved'
  WHERE  id = v_offer.inventory_item_id;

  -- Money math: commission on offered price ONLY; seller keeps full shipping amount.
  -- v_rate defaults to 10 % when the seller has no rate configured.
  v_item_price := v_offer.offered_price;
  v_shipping   := COALESCE(v_item.shipping_cost, 0);
  v_total      := v_item_price + v_shipping;
  v_rate       := COALESCE(NULLIF(v_seller_commission_rate, 0), 0.10);
  v_commission := ROUND(v_item_price * v_rate, 2);
  v_payout     := v_total - v_commission;

  -- c) Create the order at the OFFERED price, not the asking price.
  INSERT INTO orders (
    buyer_id,         seller_id,          sale_channel,
    status,           order_total,        shipping_cost,
    commission_rate,  commission_amount,  seller_payout
  )
  VALUES (
    v_offer.buyer_id, v_offer.seller_id,  'platform',
    'confirmed',      v_total,            v_shipping,
    v_rate,           v_commission,       v_payout
  )
  RETURNING id INTO v_order_id;

  -- d) Line item — price_at_sale = the offered price (not the total).
  INSERT INTO order_items (order_id, inventory_item_id, price_at_sale, quantity)
  VALUES (v_order_id, v_offer.inventory_item_id, v_item_price, 1);

  -- e) Accept this offer.
  UPDATE storefront_offers
  SET    status = 'accepted', responded_at = now(),
         seller_note = COALESCE(p_seller_note, '')
  WHERE  id = p_offer_id;

  -- f) Auto-decline every other pending offer on the same stone — the stone
  --    is now reserved and cannot be sold to anyone else.
  UPDATE storefront_offers
  SET    status = 'declined', responded_at = now(),
         seller_note = 'Stone is no longer available'
  WHERE  inventory_item_id = v_offer.inventory_item_id
    AND  status            = 'pending'
    AND  id                <> p_offer_id;

  RETURN json_build_object('offer_id', p_offer_id, 'order_id', v_order_id);
END;
$$;

GRANT EXECUTE ON FUNCTION public.respond_to_offer(uuid, text, text) TO authenticated;
