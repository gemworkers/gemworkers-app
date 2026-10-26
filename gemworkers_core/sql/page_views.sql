-- =============================================================================
-- GemWorkers — Anonymous views & visits (no cookies, no personal data)
-- =============================================================================
-- Applied to live DB 2026-10-26
--
-- Zakaria 2026-10-26. Every real visitor of the store counts (account or not);
-- staff (owner / sellers logged in) and bots don't. One row per page opened:
--   views  = rows (stone page opens per stone)
--   visits = distinct visitor codes per day — the code is a hash of
--            (daily secret, IP, browser) made by the store server; it changes
--            every day, the IP is never stored, nothing is stored on the
--            visitor's device (no cookie banner needed).
-- Also: where they came from (source) and country. Written only by the store
-- server (service role). Read: owner everything, a seller only rows of their
-- own stones (seller_id set from the stone). Kept 13 months (daily clean-up).
-- =============================================================================

BEGIN;

CREATE TABLE IF NOT EXISTS public.page_views (
  id                bigserial PRIMARY KEY,
  at                timestamptz NOT NULL DEFAULT now(),
  day               date NOT NULL DEFAULT (now() AT TIME ZONE 'Europe/Amsterdam')::date,
  path              text NOT NULL CHECK (length(path) <= 300),
  inventory_item_id uuid REFERENCES public.inventory_items(id) ON DELETE SET NULL,
  seller_id         uuid,
  visitor           text NOT NULL CHECK (length(visitor) BETWEEN 8 AND 64),
  source            text NOT NULL DEFAULT 'direct' CHECK (length(source) <= 30),
  country           text CHECK (country IS NULL OR country ~ '^[A-Z]{2}$')
);
CREATE INDEX IF NOT EXISTS page_views_day ON public.page_views (day);
CREATE INDEX IF NOT EXISTS page_views_item_day ON public.page_views (inventory_item_id, day);
CREATE INDEX IF NOT EXISTS page_views_seller_day ON public.page_views (seller_id, day);

-- The stone's seller, so sellers can read their own stones' numbers.
CREATE OR REPLACE FUNCTION public._page_view_seller()
RETURNS trigger
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public, pg_temp
AS $$
BEGIN
  IF NEW.inventory_item_id IS NOT NULL THEN
    SELECT seller_id INTO NEW.seller_id FROM inventory_items WHERE id = NEW.inventory_item_id;
  END IF;
  RETURN NEW;
END;
$$;
REVOKE ALL ON FUNCTION public._page_view_seller() FROM PUBLIC, anon, authenticated;
DROP TRIGGER IF EXISTS page_views_seller ON public.page_views;
CREATE TRIGGER page_views_seller BEFORE INSERT ON public.page_views
  FOR EACH ROW EXECUTE FUNCTION public._page_view_seller();

ALTER TABLE public.page_views ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS page_views_read ON public.page_views;
CREATE POLICY page_views_read ON public.page_views FOR SELECT TO authenticated
  USING (public.is_owner() OR (seller_id IS NOT NULL AND seller_id = public.current_seller_id()));
REVOKE ALL ON public.page_views FROM anon, authenticated;
GRANT SELECT ON public.page_views TO authenticated;

-- ── Numbers for the admin (runs with the caller's rights → RLS applies) ─────
-- p_seller: owner may pick one seller (NULL = whole shop); for a seller the
-- RLS already limits it to their own stones.
CREATE OR REPLACE FUNCTION public.page_view_stats(p_from date, p_to date, p_seller uuid DEFAULT NULL)
RETURNS json
LANGUAGE sql
STABLE
SECURITY INVOKER
SET search_path = public, pg_temp
AS $$
  WITH v AS (
    SELECT * FROM page_views
    WHERE day >= p_from AND day < p_to
      AND (p_seller IS NULL OR seller_id = p_seller)
  )
  SELECT json_build_object(
    'views',  (SELECT count(*) FROM v WHERE inventory_item_id IS NOT NULL),
    'pages',  (SELECT count(*) FROM v),
    'visits', (SELECT count(DISTINCT (day, visitor)) FROM v),
    'sources', (SELECT coalesce(json_agg(x ORDER BY x.visits DESC), '[]') FROM (
        SELECT source, count(DISTINCT (day, visitor)) AS visits FROM v GROUP BY source) x),
    'countries', (SELECT coalesce(json_agg(x ORDER BY x.visits DESC), '[]') FROM (
        SELECT country, count(DISTINCT (day, visitor)) AS visits FROM v
        WHERE country IS NOT NULL GROUP BY country ORDER BY 2 DESC LIMIT 8) x)
  );
$$;
REVOKE ALL ON FUNCTION public.page_view_stats(date, date, uuid) FROM PUBLIC, anon;
GRANT EXECUTE ON FUNCTION public.page_view_stats(date, date, uuid) TO authenticated;

-- Views per stone (last 30 days + all time) for the Listings cards.
CREATE OR REPLACE FUNCTION public.stone_view_counts()
RETURNS TABLE (inventory_item_id uuid, views_30d bigint, views_total bigint)
LANGUAGE sql
STABLE
SECURITY INVOKER
SET search_path = public, pg_temp
AS $$
  SELECT inventory_item_id,
         count(*) FILTER (WHERE day >= (now() AT TIME ZONE 'Europe/Amsterdam')::date - 29),
         count(*)
  FROM page_views
  WHERE inventory_item_id IS NOT NULL
  GROUP BY inventory_item_id;
$$;
REVOKE ALL ON FUNCTION public.stone_view_counts() FROM PUBLIC, anon;
GRANT EXECUTE ON FUNCTION public.stone_view_counts() TO authenticated;

-- ── Keep 13 months ──────────────────────────────────────────────────────────
SELECT cron.unschedule('gemworkers_page_views_cleanup')
WHERE EXISTS (SELECT 1 FROM cron.job WHERE jobname = 'gemworkers_page_views_cleanup');
SELECT cron.schedule('gemworkers_page_views_cleanup', '23 3 * * *',
  $$DELETE FROM public.page_views WHERE day < (now() AT TIME ZONE 'Europe/Amsterdam')::date - interval '13 months'$$);

COMMIT;
