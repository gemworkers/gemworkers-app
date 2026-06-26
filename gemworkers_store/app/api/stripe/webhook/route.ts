export const runtime = 'nodejs'

import { NextRequest, NextResponse } from 'next/server'
import type Stripe from 'stripe'
import { stripe } from '@/lib/stripe/server'
import { createAdminClient } from '@/lib/supabase/admin'

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

  if (event.type === 'checkout.session.completed') {
    const session = event.data.object as Stripe.Checkout.Session
    const groupId = session.metadata?.checkout_group_id
    const orderId = session.metadata?.order_id

    // Build shipping payload from what Stripe collected.
    // SDK v22+: address lives at collected_information.shipping_details (not top-level shipping_details).
    // Phone is on customer_details.phone (unchanged across SDK versions).
    // All fields written; nulls fine for optional ones like line2/state.
    const addr = session.collected_information?.shipping_details
    const shippingData = {
      shipping_name:        addr?.name                ?? null,
      shipping_line1:       addr?.address?.line1      ?? null,
      shipping_line2:       addr?.address?.line2      ?? null,
      shipping_city:        addr?.address?.city       ?? null,
      shipping_state:       addr?.address?.state      ?? null,
      shipping_postal_code: addr?.address?.postal_code ?? null,
      shipping_country:     addr?.address?.country    ?? null,
      shipping_phone:       session.customer_details?.phone ?? null,
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

      // Persist address to every order in the group. Non-fatal if it fails —
      // payment and confirmation already succeeded; don't cause Stripe to retry.
      try {
        const { data: updated, error: addrErr } = await supabase
          .from('orders')
          .update(shippingData)
          .eq('checkout_group_id', groupId)
          .select('id')
        if (addrErr) {
          console.error('[webhook] address update failed for group', groupId, ':', addrErr.message)
        } else if (!updated || updated.length === 0) {
          console.error('[webhook] address update matched 0 orders for group', groupId, '— RLS block or missing rows?')
        }
      } catch (e) {
        console.error('[webhook] address update threw for group', groupId, ':', e instanceof Error ? e.message : String(e))
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
          console.error('[webhook] confirm_order_paid failed for order', orderId, ':', error.message)
          return NextResponse.json({ error: 'Order confirmation failed' }, { status: 500 })
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
