// SERVER ONLY — refund amounts when the buyer paid in another currency.
//
// We sell and account in EUR. With Stripe Adaptive Pricing the buyer may have
// paid in USD, AUD… and Stripe refunds in the currency the buyer paid. So a
// refund of €X becomes the same share of what the buyer actually paid:
//   paid_in_their_currency × (€X ÷ € total of that payment)
// When that is (within one unit of) everything still refundable, the exact
// remainder is refunded, so rounding never leaves a cent behind.

import type Stripe from 'stripe'
import { stripe } from './server'

export async function refundAmountInChargeCurrency(paymentIntentId: string, eurCents: number): Promise<number> {
  const intent = await stripe.paymentIntents.retrieve(paymentIntentId, { expand: ['latest_charge'] })
  const charge = intent.latest_charge && typeof intent.latest_charge !== 'string' ? (intent.latest_charge as Stripe.Charge) : null
  const remaining = intent.amount - (charge?.amount_refunded ?? 0)

  let amount = eurCents
  if (intent.currency !== 'eur') {
    const sessions = await stripe.checkout.sessions.list({ payment_intent: paymentIntentId, limit: 1 })
    const eurTotal = sessions.data[0]?.currency_conversion?.amount_total
    if (!eurTotal || eurTotal <= 0) {
      throw new Error(`Can't convert the refund: payment ${paymentIntentId} is in ${intent.currency.toUpperCase()} without a euro amount`)
    }
    amount = Math.round((intent.amount * eurCents) / eurTotal)
  }
  return amount >= remaining - 1 ? remaining : amount
}

/** The euro total of a Checkout Session (its own total when it was charged in EUR). */
export function sessionEurTotal(session: Stripe.Checkout.Session): number {
  return (session.currency_conversion?.amount_total ?? session.amount_total ?? 0) / 100
}
