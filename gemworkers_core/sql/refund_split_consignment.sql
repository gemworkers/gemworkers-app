-- =============================================================================
-- GemWorkers — Consignment partial refunds are shared like the profit
-- =============================================================================
-- Applied to live DB 2026-10-24
--
-- Zakaria 2026-10-24: a partial refund on a stone HE ships for someone else
-- (consignment, B/C) is a lower sale price, so it is shared like the profit:
-- the owner is charged their profit share (default 50%) of the refund excl.
-- VAT; GemWorkers carries the rest. Everything else is unchanged:
--   • a brother's own stone (commission, A): partial refund fully his
--   • full refunds: owner pays the lost Stripe fee (+ a payout already paid)
--
-- _charge_owner_for_refund copied from the live definition
-- (refund_owner_costs.sql, applied 2026-10-24). Only change (diff):
--   -    v_amount := p_refund - coalesce(p_refund_tax, 0);
--   +    v_amount := p_refund - coalesce(p_refund_tax, 0);
--   +    IF o.payout_kind = 'consignment' THEN
--   +      v_amount := round(coalesce(o.profit_share, 0.5) * v_amount, 2);
--   +    END IF;
-- =============================================================================

BEGIN;

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
$$;

REVOKE ALL ON FUNCTION public._charge_owner_for_refund(uuid, numeric, numeric, numeric, boolean, uuid, uuid, text) FROM PUBLIC, anon, authenticated;

COMMIT;
