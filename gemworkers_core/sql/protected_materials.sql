-- =============================================================================
-- GemWorkers — Protected materials check (CITES, Kimberley Process, Russia ban)
-- =============================================================================
-- Applied to live DB 2026-10-26
--
-- Zakaria 2026-10-26. When a stone is listed (or a seller asks for listing), the
-- text of the stone (title, gem type, variety, species, gemstones used,
-- description, jewellery type, matrix) is checked for protected materials:
--   • banned  — ivory, tortoiseshell, hawksbill, rhino: never listed, unless the
--               word only describes a colour ("ivory white") → declared colour_only
--   • CITES   — coral, conch, giant clam, shells, fossils, ammonite, mammoth,
--               walrus, abalone…: listed only with a declaration: colour_only,
--               permit (export permit number required) or not_protected
--   • diamond — listed only with: conflict_free (natural, not Russian origin,
--               Kimberley warranty) or colour_only ("diamond cut"); ROUGH
--               diamonds only with kimberley + certificate number
-- Declarations are saved per stone (who, when) by set_item_compliance — the only
-- way to change them. lib/core/utils/protected_materials.dart uses the same
-- word lists to show the questions in Add / Edit stone.
-- Stones already listed are not re-checked; the check runs on listing.
-- Buyers see only "export permit" / "conflict-free diamond" (public_listing_details,
-- 2 columns appended) — never the permit numbers.
-- =============================================================================

BEGIN;

ALTER TABLE public.inventory_items
  ADD COLUMN IF NOT EXISTS cites_declaration      text,
  ADD COLUMN IF NOT EXISTS cites_permit_no        text,
  ADD COLUMN IF NOT EXISTS diamond_declaration    text,
  ADD COLUMN IF NOT EXISTS kimberley_cert_no      text,
  ADD COLUMN IF NOT EXISTS compliance_declared_at timestamptz,
  ADD COLUMN IF NOT EXISTS compliance_declared_by uuid;

ALTER TABLE public.inventory_items DROP CONSTRAINT IF EXISTS inventory_items_cites_declaration_check;
ALTER TABLE public.inventory_items ADD CONSTRAINT inventory_items_cites_declaration_check
  CHECK (cites_declaration IS NULL OR cites_declaration IN ('colour_only', 'permit', 'not_protected'));
ALTER TABLE public.inventory_items DROP CONSTRAINT IF EXISTS inventory_items_diamond_declaration_check;
ALTER TABLE public.inventory_items ADD CONSTRAINT inventory_items_diamond_declaration_check
  CHECK (diamond_declaration IS NULL OR diamond_declaration IN ('colour_only', 'conflict_free', 'kimberley'));

-- ── Which protected groups a stone's text touches ───────────────────────────
-- Returns e.g. {banned,cites,diamond,rough}. Same lists as the admin app.
CREATE OR REPLACE FUNCTION public._protected_flags(i public.inventory_items)
RETURNS text[]
LANGUAGE plpgsql
STABLE
SET search_path = public, pg_temp
AS $$
DECLARE
  t     text := lower(concat_ws(' ', i.title, i.gem_type, i.variety, i.species, i.gemstones_used,
                                i.description, i.jewelry_type, i.matrix));
  shape text := lower(concat_ws(' ', i.shape, i.cut_type, i.cut));
  f     text[] := '{}';
  v_dia boolean;
BEGIN
  IF t ~ '\m(tortoise|tortoiseshell|hawksbill|rhino)'
     OR (t ~ '\mivory\M' AND t !~ '\m(mammoth|fossil|fossili[sz]ed|walrus)\M') THEN
    f := f || 'banned'::text;
  END IF;
  IF t ~ '\m(coral|corals|conch|clam|clams|tridacna|shell|shells|seashell|seashells|nautilus|fossil|fossils|fossili[sz]ed|ammonite|ammonites|mammoth|dinosaur|walrus|abalone)\M' THEN
    f := f || 'cites'::text;
  END IF;
  v_dia := coalesce(i.gem_type, '') ~* '^diamond'
           OR (t ~ '\mdiamonds?\M' AND t !~ 'herkimer');
  IF v_dia THEN
    f := f || 'diamond'::text;
    IF shape ~ '(rough|uncut)' OR t ~ '\m(rough|uncut)\M' THEN
      f := f || 'rough'::text;
    END IF;
  END IF;
  RETURN f;
END;
$$;

-- ── The check when a stone is listed or a listing is requested ──────────────
-- Runs after inventory_listing_approval (trigger names sort alphabetically),
-- so a seller's request (listing_requested_at) is checked too.
CREATE OR REPLACE FUNCTION public._inventory_protected_materials()
RETURNS trigger
LANGUAGE plpgsql
SET search_path = public, pg_temp
AS $$
DECLARE
  f text[];
