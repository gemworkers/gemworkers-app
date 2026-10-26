-- =============================================================================
-- GemWorkers — Vacation mode for sellers (like Etsy's)
-- =============================================================================
-- Applied to live DB 2026-10-26
--
-- Zakaria 2026-10-26. A seller (or the owner for any seller) switches vacation
-- mode on, optionally with a return date:
--   • their stones disappear from the shop (public_listings / public_listing_details
--     get one extra condition; columns unchanged). A RESERVED stone stays visible
--     on its own page, so a buyer whose offer was accepted can still pay.
--   • new Buy now / cart orders and new offers on their stones are refused
--     (trigger, the payment functions themselves are not changed).
--   • orders already paid must still be shipped; messages still arrive.
--   • on the return date it switches off by itself (daily job).
-- Listings, prices and photos are untouched: switching off brings everything back.
-- =============================================================================

BEGIN;

ALTER TABLE public.sellers
  ADD COLUMN IF NOT EXISTS on_vacation    boolean NOT NULL DEFAULT false,
  ADD COLUMN IF NOT EXISTS vacation_until date;

CREATE OR REPLACE FUNCTION public.set_seller_vacation(p_on boolean, p_until date DEFAULT NULL, p_seller uuid DEFAULT NULL)
RETURNS void
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public, pg_temp
AS $$
DECLARE
  v_seller uuid := CASE WHEN public.is_owner() THEN coalesce(p_seller, public.current_seller_id())
                        ELSE public.current_seller_id() END;
BEGIN
  IF v_seller IS NULL THEN RAISE EXCEPTION 'Not allowed'; END IF;
  IF NOT public.is_owner() AND p_seller IS NOT NULL AND p_seller IS DISTINCT FROM v_seller THEN
    RAISE EXCEPTION 'Not allowed';
  END IF;
  IF p_on AND p_until IS NOT NULL AND p_until < (now() AT TIME ZONE 'Europe/Amsterdam')::date THEN
    RAISE EXCEPTION 'The return date is in the past';
  END IF;
  UPDATE sellers
  SET    on_vacation = p_on,
         vacation_until = CASE WHEN p_on THEN p_until END
  WHERE  id = v_seller;
END;
$$;
REVOKE ALL ON FUNCTION public.set_seller_vacation(boolean, date, uuid) FROM PUBLIC, anon;
GRANT EXECUTE ON FUNCTION public.set_seller_vacation(boolean, date, uuid) TO authenticated;

-- ── New purchases / offers refused while the seller is away ─────────────────
CREATE OR REPLACE FUNCTION public._refuse_vacation_seller()
RETURNS trigger
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public, pg_temp
AS $$
BEGIN
  -- Orders: only new store purchases (Buy now / cart). Accepted offers
  -- (offer_id set) and manual sales are allowed.
  IF TG_TABLE_NAME = 'orders' AND (NEW.sale_channel IS DISTINCT FROM 'platform' OR NEW.offer_id IS NOT NULL) THEN
    RETURN NEW;
  END IF;
  IF EXISTS (SELECT 1 FROM sellers WHERE id = NEW.seller_id AND on_vacation) THEN
    RAISE EXCEPTION 'This stone isn''t available right now — please try again later.';
  END IF;
  RETURN NEW;
END;
$$;
REVOKE ALL ON FUNCTION public._refuse_vacation_seller() FROM PUBLIC, anon, authenticated;

DROP TRIGGER IF EXISTS orders_vacation_seller ON public.orders;
CREATE TRIGGER orders_vacation_seller BEFORE INSERT ON public.orders
  FOR EACH ROW EXECUTE FUNCTION public._refuse_vacation_seller();
DROP TRIGGER IF EXISTS offers_vacation_seller ON public.storefront_offers;
CREATE TRIGGER offers_vacation_seller BEFORE INSERT ON public.storefront_offers
  FOR EACH ROW EXECUTE FUNCTION public._refuse_vacation_seller();

-- ── Hide their stones in the shop (live definitions + one condition) ────────
CREATE OR REPLACE VIEW public.public_listings AS
SELECT i.id,
    i.title,
    i.gem_type,
    i.variety,
    i.weight_value,
    i.weight_unit,
    i.origin_country,
    i.selling_price,
    i.image_urls ->> 0 AS image_url,
    i.sale_method,
    i.shipping_cost,
    s.country AS seller_country,
    i.product_type,
    i.maker_id
   FROM inventory_items i
     JOIN sellers s ON s.id = i.seller_id
  WHERE i.is_listed = true AND i.status = 'available'::text AND s.status = 'active'::text AND NOT s.on_vacation;

CREATE OR REPLACE VIEW public.public_listing_details AS
SELECT i.id,
    i.title,
    i.product_type,
    i.selling_price,
    i.description,
    i.image_urls,
    i.video_url,
    i.certification_lab,
    i.certification_number,
    i.treatment,
    i.dimensions_mm,
    i.length,
    i.width,
    i.height,
    i.dimension_unit,
    i.gem_type,
    i.variety,
    i.origin_country,
    i.origin_region,
    i.shape,
    i.cut_type,
    i.cut,
    i.clarity,
    i.weight_value,
    i.weight_unit,
    i.species,
    i.locality,
    i.matrix,
    i.weight_grams,
    i.weight_grams_unit,
    i.jewelry_type,
    i.metal,
    i.metal_purity,
    i.size_or_length,
    i.gemstones_used,
    i.total_weight_grams,
    i.total_weight_grams_unit,
    i.sale_method,
    i.courier,
    i.shipping_cost,
    i.delivery_days_min,
    i.delivery_days_max,
    i.prep_days,
    s.country AS seller_country,
    i.status,
    i.maker_id,
    m.name AS maker_name,
    m.place AS maker_place,
    i.cites_declaration = 'permit'::text AS export_permit,
    i.diamond_declaration = ANY (ARRAY['conflict_free'::text, 'kimberley'::text]) AS conflict_free_diamond
   FROM inventory_items i
     JOIN sellers s ON s.id = i.seller_id
     LEFT JOIN makers m ON m.id = i.maker_id
  WHERE i.is_listed = true AND (i.status = ANY (ARRAY['available'::text, 'reserved'::text])) AND s.status = 'active'::text AND (NOT s.on_vacation OR i.status = 'reserved'::text);

-- ── Back from vacation on the return date ───────────────────────────────────
SELECT cron.unschedule('gemworkers_vacation_end')
WHERE EXISTS (SELECT 1 FROM cron.job WHERE jobname = 'gemworkers_vacation_end');
SELECT cron.schedule('gemworkers_vacation_end', '5 0 * * *',
  $c$UPDATE public.sellers SET on_vacation = false, vacation_until = NULL
     WHERE on_vacation AND vacation_until IS NOT NULL
       AND vacation_until <= (now() AT TIME ZONE 'Europe/Amsterdam')::date$c$);

COMMIT;
