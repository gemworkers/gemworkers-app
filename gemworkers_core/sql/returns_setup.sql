-- =============================================================================
-- GemWorkers — Returns & refunds (30-day returns, owner refunds)
-- =============================================================================
-- Applied to live DB 2026-10-23
--
-- Zakaria 2026-10-23: 30 days for everyone (private and business); all
-- returns go to ONE GemWorkers address in NL (store_settings.return_address);
-- only the owner approves, checks the stone and refunds.
--
-- Flow:  buyer request_return  → 'requested'   (email owner)
--        owner approve_return  → 'approved'    (email buyer: address + steps)
--          buyer add_return_tracking (optional)
--        owner reject_return   → 'rejected'    (email buyer, with note)
--        buyer withdraw_return → 'withdrawn'
--        owner mark_return_received → 'received'
--        owner presses Refund (admin → store /api/admin/refund: Stripe refund)
--          → complete_return_refund (service role) → 'refunded' (email buyer)
--
-- Money: refund = what the buyer paid (order_total + tax_amount) minus an
-- optional owner deduction (e.g. damage). Original shipping is refunded (EU
-- rule); return shipping is the buyer's unless 'faulty'. refund_tax = the VAT
-- share of the refund (for the VAT / OSS correction in the tax report).
-- payout_clawback = the seller payout if it was already paid (to recover);
-- an unpaid payout is simply never paid (order status 'refunded').
--
-- Buyers have NO table access: they read buyer_returns (safe columns) and
-- write only through the functions below.
-- =============================================================================

BEGIN;

-- 1. Owner settings (return address) ----------------------------------------
CREATE TABLE IF NOT EXISTS public.store_settings (
  key        text PRIMARY KEY,
  value      text,
  updated_at timestamptz NOT NULL DEFAULT now()
);
ALTER TABLE public.store_settings ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS store_settings_owner ON public.store_settings;
CREATE POLICY store_settings_owner ON public.store_settings
  FOR ALL TO authenticated USING (public.is_owner()) WITH CHECK (public.is_owner());

-- 2. Orders: 'refunded' status + Stripe payment reference -------------------
ALTER TABLE public.orders DROP CONSTRAINT IF EXISTS orders_status_check;
ALTER TABLE public.orders ADD CONSTRAINT orders_status_check
  CHECK (status = ANY (ARRAY['draft','pending_payment','confirmed','shipped','received','paid','cancelled','refunded']));

ALTER TABLE public.orders
  ADD COLUMN IF NOT EXISTS stripe_payment_intent text;

-- 3. Returns ----------------------------------------------------------------
CREATE TABLE IF NOT EXISTS public.returns (
  id               uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  order_id         uuid NOT NULL UNIQUE REFERENCES public.orders(id),
  buyer_id         uuid NOT NULL REFERENCES auth.users(id),
  status           text NOT NULL DEFAULT 'requested'
                   CHECK (status IN ('requested','approved','received','refunded','rejected','withdrawn')),
  reason           text CHECK (reason IS NULL OR char_length(reason) <= 1000),
  faulty           boolean NOT NULL DEFAULT false,   -- faulty / not as described → we pay return shipping
  requested_at     timestamptz NOT NULL DEFAULT now(),
  approved_at      timestamptz,
  return_address   text,                             -- copied from store_settings at approval
  return_tracking  text CHECK (return_tracking IS NULL OR char_length(return_tracking) <= 100),
  received_at      timestamptz,
  condition_note   text,                             -- owner only (internal)
  decision_note    text CHECK (decision_note IS NULL OR char_length(decision_note) <= 1000), -- shown to buyer
  refunded_at      timestamptz,
  refund_amount    numeric(10,2) CHECK (refund_amount IS NULL OR refund_amount >= 0),
  refund_tax       numeric(10,2),
  deduction        numeric(10,2) NOT NULL DEFAULT 0 CHECK (deduction >= 0),
  deduction_reason text,
  stripe_refund_id text,
  payout_clawback  numeric(10,2),
  updated_at       timestamptz NOT NULL DEFAULT now()
);
CREATE INDEX IF NOT EXISTS returns_status_idx ON public.returns (status);

ALTER TABLE public.returns ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS returns_owner_select ON public.returns;
CREATE POLICY returns_owner_select ON public.returns
  FOR SELECT TO authenticated USING (public.is_owner());
