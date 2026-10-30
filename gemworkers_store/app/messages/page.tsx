import { createClient } from '@/lib/supabase/server'
import { redirect } from 'next/navigation'
import Link from 'next/link'
import { LocalTime, type StoneCardData } from './shared'
import { cardImage } from '@/lib/media'

export const metadata = { title: 'Messages · GemWorkers' }

// buyer_conversations row (only the columns used here)
type ConversationRow = {
  id: string
  inventory_item_id: string | null
  status: 'open' | 'closed'
  last_message_at: string
  unread_count: number
  last_message_preview: string | null
  last_message_is_mine: boolean | null
}

export default async function MessagesPage() {
  const supabase = await createClient()
  const { data: { user } } = await supabase.auth.getUser()
  if (!user) redirect('/auth/login?next=%2Fmessages')

  const { data: convData } = await supabase
    .from('buyer_conversations')
    .select('id, inventory_item_id, status, last_message_at, unread_count, last_message_preview, last_message_is_mine')
    .order('last_message_at', { ascending: false })

  const conversations = (convData ?? []) as ConversationRow[]

  const stoneIds = [...new Set(
    conversations.map(c => c.inventory_item_id).filter((id): id is string => !!id)
  )]
  const stones = new Map<string, StoneCardData>()
  if (stoneIds.length > 0) {
    const { data: cards } = await supabase.rpc('message_stone_cards', { p_ids: stoneIds.slice(0, 100) })
    for (const card of (cards ?? []) as StoneCardData[]) stones.set(card.id, card)
  }

  return (
    <main className="pd-wrap browse-main">
      <nav aria-label="Breadcrumb" className="pd-crumbs">
        <Link href="/">Home</Link>
        <span aria-hidden="true">/</span>
        <span aria-current="page">Messages</span>
      </nav>

      <h1 className="font-serif browse-title">Messages</h1>
      <p className="browse-count">Your conversations with GemWorkers about our stones.</p>

      {conversations.length === 0 ? (
        <div className="browse-empty">
          <p>No messages yet — ask about any stone and we&apos;ll reply here.</p>
          <Link href="/shop/all" className="pd-link">Browse stones →</Link>
        </div>
      ) : (
        <ul className="msg-list">
          {conversations.map(c => {
            const stone = c.inventory_item_id ? stones.get(c.inventory_item_id) ?? null : null
            const unread = c.unread_count > 0
            return (
              <li key={c.id}>
                <Link href={`/messages/${c.id}`} className={`msg-row ${unread ? 'is-unread' : ''}`}>
                  <div className="order-thumb" style={{ width: 64, height: 64 }}>
                    {stone?.image_url && (
                      // eslint-disable-next-line @next/next/no-img-element
                      <img src={cardImage(stone.image_url)} alt="" />
                    )}
                  </div>

                  <div className="msg-row-main">
                    <div className="msg-row-top">
                      <p className="msg-row-title">{stone?.title ?? 'Stone no longer listed'}</p>
                      <span className="msg-row-time">
                        <LocalTime iso={c.last_message_at} mode="list" />
                      </span>
                    </div>
                    <p className="msg-row-preview">
                      {c.last_message_is_mine && <span className="msg-row-you">You: </span>}
                      {c.last_message_preview ?? ''}
                    </p>
                    {c.status === 'closed' && <p className="msg-row-closed">Closed</p>}
                  </div>

                  <span
                    className="msg-dot"
                    aria-label={unread ? `${c.unread_count} unread` : undefined}
                    style={{ visibility: unread ? 'visible' : 'hidden' }}
                  />
                </Link>
              </li>
            )
          })}
        </ul>
      )}
    </main>
  )
}
