-- =============================================================================
-- GemWorkers — All-inclusive commission for sellers' own stones (kind A)
-- =============================================================================
-- Applied to live DB 2026-10-25
--
-- Zakaria 2026-10-25: GemWorkers takes a fixed % of the FINAL sale price
-- (sellers.commission_rate, 12% for the brothers), and that % includes all
-- payment costs. So for payout_kind 'commission':
--   • Stripe's fee is NO LONGER deducted from the seller's payout
--     (GemWorkers pays it out of the commission)
--   • minimum commission €3 per sale when the seller has a commission rate
--     (never more than the stone price itself); 0% sellers stay at 0
--   • offers: the commission is on the accepted price (as before), so an
--     accepted offer only lowers the seller's own share
--   • full refund: GemWorkers carries the lost Stripe fee; the seller is only
--     charged a payout that was already paid (as before)
-- Consignment (B/C) and own stones (D) are unchanged. Shipping stays the
-- seller's in full (commission is on the stone price only).
--
-- Both functions copied from the live definitions; diffs:
-- _order_payout_rule, commission branch:
--   -    NEW.seller_payout := NEW.order_total - coalesce(NEW.commission_amount, 0) - coalesce(NEW.stripe_fee, 0);
--   +    v_goods := NEW.order_total - coalesce(NEW.shipping_cost, 0);
--   +    v_comm  := coalesce(NEW.commission_amount, 0);
--   +    IF coalesce(NEW.commission_rate, 0) > 0 THEN
--   +      v_comm := least(greatest(v_comm, 3), v_goods);
--   +    END IF;
--   +    NEW.commission_amount := v_comm;
--   +    NEW.seller_payout     := NEW.order_total - v_comm;
-- _charge_owner_for_refund, full refund:
--   -    v_amount := coalesce(o.stripe_fee, 0)
--   +    v_amount := CASE WHEN o.payout_kind = 'consignment' THEN coalesce(o.stripe_fee, 0) ELSE 0 END
-- =============================================================================

BEGIN;

CREATE OR REPLACE FUNCTION public._order_payout_rule()
RETURNS trigger
LANGUAGE plpgsql
SET search_path TO 'public', 'pg_temp'
AS $function$
DECLARE
  v_goods  numeric;
  v_extra  numeric;
  v_profit numeric;
  v_owner  numeric;
  v_comm   numeric;
BEGIN
  IF NEW.payout_kind IS NULL OR NEW.payout_kind = 'own' OR NEW.payout_status = 'paid' THEN
    RETURN NEW;
  END IF;

  IF NEW.payout_kind = 'commission' THEN
    -- All-inclusive commission: Stripe's fee is paid by GemWorkers out of it.
    v_goods := NEW.order_total - coalesce(NEW.shipping_cost, 0);
    v_comm  := coalesce(NEW.commission_amount, 0);
    IF coalesce(NEW.commission_rate, 0) > 0 THEN
      v_comm := least(greatest(v_comm, 3), v_goods);   -- minimum €3 per sale
    END IF;
    NEW.commission_amount := v_comm;
    NEW.seller_payout     := NEW.order_total - v_comm;
  ELSIF NEW.payout_kind = 'consignment' THEN
    v_goods  := NEW.order_total - coalesce(NEW.shipping_cost, 0);
    v_extra  := greatest(coalesce(NEW.postage_paid, 0) - coalesce(NEW.shipping_cost, 0), 0);
    v_profit := v_goods - NEW.consignor_price - v_extra - coalesce(NEW.stripe_fee, 0);
    v_owner  := NEW.consignor_price + round(NEW.profit_share * v_profit, 2);
    NEW.seller_payout     := v_owner;
    NEW.commission_amount := v_goods - v_extra - coalesce(NEW.stripe_fee, 0) - v_owner;  -- GemWorkers' half
  END IF;
  RETURN NEW;
END;
$function$;

CREATE OR REPLACE FUNCTION public._charge_owner_for_refund(
  p_order_id uuid, p_refund numeric, p_refund_tax numeric, p_deduction numeric,
  p_full boolean, p_return_id uuid, p_order_refund_id uuid, p_reason text
)
RETURNS void
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
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
    -- Lost Stripe fee: the consignment owner shares it; for a seller's own
    -- stone GemWorkers carries it (all-inclusive commission).
    v_amount := CASE WHEN o.payout_kind = 'consignment' THEN coalesce(o.stripe_fee, 0) ELSE 0 END
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
