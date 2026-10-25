// SERVER ONLY — the logged-in buyer's saved stones (sql/favourites.sql).
import { cache } from 'react'
import { createClient } from '@/lib/supabase/server'

/** Ids of this buyer's favourites, or null when nobody is logged in. One lookup per request. */
export const favouriteIds = cache(async (): Promise<string[] | null> => {
  const supabase = await createClient()
  const { data: { user } } = await supabase.auth.getUser()
  if (!user) return null
  const { data, error } = await supabase.from('favourites').select('inventory_item_id')
  if (error) return []
  return ((data ?? []) as { inventory_item_id: string }[]).map(f => f.inventory_item_id)
})
