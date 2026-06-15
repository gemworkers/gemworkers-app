-- =============================================================================
-- GemWorkers — Public Storefront View
-- =============================================================================
-- Exposes ONLY public-safe columns from inventory_items to anonymous storefront
-- visitors. Every private column (cost_price, margin, supplier info, purchase_id,
-- location/QR fields, quantity, status, customer data, etc.) stays hidden.
-- The underlying inventory_items table keeps its existing RLS policies untouched;
-- anon still gets zero rows if they query inventory_items directly.
--
-- Security model:
--   PostgreSQL views run with security_invoker = false by default, meaning
--   row-level security on underlying tables is evaluated against the VIEW OWNER
--   (postgres), not the caller. Because the postgres role has BYPASSRLS, the
--   view can read inventory_items rows freely — but only exposes the columns and
--   rows defined here. Granting SELECT on this view (not on the table) is the
--   only permission anon receives; a direct SELECT on inventory_items still
--   returns nothing for anon because the existing policies remain in effect.
-- =============================================================================

-- 1. Create (or replace) the view.
--    security_invoker = false is the PostgreSQL default but stated explicitly
--    to document the intended security boundary for future maintainers.
CREATE OR REPLACE VIEW public.public_listings
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
    (i.image_urls ->> 0) AS image_url
FROM  public.inventory_items i
JOIN  public.sellers         s ON s.id = i.seller_id
WHERE i.is_listed = true;

-- 2. Grant read access to the VIEW only — not to the underlying table.
--    authenticated is included so logged-in users can also browse the storefront.
GRANT SELECT ON public.public_listings TO anon;
GRANT SELECT ON public.public_listings TO authenticated;
