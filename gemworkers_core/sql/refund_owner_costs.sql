-- =============================================================================
-- GemWorkers — Refund costs charged to the stone's owner + refund without a
-- return (consignment part 2)
-- =============================================================================
-- Applied to live DB 2026-10-24
--
-- Zakaria 2026-10-24: GemWorkers never carries the cost of a stone that isn't
-- its own. Every return comes to NL; a brother's returned stone stays in NL as
-- his consignment stone.
--
-- 1. owner_charges — money a seller (brother) or consignment owner owes
--    GemWorkers (positive) or is credited (negative). Part 3 (payout
--    statements) deducts the open charges from their next payout.
-- 2. Refund via a return (returns → 'refunded', trigger):
--      charge = Stripe fee (Stripe keeps it)
--             + the payout if it was already paid
--             − the deduction kept for damage (excl. VAT) — that goes to them
--    The order is 'refunded', so an unpaid payout is simply never paid.
--    A brother's own stone (payout_kind 'commission') moves to My Shop as his
--    consignment stone (owner's price = what he would have received for the
--    stone, editable before relisting), unlisted.
-- 3. Refund without a return (lost parcel, buyer keeps it, partial
--    compensation): order_refunds + record_order_refund (service role, called
--    by the store after the Stripe refund). Full refund → order 'refunded'.
--      charge = refund excl. VAT (+ Stripe fee and paid payout on a full refund)
--    A credit note is issued for each refund (tax report picks it up).
-- Own stones (payout_kind 'own'): no charge — it's GemWorkers' own loss.
-- Live money functions are not changed.
-- =============================================================================

BEGIN;

-- 1. Owner charges ------------------------------------------------------------
CREATE TABLE IF NOT EXISTS public.owner_charges (
  id               uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  seller_id        uuid REFERENCES public.sellers(id),
  consignor_id     uuid REFERENCES public.consignors(id),
  order_id         uuid REFERENCES public.orders(id),
  return_id        uuid REFERENCES public.returns(id),
  order_refund_id  uuid,
  amount           numeric(10,2) NOT NULL,   -- + they owe GemWorkers, − credit
  reason           text NOT NULL,
  created_at       timestamptz NOT NULL DEFAULT now(),
  settled_at       timestamptz,              -- set when deducted from a payout (part 3)
  CHECK ((seller_id IS NULL) <> (consignor_id IS NULL))
);
CREATE INDEX IF NOT EXISTS owner_charges_open_idx ON public.owner_charges (seller_id, consignor_id) WHERE settled_at IS NULL;

ALTER TABLE public.owner_charges ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS owner_charges_owner ON public.owner_charges;
CREATE POLICY owner_charges_owner ON public.owner_charges
  FOR SELECT TO authenticated USING (public.is_owner());
DROP POLICY IF EXISTS owner_charges_seller ON public.owner_charges;
CREATE POLICY owner_charges_seller ON public.owner_charges
  FOR SELECT TO authenticated USING (seller_id IS NOT NULL AND seller_id = public.current_seller_id());
REVOKE INSERT, UPDATE, DELETE ON public.owner_charges FROM anon, authenticated;

-- Records the charge for a refunded order (or part of it).
--   p_refund / p_refund_tax: what went back to the buyer, and its VAT share
--   p_full: the whole order is refunded
CREATE OR REPLACE FUNCTION public._charge_owner_for_refund(
  p_order_id uuid, p_refund numeric, p_refund_tax numeric, p_deduction numeric,
  p_full boolean, p_return_id uuid, p_order_refund_id uuid, p_reason text
)
RETURNS void
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public, pg_temp
AS $$
DECLARE
  o        record;
  v_amount numeric;
  v_ded    numeric := 0;
BEGIN
  SELECT * INTO o FROM public.orders WHERE id = p_order_id;
  IF o.id IS NULL OR o.payout_kind IS NULL OR o.payout_kind = 'own' THEN
    RETURN;
  END IF;

  IF coalesce(p_deduction, 0) > 0 AND (o.order_total + o.tax_amount) > 0 THEN
    v_ded := round(p_deduction * o.order_total / (o.order_total + o.tax_amount), 2);
  END IF;

  IF p_full THEN
    v_amount := coalesce(o.stripe_fee, 0)
              + CASE WHEN o.payout_status = 'paid' THEN coalesce(o.seller_payout, 0) ELSE 0 END
              - v_ded;
  ELSE
    v_amount := p_refund - coalesce(p_refund_tax, 0);
  END IF;

  IF v_amount = 0 THEN RETURN; END IF;

  INSERT INTO public.owner_charges (seller_id, consignor_id, order_id, return_id, order_refund_id, amount, reason)
  VALUES (
    CASE WHEN o.payout_kind = 'commission' THEN o.seller_id END,
    CASE WHEN o.payout_kind = 'consignment' THEN o.consignor_id END,
    o.id, p_return_id, p_order_refund_id, v_amount, p_reason
  );
