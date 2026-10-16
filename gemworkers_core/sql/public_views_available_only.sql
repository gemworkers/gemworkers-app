-- =============================================================================
-- GemWorkers — Public views: available-only browse, reserved-aware detail
-- =============================================================================
-- PROBLEM (verified on live DB):
--   seller_country_in_views.sql (2026-07-01) recreated both storefront views
--   with `status <> 'sold'`, undoing stone_sold_on_confirm_fix.sql (2026-06-27).
--   Reserved stones (pending_payment orders, accepted offers) therefore show on
--   browse pages as buyable, and public_listings lost product_type.
--
-- FIX:
--   public_listings (browse cards)
--     • WHERE status = 'available' (explicit allowlist)
--     • seller_id and seller_name removed (not used by any client; no need to
--       expose internal ids publicly)
--     • product_type appended last
--   public_listing_details (stone page, shop pages)
--     • WHERE status IN ('available', 'reserved') — a reserved stone keeps its
--       page so it can say "Reserved" instead of 404ing
--     • seller_name removed (not used by any client)
--     • status appended last (clients must filter/branch on it)
--
-- Structure changes (columns removed) → DROP VIEW + CREATE VIEW; CREATE OR
-- REPLACE cannot drop columns. Both views keep security_invoker = false and
-- the same SELECT grants to anon + authenticated as every earlier version;
-- REVOKE ALL first strips the extra privileges Supabase's default privileges
-- add to newly created relations, leaving SELECT only for those two roles.
--
-- Clients checked before writing this (store + gemworkers_core Dart + Supabase
-- edge functions): no reader of seller_id / seller_name on these views.
--
-- Atomic: wrapped in one transaction, so the storefront never sees a missing view.
-- =============================================================================

BEGIN;

-- -----------------------------------------------------------------------------
-- public_listings (browse cards: homepage, search, cart)
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
    (i.image_urls ->> 0) AS image_url,
    i.sale_method,
    i.shipping_cost,
    s.country            AS seller_country,
    i.product_type
FROM  public.inventory_items i
JOIN  public.sellers         s ON s.id = i.seller_id
WHERE i.is_listed = true
  AND i.status    = 'available'   -- explicit allowlist: reserved/sold stay off browse
  AND s.status    = 'active';

-- Supabase default privileges grant ALL on new relations in public; reduce to SELECT.
REVOKE ALL ON public.public_listings FROM anon, authenticated;
GRANT SELECT ON public.public_listings TO anon;
GRANT SELECT ON public.public_listings TO authenticated;

-- -----------------------------------------------------------------------------
-- public_listing_details (stone detail page, shop category pages)
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

    -- ── Video ──────────────────────────────────────────────────────────────
    i.video_url,

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
    i.cut,
    i.clarity,
    i.weight_value,
    i.weight_unit,

    -- ── specimen fields ────────────────────────────────────────────────────
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

    -- ── Seller display (country only; no internal id, no name) ─────────────
    s.country AS seller_country,

    -- ── Stock state: 'available' | 'reserved' — appended last ──────────────
    i.status

FROM  public.inventory_items i
JOIN  public.sellers         s ON s.id = i.seller_id
WHERE i.is_listed = true
  AND i.status    IN ('available', 'reserved')   -- reserved keeps its page ("Reserved")
  AND s.status    = 'active';

-- Supabase default privileges grant ALL on new relations in public; reduce to SELECT.
REVOKE ALL ON public.public_listing_details FROM anon, authenticated;
GRANT SELECT ON public.public_listing_details TO anon;
GRANT SELECT ON public.public_listing_details TO authenticated;

COMMIT;


-- =============================================================================
-- VERIFICATION (run after applying; read-only)
-- =============================================================================
-- View definitions — expect status = 'available' / IN ('available','reserved'),
-- no seller_id / seller_name, product_type last on public_listings, status last
-- on public_listing_details:
--
--   SELECT pg_get_viewdef('public.public_listings'::regclass, true);
--   SELECT pg_get_viewdef('public.public_listing_details'::regclass, true);
--
-- security_invoker should be absent or false on both:
--
--   SELECT c.relname, c.reloptions
--   FROM   pg_class c
--   WHERE  c.relname IN ('public_listings', 'public_listing_details');
--
-- Grants — expect exactly one row (SELECT) each for anon and authenticated on
-- both views (service_role / postgres rows may also appear; that's expected):
--
--   SELECT table_name, grantee, privilege_type
--   FROM   information_schema.role_table_grants
--   WHERE  table_schema = 'public'
--     AND  table_name IN ('public_listings', 'public_listing_details')
--   ORDER  BY table_name, grantee, privilege_type;
