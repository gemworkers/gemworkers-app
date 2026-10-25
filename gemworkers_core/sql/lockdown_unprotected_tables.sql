-- =============================================================================
-- GemWorkers — SECURITY: lock tables that had no protection (RLS off)
-- =============================================================================
-- Applied to live DB 2026-10-25
--
-- Found 2026-10-25 in the system review: these public tables had row-level
-- security OFF, so anyone with the store's public (anon) key could read,
-- insert, change and delete rows through the API:
--   _backup_buyers, _backup_customers, _backup_inventory_items,
--   _backup_order_items, _backup_orders  (old test-data copies: names,
--                                         emails, shipping addresses)
--   sku_codes                             (gem → SKU code list used by
--                                         generate_sku when a stone is added)
--
-- Fix (nothing is deleted):
--   • backups: RLS on, no policies, all API access revoked → only reachable
--     from the Supabase SQL Editor. (Drop them in the pre-launch clean-up.)
--   • sku_codes: RLS on; staff (logged in) may READ (generate_sku runs as the
--     person adding the stone); only the owner may change the list.
-- =============================================================================

BEGIN;

DO $$
DECLARE t text;
BEGIN
  FOREACH t IN ARRAY ARRAY['_backup_buyers','_backup_customers','_backup_inventory_items','_backup_order_items','_backup_orders'] LOOP
    IF to_regclass('public.' || t) IS NOT NULL THEN
      EXECUTE format('ALTER TABLE public.%I ENABLE ROW LEVEL SECURITY', t);
      EXECUTE format('REVOKE ALL ON public.%I FROM anon, authenticated', t);
    END IF;
  END LOOP;
END $$;

ALTER TABLE public.sku_codes ENABLE ROW LEVEL SECURITY;
REVOKE ALL ON public.sku_codes FROM anon;
REVOKE INSERT, UPDATE, DELETE ON public.sku_codes FROM authenticated;
GRANT SELECT ON public.sku_codes TO authenticated;

DROP POLICY IF EXISTS sku_codes_staff_read ON public.sku_codes;
CREATE POLICY sku_codes_staff_read ON public.sku_codes
  FOR SELECT TO authenticated USING (true);

DROP POLICY IF EXISTS sku_codes_owner_write ON public.sku_codes;
CREATE POLICY sku_codes_owner_write ON public.sku_codes
  FOR ALL TO authenticated USING (public.is_owner()) WITH CHECK (public.is_owner());
GRANT INSERT, UPDATE, DELETE ON public.sku_codes TO authenticated;   -- policy limits it to the owner

COMMIT;

-- VERIFICATION (read-only):
--   SELECT relname, relrowsecurity FROM pg_class
--   WHERE relnamespace = 'public'::regnamespace AND relkind = 'r' AND NOT relrowsecurity;   -- expect none