END;
$$;
REVOKE ALL ON FUNCTION public._charge_owner_for_refund(uuid, numeric, numeric, numeric, boolean, uuid, uuid, text) FROM PUBLIC, anon, authenticated;

-- 2. Returns: charge the owner; a brother's own stone becomes his consignment
CREATE OR REPLACE FUNCTION public._return_owner_costs()
RETURNS trigger
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public, pg_temp
AS $$
DECLARE
  o       record;
  it      record;
  v_cons  uuid;
  v_share numeric;
BEGIN
  IF NOT (NEW.status = 'refunded' AND OLD.status IS DISTINCT FROM 'refunded') THEN
    RETURN NEW;
  END IF;

  PERFORM public._charge_owner_for_refund(NEW.order_id, NEW.refund_amount, NEW.refund_tax, NEW.deduction,
                                          true, NEW.id, NULL, 'Return refunded');

  SELECT * INTO o FROM public.orders WHERE id = NEW.order_id;
  IF o.payout_kind = 'commission' THEN
    SELECT i.id, i.selling_price, i.title INTO it
    FROM   public.order_items oi JOIN public.inventory_items i ON i.id = oi.inventory_item_id
    WHERE  oi.order_id = o.id LIMIT 1;

    -- The brother's owner record (created once, linked to his seller account).
    SELECT id, default_share INTO v_cons, v_share FROM public.consignors WHERE seller_id = o.seller_id;
    IF v_cons IS NULL THEN
      INSERT INTO public.consignors (name, country, seller_id)
      SELECT s.name, s.country, s.id FROM public.sellers s WHERE s.id = o.seller_id
      RETURNING id, default_share INTO v_cons, v_share;
    END IF;

    UPDATE public.inventory_items
    SET    seller_id       = 'a0000000-0000-0000-0000-000000000001'::uuid,
           consignor_id    = v_cons,
           -- what he would have received for the stone itself; edit before relisting
           consignor_price = greatest(o.order_total - coalesce(o.shipping_cost, 0) - coalesce(o.commission_amount, 0), 0),
           profit_share    = coalesce(v_share, 0.5),
           is_listed       = false,
           updated_at      = now()
    WHERE  id = it.id;
  END IF;
  RETURN NEW;
EXCEPTION WHEN OTHERS THEN
  -- Never block the refund bookkeeping; the owner can fix it by hand.
  RAISE WARNING '[return owner costs] return % failed: %', NEW.id, SQLERRM;
  RETURN NEW;
END;
$$;
REVOKE ALL ON FUNCTION public._return_owner_costs() FROM PUBLIC, anon, authenticated;

DROP TRIGGER IF EXISTS returns_owner_costs ON public.returns;
CREATE TRIGGER returns_owner_costs
  AFTER UPDATE OF status ON public.returns
  FOR EACH ROW EXECUTE FUNCTION public._return_owner_costs();

-- 3. Refund without a return ------------------------------------------------
CREATE TABLE IF NOT EXISTS public.order_refunds (
  id               uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  order_id         uuid NOT NULL REFERENCES public.orders(id),
  amount           numeric(10,2) NOT NULL CHECK (amount > 0),
  tax_amount       numeric(10,2) NOT NULL DEFAULT 0,
  full_refund      boolean NOT NULL,
  stone_fate       text NOT NULL CHECK (stone_fate IN ('lost','kept','other')),
  reason           text NOT NULL CHECK (length(trim(reason)) BETWEEN 1 AND 500),
  stripe_refund_id text NOT NULL UNIQUE,
  created_at       timestamptz NOT NULL DEFAULT now()
);
ALTER TABLE public.order_refunds ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS order_refunds_owner ON public.order_refunds;
CREATE POLICY order_refunds_owner ON public.order_refunds
  FOR SELECT TO authenticated USING (public.is_owner());
REVOKE INSERT, UPDATE, DELETE ON public.order_refunds FROM anon, authenticated;

ALTER TABLE public.owner_charges
  DROP CONSTRAINT IF EXISTS owner_charges_order_refund_fk;
ALTER TABLE public.owner_charges
  ADD CONSTRAINT owner_charges_order_refund_fk FOREIGN KEY (order_refund_id) REFERENCES public.order_refunds(id);

ALTER TABLE public.invoices ADD COLUMN IF NOT EXISTS order_refund_id uuid REFERENCES public.order_refunds(id);
CREATE UNIQUE INDEX IF NOT EXISTS invoices_one_per_order_refund
  ON public.invoices (order_refund_id) WHERE order_refund_id IS NOT NULL;

