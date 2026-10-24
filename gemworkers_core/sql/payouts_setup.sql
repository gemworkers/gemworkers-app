-- =============================================================================
-- GemWorkers — Payee balances, payout statements and chargebacks (part 3)
-- =============================================================================
-- Applied to live DB 2026-10-24
--
-- Payee = who receives money for a stone:
--   • a brother's seller account (his own sales, payout_kind 'commission'),
--     AND his stones held by Zakaria in NL (consignment, when his owner record
--     is linked to his seller account) — one balance per brother
--   • an outside owner (consignment, owner record without a seller account)
-- GemWorkers' own stones ('own') have no payee.
--
-- Balance = unpaid sales (seller_payout) − open owner_charges.
-- A sale is "ready to pay" when its return period is over: 30 days after
-- delivery (60 after shipping if delivery was never confirmed) and no open
-- return or chargeback. Zakaria may still include earlier sales.
--
-- create_payout (owner): picks sales + ALL open charges of that payee, marks
-- the sales paid (orders.payout_*), settles the charges, numbers the statement
-- PO-YYYY-NNNN and keeps a frozen copy (payouts.data). Refuses €0 or less.
--
-- Chargebacks (called by the Stripe webhook, service role):
--   opened → dispute fee charged to the payee; the sale can't be paid out
--   won    → returned fee credited back
--   lost   → treated as a full refund (record_order_refund: lost Stripe fee +
--            payout already paid charged, credit note, order 'refunded')
-- =============================================================================

BEGIN;

-- 1. Order chargeback state + payout link ----------------------------------
ALTER TABLE public.orders
  ADD COLUMN IF NOT EXISTS dispute_status text CHECK (dispute_status IS NULL OR dispute_status IN ('open','won','lost')),
  ADD COLUMN IF NOT EXISTS dispute_id     text,
  ADD COLUMN IF NOT EXISTS payout_id      uuid;

ALTER TABLE public.owner_charges ADD COLUMN IF NOT EXISTS payout_id  uuid;
ALTER TABLE public.owner_charges ADD COLUMN IF NOT EXISTS dispute_id text;

-- 2. Payouts ------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS public.payout_counters (
  year        integer PRIMARY KEY,
  last_number integer NOT NULL DEFAULT 0
);
ALTER TABLE public.payout_counters ENABLE ROW LEVEL SECURITY;

CREATE TABLE IF NOT EXISTS public.payouts (
  id             uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  number         text NOT NULL UNIQUE,
  seller_id      uuid REFERENCES public.sellers(id),
  consignor_id   uuid REFERENCES public.consignors(id),
  sales_total    numeric(10,2) NOT NULL,
  charges_total  numeric(10,2) NOT NULL,
  amount         numeric(10,2) NOT NULL CHECK (amount > 0),
  method         text,
  reference      text,
  note           text,
  paid_at        timestamptz NOT NULL DEFAULT now(),
  data           jsonb NOT NULL,
  CHECK ((seller_id IS NULL) <> (consignor_id IS NULL))
);
ALTER TABLE public.orders DROP CONSTRAINT IF EXISTS orders_payout_fk;
ALTER TABLE public.orders ADD CONSTRAINT orders_payout_fk FOREIGN KEY (payout_id) REFERENCES public.payouts(id);
ALTER TABLE public.owner_charges DROP CONSTRAINT IF EXISTS owner_charges_payout_fk;
ALTER TABLE public.owner_charges ADD CONSTRAINT owner_charges_payout_fk FOREIGN KEY (payout_id) REFERENCES public.payouts(id);

ALTER TABLE public.payouts ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS payouts_owner ON public.payouts;
CREATE POLICY payouts_owner ON public.payouts
  FOR SELECT TO authenticated USING (public.is_owner());
DROP POLICY IF EXISTS payouts_seller ON public.payouts;
CREATE POLICY payouts_seller ON public.payouts
  FOR SELECT TO authenticated USING (seller_id IS NOT NULL AND seller_id = public.current_seller_id());
REVOKE INSERT, UPDATE, DELETE ON public.payouts FROM anon, authenticated;

