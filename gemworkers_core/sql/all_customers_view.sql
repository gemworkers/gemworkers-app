-- =============================================================================
-- GemWorkers — all_customers view (manual customers + website buyers)
-- =============================================================================
-- Applied to live DB 2026-10-20 and verified
--
-- 1. Catch-up: the shipping / contact columns the Stripe webhook writes on
--    orders (gemworkers_store/app/api/stripe/webhook/route.ts) were added to
--    the live DB without a migration here. ADD COLUMN IF NOT EXISTS → no-op
--    where they already exist.
-- 2. public.all_customers — one read-only list for the admin Customers page:
--      manual  : customers (in-person / Whatnot sales), stats as stored by
--                handle_sale_customer()
--      website : buyers (storefront accounts), stats computed from their
--                orders (buyer_id) in confirmed / shipped / received / paid
-- 3. security_invoker = true → the caller's RLS applies to customers, buyers
--    and orders. Owner (is_owner()) sees every row; sellers and buyers get
--    no manual rows (no customers policy) and at most their own buyer row.
-- =============================================================================

BEGIN;

-- ── 1. Catch-up: webhook-written columns on orders ───────────────────────────
ALTER TABLE public.orders
  ADD COLUMN IF NOT EXISTS shipping_name        text,
  ADD COLUMN IF NOT EXISTS shipping_line1       text,
  ADD COLUMN IF NOT EXISTS shipping_line2       text,
  ADD COLUMN IF NOT EXISTS shipping_city        text,
  ADD COLUMN IF NOT EXISTS shipping_state       text,
  ADD COLUMN IF NOT EXISTS shipping_postal_code text,
  ADD COLUMN IF NOT EXISTS shipping_country     text,
  ADD COLUMN IF NOT EXISTS shipping_phone       text,
  ADD COLUMN IF NOT EXISTS order_email          text;

-- ── 2. View ──────────────────────────────────────────────────────────────────
CREATE OR REPLACE VIEW public.all_customers
WITH (security_invoker = true) AS
SELECT
  'manual'::text                 AS source,
  c.id,
  c.name,
  c.email,
  c.country,
  c.order_count,
  c.total_spent,
  c.last_order_date::timestamptz AS last_order_at,
  c.created_at
FROM public.customers c

UNION ALL

SELECT
  'website'::text                                          AS source,
  b.id,
  COALESCE(NULLIF(b.display_name, ''), latest.shipping_name, b.email) AS name,
  b.email,
  COALESCE(latest.shipping_country, '')                    AS country,
  COALESCE(stats.order_count, 0)::integer                  AS order_count,
  COALESCE(stats.total_spent, 0)::numeric(14,2)            AS total_spent,
  stats.last_order_at,
  b.created_at
FROM public.buyers b
-- Counted orders: one aggregate row per buyer (zeros when none).
LEFT JOIN LATERAL (
  SELECT count(*)                               AS order_count,
         sum(o.order_total)                     AS total_spent,
         max(COALESCE(o.paid_at, o.created_at)) AS last_order_at
  FROM   public.orders o
  WHERE  o.buyer_id = b.id
    AND  o.status IN ('confirmed', 'shipped', 'received', 'paid')
) stats ON true
-- Name / country from the most recent order that has a Stripe shipping name.
LEFT JOIN LATERAL (
  SELECT o.shipping_name, o.shipping_country
  FROM   public.orders o
  WHERE  o.buyer_id = b.id
    AND  NULLIF(o.shipping_name, '') IS NOT NULL
  ORDER  BY COALESCE(o.paid_at, o.created_at) DESC
  LIMIT  1
) latest ON true;

-- ── 3. Privileges ────────────────────────────────────────────────────────────
-- Supabase default privileges grant ALL on new public relations to anon and
-- authenticated; strip them and leave authenticated with SELECT only.
REVOKE ALL    ON public.all_customers FROM anon, authenticated;
GRANT  SELECT ON public.all_customers TO authenticated;

COMMIT;
