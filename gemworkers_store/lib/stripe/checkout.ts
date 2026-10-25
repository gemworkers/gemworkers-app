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
// Local currency: US / UK / AU / CA buyers are charged in their own currency
// at OUR price (app/actions/commerce.ts lockLocalCurrency, sql/local_currency.sql).
// Stripe Adaptive Pricing is ON (Zakaria 2026-10-25). Sessions already in the
// buyer's currency (US/GB/AU/CA) need no conversion; buyers elsewhere (CH, JP, SE…) may pay in their own currency,
// converted by Stripe, buyer pays its fee, we receive the euro amount. Refunds
// convert back per order: lib/stripe/refunds.ts (metadata eur_total_cents).
export async function createCheckoutSession(
  params: Omit<Stripe.Checkout.SessionCreateParams, 'payment_method_types'>,
): Promise<Stripe.Checkout.Session> {
  return stripe.checkout.sessions.create(params)
}
