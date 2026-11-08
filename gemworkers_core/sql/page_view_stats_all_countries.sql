-- Applied to live DB 2026-11-08.
-- page_view_stats: return ALL countries (was top 8), so a country seen on a
-- short period (e.g. Singapore today) also shows on a longer one (30 days).
-- The admin shows the top 10 and "Show all N countries".
-- Same definition as sql/page_views.sql, only "LIMIT 8" removed.
BEGIN;

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
    'countries', (SELECT coalesce(json_agg(x ORDER BY x.visits DESC, x.country), '[]') FROM (
        SELECT country, count(DISTINCT (day, visitor)) AS visits FROM v
        WHERE country IS NOT NULL GROUP BY country) x)
  );
$$;
REVOKE ALL ON FUNCTION public.page_view_stats(date, date, uuid) FROM PUBLIC, anon;
GRANT EXECUTE ON FUNCTION public.page_view_stats(date, date, uuid) TO authenticated;

-- Check: should be false
SELECT prosrc LIKE '%LIMIT 8%' AS still_limited FROM pg_proc WHERE proname = 'page_view_stats';

COMMIT;
