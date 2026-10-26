-- =============================================================================
-- GemWorkers — Earnings: what GemWorkers keeps (per order + totals)
-- =============================================================================
-- Applied to live DB 2026-10-26
--
-- Zakaria 2026-10-26: "how much the platform earned from commissions etc,
-- what remains after payouts and taxes — per order and a sum too".
-- Owner only. All amounts in EUR, VAT never counted as income.
-- Per paid platform order (paid date in the period, Amsterdam time):
--   sales        order_total (stone + shipping, excl. VAT)
--   refunded     refunds excl. VAT (order_refunds + refunded returns)
--   payout       seller / owner share (commission + consignment) — not owed
--                after a full refund unless it was already paid out
--   recovered    owner_charges on this order (seller carries refund costs)
--   stripe_fee   Stripe's fee (NULL until Stripe reports it → fee_pending)
--   postage      postage GemWorkers paid (orders.postage_paid)
--   stone_cost   cost_price of GemWorkers' own stones (kind own), unless the
--                order was fully refunded (stone back in stock)
--   fx           euros Stripe credited − what the buyer owed in euros (the
--                2% local-currency margin; 0 when not known yet)
--   earned       sales − refunded − payout + recovered − stripe_fee − postage
--                − stone_cost + fx
--   vat          VAT collected − VAT refunded (goes to the tax office)
-- Before income tax and before fixed costs (hosting, insurance, …).
-- =============================================================================

BEGIN;

CREATE OR REPLACE FUNCTION public.earnings_report(p_from date, p_to date)
RETURNS json
LANGUAGE plpgsql
STABLE
SECURITY DEFINER
SET search_path = public, pg_temp
AS $$
DECLARE
  v json;
BEGIN
  IF NOT public.is_owner() THEN
    RAISE EXCEPTION 'Only the owner can see earnings.';
  END IF;

  WITH base AS (
    SELECT o.id, o.order_number, o.paid_at, o.status, o.payout_kind,
           o.payout_status, o.order_total, o.tax_amount, o.seller_payout,
           o.stripe_fee, o.postage_paid, o.eur_received,
           coalesce((SELECT sum(r.amount - r.tax_amount) FROM order_refunds r WHERE r.order_id = o.id), 0)
         + coalesce((SELECT sum(rt.refund_amount - coalesce(rt.refund_tax, 0)) FROM returns rt
                     WHERE rt.order_id = o.id AND rt.status = 'refunded'), 0) AS refunded,
           coalesce((SELECT sum(r.tax_amount) FROM order_refunds r WHERE r.order_id = o.id), 0)
         + coalesce((SELECT sum(coalesce(rt.refund_tax, 0)) FROM returns rt
                     WHERE rt.order_id = o.id AND rt.status = 'refunded'), 0) AS refunded_vat,
           coalesce((SELECT sum(c.amount) FROM owner_charges c WHERE c.order_id = o.id), 0) AS recovered,
           (SELECT sum(coalesce(i.cost_price, 0) * oi.quantity) FROM order_items oi
              JOIN inventory_items i ON i.id = oi.inventory_item_id WHERE oi.order_id = o.id) AS cost,
           (SELECT i.title FROM order_items oi JOIN inventory_items i ON i.id = oi.inventory_item_id
             WHERE oi.order_id = o.id LIMIT 1) AS stone
    FROM   orders o
    WHERE  o.sale_channel = 'platform'
      AND  o.paid_at IS NOT NULL
      AND  o.status IN ('paid', 'confirmed', 'shipped', 'received', 'refunded')
      AND  (o.paid_at AT TIME ZONE 'Europe/Amsterdam')::date >= p_from
      AND  (o.paid_at AT TIME ZONE 'Europe/Amsterdam')::date <  p_to
  ), calc AS (
    SELECT b.*,
           CASE WHEN b.payout_kind IN ('commission', 'consignment')
                 AND (b.status <> 'refunded' OR b.payout_status = 'paid')
                THEN coalesce(b.seller_payout, 0) ELSE 0 END AS payout,
           coalesce(b.stripe_fee, 0) AS fee,
           coalesce(b.postage_paid, 0) AS postage,
           CASE WHEN b.payout_kind = 'own' AND b.status <> 'refunded'
                THEN coalesce(b.cost, 0) ELSE 0 END AS stone_cost,
           CASE WHEN b.eur_received IS NOT NULL
                THEN b.eur_received - (b.order_total + b.tax_amount) ELSE 0 END AS fx
    FROM base b
  ), rows AS (
    SELECT c.*,
           c.order_total - c.refunded - c.payout + c.recovered - c.fee - c.postage
             - c.stone_cost + c.fx AS earned,
           c.tax_amount - c.refunded_vat AS vat
    FROM calc c
  )
  SELECT json_build_object(
    'totals', (SELECT json_build_object(
        'orders',      count(*),
        'sales',       coalesce(sum(order_total), 0),
        'refunded',    coalesce(sum(refunded), 0),
        'payout',      coalesce(sum(payout), 0),
        'payout_paid', coalesce(sum(payout) FILTER (WHERE payout_status = 'paid'), 0),
        'recovered',   coalesce(sum(recovered), 0),
        'stripe_fee',  coalesce(sum(fee), 0),
        'postage',     coalesce(sum(postage), 0),
        'stone_cost',  coalesce(sum(stone_cost), 0),
        'fx',          coalesce(sum(fx), 0),
        'earned',      coalesce(sum(earned), 0),
        'vat',         coalesce(sum(vat), 0),
        'fee_pending', count(*) FILTER (WHERE stripe_fee IS NULL),
        'cost_missing', count(*) FILTER (WHERE payout_kind = 'own' AND status <> 'refunded' AND coalesce(cost, 0) = 0)
      ) FROM rows),
    'orders', (SELECT coalesce(json_agg(json_build_object(
        'order_id', id, 'order_number', order_number, 'paid_at', paid_at, 'status', status,
        'kind', payout_kind, 'stone', stone, 'sales', order_total, 'refunded', refunded,
        'payout', payout, 'payout_paid', payout_status = 'paid', 'recovered', recovered,
        'stripe_fee', stripe_fee, 'postage', postage, 'stone_cost', stone_cost, 'fx', fx,
        'earned', earned, 'vat', vat,
        'cost_missing', payout_kind = 'own' AND status <> 'refunded' AND coalesce(cost, 0) = 0
      ) ORDER BY paid_at DESC), '[]') FROM rows)
  ) INTO v;
  RETURN v;
END;
$$;
REVOKE ALL ON FUNCTION public.earnings_report(date, date) FROM PUBLIC, anon;
GRANT EXECUTE ON FUNCTION public.earnings_report(date, date) TO authenticated;

COMMIT;
