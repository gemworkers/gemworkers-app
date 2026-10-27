// SERVER ONLY — Stripe's fee and the euros Stripe credits, saved per order.
//
// stripe_fee feeds consignment profit splits and the money overview;
// eur_received is the euros Stripe credited for the payment
// (sql/local_currency.sql column). A cart is one payment: both are split over its
// orders by what each order cost the buyer. For a payment in another currency
// Stripe often has no euro figures yet when the webhook arrives — the daily
// catch-up (app/api/cron/stripe-fees) fills those in later.

import type Stripe from 'stripe'
import { stripe } from './server'
import { createAdminClient } from '@/lib/supabase/admin'
import { paidTotal } from '@/lib/tax'

type AdminClient = ReturnType<typeof createAdminClient>

/** Saves fee + euros received on [orderIds] (all orders of payment [pi]). False = not available yet. */
export async function recordFeeForPayment(admin: AdminClient, pi: string, orderIds: string[]): Promise<boolean> {
  if (orderIds.length === 0) return false
  const intent = await stripe.paymentIntents.retrieve(pi, { expand: ['latest_charge.balance_transaction'] })
  const charge = intent.latest_charge
  const bt = charge && typeof charge !== 'string' ? (charge as Stripe.Charge).balance_transaction : null
  if (!bt || typeof bt === 'string' || bt.currency !== 'eur') return false

  const { data } = await admin.from('orders').select('id, order_total, tax_amount').in('id', orderIds)
  const rows = ((data as { id: string; order_total: string | number; tax_amount: string | number | null }[] | null) ?? [])
    .map(o => ({ id: o.id, cents: Math.round(paidTotal(o.order_total, o.tax_amount) * 100) }))
  const totalCents = rows.reduce((s, r) => s + r.cents, 0)
  if (totalCents <= 0) return false
  let left = bt.fee
  let leftGross = bt.amount
  for (const [i, r] of rows.entries()) {
    const last = i === rows.length - 1
    const share = last ? left : Math.round(bt.fee * r.cents / totalCents)
    const gross = last ? leftGross : Math.round(bt.amount * r.cents / totalCents)
    left -= share
    leftGross -= gross
    const { error } = await admin.from('orders').update({ stripe_fee: share / 100, eur_received: gross / 100 }).eq('id', r.id)
    if (error) console.error('[stripe-fee] save failed for order', r.id, ':', error.message)
  }
  return true
}
