-- =============================================================================
-- GemWorkers — Lock down photo uploads (storage bucket inventory-images)
-- =============================================================================
-- Applied to live DB 2026-10-22
--
-- Before: policy "Allow all uploads to inventory-images" let ANYONE (even
-- not logged in) upload any file of any size; no DELETE policy at all, so
-- removing a photo in admin left the file behind.
--
-- After:
--   SELECT  everyone (unchanged — public stone / maker photos)
--   INSERT  owner: anywhere in the bucket (incl. makers/)
--           seller: only into <item id>/ of a stone that is theirs
--   DELETE  same rule as INSERT (admin "remove photo" now really deletes)
--   UPDATE  nobody (the apps never overwrite files)
--   Bucket: images only (jpeg / png / webp / heic), max 10 MB per file.
--
-- Paths used by the admin: <inventory_item_id>/<timestamp>.<ext>
-- (InventoryRepository.uploadImage) and makers/<timestamp>.<ext>
-- (MakerRepository.uploadPhoto, owner only).
-- =============================================================================

BEGIN;

DROP POLICY IF EXISTS "Allow all uploads to inventory-images" ON storage.objects;
DROP POLICY IF EXISTS inventory_images_staff_insert ON storage.objects;
DROP POLICY IF EXISTS inventory_images_staff_delete ON storage.objects;

CREATE POLICY inventory_images_staff_insert
  ON storage.objects FOR INSERT
  TO authenticated
  WITH CHECK (
    bucket_id = 'inventory-images'
    AND (
      public.is_owner()
      OR (storage.foldername(name))[1] IN (
           SELECT i.id::text
           FROM   public.inventory_items i
           WHERE  i.seller_id = public.current_seller_id()
         )
    )
  );

CREATE POLICY inventory_images_staff_delete
  ON storage.objects FOR DELETE
  TO authenticated
  USING (
    bucket_id = 'inventory-images'
    AND (
      public.is_owner()
      OR (storage.foldername(name))[1] IN (
           SELECT i.id::text
           FROM   public.inventory_items i
           WHERE  i.seller_id = public.current_seller_id()
         )
    )
  );

UPDATE storage.buckets
SET    file_size_limit    = 10485760,
       allowed_mime_types = ARRAY['image/jpeg', 'image/png', 'image/webp', 'image/heic']
WHERE  id = 'inventory-images';

COMMIT;


-- VERIFICATION (read-only):
--   SELECT policyname, cmd, roles FROM pg_policies
--   WHERE  schemaname = 'storage' AND tablename = 'objects';
--   SELECT id, public, file_size_limit, allowed_mime_types FROM storage.buckets;
