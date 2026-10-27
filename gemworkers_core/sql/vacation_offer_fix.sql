-- =============================================================================
-- GemWorkers — Fix: vacation-mode check broke every new offer
-- =============================================================================
-- NOT YET APPLIED
--
-- Found 2026-10-27 while rehearsing sql/one_currency_cleanup.sql: the shared
-- trigger function from sql/vacation_mode.sql reads NEW.sale_channel in one
-- IF, also on storefront_offers (which has no such column) → "record new has
-- no field sale_channel" on every offer since 2026-10-26. Live definition
-- copied; the orders-only check is now nested so it is only read for orders.
-- =============================================================================

BEGIN;

CREATE OR REPLACE FUNCTION public._refuse_vacation_seller()
 RETURNS trigger
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO 'public', 'pg_temp'
AS $function$
BEGIN
  -- Orders: only new store purchases (Buy now / cart). Accepted offers
  -- (offer_id set) and manual sales are allowed.
  IF TG_TABLE_NAME = 'orders' THEN
    IF NEW.sale_channel IS DISTINCT FROM 'platform' OR NEW.offer_id IS NOT NULL THEN
      RETURN NEW;
    END IF;
  END IF;
  IF EXISTS (SELECT 1 FROM sellers WHERE id = NEW.seller_id AND on_vacation) THEN
    RAISE EXCEPTION 'This stone isn''t available right now — please try again later.';
  END IF;
  RETURN NEW;
END;
$function$;
REVOKE ALL ON FUNCTION public._refuse_vacation_seller() FROM PUBLIC, anon, authenticated;

COMMIT;
