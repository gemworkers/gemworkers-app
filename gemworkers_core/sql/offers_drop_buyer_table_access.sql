-- =============================================================================
-- GemWorkers — Offers: remove buyers' direct table access (plan step 12, B)
-- =============================================================================
-- Applied to live DB 2026-10-22
--
-- Buyers could SELECT whole storefront_offers rows (incl. seller_note and
-- seller_id) and UPDATE their pending offer directly. The store now reads
-- public.buyer_offers and withdraws via public.withdraw_offer() (part A,
-- deployed 2026-10-22), so both buyer policies go. Seller + owner policies
-- (offers_seller_select, offers_owner) are untouched; all buyer writes go
-- through SECURITY DEFINER functions (submit_storefront_offer,
-- respond_to_counter, withdraw_offer).
-- =============================================================================

BEGIN;

DROP POLICY IF EXISTS offers_buyer_select ON public.storefront_offers;
DROP POLICY IF EXISTS offers_buyer_update ON public.storefront_offers;

COMMIT;


-- VERIFICATION (read-only) — expect only offers_owner + offers_seller_select:
--   SELECT policyname FROM pg_policies WHERE tablename = 'storefront_offers';
