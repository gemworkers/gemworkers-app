// SERVER ONLY — never import from a client component.

import type Stripe from 'stripe'
import { stripe } from './server'

// Payment methods: Stripe's dynamic payment methods — no list in code. Stripe
// shows each buyer the methods common in their country (cards, Apple Pay,
// Google Pay, PayPal, Klarna, iDEAL, Bancontact…) from those switched on in
// Dashboard → Settings → Payment methods.
// Keep delayed methods OFF there (SEPA debit, ACH, bank transfer, vouchers):
// the stone is held for 30 minutes and the webhook confirms only payments
// that are 'paid' (charge.dispute / async_payment_succeeded handle the rest).
//
// Currency: GemWorkers charges euros only. Stripe Adaptive Pricing (ON) shows
// buyers outside the euro the exact amount in their own currency and lets them
// pay in it; the buyer pays Stripe's conversion, refunds go back at the same
// rate (lib/stripe/refunds.ts). Test a foreign buyer with an account email like
// name+location_US@… (passed as customer_email).
//
// Fraud: from THREE_DS_FROM_EUR (the order's euro value, metadata
// eur_total_cents) every card payment asks for the bank's own check
// (3-D Secure: code or approval in the banking app) where the card supports
// it. A stolen-card chargeback on a 3-D Secure payment is then the bank's
// loss, not ours. Below it Stripe asks only when the bank requires it.
export const THREE_DS_FROM_EUR = 300

export async function createCheckoutSession(
  params: Omit<Stripe.Checkout.SessionCreateParams, 'payment_method_types'>,
): Promise<Stripe.Checkout.Session> {
  const eurCents = Number(params.metadata?.eur_total_cents ?? 0)
  if (eurCents >= THREE_DS_FROM_EUR * 100) {
    params = {
      ...params,
      payment_method_options: {
        ...params.payment_method_options,
        card: { ...params.payment_method_options?.card, request_three_d_secure: 'any' },
      },
    }
  }
  return stripe.checkout.sessions.create(params)
}
