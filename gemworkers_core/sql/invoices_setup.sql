-- =============================================================================
-- GemWorkers — Invoices & credit notes (tax plan step 4a)
-- =============================================================================
-- Applied to live DB 2026-10-24
--
-- • One invoice per paid platform order, one credit note per refunded return.
--   Numbers: ONE gapless series per year, GW-2026-00001, GW-2026-00002 …
--   (a row-locked counter, not a sequence — sequences can skip numbers).
-- • Each invoice stores a frozen snapshot (data jsonb): GemWorkers' company
--   details at that moment (store_settings company_*), the buyer, the lines,
--   VAT and the VAT note. Invoices can never be changed or deleted (trigger);
--   corrections go through credit notes.
-- • Never the supplier/seller identity — only "Shipped from {country}".
-- • VAT notes (ACCOUNTANT REVIEW):
--     domestic       NL VAT
--     oss            VAT of the buyer's EU country (OSS)
--     reverse_charge "VAT reverse charged" + both VAT numbers
--     NL → outside EU  "0% VAT — export"
--     TH / PK origin   no Dutch VAT; import taxes paid by the buyer
--   Diamonds get the Kimberley / System of Warranties statement.
-- • Issued by the Stripe webhook after the address is saved (service role),
--   with a 10-minute catch-up cron; the owner may also issue one.
-- • Buyers read their own via buyer_invoices; owner reads all.
-- =============================================================================

BEGIN;

-- 1. Counter + table ----------------------------------------------------------
CREATE TABLE IF NOT EXISTS public.invoice_counters (
  year        integer PRIMARY KEY,
  last_number integer NOT NULL DEFAULT 0
);
ALTER TABLE public.invoice_counters ENABLE ROW LEVEL SECURITY;   -- no policies: functions only

CREATE TABLE IF NOT EXISTS public.invoices (
  id          uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  number      text NOT NULL UNIQUE,
  kind        text NOT NULL CHECK (kind IN ('invoice','credit_note')),
  order_id    uuid NOT NULL REFERENCES public.orders(id),
  return_id   uuid REFERENCES public.returns(id),
  issued_at   timestamptz NOT NULL DEFAULT now(),
  net_amount  numeric(10,2) NOT NULL,     -- excl. VAT (negative on credit notes)
  tax_amount  numeric(10,2) NOT NULL,
  total       numeric(10,2) NOT NULL,
  tax_scheme  text,
  ship_to_country text,
  data        jsonb NOT NULL
);
CREATE UNIQUE INDEX IF NOT EXISTS invoices_one_per_order
  ON public.invoices (order_id) WHERE kind = 'invoice';
CREATE UNIQUE INDEX IF NOT EXISTS invoices_one_per_return
  ON public.invoices (return_id) WHERE kind = 'credit_note';
CREATE INDEX IF NOT EXISTS invoices_issued_idx ON public.invoices (issued_at);

ALTER TABLE public.invoices ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS invoices_owner_select ON public.invoices;
CREATE POLICY invoices_owner_select ON public.invoices
  FOR SELECT TO authenticated USING (public.is_owner());
REVOKE INSERT, UPDATE, DELETE ON public.invoices FROM anon, authenticated;

-- Invoices are permanent.
CREATE OR REPLACE FUNCTION public._invoices_immutable()
RETURNS trigger
LANGUAGE plpgsql
AS $$
BEGIN
  RAISE EXCEPTION 'Invoices can''t be changed or deleted — issue a credit note instead.';
END;
$$;
DROP TRIGGER IF EXISTS invoices_immutable ON public.invoices;
CREATE TRIGGER invoices_immutable
  BEFORE UPDATE OR DELETE ON public.invoices
  FOR EACH ROW EXECUTE FUNCTION public._invoices_immutable();

-- Buyer view: own invoices only.
DROP VIEW IF EXISTS public.buyer_invoices;
CREATE VIEW public.buyer_invoices WITH (security_invoker = false) AS
SELECT i.id, i.order_id, i.number, i.kind, i.issued_at, i.total, i.data
FROM   public.invoices i
JOIN   public.orders o ON o.id = i.order_id
WHERE  o.buyer_id = auth.uid();
REVOKE ALL ON public.buyer_invoices FROM anon;
GRANT SELECT ON public.buyer_invoices TO authenticated;

