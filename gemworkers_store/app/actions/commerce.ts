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
