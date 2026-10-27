// SERVER ONLY — the Stripe refund amount for a refund of €X.
//
// GemWorkers charges in euros only. Buyers outside the euro may pay in their
// own currency through Stripe Adaptive Pricing; Stripe then refunds them at
// the rate of the original payment. Should a payment ever be in another
// currency, €X becomes the same share of it, using the euro total stored on
// the payment at checkout (metadata eur_total_cents).
// When that is (within one cent) everything still refundable, the exact
// remainder is refunded, so rounding never leaves a cent behind.

import type Stripe from 'stripe'
import { stripe } from './server'

export async function refundAmount(paymentIntentId: string, eurCents: number): Promise<number> {
  const intent = await stripe.paymentIntents.retrieve(paymentIntentId, { expand: ['latest_charge'] })
  const charge = intent.latest_charge && typeof intent.latest_charge !== 'string' ? (intent.latest_charge as Stripe.Charge) : null
  const remaining = intent.amount - (charge?.amount_refunded ?? 0)

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
