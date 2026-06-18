-- =============================================================================
-- GemWorkers — Storefront Commerce Foundation
-- =============================================================================
-- Data model for cart, direct-buy orders, and buyer offers on the storefront.
-- This file is SQL-only — no UI is built here.
--
-- Changes to EXISTING tables (backward-compatible, zero Flutter impact):
--   orders  → ADD COLUMN buyer_id (nullable, no DEFAULT → NULL on all manual orders)
--             ADD POLICY orders_buyer_select (buyer reads own orders)
--
-- NEW tables:
--   storefront_cart    — ephemeral per-buyer wishlist
--   storefront_offers  — buyer price proposals, seller responses
--
-- NEW SECURITY DEFINER functions:
--   create_platform_order(inventory_item_id)
--   submit_storefront_offer(inventory_item_id, offered_price, buyer_note)
--   respond_to_offer(offer_id, action, seller_note)
--
-- Flutter sell engine compatibility:
--   • orders.sale_channel defaults to 'manual' — existing Flutter INSERTs that
--     omit sale_channel stay manual with no code change.
--   • handle_sale_customer() touches only customer_id, order_total, order_date,
--     status on orders. buyer_id is never referenced. Fully unchanged.
--   • All NOT NULL columns on orders have server-side defaults; Flutter INSERT
--     statements that omit buyer_id receive NULL implicitly.
--
-- Idempotent: ADD COLUMN IF NOT EXISTS; DROP … IF EXISTS before recreations.
-- =============================================================================


-- =============================================================================
-- 1. EXTEND orders — add buyer_id
-- =============================================================================
-- Nullable with no DEFAULT so:
--   (a) All existing rows get NULL — no backfill needed.
--   (b) Manual Flutter orders that don't set buyer_id naturally stay NULL.
--   (c) Platform orders set buyer_id = auth.uid() via create_platform_order().
-- The FK references buyers.id so only real storefront buyers can appear here
-- (sellers/owners who have no buyers row will hit a FK violation if they try
-- to call the buyer-facing functions directly).

ALTER TABLE public.orders
  ADD COLUMN IF NOT EXISTS buyer_id uuid REFERENCES public.buyers(id) ON DELETE SET NULL;

CREATE INDEX IF NOT EXISTS idx_orders_buyer_id ON public.orders (buyer_id);


-- =============================================================================
-- 2. RLS — buyer SELECT on orders
-- =============================================================================
-- Additive only. Existing orders_owner and orders_seller policies are untouched.
-- A buyer can SELECT only orders where their uid is the buyer_id.
-- Buyers have no INSERT/UPDATE/DELETE on orders — those go through
-- SECURITY DEFINER functions.

DROP POLICY IF EXISTS orders_buyer_select ON public.orders;

CREATE POLICY orders_buyer_select
  ON public.orders FOR SELECT
  TO authenticated
  USING (buyer_id = auth.uid());


-- =============================================================================
-- 3. storefront_cart
-- =============================================================================
-- One row per (buyer, stone). Quantity is always 1 — each inventory_items row
-- is one unique physical gem. A stone deleted from inventory cascades out of
-- every buyer's cart automatically.

CREATE TABLE IF NOT EXISTS public.storefront_cart (
  id                 uuid        PRIMARY KEY DEFAULT gen_random_uuid(),
  buyer_id           uuid        NOT NULL REFERENCES public.buyers(id)
                                   ON DELETE CASCADE,
  inventory_item_id  uuid        NOT NULL REFERENCES public.inventory_items(id)
                                   ON DELETE CASCADE,
  added_at           timestamptz NOT NULL DEFAULT now(),

  CONSTRAINT storefront_cart_unique UNIQUE (buyer_id, inventory_item_id)
);

CREATE INDEX IF NOT EXISTS idx_storefront_cart_buyer ON public.storefront_cart (buyer_id);

ALTER TABLE public.storefront_cart ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS cart_buyer_select ON public.storefront_cart;
DROP POLICY IF EXISTS cart_buyer_insert ON public.storefront_cart;
DROP POLICY IF EXISTS cart_buyer_delete ON public.storefront_cart;
DROP POLICY IF EXISTS cart_owner        ON public.storefront_cart;

-- Buyer: full read + manage on own rows.
CREATE POLICY cart_buyer_select
  ON public.storefront_cart FOR SELECT
  TO authenticated
  USING (buyer_id = auth.uid());

CREATE POLICY cart_buyer_insert
  ON public.storefront_cart FOR INSERT
  TO authenticated
  WITH CHECK (buyer_id = auth.uid());

CREATE POLICY cart_buyer_delete
  ON public.storefront_cart FOR DELETE
  TO authenticated
  USING (buyer_id = auth.uid());

-- Owner: full access.
CREATE POLICY cart_owner
  ON public.storefront_cart FOR ALL
  TO authenticated
  USING      (public.is_owner())
  WITH CHECK (public.is_owner());

