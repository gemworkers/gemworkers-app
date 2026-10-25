import { NextRequest } from 'next/server'
import { stripe } from '@/lib/stripe/server'
import { findPaymentIntent, preflight, reply, requireOwner, type OrderPaymentRef } from '@/lib/admin-api'
import { refundAmountInChargeCurrency } from '@/lib/stripe/refunds'

// Refund an order WITHOUT a return (lost parcel, buyer keeps the stone,
// partial compensation) — sql/refund_owner_costs.sql. Owner only:
//   POST { order_id, amount, reason, stone_fate: 'lost' | 'kept' | 'other' }
// 1. order_refundable checks the amount  2. Stripe refund (idempotent per
// order + amount + refunds so far)  3. record_order_refund saves it, charges
// the stone's owner, issues the credit note and (if full) sets 'refunded'.

export async function OPTIONS(req: NextRequest) {
  return preflight(req)
}

export async function POST(req: NextRequest) {
  const auth = await requireOwner(req)
  if ('error' in auth) return auth.error
  const { admin } = auth

  const body = await req.json().catch(() => null) as
    { order_id?: string; amount?: number | string; reason?: string; stone_fate?: string } | null
  const orderId = body?.order_id
  const amount = Number(body?.amount)
  const reason = (body?.reason ?? '').trim()
  const fate = body?.stone_fate ?? 'other'
  if (!orderId || !Number.isFinite(amount) || amount <= 0) return reply(req, { error: 'Enter the amount to refund.' }, 400)
  if (!reason) return reply(req, { error: 'Enter a reason (shown on the credit note).' }, 400)
  if (!['lost', 'kept', 'other'].includes(fate)) return reply(req, { error: 'Bad request' }, 400)
  const cents = Math.round(amount * 100)

  const { data: left, error: leftErr } = await admin.rpc('order_refundable', { p_order_id: orderId })
  if (leftErr || left == null) return reply(req, { error: 'Order not found' }, 404)
  if (cents > Math.round(Number(left) * 100)) {
    return reply(req, { error: `At most €${Number(left).toFixed(2)} can still be refunded.` }, 400)
  }

  const { data: orderData } = await admin
    .from('orders')
    .select('id, order_number, checkout_group_id, stripe_payment_intent, stripe_checkout_session_id')
    .eq('id', orderId)
    .single()
  const order = orderData as (OrderPaymentRef & { order_number: string }) | null
  if (!order) return reply(req, { error: 'Order not found' }, 404)

  const pi = await findPaymentIntent(order)
  if (!pi) return reply(req, { error: 'Could not find the Stripe payment for this order — refund it in the Stripe dashboard.' }, 409)

  // Same order + same amount + same refunds so far = the same Stripe refund
  // (a double click or a retry never refunds twice).
  const { count } = await admin.from('order_refunds').select('id', { count: 'exact', head: true }).eq('order_id', orderId)
  let refundId: string
  try {
    const refund = await stripe.refunds.create(
      {
        payment_intent: pi,
        amount: await refundAmountInChargeCurrency(pi, cents),   // EUR → the buyer's currency
        metadata: { order_id: order.id, order_number: order.order_number, reason: 'order_refund' },
      },
      { idempotencyKey: `order-refund-${order.id}-${count ?? 0}-${cents}` },
    )
    refundId = refund.id
  } catch (err) {
    const message = err instanceof Error ? err.message : 'Stripe refund failed'
    console.error('[refund-order] Stripe refund failed for order', orderId, ':', message)
    return reply(req, { error: `Stripe refund failed: ${message}` }, 502)
  }

  const { error: saveErr } = await admin.rpc('record_order_refund', {
    p_order_id: orderId,
    p_amount: cents / 100,
    p_reason: reason,
    p_stone_fate: fate,
    p_stripe_refund_id: refundId,
  })
  if (saveErr) {
    console.error('[refund-order] recording failed for order', orderId, ':', saveErr.message)
    return reply(req, { error: `The money was refunded in Stripe (${refundId}) but saving failed: ${saveErr.message}. Press Refund again with the same amount to finish.` }, 500)
  }

  return reply(req, { ok: true, refund_id: refundId, amount: cents / 100 })
}
