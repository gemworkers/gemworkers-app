export const runtime = 'nodejs'

import { NextRequest, NextResponse } from 'next/server'
import type Stripe from 'stripe'
import { stripe } from '@/lib/stripe/server'
import { createAdminClient } from '@/lib/supabase/admin'
import { sendNewOrderEmail, type EmailOrderLine, type ShippingAddress } from '@/lib/email/sendNewOrderEmail'
import { sendOrderConfirmationEmail } from '@/lib/email/sendOrderConfirmationEmail'
import { paidTotal } from '@/lib/tax'
import {
  sendLatePaymentOwnerEmail,
  sendLatePaymentBuyerEmail,
  sendLatePaymentSellerEmail,
  type RefundedOrderLine,
} from '@/lib/email/sendLatePaymentRefundEmails'

// ── Email notification helpers ─────────────────────────────────────────────────
// Called after order confirmation + address write. Always best-effort — callers
// wrap in try/catch so a Resend failure never fails the webhook response.

type AdminClient = ReturnType<typeof createAdminClient>

interface OrderRow {
  id:                  string
  order_number:        string
  order_total:         string | number
  seller_id:           string
  shipping_name:       string | null
  shipping_line1:      string | null
  shipping_line2:      string | null
  shipping_city:       string | null
  shipping_state:      string | null
  shipping_postal_code: string | null
  shipping_country:    string | null
  shipping_phone:      string | null
}

function rowToShipping(o: OrderRow): ShippingAddress {
  return {
    name:       o.shipping_name,
    line1:      o.shipping_line1,
    line2:      o.shipping_line2,
    city:       o.shipping_city,
    state:      o.shipping_state,
    postalCode: o.shipping_postal_code,
    country:    o.shipping_country,
    phone:      o.shipping_phone,
  }
}

async function notifySingleOrder(admin: AdminClient, orderId: string): Promise<void> {
  const ownerEmail = process.env.OWNER_EMAIL?.trim() ?? ''

  // Order details (shipping fields written by the address-update step).
  const { data: ordData } = await admin
    .from('orders')
    .select('id, order_number, order_total, seller_id, shipping_name, shipping_line1, shipping_line2, shipping_city, shipping_state, shipping_postal_code, shipping_country, shipping_phone')
    .eq('id', orderId)
    .single()
  if (!ordData) { console.error('[webhook] email: order not found', orderId); return }
  const ord = ordData as OrderRow

  // Item title — first (and normally only) line item.
  const { data: itemData } = await admin
    .from('order_items')
    .select('inventory_item_id')
    .eq('order_id', orderId)
    .limit(1)
  const itemId = (itemData as { inventory_item_id: string }[] | null)?.[0]?.inventory_item_id
  let itemTitle = 'Stone'
  if (itemId) {
    const { data: invData } = await admin
      .from('inventory_items').select('title').eq('id', itemId).single()
    itemTitle = (invData as { title: string } | null)?.title ?? 'Stone'
  }

  // Seller email.
  const { data: sellerData } = await admin
    .from('sellers').select('email').eq('id', ord.seller_id).single()
  const sellerEmail = (sellerData as { email: string } | null)?.email?.trim() ?? ''
  if (!sellerEmail) {
    console.error('[webhook] email: seller', ord.seller_id, 'has no email — skipping seller recipient for order', orderId)
  }

  // One email per recipient — seller and owner never share a To: line.
  // A seller whose email is the owner's gets a single copy.
  const recipients = [sellerEmail, ownerEmail].filter(e => e !== '')
  const unique = recipients.filter((e, i) => recipients.findIndex(x => x.toLowerCase() === e.toLowerCase()) === i)
  if (unique.length === 0) { console.error('[webhook] email: no recipients for order', orderId); return }

  for (const to of unique) {
    try {
      await sendNewOrderEmail({
        to:       [to],
        subject:  `New GemWorkers order — ${itemTitle}`,
        orders:   [{ orderNumber: ord.order_number, itemTitle, orderTotal: Number(ord.order_total) }],
        shipping: rowToShipping(ord),
      })
    } catch (e) {
      console.error('[webhook] new-order email failed for order', orderId, '(', to === ownerEmail ? 'owner' : 'seller', '):', e instanceof Error ? e.message : String(e))
    }
  }
}

