-- ============================================================================
-- GemWorkers — Photos + videos on Bunny (media.gemworkers.com) — 2026-10-30
-- ============================================================================
-- Photos go to Bunny Storage (gemworkers-media, served from media.gemworkers.com),
-- videos to Bunny Stream (library 794698). Uploads go through the Edge Function
-- `media` (checks the stone is the caller's, keeps the Bunny keys secret).
--
-- A Bunny video needs a few minutes to encode. While it does, its id sits in
-- inventory_items.video_pending; when Bunny is done (webhook or the admin's
-- check) the function writes the playable MP4 address into video_url and
-- clears video_pending. The store only shows video_url, so a buyer never sees
-- an unfinished video.
--
-- Not in InventoryItem.toMap() → an Edit stone save can't touch it.
-- Applied to live DB 2026-10-30 (verified: video_pending text). Safe to run twice.
-- ============================================================================

ALTER TABLE public.inventory_items
  ADD COLUMN IF NOT EXISTS video_pending text;

COMMENT ON COLUMN public.inventory_items.video_pending IS
  'Bunny Stream video id still encoding (set/cleared by Edge Function media). sql/media_bunny.sql';

-- Check: one row, video_pending text
SELECT column_name, data_type
FROM information_schema.columns
WHERE table_schema = 'public' AND table_name = 'inventory_items' AND column_name = 'video_pending';
