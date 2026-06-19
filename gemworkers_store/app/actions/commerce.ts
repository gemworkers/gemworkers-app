'use server'

import { createClient } from '@/lib/supabase/server'

// Calls the create_platform_order SECURITY DEFINER RPC as the logged-in buyer.
// The anon key + buyer's session cookie is enough — no service role key used.
export async function buyNow(
  itemId: string
): Promise<{ orderId: string } | { error: string }> {
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

  return { orderId: data as string }
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
