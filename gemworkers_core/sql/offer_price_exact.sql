-- =============================================================================
-- GemWorkers — Offer Price Exactness
-- =============================================================================
-- Applied to live DB 2026-10-21
--
-- Rejects offers with more than 2 decimal places in submit_storefront_offer,
-- so a buyer's amount is never silently rounded.
--
-- This is a full CREATE OR REPLACE copied exactly from the live version
-- (offer_sale_method_guard.sql). The only addition is the
-- p_offered_price <> round(p_offered_price, 2) guard, placed right after the
-- "greater than zero" check.
--
-- Idempotent: CREATE OR REPLACE — safe to run on the live DB at any time.
-- =============================================================================

CREATE OR REPLACE FUNCTION public.submit_storefront_offer(
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

  -- ── NEW: reject offers on buy_now-only stones ───────────────────────────
  IF v_item.sale_method = 'buy_now' THEN
    RAISE EXCEPTION 'This item is not accepting offers';
  END IF;
  -- ────────────────────────────────────────────────────────────────────────

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
