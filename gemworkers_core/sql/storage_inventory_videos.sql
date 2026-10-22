-- =============================================================================
-- GemWorkers — Stone videos (Etsy-style uploads)
-- =============================================================================
-- Applied to live DB 2026-10-23
--
-- Bucket inventory-videos: public read; MP4 / MOV / WebM up to 50 MB.
-- Upload / delete follow the photo rules (storage_inventory_images_lockdown.sql):
-- owner anywhere, a seller only into <item id>/ of one of their own stones.
-- The public URL is stored in inventory_items.video_url (same column as the
-- old YouTube / Vimeo links); the store shows an uploaded file as a silent
-- looping item in the photo gallery and keeps embedding the old links.
-- =============================================================================

BEGIN;

INSERT INTO storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
VALUES ('inventory-videos', 'inventory-videos', true, 52428800,
        ARRAY['video/mp4', 'video/quicktime', 'video/webm'])
ON CONFLICT (id) DO UPDATE
SET public = true, file_size_limit = 52428800,
    allowed_mime_types = ARRAY['video/mp4', 'video/quicktime', 'video/webm'];

DROP POLICY IF EXISTS inventory_videos_read         ON storage.objects;
DROP POLICY IF EXISTS inventory_videos_staff_insert ON storage.objects;
DROP POLICY IF EXISTS inventory_videos_staff_delete ON storage.objects;

CREATE POLICY inventory_videos_read
  ON storage.objects FOR SELECT
  TO public
  USING (bucket_id = 'inventory-videos');

CREATE POLICY inventory_videos_staff_insert
  ON storage.objects FOR INSERT
  TO authenticated
  WITH CHECK (
    bucket_id = 'inventory-videos'
    AND (
      public.is_owner()
      OR (storage.foldername(name))[1] IN (
           SELECT i.id::text
           FROM   public.inventory_items i
           WHERE  i.seller_id = public.current_seller_id()
         )
    )
  );

CREATE POLICY inventory_videos_staff_delete
  ON storage.objects FOR DELETE
  TO authenticated
  USING (
    bucket_id = 'inventory-videos'
    AND (
      public.is_owner()
      OR (storage.foldername(name))[1] IN (
           SELECT i.id::text
           FROM   public.inventory_items i
           WHERE  i.seller_id = public.current_seller_id()
         )
    )
  );

COMMIT;

-- VERIFICATION (read-only):
--   SELECT id, public, file_size_limit, allowed_mime_types FROM storage.buckets WHERE id = 'inventory-videos';
--   SELECT policyname, cmd FROM pg_policies WHERE schemaname = 'storage' AND policyname LIKE 'inventory_videos%';
