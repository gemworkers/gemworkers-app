-- =============================================================================
-- GemWorkers — Sale Method Column
-- =============================================================================
-- Adds sale_method to inventory_items so sellers can choose how each listed
-- stone sells: fixed-price buy now, offer-only, or both.
--
-- Default 'buy_now': every currently-listed stone keeps its existing Buy Now
-- button on the storefront exactly as before. Fully backward-compatible —
-- no existing INSERT, UPDATE, or query needs to change.
--
-- CHECK constraint values:
--   'buy_now'        → buyer purchases at the listed selling_price
--   'accept_offers'  → buyer submits an offer; no fixed buy price shown
--   'both'           → buyer can buy at the listed price OR submit an offer
--
-- Price rule (UI-enforced, not a DB CHECK — matches existing selling_price pattern):
--   buy_now / both   → selling_price required (Flutter UI blocks listing without it)
--   accept_offers    → selling_price is optional / null
--
-- NOTE: The committed SECURITY DEFINER functions (create_platform_order,
-- submit_storefront_offer, respond_to_offer) do NOT yet enforce sale_method.
-- Enforcing sale_method server-side in submit_storefront_offer — blocking
-- offers on buy_now-only stones — is a FOLLOW-UP task for the offer UI step.
--
-- Idempotent: ADD COLUMN IF NOT EXISTS skips the column if already present.
-- =============================================================================

ALTER TABLE public.inventory_items
  ADD COLUMN IF NOT EXISTS sale_method text NOT NULL DEFAULT 'buy_now'
    CONSTRAINT inventory_items_sale_method_check
      CHECK (sale_method IN ('buy_now', 'accept_offers', 'both'));
