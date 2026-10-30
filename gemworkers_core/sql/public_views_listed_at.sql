-- =============================================================================
-- GemWorkers — Homepage: newest first + owner-picked Featured stones
-- =============================================================================
-- NOT YET APPLIED
--
-- Zakaria 2026-10-30: the hero / New arrivals showed stones in view order (new
-- listings did not come forward), and the new homepage gets a "Featured"
-- section the owner picks.
--   • inventory_items.is_featured (default false). Only the owner can change
--     it (trigger keeps the old value for anyone else — never an error, so a
--     seller's normal stone edit is unaffected).
--   • public_listings + public_listing_details: live definitions copied, TWO
--     columns appended at the end — listed_at (when listed, else when added)
--     and is_featured. Same rows, same grants, same filters.
-- =============================================================================

BEGIN;

ALTER TABLE public.inventory_items ADD COLUMN IF NOT EXISTS is_featured boolean NOT NULL DEFAULT false;

CREATE OR REPLACE FUNCTION public._inventory_featured_owner_only()
RETURNS trigger
LANGUAGE plpgsql
SET search_path = public, pg_temp
AS $$
BEGIN
  IF auth.uid() IS NULL OR public.is_owner() THEN
    RETURN NEW;
  END IF;
  IF TG_OP = 'INSERT' THEN
    NEW.is_featured := false;
  ELSE
    NEW.is_featured := OLD.is_featured;
  END IF;
  RETURN NEW;
END;
$$;
REVOKE ALL ON FUNCTION public._inventory_featured_owner_only() FROM PUBLIC, anon, authenticated;
DROP TRIGGER IF EXISTS inventory_featured_owner_only ON public.inventory_items;
CREATE TRIGGER inventory_featured_owner_only BEFORE INSERT OR UPDATE ON public.inventory_items
  FOR EACH ROW EXECUTE FUNCTION public._inventory_featured_owner_only();

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
    i.maker_id,
    COALESCE(i.listed_at, i.created_at) AS listed_at,
    i.is_featured
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
    i.diamond_declaration = ANY (ARRAY['conflict_free'::text, 'kimberley'::text]) AS conflict_free_diamond,
    COALESCE(i.listed_at, i.created_at) AS listed_at,
    i.is_featured
   FROM inventory_items i
     JOIN sellers s ON s.id = i.seller_id
     LEFT JOIN makers m ON m.id = i.maker_id
  WHERE i.is_listed = true AND (i.status = ANY (ARRAY['available'::text, 'reserved'::text])) AND s.status = 'active'::text AND (NOT s.on_vacation OR i.status = 'reserved'::text);

COMMIT;
