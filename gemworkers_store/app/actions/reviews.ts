'use server'

import { createClient } from '@/lib/supabase/server'

// Calls submit_review as the logged-in buyer. The RPC checks the order is
// theirs, shipped/received, not reviewed yet, 1–5 stars, and that the photo
// lives in their own review-photos folder. Error messages surface as-is.
export async function submitReview(
  orderId: string,
  rating: number,
  body: string,
  photoUrl: string | null,
): Promise<{ ok: true } | { error: string }> {
  const supabase = await createClient()

  const { data: { user } } = await supabase.auth.getUser()
  if (!user) return { error: 'Please sign in to leave a review.' }

  const { error } = await supabase.rpc('submit_review', {
    p_order_id: orderId,
    p_rating: rating,
    p_body: body.trim() || null,
    p_photo_url: photoUrl,
  })

  if (error) return { error: error.message }
  return { ok: true }
}
