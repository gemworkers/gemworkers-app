// SERVER ONLY — refund amounts when the buyer paid in another currency.
//
// We sell and account in EUR. US / UK / AU / CA buyers pay in their own
// currency (sql/local_currency.sql), and Stripe refunds in the currency the
// buyer paid. So a refund of €X becomes the same share of what they paid:
//   paid_in_their_currency × (€X ÷ € total of that payment)
// The € total is stored on the payment at checkout (metadata eur_total_cents).
// Stripe Adaptive Pricing payments (CHF, JPY…) stay EUR on our side — the
// payment is in EUR, Stripe refunds the buyer at the original rate — so they
// need no conversion here.
// When that is (within one unit of) everything still refundable, the exact
// remainder is refunded, so rounding never leaves a cent behind.

import type Stripe from 'stripe'
import { stripe } from './server'
import { createAdminClient } from '@/lib/supabase/admin'

// One order of the payment (a cart = one payment, several orders). Each order
// was charged its own rounded local amount (orders.charge_amount), so its
// refund converts by ITS ratio, and the last refund (final = everything still
// refundable in euros) returns exactly what is left of that order's amount.
export type RefundOrder = { orderId: string; final: boolean }

async function orderLocalRefund(intent: Stripe.PaymentIntent, eurCents: number, o: RefundOrder): Promise<number | null> {
  const { data } = await createAdminClient()
    .from('orders').select('charge_currency, charge_amount, order_total, tax_amount').eq('id', o.orderId).maybeSingle()
  const row = data as { charge_currency: string; charge_amount: string | number | null; order_total: string | number; tax_amount: string | number | null } | null
  if (!row || row.charge_currency.toLowerCase() !== intent.currency || !(Number(row.charge_amount) > 0)) return null
  const refunds = await stripe.refunds.list({ payment_intent: intent.id, limit: 100 })
  const done = refunds.data
    .filter(r => r.metadata?.order_id === o.orderId && r.status !== 'failed' && r.status !== 'canceled')
    .reduce((sum, r) => sum + r.amount, 0)
  const localLeft = Math.round(Number(row.charge_amount) * 100) - done
  const eurPaid = Math.round((Number(row.order_total) + Number(row.tax_amount ?? 0)) * 100)
  const share = Math.round(eurCents * Math.round(Number(row.charge_amount) * 100) / eurPaid)
  return Math.max(0, o.final ? localLeft : Math.min(share, localLeft))
}

export async function refundAmountInChargeCurrency(paymentIntentId: string, eurCents: number, order?: RefundOrder): Promise<number> {
  const intent = await stripe.paymentIntents.retrieve(paymentIntentId, { expand: ['latest_charge'] })
  const charge = intent.latest_charge && typeof intent.latest_charge !== 'string' ? (intent.latest_charge as Stripe.Charge) : null
  const remaining = intent.amount - (charge?.amount_refunded ?? 0)

  if (intent.currency !== 'eur' && order) {
    const local = await orderLocalRefund(intent, eurCents, order)
    if (local != null) return Math.min(local, remaining)
  }

  let amount = eurCents
  if (intent.currency !== 'eur') {
    let eurTotal = Number(intent.metadata?.eur_total_cents ?? 0)
    if (!(eurTotal > 0)) {
      const sessions = await stripe.checkout.sessions.list({ payment_intent: paymentIntentId, limit: 1 })
      eurTotal = sessions.data[0]?.currency_conversion?.amount_total ?? 0
    }
    if (!(eurTotal > 0)) {
      throw new Error(`Can't convert the refund: payment ${paymentIntentId} is in ${intent.currency.toUpperCase()} without a euro amount`)
    }
    amount = Math.round((intent.amount * eurCents) / eurTotal)
  }
  return amount >= remaining - 1 ? remaining : amount
}

/** The euro total of a Checkout Session (its own total when it was charged in EUR). */
export function sessionEurTotal(session: Stripe.Checkout.Session): number {
  const eurCents = Number(session.metadata?.eur_total_cents ?? 0)
  if (session.currency !== 'eur' && eurCents > 0) return eurCents / 100
  return (session.currency_conversion?.amount_total ?? session.amount_total ?? 0) / 100
}

/** What the buyer actually paid: amount and currency ("USD") of a Checkout Session. */
export function sessionPaid(session: Stripe.Checkout.Session): { amount: number; currency: string } {
  return { amount: (session.amount_total ?? 0) / 100, currency: (session.currency ?? 'eur').toUpperCase() }
}