-- 3. Who gets paid for an order / a charge ----------------------------------
-- (payee_seller_id, payee_consignor_id): exactly one is set; brothers' NL
-- stones fold into their seller account.
CREATE OR REPLACE VIEW public.payout_lines WITH (security_invoker = true) AS
SELECT
  o.id AS order_id,
  o.order_number,
  o.paid_at,
  o.status,
  o.payout_kind,
  o.seller_payout AS amount,
  CASE WHEN o.payout_kind = 'commission' THEN o.seller_id ELSE c.seller_id END AS payee_seller_id,
  CASE WHEN o.payout_kind = 'consignment' AND c.seller_id IS NULL THEN o.consignor_id END AS payee_consignor_id,
  (
    o.dispute_status IS DISTINCT FROM 'open'
    AND NOT EXISTS (SELECT 1 FROM public.returns r WHERE r.order_id = o.id AND r.status IN ('requested','approved','received'))
    AND (    (o.received_at IS NOT NULL AND o.received_at < now() - interval '30 days')
          OR (o.received_at IS NULL AND o.shipped_at IS NOT NULL AND o.shipped_at < now() - interval '60 days'))
  ) AS ready,
  CASE
    WHEN o.dispute_status = 'open' THEN 'chargeback open'
    WHEN EXISTS (SELECT 1 FROM public.returns r WHERE r.order_id = o.id AND r.status IN ('requested','approved','received')) THEN 'return open'
    WHEN o.shipped_at IS NULL THEN 'not shipped yet'
    WHEN o.received_at IS NULL AND o.shipped_at >= now() - interval '60 days' THEN 'in return period'
    WHEN o.received_at >= now() - interval '30 days' THEN 'in return period'
    ELSE 'ready'
  END AS state,
  (SELECT i.title FROM public.order_items oi JOIN public.inventory_items i ON i.id = oi.inventory_item_id
    WHERE oi.order_id = o.id LIMIT 1) AS stone
FROM public.orders o
LEFT JOIN public.consignors c ON c.id = o.consignor_id
WHERE o.sale_channel = 'platform'
  AND o.payout_kind IN ('commission','consignment')
  AND o.paid_at IS NOT NULL
  AND o.status IN ('confirmed','shipped','received','paid')
  AND coalesce(o.payout_status, 'unpaid') <> 'paid';

CREATE OR REPLACE VIEW public.payout_open_charges WITH (security_invoker = true) AS
SELECT
  ch.id AS charge_id,
  ch.order_id,
  (SELECT order_number FROM public.orders WHERE id = ch.order_id) AS order_number,
  ch.amount,
  ch.reason,
  ch.created_at,
  coalesce(ch.seller_id, c.seller_id) AS payee_seller_id,
  CASE WHEN ch.consignor_id IS NOT NULL AND c.seller_id IS NULL THEN ch.consignor_id END AS payee_consignor_id
FROM public.owner_charges ch
LEFT JOIN public.consignors c ON c.id = ch.consignor_id
WHERE ch.settled_at IS NULL;

GRANT SELECT ON public.payout_lines, public.payout_open_charges TO authenticated;

-- 4. Record a payout ----------------------------------------------------------
CREATE OR REPLACE FUNCTION public.create_payout(
  p_seller_id uuid, p_consignor_id uuid, p_order_ids uuid[],
  p_method text, p_reference text, p_note text
)
RETURNS uuid
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public, pg_temp
AS $$
DECLARE
  v_sales   numeric;
  v_charges numeric;
  v_n       integer;
  v_year    integer := extract(year FROM now() AT TIME ZONE 'Europe/Amsterdam')::integer;
  v_num     text;
  v_id      uuid;
  v_name    text;
  v_lines   jsonb;
  v_chs     jsonb;
  v_count   integer;