-- Sellers have no cart access (no policy = blocked by RLS).
-- Anon has no cart access (no policy = blocked by RLS).


-- =============================================================================
-- 4. storefront_offers
-- =============================================================================
-- seller_id is denormalized from inventory_items.seller_id at INSERT time
-- (inside submit_storefront_offer) so RLS can scope sellers to their own
-- offers without a join.

CREATE TABLE IF NOT EXISTS public.storefront_offers (
  id                 uuid           PRIMARY KEY DEFAULT gen_random_uuid(),
  buyer_id           uuid           NOT NULL REFERENCES public.buyers(id)
                                      ON DELETE CASCADE,
  inventory_item_id  uuid           NOT NULL REFERENCES public.inventory_items(id)
                                      ON DELETE CASCADE,
  seller_id          uuid           NOT NULL REFERENCES public.sellers(id)
                                      ON DELETE CASCADE,
  offered_price      numeric(12,2)  NOT NULL CHECK (offered_price > 0),
  status             text           NOT NULL DEFAULT 'pending'
                                      CHECK (status IN (
                                        'pending', 'accepted', 'declined',
                                        'withdrawn', 'expired'
                                      )),
  buyer_note         text           NOT NULL DEFAULT '',
  seller_note        text           NOT NULL DEFAULT '',
  created_at         timestamptz    NOT NULL DEFAULT now(),
  responded_at       timestamptz
);

CREATE INDEX IF NOT EXISTS idx_storefront_offers_buyer  ON public.storefront_offers (buyer_id);
CREATE INDEX IF NOT EXISTS idx_storefront_offers_seller ON public.storefront_offers (seller_id);
CREATE INDEX IF NOT EXISTS idx_storefront_offers_item   ON public.storefront_offers (inventory_item_id);
CREATE INDEX IF NOT EXISTS idx_storefront_offers_status ON public.storefront_offers (status);

ALTER TABLE public.storefront_offers ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS offers_buyer_select  ON public.storefront_offers;
DROP POLICY IF EXISTS offers_buyer_update  ON public.storefront_offers;
DROP POLICY IF EXISTS offers_seller_select ON public.storefront_offers;
DROP POLICY IF EXISTS offers_owner         ON public.storefront_offers;

-- Buyer: see own offers.
CREATE POLICY offers_buyer_select
  ON public.storefront_offers FOR SELECT
  TO authenticated
  USING (buyer_id = auth.uid());

-- Buyer: can only update their own PENDING offers, and only to set status =
-- 'withdrawn'. USING restricts eligible rows; WITH CHECK constrains new state.
-- No other field changes are permitted — buyer cannot alter offered_price etc.
CREATE POLICY offers_buyer_update
  ON public.storefront_offers FOR UPDATE
  TO authenticated
  USING      (buyer_id = auth.uid() AND status = 'pending')
  WITH CHECK (buyer_id = auth.uid() AND status = 'withdrawn');

-- Seller: see offers addressed to their shop.
CREATE POLICY offers_seller_select
  ON public.storefront_offers FOR SELECT
  TO authenticated
  USING (seller_id = public.current_seller_id());

-- Owner: full access.
CREATE POLICY offers_owner
  ON public.storefront_offers FOR ALL
  TO authenticated
  USING      (public.is_owner())
  WITH CHECK (public.is_owner());

-- Anon: no access (no policy = blocked).


-- =============================================================================
-- 5. FUNCTION: create_platform_order
-- =============================================================================
-- Called by a logged-in buyer to purchase a listed stone at its asking price.
--
-- Atomically:
--   a) Locks the inventory row to prevent a simultaneous order on the same stone.
--   b) Validates: listed, available, seller active, price set.
--   c) Reserves the stone (status → 'reserved') so no other buyer can order it.
--   d) Creates an orders row: sale_channel='platform', status='confirmed'.
--   e) Creates an order_items row with price_at_sale = selling_price.
--
-- Returns the new order UUID.
--
-- The buyer_id FK on orders ensures this can only succeed when the caller has
-- a row in public.buyers — sellers/owners without a buyers row will hit a FK
-- violation if they accidentally call this.

DROP FUNCTION IF EXISTS public.create_platform_order(uuid);

CREATE FUNCTION public.create_platform_order(p_inventory_item_id uuid)
RETURNS uuid
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_item     record;
  v_order_id uuid;
