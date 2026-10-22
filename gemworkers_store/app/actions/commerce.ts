'use server'

import { createClient } from '@/lib/supabase/server'
import { createAdminClient } from '@/lib/supabase/admin'
import { stripe } from '@/lib/stripe/server'
import type Stripe from 'stripe'
import { canStartOfferPayment, PAY_WINDOW_CLOSING_MESSAGE } from '@/lib/offer-payment'

// Calls the create_platform_order SECURITY DEFINER RPC as the logged-in buyer,
// then creates a Stripe Checkout Session for the authoritative order total.
// Returns { orderId, checkoutUrl } on success so the client can redirect the
// buyer to Stripe. The order starts in 'pending_payment'; it is not confirmed
// until the Stripe webhook fires in a later step.
export async function buyNow(
  itemId: string
): Promise<{ orderId: string; checkoutUrl: string } | { error: string }> {
  const supabase = await createClient()

  const { data: { user } } = await supabase.auth.getUser()
  if (!user) {
    return { error: 'You must be logged in to buy.' }
  }

  const { data, error } = await supabase.rpc('create_platform_order', {
    p_inventory_item_id: itemId,
  })

  if (error) {
    return { error: error.message }
  }
  if (!data) {
    return { error: 'No order reference returned — please try again.' }
  }

  const orderId = data as string

  // Read the authoritative total back from the DB — never trust a client value.
  // Supabase returns numeric columns as strings; coerce with Number().
  const { data: order, error: orderErr } = await supabase
    .from('orders')
    .select('order_total, order_number')
    .eq('id', orderId)
    .single()

  if (orderErr || !order) {
    return { error: 'Could not load order total for payment' }
  }

  const amountCents = Math.round(Number(order.order_total) * 100)

  if (!Number.isInteger(amountCents) || amountCents <= 0) {
    return { error: 'Invalid order amount' }
  }

  // NEXT_PUBLIC_SITE_URL must be set in .env.local for production.
  // Falls back to localhost for local development.
  const base = process.env.NEXT_PUBLIC_SITE_URL ?? 'http://localhost:3000'

  try {
    const session = await stripe.checkout.sessions.create({
      mode: 'payment',
      payment_method_types: ['card'],
      line_items: [
        {
          quantity: 1,
          price_data: {
            currency: 'eur',
            unit_amount: amountCents,
            product_data: {
              name: `GemWorkers order ${orderId.substring(0, 8).toUpperCase()}`,
            },
          },
        },
      ],
      shipping_address_collection: {
        allowed_countries: ['NL','BE','DE','FR','GB','IE','IT','ES','PT','AT','SE','DK','FI','PL','US','CA','AU','AE','SA','TH','PK','IN','SG','JP'],
      },
      phone_number_collection: { enabled: true },
      // Stripe minimum is 30 min; our sweep cancels the order at 30 min.
      expires_at: Math.floor(Date.now() / 1000) + 31 * 60,
      success_url: `${base}/orders?paid=1&order=${orderId}`,
      cancel_url:  `${base}/stones/${itemId}?canceled=1&order=${orderId}`,
      // CRITICAL: the webhook uses this to advance the order to 'confirmed'.
      metadata: { order_id: orderId },
      // Shown on the PaymentIntent in the Stripe dashboard.
      payment_intent_data: {
        description: order.order_number ? `GemWorkers ${order.order_number}` : 'GemWorkers order',
        metadata: { order_id: orderId, ...(order.order_number && { order_number: order.order_number }) },
      },
    })

    if (!session.url) {
      return { error: 'Could not generate payment link — please try again.' }
    }

    return { orderId, checkoutUrl: session.url }
  } catch (err) {
    // Order is already in 'pending_payment'. Do NOT confirm it here.
    // Cleanup of stranded pending orders is handled by the webhook step.
    const message = err instanceof Error ? err.message : 'Payment setup failed — please try again.'
    return { error: message }
  }
}

