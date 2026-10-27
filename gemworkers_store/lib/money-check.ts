// SERVER ONLY — the daily money check. Compares Stripe with our records and
// lists anything that doesn't match. Nothing is changed; problems are only
// reported (app/api/cron/money-check emails them to the owner).
//
// Checked over the last DAYS days:
//  1. every succeeded Stripe payment belongs to orders marked paid, for the
//     same euro amount (a webhook that never arrived shows up here)
//  2. every paid shop order has a succeeded Stripe payment
//  3. every Stripe refund is recorded (order refund or return), same amount —
//     except refunds of late payments (the order was already released)
// Always checked:
//  4. invoice numbers per year are gapless and unique, and every paid order
//     since invoicing started (2026-10-24, paid > 1 hour ago) has an invoice
//  5. every seller payout = its sales − its charges

import type Stripe from 'stripe'
import { stripe } from '@/lib/stripe/server'
import type { createAdminClient } from '@/lib/supabase/admin'
import { findPaymentIntent } from '@/lib/admin-api'

type Admin = ReturnType<typeof createAdminClient>

const DAYS = 7
const INVOICES_FROM = '2026-10-24'

type OrderRow = {
  id: string; order_number: string; status: string; paid_at: string | null
  order_total: string | number; tax_amount: string | number | null
  stripe_payment_intent: string | null; checkout_group_id: string | null
}

const cents = (v: string | number | null | undefined) => Math.round(Number(v ?? 0) * 100)
const eur = (c: number) => `€${(c / 100).toFixed(2)}`

export type MoneyCheck = { checked: Record<string, number>; problems: string[] }

