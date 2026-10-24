-- =============================================================================
-- GemWorkers — Quarterly tax report (tax plan step 4b)
-- =============================================================================
-- Applied to live DB 2026-10-24
--
-- tax_report(year, quarter) → jsonb, owner only. Built from invoices AND
-- credit notes (sql/invoices_setup.sql) dated in the quarter (Amsterdam time),
-- so a refund lowers the quarter its credit note falls in.
--
-- Each document goes into exactly one bucket (ACCOUNTANT REVIEW):
--   domestic        NL VAT 21%                → Dutch return box 1a
--   eu_b2b          reverse charge, NL → EU   → Dutch return box 3b + ICP list
--   export          NL → outside the EU, 0%   → Dutch return box 3a
--   oss             NL → EU consumer          → OSS return (per country/rate)
--   outside_nl      shipped from TH / PK      → not in the Dutch return
--                                               (supply outside NL) — bookkeeping only
-- Origin = the order's seller country; EU = tax_rules.customs_union 'EU'.
-- Amounts are exact cents; the Dutch return asks for whole euros.
-- Deadline: the last day of the month after the quarter (VAT, OSS and ICP).
-- =============================================================================

BEGIN;

CREATE OR REPLACE FUNCTION public.tax_report(p_year integer, p_quarter integer)
RETURNS jsonb
LANGUAGE plpgsql
STABLE
SECURITY DEFINER
SET search_path = public, pg_temp
AS $$
DECLARE
  v_first date;          -- first day of the quarter
  v_next  date;          -- first day of the next quarter
  v_from  timestamptz;
  v_to    timestamptz;
  v_out   jsonb;
BEGIN
  IF NOT public.is_owner() THEN RAISE EXCEPTION 'Owner only'; END IF;
  IF p_quarter NOT BETWEEN 1 AND 4 OR p_year NOT BETWEEN 2024 AND 2100 THEN
    RAISE EXCEPTION 'Choose a year and a quarter 1–4.';
  END IF;

  -- Calendar dates first (adding months to a UTC timestamp can land on the
  -- 30th), then midnight Amsterdam time.
  v_first := make_date(p_year, (p_quarter - 1) * 3 + 1, 1);
  v_next  := (v_first + interval '3 months')::date;
  v_from  := v_first::timestamp AT TIME ZONE 'Europe/Amsterdam';
  v_to    := v_next::timestamp  AT TIME ZONE 'Europe/Amsterdam';

  WITH docs AS (
    SELECT i.id, i.number, i.kind, i.issued_at, i.net_amount, i.tax_amount, i.total,
           i.tax_scheme, i.ship_to_country AS dest,
           s.country AS origin,
           (SELECT t.customs_union FROM public.tax_rules t WHERE t.country_code = i.ship_to_country) AS dest_union,
           o.order_number,
           i.data->'customer'->>'vat'     AS buyer_vat,
           i.data->'customer'->>'company' AS buyer_company,
           (i.data->>'tax_rate')::numeric AS rate
    FROM   public.invoices i
    JOIN   public.orders o ON o.id = i.order_id
    LEFT JOIN public.sellers s ON s.id = o.seller_id
    WHERE  i.issued_at >= v_from AND i.issued_at < v_to
  ),
  b AS (
    SELECT d.*,
      CASE
        WHEN d.tax_scheme = 'domestic'       THEN 'domestic'
        WHEN d.tax_scheme = 'reverse_charge' THEN 'eu_b2b'
        WHEN d.tax_scheme = 'oss'            THEN 'oss'
        WHEN d.origin = 'NL' AND coalesce(d.dest_union, '') <> 'EU' THEN 'export'
        ELSE 'outside_nl'
      END AS bucket
    FROM docs d
  )
  SELECT jsonb_build_object(
    'year', p_year,
    'quarter', p_quarter,
    'from', to_char(v_first, 'YYYY-MM-DD'),
    'to',   to_char(v_next - 1, 'YYYY-MM-DD'),
    'deadline', to_char((v_next + interval '1 month')::date - 1, 'YYYY-MM-DD'),
    'invoices', (SELECT count(*) FROM b WHERE kind = 'invoice'),
    'credit_notes', (SELECT count(*) FROM b WHERE kind = 'credit_note'),
    'buckets', coalesce((
      SELECT jsonb_object_agg(bucket, jsonb_build_object('net', net, 'vat', vat, 'count', n))
      FROM (SELECT bucket, sum(net_amount) net, sum(tax_amount) vat, count(*) n FROM b GROUP BY bucket) x
    ), '{}'::jsonb),
    'oss', coalesce((
      SELECT jsonb_agg(jsonb_build_object('country', dest, 'name', name, 'rate', rate, 'net', net, 'vat', vat) ORDER BY dest, rate)
      FROM (
        SELECT b.dest, c.name, b.rate, sum(b.net_amount) net, sum(b.tax_amount) vat
        FROM   b LEFT JOIN public.shipping_countries c ON c.code = b.dest
        WHERE  b.bucket = 'oss'
        GROUP  BY b.dest, c.name, b.rate
      ) x
    ), '[]'::jsonb),
    'icp', coalesce((
      SELECT jsonb_agg(jsonb_build_object('vat', buyer_vat, 'country', dest, 'company', company, 'amount', amount) ORDER BY buyer_vat)
      FROM (
        SELECT buyer_vat, dest, max(buyer_company) company, sum(net_amount) amount
        FROM   b WHERE bucket = 'eu_b2b'
        GROUP  BY buyer_vat, dest
      ) x
    ), '[]'::jsonb),
    'documents', coalesce((
      SELECT jsonb_agg(jsonb_build_object(
               'number', number, 'kind', kind,
               'date', to_char(issued_at AT TIME ZONE 'Europe/Amsterdam', 'YYYY-MM-DD'),
               'order', order_number, 'bucket', bucket, 'from', origin, 'to', dest,
               'buyer_vat', buyer_vat, 'rate', rate,
               'net', net_amount, 'vat', tax_amount, 'total', total) ORDER BY number)
      FROM b
    ), '[]'::jsonb)
  )
  INTO v_out;

  RETURN v_out;
END;
$$;

REVOKE ALL ON FUNCTION public.tax_report(integer, integer) FROM PUBLIC, anon;
GRANT EXECUTE ON FUNCTION public.tax_report(integer, integer) TO authenticated;

COMMIT;

-- VERIFICATION (as owner, e.g. in the admin): SELECT tax_report(2026, 4);
