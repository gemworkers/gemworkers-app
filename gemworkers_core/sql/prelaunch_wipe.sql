-- =============================================================================
-- GemWorkers — Pre-launch test-data wipe (run ONCE, right before going live)
-- =============================================================================
-- NOT YET APPLIED
--
-- Zakaria 2026-10-28: delete all test activity, all 12 test stones, the test
-- sellers (Testseller, GW1-Thailand, GemWorkers Thailand — re-invited later)
-- and the test buyer accounts. KEPT: the owner login, Zakaria's own test buyer
-- (printforzakaria…, used by the money practice tests), seller "My Shop"
-- (= GemWorkers itself), all settings (tax rules, countries, routes, company
-- details, store_settings, seller terms texts, makers, My Shop's locations,
-- suppliers, SKU codes), Zakaria's own confirmed newsletter sign-up.
-- Counters reset: first real invoice GW-2026-00001, first payout PO-2026-0001,
-- first order ORD-00001.
-- The weekly iCloud backup (2026-10-28) still holds the old data if anything
-- is ever needed again. Photos/videos in Storage are NOT deleted here (remove
-- them in Supabase → Storage if wanted; they are no longer linked).
-- All in one transaction: if anything fails, nothing is deleted.
-- =============================================================================

BEGIN;

-- Safety: the two logins we keep must exist, or stop.
DO $guard$
BEGIN
  IF (SELECT count(*) FROM auth.users WHERE id IN (
        'feb102da-a9b4-4054-83e1-95985f8caf1e',     -- owner
        'bcefea86-26ee-4296-8ab4-0cbd7c7e298f')) <> 2  -- Zakaria's test buyer
  THEN RAISE EXCEPTION 'Wipe stopped: the owner or test buyer login is missing.'; END IF;
END
$guard$;

-- The two delete-blocking rules, off for this transaction only.
ALTER TABLE public.invoices DISABLE TRIGGER invoices_immutable;
ALTER TABLE public.orders   DISABLE TRIGGER orders_no_delete_pending_payment;

-- Money records (children first).
DELETE FROM public.invoices;
DELETE FROM public.owner_charges;
DELETE FROM public.order_refunds;
DELETE FROM public.returns;
DELETE FROM public.reviews;
DELETE FROM public.orders;            -- order_items go with them
DELETE FROM public.payouts;

-- Offers, messages, carts, favourites, statistics.
DELETE FROM public.storefront_offers;
DELETE FROM public.conversations;     -- messages go with them
DELETE FROM public.storefront_cart;
DELETE FROM public.favourites;
DELETE FROM public.page_views;
DELETE FROM public.app_errors;
DELETE FROM public.saved_replies;

-- Stones and the test consignment owner.
DELETE FROM public.inventory_items;   -- item movements go with them
DELETE FROM public.consignors;

-- Test sellers (their locations go with them) and their terms agreements.
DELETE FROM public.seller_terms_acceptances;
DELETE FROM public.sellers WHERE id <> 'a0000000-0000-0000-0000-000000000001';   -- keep My Shop

-- Test logins (buyer rows, business details and profiles go with them).
DELETE FROM auth.users
WHERE  id IN ('4ec68d5f-cbee-42c4-8ecd-d3805d66b78a', '196f0516-5097-4f51-90b5-f36138e448ee',
              '86562d8a-972b-4207-921f-3b8c1470d66e', 'af29e82c-45c5-4774-a261-68d814aa9c86',
              'f79ba266-0fe6-44f6-aefb-f00ffaf3dd70', '995ffa01-6609-4207-a15a-a9f4e495173b',
              'c9435c98-7604-4d8c-a3d4-e7829c165241')
  AND  id NOT IN ('feb102da-a9b4-4054-83e1-95985f8caf1e', 'bcefea86-26ee-4296-8ab4-0cbd7c7e298f');

-- Counters back to the start.
DELETE FROM public.invoice_counters;
DELETE FROM public.payout_counters;
SELECT setval('public.order_number_seq', 1, false);
SELECT setval('public.page_views_id_seq', 1, false);
SELECT setval('public.app_errors_id_seq', 1, false);

ALTER TABLE public.invoices ENABLE TRIGGER invoices_immutable;
ALTER TABLE public.orders   ENABLE TRIGGER orders_no_delete_pending_payment;

-- What is left (shown in the SQL editor).
SELECT (SELECT count(*) FROM public.orders)            AS orders,
       (SELECT count(*) FROM public.invoices)          AS invoices,
       (SELECT count(*) FROM public.inventory_items)   AS stones,
       (SELECT count(*) FROM public.sellers)           AS sellers,
       (SELECT count(*) FROM auth.users)               AS logins,
       (SELECT count(*) FROM public.tax_rules)         AS tax_rules,
       (SELECT count(*) FROM public.newsletter_subscribers) AS subscribers;

COMMIT;
