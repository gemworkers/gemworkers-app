-- =============================================================================
-- GemWorkers — Fix: partial refund, then full refund, no longer charges twice
-- =============================================================================
-- Applied to live DB 2026-10-28
--
-- Found 2026-10-26 (earnings page, ORD-00054), parked, fixed 2026-10-28.
-- Before: a partial refund charged the stone's owner (brother / consignor)
-- their share; a later full refund of the rest (return within 30 days, lost
-- chargeback) charged the full-refund amount ON TOP — so an owner who was
-- never paid for the sale still paid for the first partial refund.
-- Now the full-refund branch subtracts the refund charges already made for
-- that order: in total the owner carries exactly what a single full refund
-- would cost them (consignment: the lost Stripe fee; already paid out: the
-- payout back; minus any return deduction). Live definition copied; only the
-- full-refund branch changed. Existing test data (ORD-00054) is left as is —
-- it goes in the pre-launch test-data wipe.
-- =============================================================================

BEGIN;

CREATE OR REPLACE FUNCTION public._charge_owner_for_refund(p_order_id uuid, p_refund numeric, p_refund_tax numeric, p_deduction numeric, p_full boolean, p_return_id uuid, p_order_refund_id uuid, p_reason text)
 RETURNS void
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO 'public'
AS $function$
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
    -- Lost Stripe fee: the consignment owner shares it; for a seller's own
    -- stone GemWorkers carries it (all-inclusive commission).
    v_amount := CASE WHEN o.payout_kind = 'consignment' THEN coalesce(o.stripe_fee, 0) ELSE 0 END
              + CASE WHEN o.payout_status = 'paid' THEN coalesce(o.seller_payout, 0) ELSE 0 END
              - v_ded;
    -- That is what the owner carries for the WHOLE order once it is fully
    -- refunded. Earlier partial refunds were already charged (open or settled
    -- in a payout): count them, so they are not charged twice. A negative
    -- amount credits the owner back. Chargeback fees (dispute_id) stay apart.
    v_amount := v_amount - coalesce((
      SELECT sum(c.amount) FROM public.owner_charges c
      WHERE  c.order_id = o.id
        AND  c.dispute_id IS NULL
        AND  (c.order_refund_id IS NOT NULL OR c.return_id IS NOT NULL)), 0);
  ELSE
    v_amount := p_refund - coalesce(p_refund_tax, 0);
    -- Consignment (stone Zakaria ships for its owner): shared like the profit.
    IF o.payout_kind = 'consignment' THEN
      v_amount := round(coalesce(o.profit_share, 0.5) * v_amount, 2);
    END IF;
  END IF;

  IF v_amount = 0 THEN RETURN; END IF;

  INSERT INTO public.owner_charges (seller_id, consignor_id, order_id, return_id, order_refund_id, amount, reason)
  VALUES (
    CASE WHEN o.payout_kind = 'commission' THEN o.seller_id END,
    CASE WHEN o.payout_kind = 'consignment' THEN o.consignor_id END,
    o.id, p_return_id, p_order_refund_id, v_amount, p_reason
  );
END;
$function$;

COMMIT;
