-- =============================================================================
-- GemWorkers — Reviews (verified buyers, owner-approved)
-- =============================================================================
-- Applied to live DB 2026-10-22
--
-- Decisions: only the buyer of a real platform order may review it, once per
-- order (one order = one stone); stars 1–5 + optional text + optional photo;
-- every review waits for the owner (pending → approved / hidden) and may get
-- an owner reply shown as "GemWorkers". Public shows first name + country,
-- never the seller.
--
-- 1. public.reviews (+ RLS: owner all; buyer reads own; no direct inserts).
-- 2. submit_review(order_id, rating, body, photo_url) — SECURITY DEFINER.
--    Order must be the caller's, sale_channel 'platform', status shipped /
--    received / paid, not reviewed yet. photo_url must be in the caller's own
--    review-photos folder. Name = first word of buyers.display_name (or the
--    order's shipping_name); country = shipping_country.
-- 3. public_reviews view — approved reviews only, no buyer_id / order data.
-- 4. Storage bucket review-photos (public read; a buyer uploads only into
--    <their user id>/; images ≤ 5 MB).
-- 5. Invite email: orders.review_invited_at + send_review_invites() (cron
--    every 15 min). Eligible: platform order with a buyer, not cancelled,
--    marked received, or shipped ≥ 14 days ago; no review yet. One POST per
--    checkout (cart group) to offer-notify {"type":"REVIEW_INVITE",
--    "order_ids":[…]} with the existing Vault secret 'offer_reminder_secret'
--    (same header as the payment reminder). Orders already eligible today are
--    stamped as invited so old test orders don't get emails.
--
-- Safe to re-run: one transaction, IF NOT EXISTS / CREATE OR REPLACE.
-- =============================================================================

BEGIN;

-- ── 1. reviews ──────────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS public.reviews (
  id                uuid        PRIMARY KEY DEFAULT gen_random_uuid(),
  order_id          uuid        NOT NULL UNIQUE REFERENCES public.orders(id) ON DELETE CASCADE,
  buyer_id          uuid        NOT NULL REFERENCES public.buyers(id) ON DELETE CASCADE,
  inventory_item_id uuid        REFERENCES public.inventory_items(id) ON DELETE SET NULL,
  maker_id          uuid        REFERENCES public.makers(id) ON DELETE SET NULL,
  rating            smallint    NOT NULL CHECK (rating BETWEEN 1 AND 5),
  body              text        CHECK (body IS NULL OR char_length(body) BETWEEN 1 AND 2000),
  photo_url         text,
  reviewer_name     text,
  reviewer_country  text,
  status            text        NOT NULL DEFAULT 'pending'
                                CHECK (status IN ('pending', 'approved', 'hidden')),
  owner_reply       text        CHECK (owner_reply IS NULL OR char_length(owner_reply) BETWEEN 1 AND 1000),
  replied_at        timestamptz,
  moderated_at      timestamptz,
  created_at        timestamptz NOT NULL DEFAULT now()
);

CREATE INDEX IF NOT EXISTS idx_reviews_status_created ON public.reviews (status, created_at DESC);
CREATE INDEX IF NOT EXISTS idx_reviews_maker ON public.reviews (maker_id) WHERE maker_id IS NOT NULL;
CREATE INDEX IF NOT EXISTS idx_reviews_buyer ON public.reviews (buyer_id);

ALTER TABLE public.reviews ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS reviews_owner        ON public.reviews;
DROP POLICY IF EXISTS reviews_buyer_select ON public.reviews;

CREATE POLICY reviews_owner
  ON public.reviews FOR ALL
  TO authenticated
  USING      (public.is_owner())
  WITH CHECK (public.is_owner());

CREATE POLICY reviews_buyer_select
  ON public.reviews FOR SELECT
  TO authenticated
  USING (buyer_id = auth.uid());

REVOKE ALL ON public.reviews FROM anon, authenticated;
GRANT SELECT, UPDATE, DELETE ON public.reviews TO authenticated;

-- ── 2. submit_review ────────────────────────────────────────────────────────
CREATE OR REPLACE FUNCTION public.submit_review(
  p_order_id  uuid,
  p_rating    integer,
  p_body      text DEFAULT NULL,
  p_photo_url text DEFAULT NULL
)
RETURNS uuid
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public, pg_temp
AS $$
DECLARE
  v_uid    uuid := auth.uid();
  v_order  record;
  v_item   uuid;
  v_maker  uuid;
  v_name   text;
  v_body   text;
  v_photo  text;
  v_prefix text;
  v_id     uuid;
BEGIN
  IF v_uid IS NULL THEN
    RAISE EXCEPTION 'Please sign in to leave a review.';
  END IF;

  SELECT o.id, o.buyer_id, o.status, o.sale_channel, o.shipping_name, o.shipping_country
  INTO   v_order
  FROM   orders o
  WHERE  o.id = p_order_id
  FOR UPDATE;

  IF NOT FOUND OR v_order.buyer_id IS DISTINCT FROM v_uid OR v_order.sale_channel <> 'platform' THEN
    RAISE EXCEPTION 'We couldn''t find that order.';
  END IF;
  IF v_order.status NOT IN ('shipped', 'received', 'paid') THEN
    RAISE EXCEPTION 'You can review this stone once it has been shipped to you.';
  END IF;
  IF EXISTS (SELECT 1 FROM reviews WHERE order_id = p_order_id) THEN
    RAISE EXCEPTION 'You have already reviewed this order. Thank you!';
  END IF;

  IF p_rating IS NULL OR p_rating NOT BETWEEN 1 AND 5 THEN
    RAISE EXCEPTION 'Please choose 1 to 5 stars.';
  END IF;

  v_body := NULLIF(regexp_replace(COALESCE(p_body, ''), '^[[:space:]]+|[[:space:]]+$', '', 'g'), '');
  IF v_body IS NOT NULL AND char_length(v_body) > 2000 THEN
    RAISE EXCEPTION 'Reviews can be up to 2000 characters.';
  END IF;

  v_photo  := NULLIF(btrim(COALESCE(p_photo_url, '')), '');
  v_prefix := 'https://cvqzidqnwthzfodhzepz.supabase.co/storage/v1/object/public/review-photos/'
              || v_uid::text || '/';
  IF v_photo IS NOT NULL AND left(v_photo, char_length(v_prefix)) <> v_prefix THEN
    RAISE EXCEPTION 'That photo could not be used. Please upload it again.';
  END IF;

  SELECT oi.inventory_item_id INTO v_item
  FROM   order_items oi WHERE oi.order_id = p_order_id LIMIT 1;
  IF v_item IS NOT NULL THEN
    SELECT maker_id INTO v_maker FROM inventory_items WHERE id = v_item;
  END IF;

  SELECT NULLIF(split_part(btrim(display_name), ' ', 1), '') INTO v_name
  FROM   buyers WHERE id = v_uid;
  v_name := COALESCE(v_name, NULLIF(split_part(btrim(COALESCE(v_order.shipping_name, '')), ' ', 1), ''));

  INSERT INTO reviews (order_id, buyer_id, inventory_item_id, maker_id, rating, body,
                       photo_url, reviewer_name, reviewer_country)
  VALUES (p_order_id, v_uid, v_item, v_maker, p_rating, v_body,
          v_photo, left(v_name, 40), v_order.shipping_country)
  RETURNING id INTO v_id;

  RETURN v_id;
END;
$$;

REVOKE ALL ON FUNCTION public.submit_review(uuid, integer, text, text) FROM PUBLIC, anon;
GRANT EXECUTE ON FUNCTION public.submit_review(uuid, integer, text, text) TO authenticated;

-- ── 3. public_reviews ───────────────────────────────────────────────────────
DROP VIEW IF EXISTS public.public_reviews;
CREATE VIEW public.public_reviews
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
       i.title AS stone_title
FROM   public.reviews r
LEFT   JOIN public.inventory_items i ON i.id = r.inventory_item_id
WHERE  r.status = 'approved';

REVOKE ALL ON public.public_reviews FROM anon, authenticated;
GRANT SELECT ON public.public_reviews TO anon, authenticated;

-- ── 4. Photo bucket ─────────────────────────────────────────────────────────
INSERT INTO storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
VALUES ('review-photos', 'review-photos', true, 5242880,
        ARRAY['image/jpeg', 'image/png', 'image/webp', 'image/heic'])
ON CONFLICT (id) DO UPDATE
SET public = true, file_size_limit = 5242880,
    allowed_mime_types = ARRAY['image/jpeg', 'image/png', 'image/webp', 'image/heic'];

DROP POLICY IF EXISTS review_photos_read         ON storage.objects;
DROP POLICY IF EXISTS review_photos_buyer_insert ON storage.objects;
DROP POLICY IF EXISTS review_photos_owner_delete ON storage.objects;

CREATE POLICY review_photos_read
  ON storage.objects FOR SELECT
  TO public
  USING (bucket_id = 'review-photos');

CREATE POLICY review_photos_buyer_insert
  ON storage.objects FOR INSERT
  TO authenticated
  WITH CHECK (bucket_id = 'review-photos'
              AND (storage.foldername(name))[1] = auth.uid()::text);

CREATE POLICY review_photos_owner_delete
  ON storage.objects FOR DELETE
  TO authenticated
  USING (bucket_id = 'review-photos' AND public.is_owner());

-- ── 5. Invite emails ────────────────────────────────────────────────────────
ALTER TABLE public.orders
  ADD COLUMN IF NOT EXISTS review_invited_at timestamptz;

CREATE OR REPLACE FUNCTION public._review_invite_due(o public.orders)
RETURNS boolean
LANGUAGE sql
STABLE
SET search_path = public, pg_temp
AS $$
  SELECT o.review_invited_at IS NULL
     AND o.buyer_id IS NOT NULL
     AND o.sale_channel = 'platform'
     AND o.status IN ('shipped', 'received', 'paid')
     AND (o.received_at IS NOT NULL
          OR o.shipped_at <= now() - interval '14 days')
     AND NOT EXISTS (SELECT 1 FROM public.reviews r WHERE r.order_id = o.id);
$$;

REVOKE ALL ON FUNCTION public._review_invite_due(public.orders) FROM PUBLIC, anon, authenticated;

-- Don't email old orders that are already eligible today.
UPDATE public.orders o
SET    review_invited_at = now()
WHERE  public._review_invite_due(o);

CREATE OR REPLACE FUNCTION public.send_review_invites()
RETURNS int
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public, pg_temp
AS $$
DECLARE
  v_secret text;
  v_ids    uuid[];
  v_queued int := 0;
BEGIN
  SELECT s.decrypted_secret INTO v_secret
  FROM   vault.decrypted_secrets s
  WHERE  s.name = 'offer_reminder_secret'
  LIMIT  1;

  IF v_secret IS NULL OR v_secret = '' THEN
    RAISE WARNING '[send_review_invites] Vault secret offer_reminder_secret missing — nothing sent';
    RETURN 0;
  END IF;

  FOR v_ids IN
    WITH stamped AS (
      UPDATE public.orders o
      SET    review_invited_at = now()
      WHERE  public._review_invite_due(o)
      RETURNING o.id, COALESCE(o.checkout_group_id, o.id) AS grp
    )
    SELECT array_agg(id) FROM stamped GROUP BY grp
  LOOP
    PERFORM net.http_post(
      url                  := 'https://cvqzidqnwthzfodhzepz.supabase.co/functions/v1/offer-notify',
      body                 := jsonb_build_object('type', 'REVIEW_INVITE', 'order_ids', to_jsonb(v_ids)),
      headers              := jsonb_build_object(
                                'Content-Type',      'application/json',
                                'x-reminder-secret', v_secret
                              ),
      timeout_milliseconds := 10000
    );
    v_queued := v_queued + 1;
  END LOOP;

  RAISE NOTICE '[send_review_invites] done: % emails queued', v_queued;
  RETURN v_queued;
END;
$$;

REVOKE ALL     ON FUNCTION public.send_review_invites() FROM PUBLIC, anon, authenticated;
GRANT  EXECUTE ON FUNCTION public.send_review_invites() TO service_role;
GRANT  EXECUTE ON FUNCTION public.send_review_invites() TO postgres;

DO $$
BEGIN
  PERFORM cron.unschedule('gemworkers_review_invites');
EXCEPTION
  WHEN OTHERS THEN
    NULL;
END;
$$;

SELECT cron.schedule(
  'gemworkers_review_invites',
  '*/15 * * * *',
  $$
    SELECT public.send_review_invites();
  $$
);

COMMIT;


-- =============================================================================
-- VERIFICATION (read-only)
-- =============================================================================
--   SELECT policyname, cmd FROM pg_policies WHERE tablename = 'reviews';
--   SELECT id, public, file_size_limit FROM storage.buckets WHERE id = 'review-photos';
--   SELECT jobname, schedule, active FROM cron.job WHERE jobname = 'gemworkers_review_invites';
--   SELECT count(*) FILTER (WHERE review_invited_at IS NOT NULL) FROM orders;
-- =============================================================================