BEGIN
  -- Declarations change only through set_item_compliance.
  IF TG_OP = 'UPDATE' AND coalesce(current_setting('gemworkers.compliance', true), '') <> '1' THEN
    NEW.cites_declaration      := OLD.cites_declaration;
    NEW.cites_permit_no        := OLD.cites_permit_no;
    NEW.diamond_declaration    := OLD.diamond_declaration;
    NEW.kimberley_cert_no      := OLD.kimberley_cert_no;
    NEW.compliance_declared_at := OLD.compliance_declared_at;
    NEW.compliance_declared_by := OLD.compliance_declared_by;
  ELSIF TG_OP = 'INSERT' AND coalesce(current_setting('gemworkers.compliance', true), '') <> '1' THEN
    NEW.cites_declaration := NULL; NEW.cites_permit_no := NULL;
    NEW.diamond_declaration := NULL; NEW.kimberley_cert_no := NULL;
    NEW.compliance_declared_at := NULL; NEW.compliance_declared_by := NULL;
  END IF;

  IF NOT (
       (NEW.is_listed AND (TG_OP = 'INSERT' OR NOT coalesce(OLD.is_listed, false)))
    OR (NEW.listing_requested_at IS NOT NULL AND (TG_OP = 'INSERT' OR OLD.listing_requested_at IS NULL))
  ) THEN
    RETURN NEW;
  END IF;

  f := public._protected_flags(NEW);

  IF 'banned' = ANY (f) AND coalesce(NEW.cites_declaration, '') <> 'colour_only' THEN
    RAISE EXCEPTION 'Ivory, tortoiseshell and rhino horn can''t be sold on GemWorkers. If the word only describes a colour (e.g. "ivory white"), say so under "Protected materials" in Edit stone.';
  END IF;
  IF 'cites' = ANY (f) AND (NEW.cites_declaration IS NULL
       OR (NEW.cites_declaration = 'permit' AND coalesce(btrim(NEW.cites_permit_no), '') = '')) THEN
    RAISE EXCEPTION 'This item may contain a protected material (coral, shell, fossil…). Fill in "Protected materials" in Edit stone before listing.';
  END IF;
  IF 'rough' = ANY (f) AND coalesce(NEW.diamond_declaration, '') <> 'colour_only'
     AND NOT (NEW.diamond_declaration = 'kimberley' AND coalesce(btrim(NEW.kimberley_cert_no), '') <> '') THEN
    RAISE EXCEPTION 'Rough diamonds can only be sold with a Kimberley Process certificate. Add its number under "Protected materials" in Edit stone.';
  ELSIF 'diamond' = ANY (f) AND NEW.diamond_declaration IS NULL THEN
    RAISE EXCEPTION 'For diamonds, confirm under "Protected materials" in Edit stone that it is natural, conflict-free and not of Russian origin.';
  END IF;

  RETURN NEW;
END;
$$;

DROP TRIGGER IF EXISTS inventory_protected_materials ON public.inventory_items;
CREATE TRIGGER inventory_protected_materials
  BEFORE INSERT OR UPDATE ON public.inventory_items
  FOR EACH ROW EXECUTE FUNCTION public._inventory_protected_materials();

-- ── Save a stone's declarations (owner, or the stone's own seller) ──────────
CREATE OR REPLACE FUNCTION public.set_item_compliance(
  p_item_id uuid, p_cites text, p_permit text, p_diamond text, p_kimberley text
)
RETURNS void
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public, pg_temp
AS $$
DECLARE
  v_seller uuid;
BEGIN
  SELECT seller_id INTO v_seller FROM inventory_items WHERE id = p_item_id;
  IF v_seller IS NULL THEN RAISE EXCEPTION 'Stone not found'; END IF;
  IF NOT public.is_owner() AND v_seller IS DISTINCT FROM public.current_seller_id() THEN
    RAISE EXCEPTION 'Not your stone';
  END IF;
  IF p_cites IS NOT NULL AND p_cites NOT IN ('colour_only', 'permit', 'not_protected') THEN
    RAISE EXCEPTION 'Unknown answer: %', p_cites;
  END IF;
  IF p_diamond IS NOT NULL AND p_diamond NOT IN ('colour_only', 'conflict_free', 'kimberley') THEN
    RAISE EXCEPTION 'Unknown answer: %', p_diamond;
  END IF;

  PERFORM set_config('gemworkers.compliance', '1', true);
  UPDATE inventory_items
  SET    cites_declaration      = p_cites,
         cites_permit_no        = NULLIF(btrim(coalesce(p_permit, '')), ''),
         diamond_declaration    = p_diamond,
         kimberley_cert_no      = NULLIF(btrim(coalesce(p_kimberley, '')), ''),
         compliance_declared_at = CASE WHEN p_cites IS NULL AND p_diamond IS NULL THEN NULL ELSE now() END,
         compliance_declared_by = CASE WHEN p_cites IS NULL AND p_diamond IS NULL THEN NULL ELSE auth.uid() END
  WHERE  id = p_item_id;
  PERFORM set_config('gemworkers.compliance', '0', true);
END;
$$;
REVOKE ALL ON FUNCTION public.set_item_compliance(uuid, text, text, text, text) FROM PUBLIC, anon;
GRANT EXECUTE ON FUNCTION public.set_item_compliance(uuid, text, text, text, text) TO authenticated;
REVOKE ALL ON FUNCTION public._protected_flags(public.inventory_items) FROM PUBLIC, anon;

-- ── Buyers: two yes/no facts on the stone page (columns appended) ───────────
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
    (i.cites_declaration = 'permit') AS export_permit,
    (i.diamond_declaration IN ('conflict_free', 'kimberley')) AS conflict_free_diamond
   FROM inventory_items i
     JOIN sellers s ON s.id = i.seller_id
     LEFT JOIN makers m ON m.id = i.maker_id
  WHERE i.is_listed = true AND (i.status = ANY (ARRAY['available'::text, 'reserved'::text])) AND s.status = 'active'::text;

COMMIT;