// Opens a Stripe Checkout Session for the order created when a seller accepted
// this buyer's offer (respond_to_offer → pending_payment, payment_due_at = +48h).
//
// The order is looked up under the buyer's own RLS and must be theirs, still
// 'pending_payment', and inside its payment window. The amount always comes
// from orders.order_total — the client only sends the offer id.
//
// Double-payment guard: the latest session id is stored on the order
// (orders.stripe_checkout_session_id — see sql/orders_stripe_session_id.sql).
// A previous open session is expired before a new one is created, and the new
// id is written with a compare-and-set so two concurrent clicks can't both win.
// If that column doesn't exist yet, the guard is skipped (payment still works).
export async function payAcceptedOffer(
  offerId: string
): Promise<{ checkoutUrl: string } | { error: string }> {
  const NOT_PAYABLE = 'This offer is no longer payable.'
  const SETUP_FAILED = 'Payment setup failed — please try again.'

  const supabase = await createClient()
  const { data: { user } } = await supabase.auth.getUser()
  if (!user) return { error: 'You must be logged in to pay.' }

  const { data: order, error: orderErr } = await supabase
    .from('orders')
    .select('id, order_number, order_total, payment_due_at, order_items ( inventory_item_id )')
    .eq('offer_id', offerId)
    .eq('buyer_id', user.id)
    .eq('status', 'pending_payment')
    .gt('payment_due_at', new Date().toISOString())
    .maybeSingle()

  if (orderErr) {
    console.error('[payAcceptedOffer] order lookup failed:', orderErr.message)
    return { error: SETUP_FAILED }
  }
  if (!order || !order.payment_due_at) return { error: NOT_PAYABLE }

  // Too close to the deadline: a Stripe session (30 min minimum) could outlive it.
  if (!canStartOfferPayment(order.payment_due_at)) {
    return { error: PAY_WINDOW_CLOSING_MESSAGE }
  }

  const amountCents = Math.round(Number(order.order_total) * 100)
  if (!Number.isInteger(amountCents) || amountCents <= 0) {
    return { error: 'Invalid order amount' }
  }

  const itemId = (order.order_items as { inventory_item_id: string }[] | null)?.[0]?.inventory_item_id
  if (!itemId) return { error: SETUP_FAILED }

  // Session lifetime: until the payment deadline, capped at Stripe's 24 h
  // maximum (1 min margin). The 35 min check above keeps dueSec past the
  // 30 min minimum; Math.max is only a belt-and-braces floor.
  const nowSec = Math.floor(Date.now() / 1000)
  const dueSec = Math.floor(new Date(order.payment_due_at).getTime() / 1000)
  const expiresAt = Math.max(nowSec + 31 * 60, Math.min(nowSec + 24 * 60 * 60 - 60, dueSec))

  // ── Double-payment guard: expire the previous open session ──────────────────
  const admin = createAdminClient()
  let trackSession = true
  let prevSessionId: string | null = null

  const { data: tracked, error: trackErr } = await admin
    .from('orders')
    .select('stripe_checkout_session_id')
    .eq('id', order.id)
    .single()

  if (trackErr) {
    if (trackErr.code === '42703') {
      // Column not added yet (sql/orders_stripe_session_id.sql not applied).
      console.error('[payAcceptedOffer] stripe_checkout_session_id column missing — double-payment guard disabled')
      trackSession = false
    } else {
      console.error('[payAcceptedOffer] session lookup failed:', trackErr.message)
      return { error: SETUP_FAILED }
    }
  } else {
    prevSessionId = (tracked as { stripe_checkout_session_id: string | null }).stripe_checkout_session_id
  }

  if (prevSessionId) {
    try {
      const prev = await stripe.checkout.sessions.retrieve(prevSessionId)
      if (prev.status === 'complete') {
        return { error: 'This offer has already been paid — it will appear in your orders shortly.' }
      }
      if (prev.status === 'open') {
        await stripe.checkout.sessions.expire(prevSessionId)
      }
    } catch (err) {
      // Expire can fail if the session completed a moment ago — re-check.
      const again = await stripe.checkout.sessions.retrieve(prevSessionId).catch(() => null)
      if (again?.status === 'complete') {
        return { error: 'This offer has already been paid — it will appear in your orders shortly.' }
      }
      if (again?.status !== 'expired') {
        console.error('[payAcceptedOffer] could not expire previous session:',
          err instanceof Error ? err.message : String(err))
        return { error: SETUP_FAILED }
      }
    }
  }

  // ── New session — same shape as buyNow ──────────────────────────────────────
  const base = process.env.NEXT_PUBLIC_SITE_URL ?? 'http://localhost:3000'

  let session: Stripe.Checkout.Session
  try {
    session = await stripe.checkout.sessions.create({
      mode: 'payment',
      payment_method_types: ['card'],
      line_items: [
        {
          quantity: 1,
          price_data: {
            currency: 'eur',
            unit_amount: amountCents,
            product_data: {
              name: `GemWorkers order ${order.id.substring(0, 8).toUpperCase()}`,
            },
          },
        },
      ],
      shipping_address_collection: {
        allowed_countries: ['NL','BE','DE','FR','GB','IE','IT','ES','PT','AT','SE','DK','FI','PL','US','CA','AU','AE','SA','TH','PK','IN','SG','JP'],
      },
      phone_number_collection: { enabled: true },
      expires_at: expiresAt,
      success_url: `${base}/orders?paid=1&order=${order.id}`,
      cancel_url:  `${base}/stones/${itemId}?canceled=1&order=${order.id}`,
      // CRITICAL: the webhook uses this to advance the order to 'confirmed'.
      metadata: { order_id: order.id },
      // Shown on the PaymentIntent in the Stripe dashboard.
      payment_intent_data: {
        description: order.order_number ? `GemWorkers ${order.order_number}` : 'GemWorkers order',
        metadata: { order_id: order.id, ...(order.order_number && { order_number: order.order_number }) },
      },
    })
  } catch (err) {
    // The order stays pending_payment inside its window; the buyer can retry.
    const message = err instanceof Error ? err.message : SETUP_FAILED
    return { error: message }
  }

  if (!session.url) return { error: SETUP_FAILED }

  // ── Record the new session (compare-and-set on the previous value) ──────────
  if (trackSession) {
    let update = admin
      .from('orders')
      .update({ stripe_checkout_session_id: session.id })
      .eq('id', order.id)
      .eq('status', 'pending_payment')
    update = prevSessionId
      ? update.eq('stripe_checkout_session_id', prevSessionId)
      : update.is('stripe_checkout_session_id', null)

    const { data: updated, error: updErr } = await update.select('id')
    if (updErr || !updated || updated.length === 0) {
      // Another click recorded its session first — don't leave a second one open.
      await stripe.checkout.sessions.expire(session.id).catch(() => {})
      if (updErr) console.error('[payAcceptedOffer] session record failed:', updErr.message)
      return { error: 'A payment for this offer is already being set up — please try again in a moment.' }
    }
  }

  return { checkoutUrl: session.url }
}

