-- =============================================================================
-- GemWorkers — Add seller_country to Storefront Views
-- =============================================================================
-- Adds s.country AS seller_country to public_listings and
-- public_listing_details so the storefront UI can render "Ships from
-- NL/TH/PK" without a second round-trip to the sellers table.
--
-- Applied as DROP VIEW + CREATE VIEW rather than CREATE OR REPLACE: the
-- live column order on both views no longer matched CREATE OR REPLACE's
-- requirements, and Postgres rejects in-place changes to view output
-- columns with error 42P16 (cannot change name/type/order of an existing
-- view column). Dropping and recreating sidesteps that.
--
-- Project convention: view columns are only ever APPENDED, never inserted
-- mid-list. seller_country is therefore added as the LAST column of each
-- view (not alongside seller_name) so future additions can keep using
-- CREATE OR REPLACE instead of drop+recreate.
--
-- Backward-compatible: every existing column, filter, JOIN, security_invoker
-- setting, and GRANT is left untouched — this only appends one new output
-- column to each view. Existing callers that select specific columns (or
-- select *) keep working; nothing is removed or renamed.
--
-- Security posture unchanged:
--   public_listing_details still excludes seller_id (only the seller's
--   display name and country are exposed, never the internal ID).
--   Both views keep security_invoker = false and the same anon/authenticated
--   GRANTs as before.
-- =============================================================================

-- -----------------------------------------------------------------------------
-- public_listings (browse cards)
-- -----------------------------------------------------------------------------
DROP VIEW IF EXISTS public.public_listings;

CREATE VIEW public.public_listings
WITH (security_invoker = false)
AS
SELECT
    i.id,
    i.title,
    i.gem_type,
    i.variety,
    i.weight_value,
    i.weight_unit,
    i.origin_country,
    i.selling_price,
    i.seller_id,
    s.name          AS seller_name,
    (i.image_urls ->> 0) AS image_url,
    i.sale_method,
    i.shipping_cost,
    s.country       AS seller_country
FROM  public.inventory_items i
JOIN  public.sellers         s ON s.id = i.seller_id
WHERE i.is_listed = true
  AND i.status   <> 'sold'
  AND s.status    = 'active';

GRANT SELECT ON public.public_listings TO anon;
GRANT SELECT ON public.public_listings TO authenticated;

-- -----------------------------------------------------------------------------
-- public_listing_details (detail page)
-- -----------------------------------------------------------------------------
DROP VIEW IF EXISTS public.public_listing_details;

CREATE VIEW public.public_listing_details
WITH (security_invoker = false)
AS
SELECT
    -- ── Identity & commerce ────────────────────────────────────────────────
    i.id,
    i.title,
    i.product_type,
    i.selling_price,

    -- ── Public description ─────────────────────────────────────────────────
    i.description,

    -- ── Photos (ordered; index 0 = cover; plain URL strings only) ─────────
    i.image_urls,

    -- ── video_url: stored but NOT rendered in this version ─────────────────
    -- TODO: wire up video player in next session
    i.video_url,

    -- ── Seller display (no internal seller_id) ─────────────────────────────
    s.name AS seller_name,

    -- ── Shared fields (all product types) ──────────────────────────────────
    i.certification_lab,
    i.certification_number,
    i.treatment,
    i.dimensions_mm,       -- retired free-text; kept for older data
    i.length,
    i.width,
    i.height,
    i.dimension_unit,

    -- ── loose_stone fields ─────────────────────────────────────────────────
    i.gem_type,
    i.variety,
    i.origin_country,
    i.origin_region,
    i.shape,
    i.cut_type,
    i.cut,           -- finish / technique (separate from cut_type)
    i.clarity,
    i.weight_value,
    i.weight_unit,

    -- ── specimen fields ────────────────────────────────────────────────────
    -- (origin_country already included above; used by both loose_stone + specimen)
    i.species,
    i.locality,
    i.matrix,
    i.weight_grams,
    i.weight_grams_unit,

    -- ── jewelry fields ─────────────────────────────────────────────────────
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

    -- ── seller_country: appended last, see header note ─────────────────────
    s.country AS seller_country

FROM  public.inventory_items i
JOIN  public.sellers         s ON s.id = i.seller_id
WHERE i.is_listed  = true          -- must be actively listed
  AND i.status    <> 'sold'        -- exclude sold items (is_listed should be false too,
                                   --   but this is an explicit belt-and-suspenders guard)
  AND s.status     = 'active';     -- seller must not be suspended

GRANT SELECT ON public.public_listing_details TO anon;
GRANT SELECT ON public.public_listing_details TO authenticated;