-- 2. Helpers --------------------------------------------------------------------
CREATE OR REPLACE FUNCTION public._next_invoice_number()
RETURNS text
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public, pg_temp
AS $$
DECLARE
  v_year integer := extract(year FROM now() AT TIME ZONE 'Europe/Amsterdam')::integer;
  v_n    integer;
BEGIN
  INSERT INTO public.invoice_counters (year, last_number) VALUES (v_year, 0)
  ON CONFLICT (year) DO NOTHING;
  UPDATE public.invoice_counters SET last_number = last_number + 1
  WHERE  year = v_year
  RETURNING last_number INTO v_n;               -- row lock: no gaps, no doubles
  RETURN 'GW-' || v_year || '-' || lpad(v_n::text, 5, '0');
END;
$$;

-- Only the service role (webhook), pg_cron or the owner may issue documents.
CREATE OR REPLACE FUNCTION public._may_issue_invoices()
RETURNS boolean
LANGUAGE sql
STABLE
SET search_path = public, pg_temp
AS $$
  SELECT session_user <> 'authenticator'
      OR coalesce(auth.role(), '') = 'service_role'
      OR public.is_owner();
$$;

CREATE OR REPLACE FUNCTION public._company_snapshot()
RETURNS jsonb
LANGUAGE sql
STABLE
SECURITY DEFINER
SET search_path = public, pg_temp
AS $$
  SELECT jsonb_build_object(
    'name',    coalesce((SELECT value FROM public.store_settings WHERE key = 'company_name'), 'GemWorkers'),
    'address', (SELECT value FROM public.store_settings WHERE key = 'company_address'),
    'kvk',     (SELECT value FROM public.store_settings WHERE key = 'company_kvk'),
    'vat',     (SELECT value FROM public.store_settings WHERE key = 'company_vat'),
    'email',   coalesce((SELECT value FROM public.store_settings WHERE key = 'company_email'), 'hello@gemworkers.com')
  );
$$;

-- 3. Issue an invoice for a paid order (idempotent) --------------------------
CREATE OR REPLACE FUNCTION public.issue_invoice(p_order_id uuid)
RETURNS uuid
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public, pg_temp
AS $$
DECLARE
  o          record;
  it         record;
  v_id       uuid;
  v_origin   text;
  v_from     text;
  v_to       text;
  v_note     text;
  v_diamond  boolean;
  v_goods    numeric;
  v_ship     numeric;