// Immediately releases a pending_payment order and restores the stone to
// available. Called when the buyer returns from Stripe via the cancel_url.
// Service role required — anon lacks EXECUTE on cancel_pending_payment_order.
//
// Race-safe: if the Stripe webhook confirmed the order before this runs, the
// RPC throws "Cannot cancel order: ... found 'confirmed'". We treat that as
// ok — a confirmed order must never be undone here.
// Idempotent: already-cancelled orders are a safe no-op in the RPC.
export async function cancelPendingOrder(
  orderId: string
): Promise<{ ok: boolean }> {
  try {
    const supabase = createAdminClient()
    const { error } = await supabase.rpc('cancel_pending_payment_order', {
      p_order_id: orderId,
    })
    if (error) {
      // RPC threw because the order is no longer in 'pending_payment' —
      // the webhook already confirmed it. The confirmed order stays confirmed.
      if (error.message.startsWith('Cannot cancel order')) {
        return { ok: true }
      }
      console.error('[cancelPendingOrder] RPC error:', error.message)
      return { ok: false }
    }
    return { ok: true }
  } catch (err) {
    console.error('[cancelPendingOrder] unexpected error:', err instanceof Error ? err.message : String(err))
    return { ok: false }
  }
}

// ── checkoutCart helpers ──────────────────────────────────────────────────────

// Joins values with commas, dropping whole trailing values so the result stays
// within Stripe's 500-character metadata value limit.
function joinForMetadata(values: string[], max = 500): string {
  let out = ''
  for (const v of values) {
    const next = out ? `${out},${v}` : v
    if (next.length > max) break
    out = next
  }
  return out
}

