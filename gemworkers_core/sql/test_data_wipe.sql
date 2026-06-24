-- =============================================================================
-- TEST DATA WIPE
-- =============================================================================
-- Purpose : Delete ALL transactional and inventory test data in one atomic
--           operation. If any statement fails the entire transaction is rolled
--           back — nothing is deleted.
--
-- DELETES (all rows, no WHERE):
--   1.  order_items          – references orders + inventory_items
--   2.  storefront_cart      – references inventory_items
--   3.  storefront_offers    – references inventory_items
--   4.  product_media        – references inventory_items
--   5.  inventory_movements  – references inventory_items
--   6.  item_movements       – references inventory_items
--   7.  marketplace_listings – references inventory_items
--   8.  purchase_items       – references purchases
--   9.  purchases            – safe once purchase_items gone
--   10. orders               – safe once order_items gone
--   11. inventory_items      – self-ref (parent_lot_id) nulled first,
--                              then all other FK refs are gone
--
-- PRESERVES (not touched):
--   sellers, buyers, auth.users, suppliers, locations, branches,
--   product_types, sale_method config, and all RLS/function objects.
--
-- Repo scan result: no additional tables with FK → inventory_items or orders
-- were found beyond the eleven listed above. The list is complete per the repo.
--
-- HOW TO RUN:
--   Paste into the Supabase SQL Editor and execute. Review the output before
--   committing. Do NOT run on production data.
-- =============================================================================

BEGIN;

-- 1. order_items
--    Must go first: FK to inventory_items is RESTRICT — it blocks the
--    inventory_items delete. Also cascades naturally from orders, but we
--    delete explicitly to keep the order deterministic.
DELETE FROM public.order_items;

-- 2. storefront_cart
DELETE FROM public.storefront_cart;

-- 3. storefront_offers
DELETE FROM public.storefront_offers;

-- 4. product_media
DELETE FROM public.product_media;

-- 5. inventory_movements
DELETE FROM public.inventory_movements;

-- 6. item_movements
DELETE FROM public.item_movements;

-- 7. marketplace_listings
DELETE FROM public.marketplace_listings;

-- 8. purchase_items
--    References purchases (ON DELETE CASCADE), not inventory_items directly.
DELETE FROM public.purchase_items;

-- 9. purchases
--    Safe now that purchase_items is gone.
DELETE FROM public.purchases;

-- 10. orders
--     Safe now that order_items is gone.
DELETE FROM public.orders;

-- 11. inventory_items
--     Step A: break the self-reference (parent_lot_id → inventory_items.id)
--     so no row blocks another during the delete.
UPDATE public.inventory_items SET parent_lot_id = NULL;
--     Step B: all external FKs are now gone — delete every row.
DELETE FROM public.inventory_items;

COMMIT;