BEGIN
  IF NOT public.is_owner() THEN RAISE EXCEPTION 'Owner only'; END IF;
  IF (p_seller_id IS NULL) = (p_consignor_id IS NULL) THEN RAISE EXCEPTION 'Choose one payee.'; END IF;

  -- Lock the chosen sales; every one must belong to this payee and be unpaid.
  PERFORM 1 FROM public.orders WHERE id = ANY(coalesce(p_order_ids, '{}')) FOR UPDATE;
  SELECT count(*), coalesce(sum(amount), 0),
         coalesce(jsonb_agg(jsonb_build_object('order', order_number, 'stone', stone,
                  'date', to_char(paid_at AT TIME ZONE 'Europe/Amsterdam', 'YYYY-MM-DD'),
                  'kind', payout_kind, 'amount', amount) ORDER BY paid_at), '[]'::jsonb)
  INTO   v_count, v_sales, v_lines
  FROM   public.payout_lines
  WHERE  order_id = ANY(coalesce(p_order_ids, '{}'))
    AND  payee_seller_id IS NOT DISTINCT FROM p_seller_id
    AND  payee_consignor_id IS NOT DISTINCT FROM p_consignor_id
    AND  state <> 'chargeback open';
  IF v_count <> coalesce(array_length(p_order_ids, 1), 0) THEN
    RAISE EXCEPTION 'Some selected sales can''t be paid to this payee (already paid, refunded or under a chargeback). Reload and try again.';
  END IF;

  SELECT coalesce(sum(amount), 0),
         coalesce(jsonb_agg(jsonb_build_object('order', order_number, 'reason', reason,
                  'date', to_char(created_at AT TIME ZONE 'Europe/Amsterdam', 'YYYY-MM-DD'),
                  'amount', amount) ORDER BY created_at), '[]'::jsonb)
  INTO   v_charges, v_chs
  FROM   public.payout_open_charges
  WHERE  payee_seller_id IS NOT DISTINCT FROM p_seller_id
    AND  payee_consignor_id IS NOT DISTINCT FROM p_consignor_id;

  IF v_sales - v_charges <= 0 THEN
    RAISE EXCEPTION 'Nothing to pay: sales €% − charges €% = €%.', v_sales, v_charges, v_sales - v_charges;
  END IF;

  INSERT INTO public.payout_counters (year, last_number) VALUES (v_year, 0) ON CONFLICT (year) DO NOTHING;
  UPDATE public.payout_counters SET last_number = last_number + 1 WHERE year = v_year RETURNING last_number INTO v_n;
  v_num := 'PO-' || v_year || '-' || lpad(v_n::text, 4, '0');

  IF p_seller_id IS NOT NULL THEN
    SELECT name INTO v_name FROM public.sellers WHERE id = p_seller_id;
  ELSE
    SELECT name INTO v_name FROM public.consignors WHERE id = p_consignor_id;
  END IF;

  INSERT INTO public.payouts (number, seller_id, consignor_id, sales_total, charges_total, amount, method, reference, note, data)
  VALUES (v_num, p_seller_id, p_consignor_id, v_sales, v_charges, v_sales - v_charges,
          nullif(trim(p_method), ''), nullif(trim(p_reference), ''), nullif(trim(p_note), ''),
          jsonb_build_object('payee', v_name, 'company', public._company_snapshot(),
                             'sales', v_lines, 'charges', v_chs))
  RETURNING id INTO v_id;

  UPDATE public.orders
  SET    payout_status = 'paid', payout_paid_at = now(), payout_id = v_id,
         payout_method = nullif(trim(p_method), ''), payout_reference = coalesce(nullif(trim(p_reference), ''), v_num)
  WHERE  id = ANY(p_order_ids);

  UPDATE public.owner_charges ch
  SET    settled_at = now(), payout_id = v_id
  FROM   public.payout_open_charges pc
  WHERE  pc.charge_id = ch.id
    AND  pc.payee_seller_id IS NOT DISTINCT FROM p_seller_id
    AND  pc.payee_consignor_id IS NOT DISTINCT FROM p_consignor_id;

  RETURN v_id;
END;
$$;
REVOKE ALL ON FUNCTION public.create_payout(uuid, uuid, uuid[], text, text, text) FROM PUBLIC, anon;
GRANT EXECUTE ON FUNCTION public.create_payout(uuid, uuid, uuid[], text, text, text) TO authenticated;

-- Orders covered by the new system can't be marked paid one by one anymore.
CREATE OR REPLACE FUNCTION public._orders_payout_via_statement()
RETURNS trigger
LANGUAGE plpgsql
SET search_path = public, pg_temp
AS $$
BEGIN
  IF NEW.payout_status = 'paid' AND OLD.payout_status IS DISTINCT FROM 'paid'
     AND NEW.payout_kind IN ('commission','consignment') AND NEW.payout_id IS NULL THEN
    RAISE EXCEPTION 'Pay this seller/owner under Payouts, so open charges are deducted.';
  END IF;
  RETURN NEW;
