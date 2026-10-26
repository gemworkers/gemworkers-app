-- =============================================================================
-- GemWorkers — Sales per channel (which platform brings buyers)
-- =============================================================================
-- Applied to live DB 2026-10-26
--
-- Zakaria 2026-10-26. No cookies: the store recognises a buyer as the same
-- anonymous visitor (daily code, sql/page_views.sql) only on the day of the
-- visit. At checkout / when an offer is made, the store looks up where that
-- visitor came from today (first non-direct source, else 'direct') and saves
-- it on the order (orders.source) or the offer (storefront_offers.source).
-- An accepted offer's order takes the offer's source.
-- sales_by_source(from, to, seller) — runs with the caller's rights (owner:
-- everything, seller: own orders) — paid orders and revenue per source.
-- =============================================================================

BEGIN;

ALTER TABLE public.orders            ADD COLUMN IF NOT EXISTS source text CHECK (source IS NULL OR length(source) <= 30);
ALTER TABLE public.storefront_offers ADD COLUMN IF NOT EXISTS source text CHECK (source IS NULL OR length(source) <= 30);

-- Accepted offer → its order carries the source noted when the offer was made.
CREATE OR REPLACE FUNCTION public._order_source_from_offer()
RETURNS trigger
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public, pg_temp
AS $$
BEGIN
  IF NEW.offer_id IS NOT NULL AND NEW.source IS NULL THEN
    SELECT source INTO NEW.source FROM storefront_offers WHERE id = NEW.offer_id;
  END IF;
  RETURN NEW;
END;
$$;
REVOKE ALL ON FUNCTION public._order_source_from_offer() FROM PUBLIC, anon, authenticated;
DROP TRIGGER IF EXISTS orders_source_from_offer ON public.orders;
CREATE TRIGGER orders_source_from_offer BEFORE INSERT ON public.orders
  FOR EACH ROW EXECUTE FUNCTION public._order_source_from_offer();

CREATE OR REPLACE FUNCTION public.sales_by_source(p_from date, p_to date, p_seller uuid DEFAULT NULL)
RETURNS json
LANGUAGE sql
STABLE
SECURITY INVOKER
SET search_path = public, pg_temp
AS $$
  SELECT coalesce(json_agg(x ORDER BY x.revenue DESC), '[]') FROM (
    SELECT coalesce(source, 'unknown') AS source,
           count(*) AS orders,
           round(sum(order_total), 2) AS revenue
    FROM   orders
    WHERE  sale_channel = 'platform'
      AND  status IN ('paid', 'confirmed', 'shipped', 'received')
      AND  (coalesce(paid_at, order_date) AT TIME ZONE 'Europe/Amsterdam')::date >= p_from
      AND  (coalesce(paid_at, order_date) AT TIME ZONE 'Europe/Amsterdam')::date <  p_to
      AND  (p_seller IS NULL OR seller_id = p_seller)
    GROUP BY 1
  ) x;
$$;
REVOKE ALL ON FUNCTION public.sales_by_source(date, date, uuid) FROM PUBLIC, anon;
GRANT EXECUTE ON FUNCTION public.sales_by_source(date, date, uuid) TO authenticated;

COMMIT;