REVOKE INSERT, UPDATE, DELETE ON public.returns FROM anon, authenticated;

-- Buyer view: own returns, buyer-safe columns only.
DROP VIEW IF EXISTS public.buyer_returns;
CREATE VIEW public.buyer_returns WITH (security_invoker = false) AS
SELECT r.id, r.order_id, r.status, r.reason, r.faulty, r.requested_at, r.approved_at,
       r.return_address, r.return_tracking, r.received_at, r.decision_note,
       r.refunded_at, r.refund_amount
FROM   public.returns r
WHERE  r.buyer_id = auth.uid();
REVOKE ALL ON public.buyer_returns FROM anon;
GRANT SELECT ON public.buyer_returns TO authenticated;

-- 4. Buyer functions --------------------------------------------------------
CREATE OR REPLACE FUNCTION public.request_return(p_order_id uuid, p_reason text, p_faulty boolean)
RETURNS uuid
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  o    record;
  v_id uuid;
  v_existing record;
BEGIN
  SELECT id, buyer_id, status, received_at, shipped_at INTO o
  FROM   public.orders WHERE id = p_order_id FOR UPDATE;

  IF o.id IS NULL OR o.buyer_id IS DISTINCT FROM auth.uid() THEN
    RAISE EXCEPTION 'Order not found.';
  END IF;
  IF o.status NOT IN ('shipped','received','paid') THEN
    RAISE EXCEPTION 'This order can''t be returned (it hasn''t been shipped yet).';
  END IF;
  -- 30 days from delivery (received), or from shipping if not marked received
  -- (then 30 days + up to 30 days transit).
  IF (o.received_at IS NOT NULL AND o.received_at < now() - interval '30 days')
     OR (o.received_at IS NULL AND o.shipped_at IS NOT NULL AND o.shipped_at < now() - interval '60 days') THEN
    RAISE EXCEPTION 'The 30-day return period for this order has ended. Please contact us if the stone is faulty.';
  END IF;

  SELECT id, status INTO v_existing FROM public.returns WHERE order_id = p_order_id;
  IF v_existing.id IS NOT NULL THEN
    IF v_existing.status <> 'withdrawn' THEN
      RAISE EXCEPTION 'A return for this order was already requested.';
    END IF;
    UPDATE public.returns
    SET    status = 'requested', reason = nullif(trim(p_reason), ''), faulty = coalesce(p_faulty, false),
           requested_at = now(), approved_at = NULL, return_address = NULL, return_tracking = NULL,
           decision_note = NULL, updated_at = now()
    WHERE  id = v_existing.id;
    RETURN v_existing.id;
  END IF;

  INSERT INTO public.returns (order_id, buyer_id, reason, faulty)
  VALUES (p_order_id, auth.uid(), nullif(trim(p_reason), ''), coalesce(p_faulty, false))
  RETURNING id INTO v_id;
  RETURN v_id;
END;
$$;

CREATE OR REPLACE FUNCTION public.withdraw_return(p_return_id uuid)
RETURNS void
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
BEGIN
  UPDATE public.returns SET status = 'withdrawn', updated_at = now()
  WHERE  id = p_return_id AND buyer_id = auth.uid() AND status IN ('requested','approved');
  IF NOT FOUND THEN
    RAISE EXCEPTION 'This return can no longer be cancelled.';
  END IF;
END;
$$;

CREATE OR REPLACE FUNCTION public.add_return_tracking(p_return_id uuid, p_tracking text)
RETURNS void
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
BEGIN
  UPDATE public.returns SET return_tracking = nullif(trim(p_tracking), ''), updated_at = now()
  WHERE  id = p_return_id AND buyer_id = auth.uid() AND status = 'approved';
  IF NOT FOUND THEN
    RAISE EXCEPTION 'Tracking can only be added to an approved return.';
  END IF;
END;
$$;

REVOKE ALL ON FUNCTION public.request_return(uuid, text, boolean) FROM PUBLIC, anon;
REVOKE ALL ON FUNCTION public.withdraw_return(uuid) FROM PUBLIC, anon;
REVOKE ALL ON FUNCTION public.add_return_tracking(uuid, text) FROM PUBLIC, anon;
GRANT EXECUTE ON FUNCTION public.request_return(uuid, text, boolean) TO authenticated;
GRANT EXECUTE ON FUNCTION public.withdraw_return(uuid) TO authenticated;
GRANT EXECUTE ON FUNCTION public.add_return_tracking(uuid, text) TO authenticated;