BEGIN
  IF NOT public._may_issue_invoices() THEN RAISE EXCEPTION 'Not allowed'; END IF;

  SELECT id INTO v_id FROM public.invoices WHERE order_id = p_order_id AND kind = 'invoice';
  IF v_id IS NOT NULL THEN RETURN v_id; END IF;

  SELECT * INTO o FROM public.orders WHERE id = p_order_id FOR UPDATE;
  IF o.id IS NULL OR o.sale_channel <> 'platform' OR o.paid_at IS NULL
     OR o.status IN ('draft','pending_payment','cancelled') THEN
    RAISE EXCEPTION 'Only paid store orders get an invoice.';
  END IF;

  SELECT i.title, i.sku, i.product_type, i.gem_type, i.weight_value, i.weight_unit
  INTO   it
  FROM   public.order_items oi JOIN public.inventory_items i ON i.id = oi.inventory_item_id
  WHERE  oi.order_id = o.id LIMIT 1;

  SELECT s.country INTO v_origin FROM public.sellers s WHERE s.id = o.seller_id;
  SELECT name INTO v_from FROM public.shipping_countries WHERE code = v_origin;
  SELECT name INTO v_to   FROM public.shipping_countries WHERE code = coalesce(o.ship_to_country, o.shipping_country);

  v_ship  := coalesce(o.shipping_cost, 0);
  v_goods := o.order_total - v_ship;
  v_diamond := coalesce(it.gem_type, '') ILIKE '%diamond%' OR coalesce(it.title, '') ILIKE '%diamond%';

  v_note := CASE
    WHEN o.tax_scheme = 'reverse_charge' THEN
      'VAT reverse charged — intra-Community supply of goods (Article 138 EU VAT Directive). Customer VAT number: '
      || coalesce(o.buyer_vat_number, '—') || '.'
    WHEN o.tax_scheme = 'oss' THEN
      'VAT charged at the rate of ' || coalesce(v_to, o.ship_to_country, 'the customer''s country') || ' (EU One-Stop-Shop).'
    WHEN o.tax_scheme = 'domestic' THEN NULL
    WHEN v_origin = 'NL' THEN
      '0% VAT — export of goods outside the EU. Import taxes and duties, if any, are paid by the customer.'
    ELSE
      'Shipped from ' || coalesce(v_from, v_origin, 'outside the EU') || ' — no Dutch VAT. Import taxes and duties, if any, are paid by the customer on delivery.'
  END;

  INSERT INTO public.invoices (number, kind, order_id, net_amount, tax_amount, total, tax_scheme, ship_to_country, data)
  VALUES (
    public._next_invoice_number(), 'invoice', o.id,
    o.order_total, o.tax_amount, o.order_total + o.tax_amount, o.tax_scheme,
    coalesce(o.ship_to_country, o.shipping_country),
    jsonb_build_object(
      'company', public._company_snapshot(),
      'order_number', o.order_number,
      'supply_date', to_char(o.paid_at AT TIME ZONE 'Europe/Amsterdam', 'YYYY-MM-DD'),
      'customer', jsonb_build_object(
        'type',     coalesce(o.customer_type, 'private'),
        'name',     o.shipping_name,
        'company',  o.buyer_company,
        'vat',      o.buyer_vat_number,
        'vat_verified', o.vat_verified,
        'vies_reference', o.vies_reference,
        'address',  concat_ws(E'\n', o.shipping_line1, o.shipping_line2,
                              concat_ws(' ', o.shipping_postal_code, o.shipping_city), o.shipping_state, v_to),
        'country',  coalesce(o.ship_to_country, o.shipping_country),
        'email',    o.order_email
      ),
      'ships_from', v_from,
      'lines', jsonb_build_array(
        jsonb_build_object('description', coalesce(it.title, 'Gemstone'),
                           'detail', concat_ws(' · ', it.sku,
                                               CASE WHEN it.weight_value IS NOT NULL
                                                    THEN it.weight_value::text || ' ' || coalesce(it.weight_unit, '') END),
                           'quantity', 1, 'amount', v_goods)
      ) || CASE WHEN v_ship > 0
                THEN jsonb_build_array(jsonb_build_object('description', 'Shipping', 'quantity', 1, 'amount', v_ship))
                ELSE '[]'::jsonb END,
      'tax_name', o.tax_name,
      'tax_rate', o.tax_rate,
      'vat_note', v_note,
      'diamond_statement', CASE WHEN v_diamond THEN
        'The diamonds herein invoiced have been purchased from legitimate sources not involved in funding conflict and in compliance with United Nations resolutions. The seller hereby guarantees that these diamonds are conflict free, based on personal knowledge and/or written guarantees provided by the supplier of these diamonds.'
        END,
      'currency', 'EUR'
    )
  )
  RETURNING id INTO v_id;
  RETURN v_id;
END;
$$;

-- 4. Credit note for a refunded return (idempotent) -------------------------
CREATE OR REPLACE FUNCTION public.issue_credit_note(p_return_id uuid)
RETURNS uuid
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public, pg_temp
AS $$
DECLARE
  r     record;
  inv   record;
  v_id  uuid;
  v_net numeric;
BEGIN
  IF NOT public._may_issue_invoices() THEN RAISE EXCEPTION 'Not allowed'; END IF;

  SELECT id INTO v_id FROM public.invoices WHERE return_id = p_return_id AND kind = 'credit_note';
  IF v_id IS NOT NULL THEN RETURN v_id; END IF;

  SELECT * INTO r FROM public.returns WHERE id = p_return_id AND status = 'refunded';
  IF r.id IS NULL THEN RAISE EXCEPTION 'Only a refunded return gets a credit note.'; END IF;

  SELECT * INTO inv FROM public.invoices WHERE order_id = r.order_id AND kind = 'invoice';
  IF inv.id IS NULL THEN
    RETURN NULL;     -- order was never invoiced (e.g. before invoices existed)
  END IF;

  v_net := r.refund_amount - coalesce(r.refund_tax, 0);

  INSERT INTO public.invoices (number, kind, order_id, return_id, net_amount, tax_amount, total, tax_scheme, ship_to_country, data)
  VALUES (
    public._next_invoice_number(), 'credit_note', r.order_id, r.id,
    -v_net, -coalesce(r.refund_tax, 0), -r.refund_amount, inv.tax_scheme, inv.ship_to_country,
    (inv.data - 'lines' - 'diamond_statement') || jsonb_build_object(
      'company', public._company_snapshot(),
      'credits_invoice', inv.number,
      'supply_date', to_char(r.refunded_at AT TIME ZONE 'Europe/Amsterdam', 'YYYY-MM-DD'),
      'lines', jsonb_build_array(jsonb_build_object(
        'description', 'Return — credit for invoice ' || inv.number,
        'detail', CASE WHEN r.deduction > 0
                       THEN 'Deduction ' || r.deduction::text || ' EUR: ' || coalesce(r.deduction_reason, '') END,
        'quantity', 1, 'amount', -v_net))
    )
  )
  RETURNING id INTO v_id;
  RETURN v_id;