// Releases all pending_payment orders created during a failed checkoutCart.
// If the grouping update already succeeded, tries cancel_order_group (the
// group-aware RPC added alongside checkout_group_id). Falls back to individual
// cancel_pending_payment_order calls if that RPC is not yet deployed or fails.
// Service role required — anon lacks EXECUTE on both cancel RPCs.
// Never throws: any inner failure is logged and swallowed.
async function cleanupOrderGroup(
  orderIds: string[],
  groupId: string | null,
): Promise<void> {
  const admin = createAdminClient()
  try {
    if (groupId) {
      const { error } = await admin.rpc('cancel_order_group', { p_group_id: groupId })
      if (!error) return
      // Group RPC unavailable or failed — fall through to per-order cancels.
      console.error('[checkoutCart] cancel_order_group failed:', error.message)
    }
    for (const orderId of orderIds) {
      try {
        await admin.rpc('cancel_pending_payment_order', { p_order_id: orderId })
      } catch (e) {
        console.error('[checkoutCart] cleanup: cancel failed for order', orderId,
          e instanceof Error ? e.message : String(e))
      }
    }
  } catch (e) {
    console.error('[checkoutCart] cleanup: unexpected error',
      e instanceof Error ? e.message : String(e))
  }
}

// Reads the buyer's cart, creates one pending_payment order per available stone
// (silently skipping any that are sold/unlisted/unavailable), groups them under
// one checkout_group_id, and opens a single Stripe Checkout Session covering all
// of them. The cart is NOT cleared here — that happens after payment succeeds.
//
// Returns { checkoutUrl, ordered, skipped } on success, { error } on failure.
// On any post-order-creation failure (grouping error, invalid amount, Stripe
// error), releases all created orders so no stones stay permanently reserved.
export async function checkoutCart(): Promise<
  { checkoutUrl: string; ordered: number; skipped: number } | { error: string }
