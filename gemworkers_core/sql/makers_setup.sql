-- =============================================================================
-- GemWorkers — Maker credit (cutters / jewellers / collectors)
-- =============================================================================
-- Applied to live DB 2026-10-22
--
-- Decisions: optional on every item (unknown → nothing shown); wording by
-- product_type in the apps ("Cut by" loose stone, "Made by" jewelry,
-- "Collected by" specimen); owner-only maker list; public profiles on the
-- store's Makers page. A maker is a craftsperson, never a seller — the store
-- still shows no seller identity.
--
-- 1. public.makers — name, place ("Chanthaburi, Thailand"), story, photo_url.
--    RLS: everyone may read (public profiles); only the owner writes.
-- 2. inventory_items.maker_id → makers (ON DELETE SET NULL).
--    Guard trigger: only the owner may set or change maker_id (sellers can
--    still edit everything else on their stones). Service role / SQL editor
--    (auth.uid() IS NULL) is allowed.
-- 3. Public views — LIVE definitions copied, columns appended only:
--      public_listing_details + maker_id, maker_name, maker_place
--      public_listings        + maker_id   (Makers page: "their stones")
--
-- Safe to re-run: one transaction, IF NOT EXISTS / CREATE OR REPLACE.
-- =============================================================================

BEGIN;

-- ── 1. makers ───────────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS public.makers (
  id          uuid        PRIMARY KEY DEFAULT gen_random_uuid(),
  name        text        NOT NULL CHECK (char_length(btrim(name)) BETWEEN 1 AND 80),
  place       text        CHECK (place IS NULL OR char_length(place) <= 120),
  story       text        CHECK (story IS NULL OR char_length(story) <= 4000),
  photo_url   text,
  created_at  timestamptz NOT NULL DEFAULT now(),
  updated_at  timestamptz NOT NULL DEFAULT now()
);

ALTER TABLE public.makers ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS makers_public_read ON public.makers;
DROP POLICY IF EXISTS makers_owner       ON public.makers;

CREATE POLICY makers_public_read
  ON public.makers FOR SELECT
  TO anon, authenticated
  USING (true);

CREATE POLICY makers_owner
  ON public.makers FOR ALL
  TO authenticated
  USING      (public.is_owner())
  WITH CHECK (public.is_owner());

REVOKE ALL ON public.makers FROM anon, authenticated;
GRANT SELECT ON public.makers TO anon;
GRANT SELECT, INSERT, UPDATE, DELETE ON public.makers TO authenticated;

CREATE OR REPLACE FUNCTION public._makers_touch_updated_at()
RETURNS trigger
LANGUAGE plpgsql
SET search_path = public, pg_temp
AS $$
BEGIN
  NEW.updated_at := now();
  RETURN NEW;
END;
$$;

DROP TRIGGER IF EXISTS makers_updated_at ON public.makers;
CREATE TRIGGER makers_updated_at
  BEFORE UPDATE ON public.makers
  FOR EACH ROW EXECUTE FUNCTION public._makers_touch_updated_at();

-- ── 2. inventory_items.maker_id + owner-only guard ──────────────────────────
ALTER TABLE public.inventory_items
  ADD COLUMN IF NOT EXISTS maker_id uuid REFERENCES public.makers(id) ON DELETE SET NULL;

CREATE INDEX IF NOT EXISTS idx_inventory_items_maker
  ON public.inventory_items (maker_id)
  WHERE maker_id IS NOT NULL;

CREATE OR REPLACE FUNCTION public._inventory_maker_owner_only()
RETURNS trigger
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public, pg_temp
AS $$
BEGIN
  IF auth.uid() IS NULL OR public.is_owner() THEN
    RETURN NEW;
  END IF;

  IF TG_OP = 'INSERT' AND NEW.maker_id IS NOT NULL THEN
    RAISE EXCEPTION 'Only the owner can set the maker of a stone';
  END IF;
  IF TG_OP = 'UPDATE' AND NEW.maker_id IS DISTINCT FROM OLD.maker_id THEN
    RAISE EXCEPTION 'Only the owner can set the maker of a stone';
  END IF;

  RETURN NEW;
END;
$$;

REVOKE ALL ON FUNCTION public._inventory_maker_owner_only() FROM PUBLIC, anon, authenticated;

DROP TRIGGER IF EXISTS inventory_maker_owner_only ON public.inventory_items;
CREATE TRIGGER inventory_maker_owner_only
  BEFORE INSERT OR UPDATE OF maker_id ON public.inventory_items
  FOR EACH ROW EXECUTE FUNCTION public._inventory_maker_owner_only();

-- ── 3. Public views (live definitions; new columns at the end) ──────────────
CREATE OR REPLACE VIEW public.public_listing_details
WITH (security_invoker = false)
AS
SELECT i.id, i.title, i.product_type, i.selling_price, i.description, i.image_urls,
       i.video_url, i.certification_lab, i.certification_number, i.treatment,
       i.dimensions_mm, i.length, i.width, i.height, i.dimension_unit, i.gem_type,
       i.variety, i.origin_country, i.origin_region, i.shape, i.cut_type, i.cut,
       i.clarity, i.weight_value, i.weight_unit, i.species, i.locality, i.matrix,
       i.weight_grams, i.weight_grams_unit, i.jewelry_type, i.metal, i.metal_purity,
       i.size_or_length, i.gemstones_used, i.total_weight_grams,
       i.total_weight_grams_unit, i.sale_method, i.courier, i.shipping_cost,
       i.delivery_days_min, i.delivery_days_max, i.prep_days,
       s.country AS seller_country, i.status,
       i.maker_id,
       m.name  AS maker_name,
       m.place AS maker_place
FROM ((public.inventory_items i
  JOIN public.sellers s ON ((s.id = i.seller_id)))
  LEFT JOIN public.makers m ON ((m.id = i.maker_id)))
WHERE ((i.is_listed = true)
  AND (i.status = ANY (ARRAY['available'::text, 'reserved'::text]))
  AND (s.status = 'active'::text));

CREATE OR REPLACE VIEW public.public_listings
WITH (security_invoker = false)
AS
SELECT i.id, i.title, i.gem_type, i.variety, i.weight_value, i.weight_unit,
       i.origin_country, i.selling_price, (i.image_urls ->> 0) AS image_url,
       i.sale_method, i.shipping_cost, s.country AS seller_country, i.product_type,
       i.maker_id
FROM (public.inventory_items i
  JOIN public.sellers s ON ((s.id = i.seller_id)))
WHERE ((i.is_listed = true)
  AND (i.status = 'available'::text)
  AND (s.status = 'active'::text));

COMMIT;


-- =============================================================================
-- VERIFICATION (read-only)
-- =============================================================================
--   SELECT policyname, cmd, roles FROM pg_policies WHERE tablename = 'makers';
--   SELECT column_name FROM information_schema.columns
--   WHERE  table_name IN ('public_listing_details', 'public_listings')
--     AND  column_name LIKE 'maker%';
--   SELECT tgname FROM pg_trigger WHERE tgrelid = 'public.inventory_items'::regclass;
-- =============================================================================
