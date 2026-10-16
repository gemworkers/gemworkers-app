-- =============================================================================
-- GemWorkers — orders.stripe_checkout_session_id
-- =============================================================================
-- Already applied to live DB 2026-10-16.
--
-- Stores the most recent Stripe Checkout Session created for an order, so the
-- storefront can expire an earlier open session before creating a new one
-- (payAcceptedOffer: a buyer may click "Pay" several times within the 48 h
-- offer payment window — without this, two open sessions could both be paid).
--
-- Written only by the storefront server (service-role admin client), with a
-- compare-and-set on the previous value so two concurrent clicks cannot both
-- succeed. Buyers keep SELECT-only access via orders_buyer_select; no new
-- policy is needed.
--
-- Additive + idempotent: nullable column, no default, existing rows unaffected.
-- =============================================================================

ALTER TABLE public.orders
  ADD COLUMN IF NOT EXISTS stripe_checkout_session_id text;

COMMENT ON COLUMN public.orders.stripe_checkout_session_id IS
  'Latest Stripe Checkout Session id for this order (set by the storefront when '
  'creating a session; used to expire a previous open session). NULL if none.';


-- =============================================================================
-- VERIFICATION (read-only)
-- =============================================================================
--   SELECT column_name, data_type, is_nullable
--   FROM   information_schema.columns
--   WHERE  table_schema = 'public' AND table_name = 'orders'
--     AND  column_name = 'stripe_checkout_session_id';