async function notifyGroupOrders(admin: AdminClient, groupId: string, orderIdsInScope: string[]): Promise<void> {
  const ownerEmail = process.env.OWNER_EMAIL?.trim() ?? ''

  // 1. All orders in the group (shipping is shared — same buyer checkout).
  const { data: ordersData } = await admin
    .from('orders')
    .select('id, order_number, order_total, seller_id, shipping_name, shipping_line1, shipping_line2, shipping_city, shipping_state, shipping_postal_code, shipping_country, shipping_phone')
    .eq('checkout_group_id', groupId)
    .in('id', orderIdsInScope)
  const orders = (ordersData as OrderRow[] | null) ?? []
  if (orders.length === 0) return

  // 2. First order's shipping fields represent the whole group.
  const shipping = rowToShipping(orders[0]!)

  // 3. All order items → map order_id → item title.
  const orderIds = orders.map(o => o.id)
  const { data: itemsData } = await admin
    .from('order_items').select('order_id, inventory_item_id').in('order_id', orderIds)
  const items = (itemsData as { order_id: string; inventory_item_id: string }[] | null) ?? []

  const invIds = [...new Set(items.map(i => i.inventory_item_id))]
  const { data: invData } = await admin
    .from('inventory_items').select('id, title').in('id', invIds)
  const invMap = new Map(((invData as { id: string; title: string }[] | null) ?? []).map(i => [i.id, i.title]))

  const orderTitleMap = new Map<string, string>()
  for (const it of items) {
    if (!orderTitleMap.has(it.order_id)) {
      orderTitleMap.set(it.order_id, invMap.get(it.inventory_item_id) ?? 'Stone')
    }
  }

  // 4. Seller emails.
  const sellerIds = [...new Set(orders.map(o => o.seller_id))]
  const { data: sellersData } = await admin
    .from('sellers').select('id, email').in('id', sellerIds)
  const sellerEmailMap = new Map(
    ((sellersData as { id: string; email: string }[] | null) ?? [])
      .map(s => [s.id, s.email?.trim() ?? ''])
  )

  // Owner — one summary of ALL orders in the group.
  if (ownerEmail) {
    const allLines: EmailOrderLine[] = orders.map(o => ({
      orderNumber: o.order_number,
      itemTitle:   orderTitleMap.get(o.id) ?? 'Stone',
      orderTotal:  Number(o.order_total),
    }))
    await sendNewOrderEmail({
      to:       [ownerEmail],
      subject:  `New GemWorkers order group — ${orders.length} stone${orders.length !== 1 ? 's' : ''}`,
      orders:   allLines,
      shipping,
    })
  }

  // Each seller — only their orders in the group.
  const sellerOrders = new Map<string, OrderRow[]>()
  for (const ord of orders) {
    const existing = sellerOrders.get(ord.seller_id)
    if (existing) { existing.push(ord) } else { sellerOrders.set(ord.seller_id, [ord]) }
  }
  for (const [sellerId, sellerOrderList] of sellerOrders) {
    const sellerEmail = sellerEmailMap.get(sellerId) ?? ''
    if (!sellerEmail) {
      console.error('[webhook] email: seller', sellerId, 'has no email — skipping seller recipient in group', groupId)
      continue
    }
    const lines: EmailOrderLine[] = sellerOrderList.map(o => ({
      orderNumber: o.order_number,
      itemTitle:   orderTitleMap.get(o.id) ?? 'Stone',
      orderTotal:  Number(o.order_total),
    }))
    await sendNewOrderEmail({
      to:       [sellerEmail],
      subject:  lines.length === 1
        ? `New GemWorkers order — ${lines[0]!.itemTitle}`
        : `New GemWorkers order — ${lines.length} stones`,
      orders:   lines,
      shipping,
    })
  }
}

