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
