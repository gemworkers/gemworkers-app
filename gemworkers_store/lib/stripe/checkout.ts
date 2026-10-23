// SERVER ONLY — never import from a client component.

import Stripe from 'stripe'
import { stripe } from './server'

// Payment methods on the Stripe page. Instant methods only: each one is paid
// the moment Checkout completes, which is when the webhook confirms the order
// (delayed methods such as SEPA debit are deliberately left out).
// Apple Pay and Google Pay come with 'card'. Each method must also be switched
// on in Stripe Dashboard → Settings → Payment methods.
export const PAYMENT_METHODS: Stripe.Checkout.SessionCreateParams.PaymentMethodType[] = [
  'card',
  'paypal',
  'ideal',
  'bancontact',
  'klarna',
]

// Creates the Checkout Session with PAYMENT_METHODS. If Stripe refuses one of
// them (not switched on in the dashboard yet), retries with card only so
// checkout never breaks.
export async function createCheckoutSession(
  params: Omit<Stripe.Checkout.SessionCreateParams, 'payment_method_types'>,
): Promise<Stripe.Checkout.Session> {
  try {
    return await stripe.checkout.sessions.create({ ...params, payment_method_types: PAYMENT_METHODS })
  } catch (err) {
    const methodRefused =
      err instanceof Stripe.errors.StripeInvalidRequestError &&
      ((err.param ?? '').startsWith('payment_method_types') || /payment method type/i.test(err.message))
    if (!methodRefused) throw err
    console.error('[checkout] a payment method is not switched on in Stripe — card only:', (err as Error).message)
    return stripe.checkout.sessions.create({ ...params, payment_method_types: ['card'] })
  }
}