> {
  // ── 1. Auth ────────────────────────────────────────────────────────────────
  const supabase = await createClient()
  const { data: { user } } = await supabase.auth.getUser()
  if (!user) return { error: 'You must be logged in.' }

  // ── 2. Read cart (same query as cart page, RLS-scoped to this buyer) ──────
  const { data: cartRows } = await supabase
    .from('storefront_cart')
    .select('inventory_item_id, added_at')
    .order('added_at', { ascending: true })

  if (!cartRows || cartRows.length === 0) {
    return { error: 'Your cart is empty.' }
  }

  // ── 3. Create one order per stone, skip unavailable ───────────────────────
  const groupId = crypto.randomUUID()

  type Created = { orderId: string; itemId: string }
  const created: Created[] = []
  const skippedIds: string[] = []

  for (const row of cartRows) {
    const itemId: string = row.inventory_item_id
    const { data, error } = await supabase.rpc('create_platform_order', {
      p_inventory_item_id: itemId,
    })
    if (error || !data) {
      // RPC raises for: sold, reserved, unlisted, inactive seller, no price.
      // All treated as silently skipped — do not abort the whole checkout.
      skippedIds.push(itemId)
      continue
    }
    created.push({ orderId: data as string, itemId })
  }

  // ── 4. Edge case: nothing available ───────────────────────────────────────
  if (created.length === 0) {
    return { error: 'None of the items in your cart are still available.' }
  }

  const createdOrderIds = created.map(c => c.orderId)

  // ── 3b. Stamp group id on all created orders in one update ─────────────────
  // Buyers have no UPDATE policy on orders (RLS allows SELECT only). Use the
  // service-role admin client so the stamp is not silently blocked. Verify
  // the returned row count: zero rows updated with no error is still failure.
  const admin = createAdminClient()
  const { data: updated, error: groupErr } = await admin
    .from('orders')
    .update({ checkout_group_id: groupId })
    .in('id', createdOrderIds)
    .select('id')

  if (groupErr || (updated?.length ?? 0) !== createdOrderIds.length) {
    console.error('[checkoutCart] grouping update failed:',
      groupErr?.message ?? `expected ${createdOrderIds.length} rows, got ${updated?.length ?? 0}`)
    await cleanupOrderGroup(createdOrderIds, null)
    return { error: 'Payment setup failed — please try again.' }
  }

  // ── 5. Read authoritative totals back from DB ─────────────────────────────
  const { data: orderRows, error: totalsErr } = await supabase
    .from('orders')
    .select('id, order_number, order_total')
    .in('id', createdOrderIds)

  if (totalsErr || !orderRows || orderRows.length === 0) {
    console.error('[checkoutCart] failed to read order totals:', totalsErr?.message)
    await cleanupOrderGroup(createdOrderIds, groupId)
    return { error: 'Payment setup failed — please try again.' }
  }

  // Build one Stripe line item per order; validate each amount.
  // Supabase returns numeric columns as strings — coerce with Number().
  const lineItems: {
    quantity: number
    price_data: { currency: string; unit_amount: number; product_data: { name: string } }
  }[] = []
  for (const ord of orderRows) {
    const amountCents = Math.round(Number(ord.order_total) * 100)
    if (!Number.isInteger(amountCents) || amountCents <= 0) {
      console.error('[checkoutCart] invalid amount for order', ord.id, ord.order_total)
      await cleanupOrderGroup(createdOrderIds, groupId)
      return { error: 'Payment setup failed — please try again.' }
    }
    lineItems.push({
      quantity: 1,
      price_data: {
        currency: 'eur',
        unit_amount: amountCents,
        product_data: {
          name: `GemWorkers order ${ord.id.substring(0, 8).toUpperCase()}`,
        },
      },
    })
  }

  // ── 5b. Create Stripe Checkout Session ────────────────────────────────────
  const base = process.env.NEXT_PUBLIC_SITE_URL ?? 'http://localhost:3000'

  try {
    const session = await stripe.checkout.sessions.create({
      mode: 'payment',
      payment_method_types: ['card'],
      line_items: lineItems,
      shipping_address_collection: {
        allowed_countries: ['NL','BE','DE','FR','GB','IE','IT','ES','PT','AT','SE','DK','FI','PL','US','CA','AU','AE','SA','TH','PK','IN','SG','JP'],
      },
      phone_number_collection: { enabled: true },
      // Stripe minimum is 30 min; our sweep cancels the orders at 30 min.
      expires_at: Math.floor(Date.now() / 1000) + 31 * 60,
      success_url: `${base}/orders?paid=1&group=${groupId}`,
      cancel_url:  `${base}/cart?canceled=1&group=${groupId}`,
      // CRITICAL: the webhook uses this to confirm all orders in the group.
      metadata: { checkout_group_id: groupId },
      // Shown on the PaymentIntent in the Stripe dashboard.
      payment_intent_data: {
        description: `GemWorkers cart — ${orderRows.length} item${orderRows.length === 1 ? '' : 's'}`,
        metadata: {
          checkout_group_id: groupId,
          order_ids: joinForMetadata(orderRows.map(o => o.id)),
          order_numbers: joinForMetadata(orderRows.map(o => o.order_number).filter(Boolean)),
        },
      },
    })

    if (!session.url) {
      await cleanupOrderGroup(createdOrderIds, groupId)
      return { error: 'Payment setup failed — please try again.' }
    }

    return {
      checkoutUrl: session.url,
      ordered: createdOrderIds.length,
      skipped: skippedIds.length,
    }
  } catch (err) {
    // Orders are in pending_payment with stones reserved. Release them.
    await cleanupOrderGroup(createdOrderIds, groupId)
    return { error: 'Payment setup failed — please try again.' }
  }
}

// Inserts a storefront_cart row for the logged-in buyer.
// The UNIQUE(buyer_id, inventory_item_id) constraint means a duplicate insert
// returns error code 23505 — treated as a no-op success ("already in cart").
export async function addToCart(
  itemId: string
): Promise<{ ok: true; alreadyInCart?: boolean } | { error: string }> {
  const supabase = await createClient()

  const { data: { user } } = await supabase.auth.getUser()
  if (!user) return { error: 'You must be logged in to save items to your cart.' }

  const { error } = await supabase
    .from('storefront_cart')
    .insert({ buyer_id: user.id, inventory_item_id: itemId })

  if (error) {
    if (error.code === '23505') return { ok: true, alreadyInCart: true }
    return { error: error.message }
  }

  return { ok: true }
}