export async function runMoneyCheck(admin: Admin): Promise<MoneyCheck> {
  const problems: string[] = []
  const checked: Record<string, number> = {}
  const since = Math.floor(Date.now() / 1000) - DAYS * 24 * 3600
  const sinceIso = new Date(since * 1000).toISOString()

  // ── 1. Stripe payments → our orders ────────────────────────────────────────
  const payments: Stripe.PaymentIntent[] = []
  for await (const pi of stripe.paymentIntents.list({ created: { gte: since }, limit: 100 })) {
    if (pi.status === 'succeeded') payments.push(pi)
  }
  checked.stripe_payments = payments.length
  const lateRefunded = new Set<string>()   // payments refunded because they came too late
  const refunds: Stripe.Refund[] = []
  for await (const r of stripe.refunds.list({ created: { gte: since }, limit: 100 })) {
    if (r.status === 'failed' || r.status === 'canceled') continue
    refunds.push(r)
    if (r.metadata?.reason === 'late_payment' && typeof r.payment_intent === 'string') lateRefunded.add(r.payment_intent)
  }

  const cols = 'id, order_number, status, paid_at, order_total, tax_amount, stripe_payment_intent, checkout_group_id'
  for (const pi of payments) {
    let { data } = await admin.from('orders').select(cols).eq('stripe_payment_intent', pi.id)
    let orders = (data as OrderRow[] | null) ?? []
    if (orders.length === 0) {
      const group = pi.metadata?.checkout_group_id
      const orderId = pi.metadata?.order_id
      if (group) ({ data } = await admin.from('orders').select(cols).eq('checkout_group_id', group))
      else if (orderId) ({ data } = await admin.from('orders').select(cols).eq('id', orderId))
      orders = (data as OrderRow[] | null) ?? []
    }
    const label = `Stripe payment ${eur(pi.amount)} (${pi.id})`
    if (orders.length === 0) {
      problems.push(`${label} has no order in GemWorkers.`)
      continue
    }
    const names = orders.map(o => o.order_number).join(', ')
    if (lateRefunded.has(pi.id)) continue   // paid after the deadline, refunded on purpose
    const unpaid = orders.filter(o => !o.paid_at)
    if (unpaid.length > 0) {
      problems.push(`${label} was paid, but ${unpaid.map(o => `${o.order_number} (${o.status})`).join(', ')} is not marked paid.`)
      continue
    }
    if (pi.currency === 'eur') {
      const ours = orders.reduce((s, o) => s + cents(o.order_total) + cents(o.tax_amount), 0)
      if (ours !== pi.amount) problems.push(`${label}: Stripe charged ${eur(pi.amount)}, ${names} add up to ${eur(ours)}.`)
    }
  }

  // ── 2. Our paid orders → Stripe ────────────────────────────────────────────
  const { data: paidData } = await admin.from('orders').select(cols)
    .eq('sale_channel', 'platform').gte('paid_at', sinceIso)
  const paid = (paidData as OrderRow[] | null) ?? []
  checked.paid_orders = paid.length
  const byId = new Map(payments.map(p => [p.id, p]))
  for (const o of paid) {
    // Older orders may lack the link: look the payment up in Stripe by its
    // order / cart number before calling it a problem.
    const piId = o.stripe_payment_intent ?? await findPaymentIntent({
      id: o.id, checkout_group_id: o.checkout_group_id, stripe_payment_intent: null, stripe_checkout_session_id: null,
    })
    if (!piId) {
      problems.push(`${o.order_number} is marked paid but no Stripe payment was found for it.`)
      continue
    }
    let pi = byId.get(piId)
    if (!pi) {
      try { pi = await stripe.paymentIntents.retrieve(piId) } catch { /* reported below */ }
    }
    if (!pi || pi.status !== 'succeeded') {
      problems.push(`${o.order_number} is marked paid, but its Stripe payment is ${pi ? pi.status : 'not found'}.`)
    }
  }

  // ── 3. Stripe refunds → our records ────────────────────────────────────────
  checked.stripe_refunds = refunds.length
  for (const r of refunds) {
    if (r.metadata?.reason === 'late_payment') continue
    const [{ data: orf }, { data: ret }] = await Promise.all([
      admin.from('order_refunds').select('amount').eq('stripe_refund_id', r.id).maybeSingle(),
      admin.from('returns').select('refund_amount').eq('stripe_refund_id', r.id).maybeSingle(),
    ])
    const recorded = (orf as { amount: string } | null)?.amount ?? (ret as { refund_amount: string } | null)?.refund_amount
    const label = `Stripe refund ${eur(r.amount)} (${r.id}${r.metadata?.order_number ? `, ${r.metadata.order_number}` : ''})`
    if (recorded == null) problems.push(`${label} is not recorded in GemWorkers (no refund or return).`)
    else if (r.currency === 'eur' && cents(recorded) !== r.amount) problems.push(`${label}: GemWorkers recorded ${eur(cents(recorded))}.`)
  }

  // ── 4. Invoices ────────────────────────────────────────────────────────────
  const { data: invData } = await admin.from('invoices').select('number, order_id, kind')
  const invoices = (invData as { number: string; order_id: string; kind: string }[] | null) ?? []
  checked.invoices = invoices.length
  const perYear = new Map<string, number[]>()
  for (const inv of invoices) {
    const m = /^GW-(\d{4})-(\d+)$/.exec(inv.number)
    if (!m) { problems.push(`Invoice number "${inv.number}" has an unexpected format.`); continue }
    perYear.set(m[1], [...(perYear.get(m[1]) ?? []), Number(m[2])])
  }
  for (const [year, nums] of perYear) {
    const sorted = [...nums].sort((a, b) => a - b)
    const dupes = sorted.filter((n, i) => i > 0 && n === sorted[i - 1])
    if (dupes.length) problems.push(`Invoice numbers used twice in ${year}: ${[...new Set(dupes)].join(', ')}.`)
    const missing: number[] = []
    for (let n = 1; n <= sorted[sorted.length - 1]; n++) if (!sorted.includes(n)) missing.push(n)
    if (missing.length) problems.push(`Invoice numbers missing in ${year} (gap): ${missing.slice(0, 10).join(', ')}${missing.length > 10 ? '…' : ''}.`)
  }
  const invoiced = new Set(invoices.filter(i => i.kind === 'invoice').map(i => i.order_id))
  const { data: needData } = await admin.from('orders').select('order_number, id')
    .eq('sale_channel', 'platform').gte('paid_at', INVOICES_FROM)
    .lte('paid_at', new Date(Date.now() - 3600 * 1000).toISOString())
  for (const o of (needData as { id: string; order_number: string }[] | null) ?? []) {
    if (!invoiced.has(o.id)) problems.push(`${o.order_number} is paid but has no invoice.`)
  }

  // ── 5. Payouts ─────────────────────────────────────────────────────────────
  const { data: poData } = await admin.from('payouts').select('number, sales_total, charges_total, amount')
  const pos = (poData as { number: string; sales_total: string; charges_total: string; amount: string }[] | null) ?? []
  checked.payouts = pos.length
  for (const p of pos) {
    if (cents(p.sales_total) - cents(p.charges_total) !== cents(p.amount)) {
      problems.push(`Payout ${p.number}: ${eur(cents(p.sales_total))} sales − ${eur(cents(p.charges_total))} charges ≠ ${eur(cents(p.amount))} paid.`)
    }
  }

  return { checked, problems }
}
