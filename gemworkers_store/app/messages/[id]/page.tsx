import { createClient } from '@/lib/supabase/server'
import { notFound, redirect } from 'next/navigation'
import Link from 'next/link'
import { ThreadView } from './ThreadView'
import type { StoneCardData, ThreadMessage } from '../shared'
import { priceContext } from '@/lib/display-price'
import { shownPrice } from '@/lib/price-shown'

export const metadata = { title: 'Messages · GemWorkers' }

const UUID_RE = /^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$/i

export default async function ThreadPage({ params }: { params: Promise<{ id: string }> }) {
  const { id } = await params

  const supabase = await createClient()
  const { data: { user } } = await supabase.auth.getUser()
  if (!user) redirect(`/auth/login?next=${encodeURIComponent(`/messages/${id}`)}`)

  if (!UUID_RE.test(id)) notFound()

  // buyer_conversations / buyer_messages are filtered on auth.uid(), so another
  // buyer's conversation id simply returns nothing.
  const [{ data: conv }, { data: msgData }] = await Promise.all([
    supabase
      .from('buyer_conversations')
      .select('id, inventory_item_id, status, unread_count')
      .eq('id', id)
      .maybeSingle(),
    supabase
      .from('buyer_messages')
      .select('id, is_mine, sender_name, body, linked_inventory_item_id, created_at, kind, offer_id, offer_amount')
      .eq('conversation_id', id)
      .order('created_at', { ascending: true }),
  ])

  if (!conv) notFound()

  const messages = (msgData ?? []) as ThreadMessage[]
  const stoneId = (conv.inventory_item_id as string | null) ?? null

  const ids = [...new Set([
    ...(stoneId ? [stoneId] : []),
    ...messages.map(m => m.linked_inventory_item_id).filter((x): x is string => !!x),
  ])].slice(0, 100)

  const stones: Record<string, StoneCardData> = {}
  if (ids.length > 0) {
    const { data: cards } = await supabase.rpc('message_stone_cards', { p_ids: ids })
    for (const card of (cards ?? []) as StoneCardData[]) stones[card.id] = card

    // EU consumers see prices incl. VAT (same rule as the stone page).
    const pctx = await priceContext()
    if (pctx) {
      const { data: from } = await supabase.from('public_listings').select('id, seller_country').in('id', Object.keys(stones))
      for (const f of (from ?? []) as { id: string; seller_country: string | null }[]) {
        const card = stones[f.id]
        if (card?.selling_price == null) continue
        const shown = shownPrice(Number(card.selling_price), f.seller_country, pctx)
        stones[f.id] = { ...card, selling_price: shown.amount, incl_vat: shown.inclVat }
      }
    }
  }

  return (
    <main className="pd-wrap browse-main">
      <nav aria-label="Breadcrumb" className="pd-crumbs">
        <Link href="/">Home</Link>
        <span aria-hidden="true">/</span>
        <Link href="/messages">Messages</Link>
        <span aria-hidden="true">/</span>
        <span aria-current="page" className="pd-crumb-current">
          {(stoneId && stones[stoneId]?.title) || 'Conversation'}
        </span>
      </nav>

      <ThreadView
        conversationId={id}
        stone={stoneId ? stones[stoneId] ?? null : null}
        stones={stones}
        messages={messages}
        closed={conv.status !== 'open'}
        unreadCount={Number(conv.unread_count) || 0}
      />
    </main>
  )
}
