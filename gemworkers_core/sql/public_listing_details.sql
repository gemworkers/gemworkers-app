-- =============================================================================
-- GemWorkers — Public Listing Details View
-- =============================================================================
-- Companion to public_listings (browse cards). Exposes the richer field set
-- needed by the /stones/:id detail page — full photo array, type-specific spec
-- fields, and description — while keeping the IDENTICAL security boundary as
-- public_listings. Do NOT modify or drop public_listings; browse depends on it.
--
-- Security model (mirrors public_listings exactly):
--   security_invoker = false  → view runs as owner (postgres / BYPASSRLS).
--   Anon is granted SELECT on this view only, never on the underlying table.
--   A direct SELECT on inventory_items still returns zero rows for anon.
--   WHERE is_listed = true AND status <> 'sold' AND seller.status = 'active'
--   → stricter than the current public_listings (which only checks is_listed).
--   public_listings should be patched with the same filters in a follow-up.
--
-- Photo column:
--   image_urls is a jsonb array of URL strings (index 0 = cover). The full
--   array is exposed because the detail page renders all photos. The values
--   are only public storage URLs — no internal IDs or cost data are embedded.
--
-- Excluded (never exposed):
--   cost_price, sale_price, margin, supplier_id, location_id, barcode,
--   qr_code, quantity, notes (internal), status, sku, is_listed, listed_at,
--   lot fields, seller_id, purchase_id, any other internal column.
-- Exposed: sale_method — storefront needs it to decide which action buttons to show.
--
-- Idempotent: safe to run repeatedly (CREATE OR REPLACE).
-- =============================================================================

CREATE OR REPLACE VIEW public.public_listing_details
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

    -- ── Seller display name (no internal seller_id) ────────────────────────
    s.name AS seller_name,

    -- ── Shared fields (all product types) ──────────────────────────────────
    i.certification_lab,
    i.certification_number,
    i.treatment,
    i.dimensions_mm,

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
    i.prep_days

FROM  public.inventory_items i
JOIN  public.sellers         s ON s.id = i.seller_id
WHERE i.is_listed  = true          -- must be actively listed
  AND i.status    <> 'sold'        -- exclude sold items (is_listed should be false too,
                                   --   but this is an explicit belt-and-suspenders guard)
  AND s.status     = 'active';     -- seller must not be suspended

-- Grant read access to the VIEW only — same roles as public_listings.
GRANT SELECT ON public.public_listing_details TO anon;
GRANT SELECT ON public.public_listing_details TO authenticated;