END;
$$;

REVOKE ALL ON FUNCTION public._next_invoice_number() FROM PUBLIC, anon, authenticated;
REVOKE ALL ON FUNCTION public._may_issue_invoices() FROM PUBLIC, anon;
REVOKE ALL ON FUNCTION public._company_snapshot() FROM PUBLIC, anon, authenticated;
REVOKE ALL ON FUNCTION public.issue_invoice(uuid) FROM PUBLIC, anon;
REVOKE ALL ON FUNCTION public.issue_credit_note(uuid) FROM PUBLIC, anon;
GRANT EXECUTE ON FUNCTION public.issue_invoice(uuid) TO authenticated, service_role;
GRANT EXECUTE ON FUNCTION public.issue_credit_note(uuid) TO authenticated, service_role;

-- 5. Credit note automatically when a return is refunded ---------------------
CREATE OR REPLACE FUNCTION public._return_credit_note()
RETURNS trigger
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public, pg_temp
AS $$
BEGIN
  IF NEW.status = 'refunded' AND OLD.status IS DISTINCT FROM 'refunded' THEN
    BEGIN
      PERFORM public.issue_credit_note(NEW.id);
    EXCEPTION WHEN OTHERS THEN
      RAISE WARNING '[credit note] return % failed: %', NEW.id, SQLERRM;
    END;
  END IF;
  RETURN NEW;
END;
$$;
REVOKE ALL ON FUNCTION public._return_credit_note() FROM PUBLIC, anon, authenticated;

DROP TRIGGER IF EXISTS returns_credit_note ON public.returns;
CREATE TRIGGER returns_credit_note
  AFTER UPDATE OF status ON public.returns
  FOR EACH ROW EXECUTE FUNCTION public._return_credit_note();

-- 6. Catch-up: paid orders without an invoice (from today on) ----------------
CREATE OR REPLACE FUNCTION public.issue_missing_invoices()
RETURNS integer
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public, pg_temp
AS $$
DECLARE
  o   record;
  n   integer := 0;
BEGIN
  FOR o IN
    SELECT ord.id FROM public.orders ord
    WHERE  ord.sale_channel = 'platform'
      AND  ord.paid_at IS NOT NULL
      AND  ord.paid_at >= '2026-10-24'
      AND  ord.paid_at < now() - interval '5 minutes'
      AND  ord.status NOT IN ('draft','pending_payment','cancelled')
      AND  NOT EXISTS (SELECT 1 FROM public.invoices i WHERE i.order_id = ord.id AND i.kind = 'invoice')
  LOOP
    BEGIN
      PERFORM public.issue_invoice(o.id);
      n := n + 1;
    EXCEPTION WHEN OTHERS THEN
      RAISE WARNING '[invoices] order % failed: %', o.id, SQLERRM;
    END;
  END LOOP;
  RETURN n;
END;
$$;
REVOKE ALL ON FUNCTION public.issue_missing_invoices() FROM PUBLIC, anon, authenticated;

SELECT cron.unschedule('gemworkers_missing_invoices')
WHERE  EXISTS (SELECT 1 FROM cron.job WHERE jobname = 'gemworkers_missing_invoices');
SELECT cron.schedule(
  'gemworkers_missing_invoices',
  '*/10 * * * *',
  $$
    SELECT public.issue_missing_invoices();
  $$
);

COMMIT;

-- VERIFICATION (read-only):
--   SELECT number, kind, total FROM invoices ORDER BY issued_at;
--   SELECT * FROM invoice_counters;
