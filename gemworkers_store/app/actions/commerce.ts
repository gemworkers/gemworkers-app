'use server'

import { createClient } from '@/lib/supabase/server'
import { createAdminClient } from '@/lib/supabase/admin'
import { stripe } from '@/lib/stripe/server'

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
    .select('order_total')
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
      success_url: `${base}/orders?paid=1&order=${orderId}`,
      cancel_url:  `${base}/stones/${itemId}?canceled=1&order=${orderId}`,
      // CRITICAL: the webhook uses this to advance the order to 'confirmed'.
      metadata: { order_id: orderId },
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

  const { data, error } = await supabase.rpc('submit_storefront_offer', {
    p_inventory_item_id: itemId,
    p_offered_price: offeredPrice,
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
