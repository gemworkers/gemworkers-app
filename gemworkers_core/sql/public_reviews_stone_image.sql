-- =============================================================================
-- GemWorkers — Reviews show the purchased stone's photo (Etsy-style)
-- =============================================================================
-- Applied to live DB 2026-10-22
--
-- public_reviews (reviews_setup.sql): same definition, one column appended:
--   stone_image_url = first photo of the reviewed stone (inventory_items).
-- Columns only appended → CREATE OR REPLACE; grants kept and restated.
-- =============================================================================

BEGIN;

CREATE OR REPLACE VIEW public.public_reviews
WITH (security_invoker = false)
AS
SELECT r.id,
       r.rating,
       r.body,
       r.photo_url,
       r.reviewer_name,
       r.reviewer_country,
       r.owner_reply,
       r.replied_at,
       r.created_at,
       r.maker_id,
       i.title AS stone_title,
       (i.image_urls ->> 0) AS stone_image_url
FROM   public.reviews r
LEFT   JOIN public.inventory_items i ON i.id = r.inventory_item_id
WHERE  r.status = 'approved';

REVOKE ALL ON public.public_reviews FROM anon, authenticated;
GRANT SELECT ON public.public_reviews TO anon, authenticated;

COMMIT;

-- VERIFICATION (read-only):
--   SELECT stone_title, stone_image_url FROM public.public_reviews;