END;
$$;
REVOKE ALL ON FUNCTION public._orders_payout_via_statement() FROM PUBLIC, anon, authenticated;
DROP TRIGGER IF EXISTS orders_payout_via_statement ON public.orders;
CREATE TRIGGER orders_payout_via_statement
  BEFORE UPDATE OF payout_status ON public.orders
  FOR EACH ROW EXECUTE FUNCTION public._orders_payout_via_statement();

-- 5. Chargebacks (service role, from the Stripe webhook) --------------------
-- p_orders: [{order_id, share}] — the orders behind the disputed payment and
-- each one's share (a cart is one payment); p_fee: dispute fee in euros.
CREATE OR REPLACE FUNCTION public.record_dispute_opened(p_dispute_id text, p_orders jsonb, p_fee numeric)
RETURNS void
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public, pg_temp
AS $$
DECLARE
  x     jsonb;
  o     record;
  v_fee numeric;
BEGIN
  IF EXISTS (SELECT 1 FROM public.owner_charges WHERE dispute_id = p_dispute_id) THEN RETURN; END IF;
  FOR x IN SELECT * FROM jsonb_array_elements(p_orders) LOOP
    SELECT * INTO o FROM public.orders WHERE id = (x->>'order_id')::uuid;
    CONTINUE WHEN o.id IS NULL;
    UPDATE public.orders SET dispute_status = 'open', dispute_id = p_dispute_id WHERE id = o.id;
    v_fee := round(coalesce(p_fee, 0) * (x->>'share')::numeric, 2);
    IF o.payout_kind IN ('commission','consignment') AND v_fee > 0 THEN
      INSERT INTO public.owner_charges (seller_id, consignor_id, order_id, amount, reason, dispute_id)
      VALUES (CASE WHEN o.payout_kind = 'commission' THEN o.seller_id END,
              CASE WHEN o.payout_kind = 'consignment' THEN o.consignor_id END,
              o.id, v_fee, 'Chargeback opened — Stripe dispute fee', p_dispute_id);
    END IF;
  END LOOP;
END;
$$;

-- p_status 'won' | 'lost'; p_fee_back: dispute fee Stripe returned (euros).
CREATE OR REPLACE FUNCTION public.record_dispute_closed(p_dispute_id text, p_status text, p_fee_back numeric, p_orders jsonb)
RETURNS void
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public, pg_temp
AS $$
DECLARE
  x      jsonb;
  o      record;
  v_back numeric;
  v_left numeric;
BEGIN
  IF p_status NOT IN ('won','lost') THEN RETURN; END IF;
  FOR x IN SELECT * FROM jsonb_array_elements(p_orders) LOOP
    SELECT * INTO o FROM public.orders WHERE id = (x->>'order_id')::uuid FOR UPDATE;
    CONTINUE WHEN o.id IS NULL OR o.dispute_status IS DISTINCT FROM 'open';
    UPDATE public.orders SET dispute_status = p_status WHERE id = o.id;

    v_back := round(coalesce(p_fee_back, 0) * (x->>'share')::numeric, 2);
    IF v_back > 0 AND o.payout_kind IN ('commission','consignment') THEN
      INSERT INTO public.owner_charges (seller_id, consignor_id, order_id, amount, reason, dispute_id)
      VALUES (CASE WHEN o.payout_kind = 'commission' THEN o.seller_id END,
              CASE WHEN o.payout_kind = 'consignment' THEN o.consignor_id END,
              o.id, -v_back, 'Chargeback ' || p_status || ' — dispute fee returned', p_dispute_id || ':closed');
    END IF;

    IF p_status = 'lost' THEN
      v_left := public.order_refundable(o.id);
      IF v_left > 0 THEN
        PERFORM public.record_order_refund(o.id, v_left, 'Chargeback lost', 'other', p_dispute_id || ':' || o.id);
      END IF;
    END IF;
  END LOOP;
END;
$$;

REVOKE ALL ON FUNCTION public.record_dispute_opened(text, jsonb, numeric) FROM PUBLIC, anon, authenticated;
REVOKE ALL ON FUNCTION public.record_dispute_closed(text, text, numeric, jsonb) FROM PUBLIC, anon, authenticated;
GRANT EXECUTE ON FUNCTION public.record_dispute_opened(text, jsonb, numeric) TO service_role;
GRANT EXECUTE ON FUNCTION public.record_dispute_closed(text, text, numeric, jsonb) TO service_role;

COMMIT;

-- VERIFICATION (read-only):
--   SELECT * FROM payout_lines;  SELECT * FROM payout_open_charges;