async function notifyCustomerSingleOrder(
  admin: AdminClient,
  orderId: string,
  stripeEmail: string | null,
): Promise<void> {
  // Resolve email: Stripe's collected value is authoritative; fall back to buyers table.
  let customerEmail = stripeEmail?.trim() || ''
  if (!customerEmail) {
    const { data: ob } = await admin
      .from('orders').select('buyer_id').eq('id', orderId).single()
    const buyerId = (ob as { buyer_id: string } | null)?.buyer_id
    if (buyerId) {
      const { data: bd } = await admin
        .from('buyers').select('email').eq('id', buyerId).single()
      customerEmail = (bd as { email: string } | null)?.email?.trim() ?? ''
    }
  }
  if (!customerEmail) {
    console.error('[webhook] customer email: no address resolved for order', orderId)
    return
  }

  const { data: ordData } = await admin
    .from('orders')
    .select('order_number, order_total, tax_amount, shipping_name, shipping_line1, shipping_line2, shipping_city, shipping_state, shipping_postal_code, shipping_country, shipping_phone')
    .eq('id', orderId)
    .single()
  if (!ordData) { console.error('[webhook] customer email: order not found', orderId); return }

  const o = ordData as {
    order_number: string; order_total: string | number; tax_amount: string | number | null
    shipping_name: string | null; shipping_line1: string | null; shipping_line2: string | null
    shipping_city: string | null; shipping_state: string | null
    shipping_postal_code: string | null; shipping_country: string | null; shipping_phone: string | null
  }

  const { data: itemData } = await admin
    .from('order_items').select('inventory_item_id').eq('order_id', orderId).limit(1)
  const itemId = (itemData as { inventory_item_id: string }[] | null)?.[0]?.inventory_item_id
  let itemTitle = 'Stone'
  if (itemId) {
    const { data: invData } = await admin
      .from('inventory_items').select('title').eq('id', itemId).single()
    itemTitle = (invData as { title: string } | null)?.title ?? 'Stone'
  }

  const shipping: ShippingAddress = {
    name:       o.shipping_name,
    line1:      o.shipping_line1,
    line2:      o.shipping_line2,
    city:       o.shipping_city,
    state:      o.shipping_state,
    postalCode: o.shipping_postal_code,
    country:    o.shipping_country,
    phone:      o.shipping_phone,
  }

  await sendOrderConfirmationEmail({
    to:       [customerEmail],
    orders:   [{ orderNumber: o.order_number, itemTitle, orderTotal: paidTotal(o.order_total, o.tax_amount) }],
    shipping,
  })
}

async function notifyCustomerGroupOrder(
  admin: AdminClient,
  groupId: string,
  orderIdsInScope: string[],
  stripeEmail: string | null,
): Promise<void> {
  type GroupOrderRow = {
    id: string; buyer_id: string; order_number: string; order_total: string | number; tax_amount: string | number | null
    shipping_name: string | null; shipping_line1: string | null; shipping_line2: string | null
    shipping_city: string | null; shipping_state: string | null
    shipping_postal_code: string | null; shipping_country: string | null; shipping_phone: string | null
  }

  const { data: ordersData } = await admin
    .from('orders')
    .select('id, buyer_id, order_number, order_total, tax_amount, shipping_name, shipping_line1, shipping_line2, shipping_city, shipping_state, shipping_postal_code, shipping_country, shipping_phone')
    .eq('checkout_group_id', groupId)
    .in('id', orderIdsInScope)
  const orders = (ordersData as GroupOrderRow[] | null) ?? []
  if (orders.length === 0) return

  // Resolve email: Stripe's collected value is authoritative; fall back to buyers table.
  let customerEmail = stripeEmail?.trim() || ''
  if (!customerEmail) {
    const buyerId = orders[0]!.buyer_id
    const { data: bd } = await admin
      .from('buyers').select('email').eq('id', buyerId).single()
    customerEmail = (bd as { email: string } | null)?.email?.trim() ?? ''
  }
  if (!customerEmail) {
    console.error('[webhook] customer email: no address resolved for group', groupId)
    return
  }

  // Resolve item titles.
  const orderIds = orders.map(o => o.id)
  const { data: itemsData } = await admin
    .from('order_items').select('order_id, inventory_item_id').in('order_id', orderIds)
  const items = (itemsData as { order_id: string; inventory_item_id: string }[] | null) ?? []

  const invIds = [...new Set(items.map(i => i.inventory_item_id))]
  const { data: invData } = await admin
    .from('inventory_items').select('id, title').in('id', invIds)
  const invMap = new Map(
    ((invData as { id: string; title: string }[] | null) ?? []).map(i => [i.id, i.title])
  )

  const orderTitleMap = new Map<string, string>()
  for (const it of items) {
    if (!orderTitleMap.has(it.order_id)) {
      orderTitleMap.set(it.order_id, invMap.get(it.inventory_item_id) ?? 'Stone')
    }
  }

  // Shipping is shared across the group — use the first order's fields.
  const first = orders[0]!
  const shipping: ShippingAddress = {
    name:       first.shipping_name,
    line1:      first.shipping_line1,
    line2:      first.shipping_line2,
    city:       first.shipping_city,
    state:      first.shipping_state,
    postalCode: first.shipping_postal_code,
    country:    first.shipping_country,
    phone:      first.shipping_phone,
  }

  const lines: EmailOrderLine[] = orders.map(o => ({
    orderNumber: o.order_number,
    itemTitle:   orderTitleMap.get(o.id) ?? 'Stone',
    orderTotal:  paidTotal(o.order_total, o.tax_amount),
  }))

  await sendOrderConfirmationEmail({ to: [customerEmail], orders: lines, shipping })
}