-- How much of an order can still be refunded (paid − everything refunded).
CREATE OR REPLACE FUNCTION public.order_refundable(p_order_id uuid)
RETURNS numeric
LANGUAGE sql
STABLE
SECURITY DEFINER
SET search_path = public, pg_temp
AS $$
  SELECT (o.order_total + o.tax_amount)
       - coalesce((SELECT sum(r.amount) FROM public.order_refunds r WHERE r.order_id = o.id), 0)
       - coalesce((SELECT rt.refund_amount FROM public.returns rt WHERE rt.order_id = o.id AND rt.status = 'refunded'), 0)
  FROM public.orders o WHERE o.id = p_order_id;
$$;
REVOKE ALL ON FUNCTION public.order_refundable(uuid) FROM PUBLIC, anon;
GRANT EXECUTE ON FUNCTION public.order_refundable(uuid) TO authenticated, service_role;

-- Called by the store (service role) AFTER the Stripe refund succeeded.
CREATE OR REPLACE FUNCTION public.record_order_refund(
  p_order_id uuid, p_amount numeric, p_reason text, p_stone_fate text, p_stripe_refund_id text
)
RETURNS uuid
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public, pg_temp
AS $$
DECLARE
  o       record;
  v_left  numeric;
  v_tax   numeric;
  v_full  boolean;
  v_id    uuid;
  v_inv   record;
BEGIN
  SELECT id INTO v_id FROM public.order_refunds WHERE stripe_refund_id = p_stripe_refund_id;
  IF v_id IS NOT NULL THEN RETURN v_id; END IF;      -- retry after a save failure

  SELECT * INTO o FROM public.orders WHERE id = p_order_id FOR UPDATE;
  IF o.id IS NULL OR o.paid_at IS NULL OR o.status IN ('pending_payment','cancelled','refunded','draft') THEN
    RAISE EXCEPTION 'Only a paid order can be refunded.';
  END IF;
  IF EXISTS (SELECT 1 FROM public.returns WHERE order_id = o.id AND status IN ('requested','approved','received')) THEN
    RAISE EXCEPTION 'This order has an open return — refund it under Returns.';
  END IF;

  v_left := public.order_refundable(o.id);
  IF p_amount IS NULL OR p_amount <= 0 OR p_amount > v_left OR p_amount <> round(p_amount, 2) THEN
    RAISE EXCEPTION 'The refund must be between €0.01 and €% (what is left to refund).', v_left;
  END IF;

  v_full := (p_amount = v_left);
  v_tax  := CASE WHEN o.tax_amount > 0
                 THEN round(p_amount * o.tax_amount / (o.order_total + o.tax_amount), 2) ELSE 0 END;

  INSERT INTO public.order_refunds (order_id, amount, tax_amount, full_refund, stone_fate, reason, stripe_refund_id)
  VALUES (o.id, p_amount, v_tax, v_full, p_stone_fate, trim(p_reason), p_stripe_refund_id)
  RETURNING id INTO v_id;

  PERFORM public._charge_owner_for_refund(o.id, p_amount, v_tax, 0, v_full, NULL, v_id,
            'Refund: ' || trim(p_reason));

  IF v_full THEN
    UPDATE public.orders SET status = 'refunded' WHERE id = o.id;
  END IF;

  -- Credit note (only when the order was invoiced).
  SELECT * INTO v_inv FROM public.invoices WHERE order_id = o.id AND kind = 'invoice';
  IF v_inv.id IS NOT NULL THEN
    INSERT INTO public.invoices (number, kind, order_id, order_refund_id, net_amount, tax_amount, total, tax_scheme, ship_to_country, data)
    VALUES (
      public._next_invoice_number(), 'credit_note', o.id, v_id,
      -(p_amount - v_tax), -v_tax, -p_amount, v_inv.tax_scheme, v_inv.ship_to_country,
      (v_inv.data - 'lines' - 'diamond_statement') || jsonb_build_object(
        'company', public._company_snapshot(),
        'credits_invoice', v_inv.number,
        'supply_date', to_char(now() AT TIME ZONE 'Europe/Amsterdam', 'YYYY-MM-DD'),
        'lines', jsonb_build_array(jsonb_build_object(
          'description', CASE WHEN v_full THEN 'Refund' ELSE 'Partial refund' END || ' — credit for invoice ' || v_inv.number,
          'detail', trim(p_reason), 'quantity', 1, 'amount', -(p_amount - v_tax))))
    );
  END IF;

  RETURN v_id;
END;
$$;
REVOKE ALL ON FUNCTION public.record_order_refund(uuid, numeric, text, text, text) FROM PUBLIC, anon, authenticated;
GRANT EXECUTE ON FUNCTION public.record_order_refund(uuid, numeric, text, text, text) TO service_role;

COMMIT;

-- VERIFICATION (read-only):
--   SELECT * FROM owner_charges ORDER BY created_at DESC;
--   SELECT * FROM order_refunds ORDER BY created_at DESC;
