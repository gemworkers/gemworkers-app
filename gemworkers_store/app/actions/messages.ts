'use server'

import { createClient } from '@/lib/supabase/server'
import { findLinkedStoneId } from '@/lib/stone-links'

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
  firstName?: string,
  linkedStoneId?: string | null
): Promise<{ conversationId: string } | { error: string }> {
  if (typeof stoneId !== 'string' || typeof body !== 'string') {
    return { error: GENERIC_ERROR }
  }
  if (linkedStoneId != null && typeof linkedStoneId !== 'string') {
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
    p_linked_item_id:    linkedStoneId || findLinkedStoneId(body),
    p_first_name:      firstName?.trim() || null,
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

// Replies in an existing conversation. A picked stone (linkedStoneId) is sent
// as the message's linked stone; otherwise the first pasted
// gemworkers.com/stones/{id} link is.
export async function sendBuyerMessage(
  conversationId: string,
  body: string,
  linkedStoneId?: string | null
): Promise<{ ok: true } | { error: string }> {
  if (typeof conversationId !== 'string' || typeof body !== 'string') {
    return { error: GENERIC_ERROR }
  }
  if (linkedStoneId != null && typeof linkedStoneId !== 'string') {
    return { error: GENERIC_ERROR }
  }

  const supabase = await createClient()

  const { data: { user } } = await supabase.auth.getUser()
  if (!user) {
    return { error: 'Please sign in to send a message.' }
  }

  const { error } = await supabase.rpc('send_buyer_message', {
    p_conversation_id: conversationId,
    p_body:            body,
    p_linked_item_id:  linkedStoneId || findLinkedStoneId(body),
  })

  if (error) {
    return { error: friendlyError(error) }
  }

  return { ok: true }
}

// Moves the buyer's read marker to now (clears the unread dot).
export async function markConversationRead(
  conversationId: string
): Promise<{ ok: true } | { error: string }> {
  if (typeof conversationId !== 'string') {
    return { error: GENERIC_ERROR }
  }

  const supabase = await createClient()

  const { error } = await supabase.rpc('mark_conversation_read', {
    p_conversation_id: conversationId,
  })

  if (error) {
    return { error: friendlyError(error) }
  }

  return { ok: true }
}

// ── Attach a stone ────────────────────────────────────────────────────────────

export type AttachableStone = {
  id: string
  title: string
  gem_type: string | null
  selling_price: number | null
  image_url: string | null
}

const SEARCH_LIMIT = 30

// Stones a buyer can attach to a message. public_listing_details only holds
// listed, unsold stones from active sellers, which matches the rule the DB
// enforces on p_linked_item_id. Matches on title or gem type.
export async function searchAttachableStones(
  query: string
): Promise<{ stones: AttachableStone[] } | { error: string }> {
  if (typeof query !== 'string') {
    return { error: GENERIC_ERROR }
  }

  const supabase = await createClient()

  const { data: { user } } = await supabase.auth.getUser()
  if (!user) {
    return { error: 'Please sign in to attach a stone.' }
  }

  // Drop characters that mean something inside a PostgREST or() filter.
  const term = query.replace(/[%_,()*\\"'.:]/g, ' ').trim().slice(0, 60)

  // The view exposes no listing date, so results are alphabetical.
  let req = supabase
    .from('public_listing_details')
    .select('id, title, gem_type, selling_price, image_urls')
    .order('title', { ascending: true })
    .limit(SEARCH_LIMIT)

  if (term) {
    req = req.or(`title.ilike.%${term}%,gem_type.ilike.%${term}%`)
  }

  const { data, error } = await req

  if (error) {
    console.error('[messages] stone search error:', error.code, error.message)
    return { error: 'Could not load stones — please try again.' }
  }

  const stones: AttachableStone[] = (data ?? []).map(row => ({
    id:            row.id as string,
    title:         row.title as string,
    gem_type:      (row.gem_type as string | null) ?? null,
    selling_price: row.selling_price != null ? Number(row.selling_price) : null,
    image_url:     Array.isArray(row.image_urls)
      ? ((row.image_urls as string[])[0] ?? null)
      : null,
  }))

  return { stones }
}