// ── Late payment (order no longer pending) ────────────────────────────────────
// A Stripe payment can complete after the order was cancelled (reservation
// expired, session expired, offer window closed). The stone may already be
// released, so we refund instead of confirming.

// Statuses that mean the order was already paid for — never refund these.
const PAID_STATUSES = ['confirmed', 'shipped', 'received', 'paid']

function isLateStatus(status: string): boolean {
  return status !== 'pending_payment' && !PAID_STATUSES.includes(status)
}

function paymentIntentId(session: Stripe.Checkout.Session): string | null {
  const pi = session.payment_intent
  if (!pi) return null
  return typeof pi === 'string' ? pi : pi.id
}

// Refunds one order's share of the payment. Returns false if a late refund for
// this order already exists (duplicate delivery). Double-guarded: the Stripe
// idempotency key covers retries within 24h; the metadata lookup covers
// redeliveries after the key has expired.
async function refundLateOrder(
  paymentIntent: string,
  orderId: string,
  amountCents?: number,   // omitted = full refund
): Promise<boolean> {
  const existing = await stripe.refunds.list({ payment_intent: paymentIntent, limit: 100 })
  if (existing.data.some(r => r.metadata?.order_id === orderId && r.metadata?.reason === 'late_payment')) {
    return false
  }
  await stripe.refunds.create(
    {
      payment_intent: paymentIntent,
      ...(amountCents !== undefined ? { amount: amountCents } : {}),
      metadata: { order_id: orderId, reason: 'late_payment' },
    },
    { idempotencyKey: `refund-late-${orderId}` },
  )
  return true
}

// Issues the invoice for each paid order. Never throws — a failure is logged
// and the 10-minute issue_missing_invoices cron issues it later.
async function issueInvoices(admin: AdminClient, orderIds: string[]): Promise<void> {
  for (const id of orderIds) {
    try {
      const { error } = await admin.rpc('issue_invoice', { p_order_id: id })
      if (error) console.error('[webhook] issue_invoice failed for order', id, ':', error.message)
    } catch (e) {
      console.error('[webhook] issue_invoice threw for order', id, ':', e instanceof Error ? e.message : String(e))
    }
  }
}

// Order number / title / total for the refund emails.
async function loadRefundedLines(admin: AdminClient, orderIds: string[]): Promise<RefundedOrderLine[]> {
  const { data: ordersData } = await admin
    .from('orders').select('id, order_number, order_total, tax_amount').in('id', orderIds)
  const orders = (ordersData as { id: string; order_number: string; order_total: string | number; tax_amount: string | number | null }[] | null) ?? []

  const { data: itemsData } = await admin
    .from('order_items').select('order_id, inventory_item_id').in('order_id', orderIds)
  const items = (itemsData as { order_id: string; inventory_item_id: string }[] | null) ?? []
  const invIds = [...new Set(items.map(i => i.inventory_item_id))]
  const { data: invData } = await admin
    .from('inventory_items').select('id, title').in('id', invIds)
  const invMap = new Map(((invData as { id: string; title: string }[] | null) ?? []).map(i => [i.id, i.title]))
  const titleMap = new Map<string, string>()
  for (const it of items) {
    if (!titleMap.has(it.order_id)) titleMap.set(it.order_id, invMap.get(it.inventory_item_id) ?? 'Stone')
  }

  return orderIds.map(id => {
    const o = orders.find(x => x.id === id)
    return {
      orderId:     id,
      orderNumber: o?.order_number ?? id,
      itemTitle:   titleMap.get(id) ?? 'Stone',
      orderTotal:  paidTotal(o?.order_total ?? 0, o?.tax_amount ?? 0),   // refunded = paid incl. VAT
    }
  })
}