-- 5. Owner functions --------------------------------------------------------
CREATE OR REPLACE FUNCTION public.approve_return(p_return_id uuid, p_note text)
RETURNS void
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_address text;
BEGIN
  IF NOT public.is_owner() THEN RAISE EXCEPTION 'Owner only'; END IF;
  SELECT value INTO v_address FROM public.store_settings WHERE key = 'return_address';
  IF v_address IS NULL OR trim(v_address) = '' THEN
    RAISE EXCEPTION 'Set the return address first (Returns → Return address).';
  END IF;
  UPDATE public.returns
  SET    status = 'approved', approved_at = now(), return_address = v_address,
         decision_note = nullif(trim(p_note), ''), updated_at = now()
  WHERE  id = p_return_id AND status = 'requested';
  IF NOT FOUND THEN RAISE EXCEPTION 'Only a requested return can be approved.'; END IF;
END;
$$;

CREATE OR REPLACE FUNCTION public.reject_return(p_return_id uuid, p_note text)
RETURNS void
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
BEGIN
  IF NOT public.is_owner() THEN RAISE EXCEPTION 'Owner only'; END IF;
  IF p_note IS NULL OR trim(p_note) = '' THEN
    RAISE EXCEPTION 'Please give the buyer a reason.';
  END IF;
  UPDATE public.returns
  SET    status = 'rejected', decision_note = trim(p_note), updated_at = now()
  WHERE  id = p_return_id AND status IN ('requested','approved','received');
  IF NOT FOUND THEN RAISE EXCEPTION 'This return can no longer be rejected.'; END IF;
END;
$$;

CREATE OR REPLACE FUNCTION public.mark_return_received(p_return_id uuid, p_condition_note text)
RETURNS void
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
BEGIN
  IF NOT public.is_owner() THEN RAISE EXCEPTION 'Owner only'; END IF;
  UPDATE public.returns
  SET    status = 'received', received_at = now(),
         condition_note = nullif(trim(p_condition_note), ''), updated_at = now()
  WHERE  id = p_return_id AND status = 'approved';
  IF NOT FOUND THEN RAISE EXCEPTION 'Only an approved return can be marked received.'; END IF;
END;
$$;

REVOKE ALL ON FUNCTION public.approve_return(uuid, text) FROM PUBLIC, anon;
REVOKE ALL ON FUNCTION public.reject_return(uuid, text) FROM PUBLIC, anon;
REVOKE ALL ON FUNCTION public.mark_return_received(uuid, text) FROM PUBLIC, anon;
GRANT EXECUTE ON FUNCTION public.approve_return(uuid, text) TO authenticated;
GRANT EXECUTE ON FUNCTION public.reject_return(uuid, text) TO authenticated;
GRANT EXECUTE ON FUNCTION public.mark_return_received(uuid, text) TO authenticated;

-- 6. Refund bookkeeping (service role only — called after the Stripe refund) -
-- Returns the amount to refund for a 'received' return (used before Stripe).
CREATE OR REPLACE FUNCTION public.return_refund_amount(p_return_id uuid, p_deduction numeric)
RETURNS numeric
LANGUAGE plpgsql
STABLE
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_paid numeric;
BEGIN
  SELECT o.order_total + o.tax_amount INTO v_paid
  FROM   public.returns r JOIN public.orders o ON o.id = r.order_id
  WHERE  r.id = p_return_id AND r.status = 'received';
  IF v_paid IS NULL THEN RAISE EXCEPTION 'Only a received return can be refunded.'; END IF;
  IF p_deduction IS NULL OR p_deduction < 0 OR p_deduction >= v_paid THEN
    RAISE EXCEPTION 'The deduction must be at least €0 and less than the amount paid.';
  END IF;
  IF p_deduction <> round(p_deduction, 2) THEN RAISE EXCEPTION 'Use whole cents.'; END IF;
  RETURN v_paid - p_deduction;
END;
$$;

CREATE OR REPLACE FUNCTION public.complete_return_refund(
  p_return_id        uuid,
  p_deduction        numeric,
  p_deduction_reason text,
  p_stripe_refund_id text
)
RETURNS void
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  r        record;
  v_refund numeric;