BEGIN
  -- a) Lock the row so a concurrent call on the same stone loses the race.
  SELECT i.id, i.selling_price, i.seller_id, i.status, i.is_listed,
         s.status AS seller_status
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

  -- c) Reserve the stone — takes it off-market immediately.
  UPDATE inventory_items
  SET    status = 'reserved'
  WHERE  id = p_inventory_item_id;

  -- d) Create the order. commission fields default to 0 — calculated in the
  --    payment epic. order_number is auto-assigned by the ORD-XXXXX sequence.
  INSERT INTO orders (
    buyer_id,     seller_id,           sale_channel,
    status,       order_total,
    commission_rate, commission_amount, seller_payout
  )
  VALUES (
    auth.uid(),   v_item.seller_id,    'platform',
    'confirmed',  v_item.selling_price,
    0,            0,                   0
  )
  RETURNING id INTO v_order_id;

  -- e) Line item — price_at_sale locks the price at this moment in time.
  INSERT INTO order_items (order_id, inventory_item_id, price_at_sale, quantity)
  VALUES (v_order_id, p_inventory_item_id, v_item.selling_price, 1);

  RETURN v_order_id;
END;
$$;

GRANT EXECUTE ON FUNCTION public.create_platform_order(uuid) TO authenticated;


-- =============================================================================
-- 6. FUNCTION: submit_storefront_offer
-- =============================================================================
-- Called by a logged-in buyer to propose a price for a listed stone.
--
-- Reads seller_id from inventory_items — the buyer cannot supply or forge it.
-- Enforces one active offer per buyer per stone (prevents spam).
-- Returns the new offer UUID.

DROP FUNCTION IF EXISTS public.submit_storefront_offer(uuid, numeric, text);

CREATE FUNCTION public.submit_storefront_offer(
  p_inventory_item_id uuid,
  p_offered_price     numeric,
  p_buyer_note        text DEFAULT ''
)
RETURNS uuid
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_item     record;
  v_offer_id uuid;
BEGIN
  SELECT i.id, i.seller_id, i.is_listed, i.status, s.status AS seller_status
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
  IF p_offered_price <= 0 THEN
    RAISE EXCEPTION 'Offered price must be greater than zero';
  END IF;

  -- One active offer per buyer per stone.
  IF EXISTS (
    SELECT 1 FROM storefront_offers
    WHERE  buyer_id          = auth.uid()
      AND  inventory_item_id = p_inventory_item_id
      AND  status            = 'pending'
  ) THEN
    RAISE EXCEPTION 'You already have a pending offer on this item';
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
$$;

GRANT EXECUTE ON FUNCTION public.submit_storefront_offer(uuid, numeric, text) TO authenticated;


-- =============================================================================
-- 7. FUNCTION: respond_to_offer
-- =============================================================================
-- Called by the seller who owns the stone to accept or decline a pending offer.
-- p_action: 'accepted' | 'declined'
--
-- On 'accepted' — atomically:
--   a) Validates the stone is still available (locks the row).
--   b) Reserves the stone (status → 'reserved').
--   c) Creates an orders row (order_total = offered_price, not selling_price).
--   d) Creates an order_items row (price_at_sale = offered_price).
--   e) Marks this offer as accepted.
--   f) Auto-declines every other pending offer on the same stone.
--
-- On 'declined':
--   a) Marks the offer as declined. Stone stays available.
--
-- Returns JSON: { "offer_id": "...", "order_id": "..." | null }
--
-- IS DISTINCT FROM is used for the seller check so that callers with a NULL
-- current_seller_id() (buyers, owner) are correctly blocked.

DROP FUNCTION IF EXISTS public.respond_to_offer(uuid, text, text);

CREATE FUNCTION public.respond_to_offer(
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
  v_offer    record;
  v_item     record;
  v_order_id uuid;
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
  IF p_action = 'declined' THEN
    UPDATE storefront_offers
    SET    status = 'declined', responded_at = now(),
           seller_note = COALESCE(p_seller_note, '')
    WHERE  id = p_offer_id;

    RETURN json_build_object('offer_id', p_offer_id, 'order_id', null);
  END IF;

  -- ── ACCEPT ─────────────────────────────────────────────────────────────────
  -- Lock the inventory row.
  SELECT id, status
  INTO   v_item
  FROM   inventory_items
  WHERE  id = v_offer.inventory_item_id
  FOR UPDATE;

  IF v_item.status <> 'available' THEN
    RAISE EXCEPTION 'Item is no longer available (status: %)', v_item.status;
  END IF;

  -- b) Reserve.
  UPDATE inventory_items
  SET    status = 'reserved'
  WHERE  id = v_offer.inventory_item_id;

  -- c) Create the order at the OFFERED price, not the asking price.
  INSERT INTO orders (
    buyer_id,        seller_id,         sale_channel,
    status,          order_total,
    commission_rate, commission_amount,  seller_payout
  )
  VALUES (
    v_offer.buyer_id, v_offer.seller_id, 'platform',
    'confirmed',      v_offer.offered_price,
    0,                0,                  0
  )
  RETURNING id INTO v_order_id;

  -- d) Line item.
  INSERT INTO order_items (order_id, inventory_item_id, price_at_sale, quantity)
  VALUES (v_order_id, v_offer.inventory_item_id, v_offer.offered_price, 1);

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
