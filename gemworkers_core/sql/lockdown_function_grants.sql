-- =============================================================================
-- GemWorkers — SECURITY: who may call which database function
-- =============================================================================
-- Applied to live DB 2026-10-25
--
-- Found 2026-10-25 in the system review: several SECURITY DEFINER functions
-- could be called by ANYONE through the public API (anon key, no login) and
-- by any logged-in buyer, while they don't check the caller themselves:
--   confirm_order_paid / confirm_order_group   → mark an order paid without paying!
--   cancel_pending_payment_order / cancel_order_group → cancel other people's orders
--   sweep_expired_pending_orders               → run the 30-minute sweep
-- They are only meant for the Stripe webhook / store server (service role)
-- and pg_cron. Functions inside other SECURITY DEFINER functions keep working
-- (they run as the definer).
--
-- Also: buyer/staff actions need a login anyway, so "anon" loses EXECUTE on
-- them (they keep working for logged-in users, with their own checks inside).
-- tax_quote stays public (stone page for visitors).
-- =============================================================================

BEGIN;

-- Server / cron only.
DO $$
DECLARE f regprocedure;
BEGIN
  FOR f IN SELECT p.oid::regprocedure FROM pg_proc p
           WHERE p.pronamespace = 'public'::regnamespace
             AND p.proname IN ('confirm_order_paid','confirm_order_group',
                               'cancel_pending_payment_order','cancel_order_group',
                               'sweep_expired_pending_orders')
  LOOP
    EXECUTE format('REVOKE ALL ON FUNCTION %s FROM PUBLIC, anon, authenticated', f);
    EXECUTE format('GRANT EXECUTE ON FUNCTION %s TO service_role', f);
  END LOOP;
END $$;

-- Logged-in users only (each checks who is calling).
DO $$
DECLARE f regprocedure;
BEGIN
  FOR f IN SELECT p.oid::regprocedure FROM pg_proc p
           WHERE p.pronamespace = 'public'::regnamespace
             AND p.proname IN ('create_platform_order','submit_storefront_offer','respond_to_offer',
                               'mark_order_received','mark_order_shipped','mark_payout_paid',
                               'handle_sale_customer','generate_sku')
  LOOP
    EXECUTE format('REVOKE ALL ON FUNCTION %s FROM PUBLIC, anon', f);
    EXECUTE format('GRANT EXECUTE ON FUNCTION %s TO authenticated, service_role', f);
  END LOOP;
END $$;

-- Trigger functions: never called directly.
DO $$
DECLARE f regprocedure;
BEGIN
  FOR f IN SELECT p.oid::regprocedure FROM pg_proc p
           WHERE p.pronamespace = 'public'::regnamespace
             AND p.proname IN ('handle_new_buyer','set_order_paid_at','prevent_delete_pending_payment_order',
                               'update_updated_at_column','set_sku','_invoices_immutable','_makers_touch_updated_at')
  LOOP
    EXECUTE format('REVOKE ALL ON FUNCTION %s FROM PUBLIC, anon', f);
  END LOOP;
END $$;

COMMIT;

-- VERIFICATION (read-only): functions anyone can still call without logging in
--   SELECT proname FROM pg_proc WHERE pronamespace = 'public'::regnamespace
--     AND has_function_privilege('anon', oid, 'execute');
