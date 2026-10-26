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
// converted by Stripe; the session/payment stay EUR for us, the buyer pays the
// 2–4% fee, refunds go back at the same rate. It never touches our USD/GBP/AUD/
// CAD sessions (not a settlement currency). Test it with a buyer account email
// like name+location_CH@… (passed as customer_email). Refunds of our own
// local-currency orders: lib/stripe/refunds.ts.
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
