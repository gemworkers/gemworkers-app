'use server'

import { createClient } from '@/lib/supabase/server'

// Message portal actions. Always run as the logged-in buyer (session client);
// every rule — confirmed email, length, contact info, rate limits — is enforced
// inside the SECURITY DEFINER functions in gemworkers_core/sql/messaging_setup.sql.

const GENERIC_ERROR = 'Something went wrong sending your message — please try again.'

// The messaging functions raise P0001 with a human-readable MESSAGE meant to be
// shown as-is. Anything else (network, unexpected DB error) gets a generic line.
function friendlyError(error: { code?: string; message: string }): string {
  if (error.code === 'P0001' && error.message) return error.message
  console.error('[messages] unexpected error:', error.code, error.message)
  return GENERIC_ERROR
}

// Starts (or continues) the buyer's conversation about a stone.
export async function askAboutStone(
  stoneId: string,
  body: string,
  firstName?: string
): Promise<{ conversationId: string } | { error: string }> {
  if (typeof stoneId !== 'string' || typeof body !== 'string') {
    return { error: GENERIC_ERROR }
  }

  const supabase = await createClient()

  const { data: { user } } = await supabase.auth.getUser()
  if (!user) {
    return { error: 'Please sign in to send a message.' }
  }

  const { data, error } = await supabase.rpc('ask_about_stone', {
    p_inventory_item_id: stoneId,
    p_body:              body,
    p_first_name:        firstName?.trim() || null,
  })

  if (error) {
    return { error: friendlyError(error) }
  }

  const conversationId = (data as { conversation_id?: string } | null)?.conversation_id
  if (!conversationId) {
    return { error: GENERIC_ERROR }
  }

  return { conversationId }
}
