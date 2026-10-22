-- =============================================================================
-- GemWorkers — Listing approval: sellers' new listings wait for the owner
-- =============================================================================
-- Applied to live DB 2026-10-22
--
-- 1. inventory_items.listing_requested_at — set when a seller asks to list a
--    stone; NULL otherwise. is_listed keeps its meaning ("live on the store"),
--    so every store view / function that checks is_listed is unchanged.
-- 2. Trigger inventory_listing_approval (BEFORE INSERT / UPDATE OF is_listed):
--      a seller's direct write (current_user = 'authenticated', not owner)
--      that turns is_listed false→true is turned into a request:
--        is_listed := false, listed_at := NULL, listing_requested_at := now()
--      Any row that ends up live (is_listed = true) has its request cleared.
--    SECURITY DEFINER functions (cancel_pending_payment_order putting a
--    released stone back on sale, webhooks, sweeps) run as the function owner,
--    not 'authenticated', so they are never turned into requests.
--    Edits to an already-live listing (price, shipping…) stay immediate.
--    Unlisting is always immediate.
-- 3. Owner approves by setting is_listed = true (request cleared by the
--    trigger); rejects by clearing listing_requested_at. Both from the admin.
--
-- Already-live seller listings are not touched.
-- Safe to re-run.
-- =============================================================================

BEGIN;

ALTER TABLE public.inventory_items
  ADD COLUMN IF NOT EXISTS listing_requested_at timestamptz;

CREATE INDEX IF NOT EXISTS idx_inventory_items_listing_requested
  ON public.inventory_items (listing_requested_at)
  WHERE listing_requested_at IS NOT NULL;

-- SECURITY INVOKER on purpose: current_user must be the caller's role.
CREATE OR REPLACE FUNCTION public._inventory_listing_approval()
RETURNS trigger
LANGUAGE plpgsql
SET search_path = public, pg_temp
AS $$
BEGIN
  IF current_user = 'authenticated'
     AND NEW.is_listed
     AND (TG_OP = 'INSERT' OR NOT COALESCE(OLD.is_listed, false))
     AND NOT public.is_owner() THEN
    NEW.is_listed            := false;
    NEW.listed_at            := NULL;
    NEW.listing_requested_at := now();
  END IF;

  IF NEW.is_listed THEN
    NEW.listing_requested_at := NULL;
  END IF;

  RETURN NEW;
END;
$$;

REVOKE ALL ON FUNCTION public._inventory_listing_approval() FROM PUBLIC, anon, authenticated;

DROP TRIGGER IF EXISTS inventory_listing_approval ON public.inventory_items;
CREATE TRIGGER inventory_listing_approval
  BEFORE INSERT OR UPDATE OF is_listed ON public.inventory_items
  FOR EACH ROW EXECUTE FUNCTION public._inventory_listing_approval();

COMMIT;


-- VERIFICATION (read-only):
--   SELECT tgname FROM pg_trigger WHERE tgrelid = 'public.inventory_items'::regclass;
--   SELECT count(*) FILTER (WHERE is_listed) AS live,
--          count(*) FILTER (WHERE listing_requested_at IS NOT NULL) AS waiting
--   FROM   public.inventory_items;
