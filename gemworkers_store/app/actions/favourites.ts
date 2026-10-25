'use server'

import { revalidatePath } from 'next/cache'
import { createClient } from '@/lib/supabase/server'

// Save / unsave a stone for the logged-in buyer (sql/favourites.sql; RLS keeps
// every buyer to their own rows).
export async function setFavourite(itemId: string, on: boolean): Promise<{ ok: true } | { error: string; login?: boolean }> {
  const supabase = await createClient()
  const { data: { user } } = await supabase.auth.getUser()
  if (!user) return { error: 'Log in to save stones.', login: true }

  const { error } = on
    ? await supabase.from('favourites').upsert({ buyer_id: user.id, inventory_item_id: itemId }, { onConflict: 'buyer_id,inventory_item_id', ignoreDuplicates: true })
    : await supabase.from('favourites').delete().eq('inventory_item_id', itemId)
  if (error) {
    console.error('[favourites] save failed:', error.message)
    return { error: 'Could not save — please try again.' }
  }
  revalidatePath('/favourites')
  return { ok: true }
}