// Each seller is told about their own refunded orders: the sale fell through
// and nothing should be shipped. Skipped when the seller's inbox is the
// owner's (the owner notice already covers it).
async function notifyLatePaymentSellers(
  admin: AdminClient,
  lines: RefundedOrderLine[],
  ownerEmail: string,
): Promise<void> {
  const { data: ordersData } = await admin
    .from('orders').select('id, seller_id').in('id', lines.map(l => l.orderId))
  const sellerOf = new Map(
    ((ordersData as { id: string; seller_id: string }[] | null) ?? []).map(o => [o.id, o.seller_id])
  )

  const bySeller = new Map<string, RefundedOrderLine[]>()
  for (const line of lines) {
    const sellerId = sellerOf.get(line.orderId)
    if (!sellerId) { console.error('[webhook] late-payment seller email: no seller for order', line.orderId); continue }
    bySeller.set(sellerId, [...(bySeller.get(sellerId) ?? []), line])
  }
  if (bySeller.size === 0) return

  const { data: sellersData } = await admin
    .from('sellers').select('id, email').in('id', [...bySeller.keys()])
  const emailOf = new Map(
    ((sellersData as { id: string; email: string | null }[] | null) ?? []).map(s => [s.id, s.email?.trim() ?? ''])
  )

  for (const [sellerId, sellerLines] of bySeller) {
    const to = emailOf.get(sellerId) ?? ''
    if (!to) {
      console.error('[webhook] late-payment seller email: seller', sellerId, 'has no email')
      continue
    }
    if (to.toLowerCase() === ownerEmail.toLowerCase()) continue
    try {
      await sendLatePaymentSellerEmail({ to, orders: sellerLines })
    } catch (e) {
      console.error('[webhook] late-payment seller email failed for seller', sellerId, ':', e instanceof Error ? e.message : String(e))
    }
  }
}

// Owner + buyer + seller notices. Best-effort — each send is isolated.
async function notifyLatePayment(
  admin: AdminClient,
  orderIds: string[],
  refundedTotal: number,
  buyerEmail: string | null,
  sessionId: string,
  paymentIntent: string,
): Promise<void> {
  const lines = await loadRefundedLines(admin, orderIds)
  const ownerEmail = process.env.OWNER_EMAIL?.trim() ?? ''

  if (ownerEmail) {
    try {
      await sendLatePaymentOwnerEmail({ to: ownerEmail, orders: lines, refundedTotal, buyerEmail, sessionId, paymentIntent })
    } catch (e) {
      console.error('[webhook] late-payment owner email failed for', orderIds, ':', e instanceof Error ? e.message : String(e))
    }
  } else {
    console.error('[webhook] late-payment owner email: OWNER_EMAIL not set')
  }

  if (buyerEmail) {
    try {
      await sendLatePaymentBuyerEmail({ to: buyerEmail, orders: lines, refundedTotal })
    } catch (e) {
      console.error('[webhook] late-payment buyer email failed for', orderIds, ':', e instanceof Error ? e.message : String(e))
    }
  } else {
    console.error('[webhook] late-payment buyer email: no customer email on session', sessionId)
  }

  try {
    await notifyLatePaymentSellers(admin, lines, ownerEmail)
  } catch (e) {
    console.error('[webhook] late-payment seller emails threw for', orderIds, ':', e instanceof Error ? e.message : String(e))
  }
}

// ── Webhook handler ────────────────────────────────────────────────────────────