BEGIN
  SELECT rt.id, rt.order_id, o.order_total, o.tax_amount, o.payout_status, o.seller_payout
  INTO   r
  FROM   public.returns rt JOIN public.orders o ON o.id = rt.order_id
  WHERE  rt.id = p_return_id AND rt.status = 'received'
  FOR UPDATE OF rt, o;
  IF r.id IS NULL THEN RAISE EXCEPTION 'Only a received return can be refunded.'; END IF;

  v_refund := public.return_refund_amount(p_return_id, p_deduction);

  UPDATE public.returns
  SET    status = 'refunded', refunded_at = now(),
         refund_amount = v_refund,
         refund_tax = CASE WHEN r.tax_amount > 0
                           THEN round(v_refund * r.tax_amount / (r.order_total + r.tax_amount), 2)
                           ELSE 0 END,
         deduction = p_deduction, deduction_reason = nullif(trim(p_deduction_reason), ''),
         stripe_refund_id = p_stripe_refund_id,
         payout_clawback = CASE WHEN r.payout_status = 'paid' THEN r.seller_payout ELSE 0 END,
         updated_at = now()
  WHERE  id = p_return_id;

  UPDATE public.orders SET status = 'refunded' WHERE id = r.order_id;

  -- The stone is back in stock, unlisted until the owner relists it.
  UPDATE public.inventory_items i
  SET    status = 'available', is_listed = false, updated_at = now()
  FROM   public.order_items oi
  WHERE  oi.order_id = r.order_id AND i.id = oi.inventory_item_id;
END;
$$;

REVOKE ALL ON FUNCTION public.return_refund_amount(uuid, numeric) FROM PUBLIC, anon, authenticated;
REVOKE ALL ON FUNCTION public.complete_return_refund(uuid, numeric, text, text) FROM PUBLIC, anon, authenticated;
GRANT EXECUTE ON FUNCTION public.return_refund_amount(uuid, numeric) TO service_role;
GRANT EXECUTE ON FUNCTION public.complete_return_refund(uuid, numeric, text, text) TO service_role;

-- 7. Emails (offer-notify RETURN_EVENT) -------------------------------------
CREATE OR REPLACE FUNCTION public._return_notify()
RETURNS trigger
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public, pg_temp
AS $$
DECLARE
  v_secret text;
BEGIN
  IF TG_OP = 'UPDATE' AND OLD.status = NEW.status THEN
    RETURN NEW;
  END IF;
  IF NEW.status NOT IN ('requested','approved','rejected','refunded') THEN
    RETURN NEW;
  END IF;

  SELECT s.decrypted_secret INTO v_secret
  FROM   vault.decrypted_secrets s
  WHERE  s.name = 'offer_reminder_secret'
  LIMIT  1;

  IF v_secret IS NULL OR v_secret = '' THEN
    RAISE WARNING '[return notify] Vault secret offer_reminder_secret missing — no email for %', NEW.id;
    RETURN NEW;
  END IF;

  BEGIN
    PERFORM net.http_post(
      url                  := 'https://cvqzidqnwthzfodhzepz.supabase.co/functions/v1/offer-notify',
      body                 := jsonb_build_object('type', 'RETURN_EVENT', 'return_id', NEW.id, 'event', NEW.status),
      headers              := jsonb_build_object(
                                'Content-Type',      'application/json',
                                'x-reminder-secret', v_secret
                              ),
      timeout_milliseconds := 10000
    );
  EXCEPTION WHEN OTHERS THEN
    RAISE WARNING '[return notify] queue failed for %: %', NEW.id, SQLERRM;
  END;

  RETURN NEW;
END;
$$;

REVOKE ALL ON FUNCTION public._return_notify() FROM PUBLIC, anon, authenticated;

DROP TRIGGER IF EXISTS returns_notify ON public.returns;
CREATE TRIGGER returns_notify
  AFTER INSERT OR UPDATE OF status ON public.returns
  FOR EACH ROW
  EXECUTE FUNCTION public._return_notify();

COMMIT;

-- VERIFICATION (read-only):
--   SELECT pg_get_constraintdef(oid) FROM pg_constraint WHERE conname = 'orders_status_check';
--   SELECT proname FROM pg_proc WHERE proname IN ('request_return','withdraw_return','add_return_tracking',
--     'approve_return','reject_return','mark_return_received','return_refund_amount','complete_return_refund');