// Deletes the buyer's storefront_cart row for this item.
// RLS enforces buyer_id = auth.uid() — a buyer can only delete their own rows.
export async function removeFromCart(
  itemId: string
): Promise<{ ok: true } | { error: string }> {
  const supabase = await createClient()

  const { data: { user } } = await supabase.auth.getUser()
  if (!user) return { error: 'You must be logged in.' }

  const { error } = await supabase
    .from('storefront_cart')
    .delete()
    .eq('buyer_id', user.id)
    .eq('inventory_item_id', itemId)

  if (error) return { error: error.message }
  return { ok: true }
}

// Calls submit_storefront_offer as the logged-in buyer.
// The RPC reads seller_id from the DB — the buyer cannot forge it.
// The RPC enforces: listed, available, active seller, sale_method != buy_now,
// price > 0, and one-pending-offer-per-buyer. Error messages are surfaced as-is.
export async function submitOffer(
  itemId: string,
  offeredPrice: number,
  note?: string
): Promise<{ offerId: string } | { error: string }> {
  const supabase = await createClient()

  const { data: { user } } = await supabase.auth.getUser()
  if (!user) return { error: 'You must be logged in to make an offer.' }

  if (!Number.isFinite(offeredPrice) || offeredPrice <= 0) {
    return { error: 'Please enter an offer greater than €0.' }
  }
  // Strip float noise (e.g. 49.800000000001) so the RPC's 2-decimal guard
  // only rejects genuinely over-precise amounts.
  const exactPrice = Math.round(offeredPrice * 100) / 100

  const { data, error } = await supabase.rpc('submit_storefront_offer', {
    p_inventory_item_id: itemId,
    p_offered_price: exactPrice,
    p_buyer_note: note ?? '',
  })

  if (error) return { error: error.message }
  if (!data) return { error: 'No offer ID returned — please try again.' }

  return { offerId: data as string }
}

// Calls mark_order_received as the logged-in buyer.
// Buyers have no UPDATE policy on orders; this SECURITY DEFINER RPC is the
// only write path. The RPC validates buyer_id = auth.uid() and status = 'shipped'.
export async function markOrderReceived(
  orderId: string
): Promise<{ ok: true } | { error: string }> {
  const supabase = await createClient()

  const { data: { user } } = await supabase.auth.getUser()
  if (!user) return { error: 'You must be logged in.' }

  const { error } = await supabase.rpc('mark_order_received', {
    p_order_id: orderId,
  })

  if (error) return { error: error.message }
  return { ok: true }
}

// Sets status = 'withdrawn' on the buyer's own pending offer.
// RLS offers_buyer_update enforces: row must be buyer's own AND currently pending;
// the new row must have status = 'withdrawn' (no other change is permitted).
export async function withdrawOffer(
  offerId: string
): Promise<{ ok: true } | { error: string }> {
  const supabase = await createClient()

  const { data: { user } } = await supabase.auth.getUser()
  if (!user) return { error: 'You must be logged in.' }

  const { data, error } = await supabase
    .from('storefront_offers')
    .update({ status: 'withdrawn' })
    .eq('id', offerId)
    .select('id')
    .maybeSingle()

  if (error) return { error: error.message }
  if (!data) return { error: 'Could not withdraw — the offer may already be resolved.' }

  return { ok: true }
}

// Buyer answers a counter-offer via respond_to_counter. The RPC checks the
// caller is the offer's buyer, the counter is still open (countered, not past
// counter_expires_at) and, on accept, reserves the stone and creates the
// pending_payment order at the counter price. Error messages surface as-is.
export async function respondToCounter(
  offerId: string,
  action: 'accepted' | 'declined'
): Promise<{ ok: true; orderId: string | null } | { error: string }> {
  const supabase = await createClient()

  const { data: { user } } = await supabase.auth.getUser()
  if (!user) return { error: 'You must be logged in.' }

  const { data, error } = await supabase.rpc('respond_to_counter', {
    p_offer_id: offerId,
    p_action: action,
  })

  if (error) return { error: error.message }
  const orderId = (data as { order_id?: string | null } | null)?.order_id ?? null
  return { ok: true, orderId }
}