export async function POST(req: NextRequest) {
  // Raw body required — Stripe signature verification needs the exact bytes
  // that were transmitted. Parsing JSON first would break the HMAC check.
  const rawBody = await req.text()
  const signature = req.headers.get('stripe-signature')

  if (!process.env.STRIPE_WEBHOOK_SECRET) {
    console.error('[webhook] STRIPE_WEBHOOK_SECRET is not set')
    return NextResponse.json({ error: 'Webhook secret not configured' }, { status: 400 })
  }

  if (!signature) {
    return NextResponse.json({ error: 'Missing stripe-signature header' }, { status: 400 })
  }

  let event: Stripe.Event
  try {
    event = stripe.webhooks.constructEvent(
      rawBody,
      signature,
      process.env.STRIPE_WEBHOOK_SECRET
    )
  } catch (err) {
    const message = err instanceof Error ? err.message : 'Signature verification failed'
    console.error('[webhook] Signature verification failed:', message)
    return NextResponse.json({ error: message }, { status: 400 })
  }

  // Service role client — the webhook has no user session, so the normal
  // cookie-based client would authenticate as anon, which lacks EXECUTE on
  // confirm_order_paid and cancel_pending_payment_order.
  const supabase = createAdminClient()

  // async_payment_succeeded = a delayed method paid later; same path (a late
  // payment for a released stone is refunded there).
  if (event.type === 'checkout.session.completed' || event.type === 'checkout.session.async_payment_succeeded') {
    const session = event.data.object as Stripe.Checkout.Session

    // Only confirm money that has arrived. Every method we offer is instant
    // (lib/stripe/checkout.ts), so this is a guard: an unpaid session is left
    // pending and the 30-minute sweep releases the stone.
    if (session.payment_status !== 'paid') {
      console.error('[webhook] checkout completed but not paid (status', session.payment_status, ') — session', session.id, 'left pending')
      return NextResponse.json({ received: true })
    }
    const groupId = session.metadata?.checkout_group_id
    const orderId = session.metadata?.order_id

    // Build shipping payload from what Stripe collected.
    // SDK v22+: address lives at collected_information.shipping_details (not top-level shipping_details).
    // Phone is on customer_details.phone (unchanged across SDK versions).
    // All fields written; nulls fine for optional ones like line2/state.
    const addr = session.collected_information?.shipping_details
    const custEmail = session.customer_details?.email?.trim() || null
    const shippingData = {
      shipping_name:        addr?.name                ?? null,
      shipping_line1:       addr?.address?.line1      ?? null,
      shipping_line2:       addr?.address?.line2      ?? null,
      shipping_city:        addr?.address?.city       ?? null,
      shipping_state:       addr?.address?.state      ?? null,
      shipping_postal_code: addr?.address?.postal_code ?? null,
      shipping_country:     addr?.address?.country    ?? null,
      shipping_phone:       session.customer_details?.phone ?? null,
      order_email:          custEmail,
      // Needed to refund a return later (cart orders share one payment).
      stripe_payment_intent: paymentIntentId(session),
    }

    if (groupId) {
      // Cart payment: confirm all orders in the group with one RPC call.
      const { error } = await supabase.rpc('confirm_order_group', {
        p_group_id: groupId,
      })
      if (error) {
        console.error('[webhook] confirm_order_group failed for group', groupId, ':', error.message)
        return NextResponse.json({ error: 'Order confirmation failed' }, { status: 500 })
      }

      // confirm_order_group swallows per-order failures, so re-read the group
      // to see which orders actually got confirmed.
      const { data: groupData, error: groupErr } = await supabase
        .from('orders')
        .select('id, status, order_total, tax_amount')
        .eq('checkout_group_id', groupId)
      if (groupErr) {
        console.error('[webhook] re-read of group', groupId, 'failed:', groupErr.message)
        return NextResponse.json({ error: 'Order confirmation failed' }, { status: 500 })
      }
      const groupOrders = (groupData as { id: string; status: string; order_total: string | number; tax_amount: string | number | null }[] | null) ?? []

      // Still pending = confirm failed for an unexpected reason. Retry the
      // whole event (confirm is idempotent; nothing has been sent yet).
      const stillPending = groupOrders.filter(o => o.status === 'pending_payment')
      if (stillPending.length > 0) {
        console.error('[webhook] confirm_order_group left orders pending in group', groupId, ':', stillPending.map(o => o.id))
        return NextResponse.json({ error: 'Order confirmation failed' }, { status: 500 })
      }

      const paidIds    = groupOrders.filter(o => PAID_STATUSES.includes(o.status)).map(o => o.id)
      const lateOrders = groupOrders.filter(o => isLateStatus(o.status))

      // Refund late orders first: if a refund fails we return 500 before any
      // address write or email, so the retry doesn't duplicate them.
      if (lateOrders.length > 0) {
        const pi = paymentIntentId(session)
        if (!pi) {
          console.error('[webhook] late payment in group', groupId, 'but session has no payment_intent — cannot refund')
          return NextResponse.json({ error: 'Refund failed' }, { status: 500 })
        }
        const newlyRefunded: string[] = []
        let refundedTotal = 0
        for (const o of lateOrders) {
          try {
            const created = await refundLateOrder(pi, o.id, Math.round(paidTotal(o.order_total, o.tax_amount) * 100))
            if (created) {
              newlyRefunded.push(o.id)
              refundedTotal += paidTotal(o.order_total, o.tax_amount)
            }
          } catch (e) {
            console.error('[webhook] late-payment refund failed for order', o.id, 'in group', groupId, ':', e instanceof Error ? e.message : String(e))
            return NextResponse.json({ error: 'Refund failed' }, { status: 500 })
          }
        }
        console.error('[webhook] late payment in group', groupId, '— refunded orders:', newlyRefunded, '— already refunded:', lateOrders.length - newlyRefunded.length)
        if (newlyRefunded.length > 0) {
          try {
            await notifyLatePayment(supabase, newlyRefunded, refundedTotal, custEmail, session.id, pi)
          } catch (e) {
            console.error('[webhook] late-payment emails threw for group', groupId, ':', e instanceof Error ? e.message : String(e))
          }
        }
      }

      if (paidIds.length === 0) {
        return NextResponse.json({ received: true })
      }

      // Persist address to the confirmed orders only. Non-fatal if it fails —
      // payment and confirmation already succeeded; don't cause Stripe to retry.
      try {
        const { data: updated, error: addrErr } = await supabase
          .from('orders')
          .update(shippingData)
          .eq('checkout_group_id', groupId)
          .in('id', paidIds)
          .select('id')
        if (addrErr) {
          console.error('[webhook] address update failed for group', groupId, ':', addrErr.message)
        } else if (!updated || updated.length === 0) {
          console.error('[webhook] address update matched 0 orders for group', groupId, '— RLS block or missing rows?')
        }
      } catch (e) {
        console.error('[webhook] address update threw for group', groupId, ':', e instanceof Error ? e.message : String(e))
      }

      // Invoices (sql/invoices_setup.sql) — after the address is saved so it's
      // on the invoice. Best-effort; issue_missing_invoices catches up.
      await issueInvoices(supabase, paidIds)

      // Send new-order notification emails — best-effort, never fails the webhook.
      try {
        await notifyGroupOrders(supabase, groupId, paidIds)
      } catch (e) {
        console.error('[webhook] email notification threw for group', groupId, ':', e instanceof Error ? e.message : String(e))
      }

      // Customer order confirmation email — best-effort.
      try {
        await notifyCustomerGroupOrder(supabase, groupId, paidIds, custEmail)
      } catch (e) {
        console.error('[webhook] customer confirmation email threw for group', groupId, ':', e instanceof Error ? e.message : String(e))
      }

    } else if (orderId) {
      // Single-stone buy-now payment.
      // confirm_order_paid is idempotent at the SQL level: it RETURN-s void
      // (no throw) when the order is already 'confirmed', so a duplicate
      // delivery normally produces no error. If an error does mention
      // 'confirmed', treat it as success so Stripe stops retrying.
      const { error } = await supabase.rpc('confirm_order_paid', {
        p_order_id: orderId,
      })
      if (error) {
        if (error.message.includes("found 'confirmed'")) {
          // Order already confirmed — idempotent duplicate delivery, safe to ack.
          console.error('[webhook] confirm_order_paid: order already confirmed (dup delivery), acking', orderId)
        } else {
          // Late payment? Check the order's current status rather than parsing
          // the error text (also rules out transient errors on a pending order).
          const { data: stData } = await supabase
            .from('orders').select('status').eq('id', orderId).maybeSingle()
          const status = (stData as { status: string } | null)?.status

          if (!status || !isLateStatus(status)) {
            console.error('[webhook] confirm_order_paid failed for order', orderId, ':', error.message)
            return NextResponse.json({ error: 'Order confirmation failed' }, { status: 500 })
          }

          // Paid, but the order is no longer pending (e.g. cancelled) — refund
          // in full. No address write, no normal order emails.
          const pi = paymentIntentId(session)
          if (!pi) {
            console.error('[webhook] late payment for order', orderId, `(status '${status}') but session has no payment_intent — cannot refund`)
            return NextResponse.json({ error: 'Refund failed' }, { status: 500 })
          }
          let created: boolean
          try {
            created = await refundLateOrder(pi, orderId)
          } catch (e) {
            console.error('[webhook] late-payment refund failed for order', orderId, ':', e instanceof Error ? e.message : String(e))
            return NextResponse.json({ error: 'Refund failed' }, { status: 500 })
          }
          console.error('[webhook] late payment for order', orderId, `(status '${status}') —`, created ? 'refunded in full' : 'already refunded (dup delivery)')
          if (created) {
            try {
              await notifyLatePayment(supabase, [orderId], (session.amount_total ?? 0) / 100, custEmail, session.id, pi)
            } catch (e) {
              console.error('[webhook] late-payment emails threw for order', orderId, ':', e instanceof Error ? e.message : String(e))
            }
          }
          return NextResponse.json({ received: true })
        }
      }

      // Persist address to the single order. Non-fatal if it fails.
      try {
        const { data: updated, error: addrErr } = await supabase
          .from('orders')
          .update(shippingData)
          .eq('id', orderId)
          .select('id')
        if (addrErr) {
          console.error('[webhook] address update failed for order', orderId, ':', addrErr.message)
        } else if (!updated || updated.length === 0) {
          console.error('[webhook] address update matched 0 orders for order', orderId, '— RLS block or missing row?')
        }
      } catch (e) {
        console.error('[webhook] address update threw for order', orderId, ':', e instanceof Error ? e.message : String(e))
      }

      // Invoice (after the address is saved). Best-effort; the cron catches up.
      await issueInvoices(supabase, [orderId])

      // Send new-order notification email — best-effort, never fails the webhook.
      try {
        await notifySingleOrder(supabase, orderId)
      } catch (e) {
        console.error('[webhook] email notification threw for order', orderId, ':', e instanceof Error ? e.message : String(e))
      }

      // Customer order confirmation email — best-effort.
      try {
        await notifyCustomerSingleOrder(supabase, orderId, custEmail)
      } catch (e) {
        console.error('[webhook] customer confirmation email threw for order', orderId, ':', e instanceof Error ? e.message : String(e))
      }
    }
    // Neither present: skip (malformed metadata — return 200 so Stripe doesn't retry).

  } else if (event.type === 'checkout.session.expired') {
    const session = event.data.object as Stripe.Checkout.Session
    const groupId = session.metadata?.checkout_group_id
    const orderId = session.metadata?.order_id

    if (groupId) {
      // Cart payment: cancel all pending orders in the group and release their stones.
      const { error } = await supabase.rpc('cancel_order_group', {
        p_group_id: groupId,
      })
      if (error) {
        console.error('[webhook] cancel_order_group failed for group', groupId, ':', error.message)
        return NextResponse.json({ error: 'Order cancellation failed' }, { status: 500 })
      }
    } else if (orderId) {
      // Single-stone path: unchanged.
      const { error } = await supabase.rpc('cancel_pending_payment_order', {
        p_order_id: orderId,
      })
      if (error) {
        console.error('[webhook] cancel_pending_payment_order failed for order', orderId, ':', error.message)
        return NextResponse.json({ error: 'Order cancellation failed' }, { status: 500 })
      }
    }

  }
  // All other event types are silently ignored.

  return NextResponse.json({ received: true })
}
