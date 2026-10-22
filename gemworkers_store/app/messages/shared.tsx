'use client'

import { useEffect, useState } from 'react'
import Link from 'next/link'
import { formatEur } from '@/lib/money'

// Shared types + pieces for the buyer message portal (/messages).

// message_stone_cards row. status: available | reserved | unavailable;
// selling_price is null when unavailable.
export type StoneCardData = {
  id: string
  title: string
  image_url: string | null
  selling_price: number | null
  product_type: string | null
  status: 'available' | 'reserved' | 'unavailable'
}

// buyer_messages row
export type ThreadMessage = {
  id: string
  is_mine: boolean
  sender_name: string
  body: string
  linked_inventory_item_id: string | null
  created_at: string
  // 'text' or an offer event card (offer_made, offer_accepted, …)
  kind: string
  offer_id: string | null
  offer_amount: number | string | null
}

// ── Local time ────────────────────────────────────────────────────────────────
// Rendered in UTC on the server and on first paint (identical, so no hydration
// mismatch), then switched to the buyer's own time zone after mount.

function formatTime(iso: string, mode: 'list' | 'thread', timeZone?: string): string {
  const d = new Date(iso)
  const now = new Date()
  const dayKey = (x: Date) => x.toLocaleDateString('en-IE', { timeZone })
  const time = d.toLocaleTimeString('en-IE', { hour: '2-digit', minute: '2-digit', timeZone })

  if (dayKey(d) === dayKey(now)) return mode === 'list' ? time : `Today, ${time}`

  const sameYear = d.toLocaleDateString('en-IE', { year: 'numeric', timeZone })
    === now.toLocaleDateString('en-IE', { year: 'numeric', timeZone })
  const date = d.toLocaleDateString('en-IE', {
    day: 'numeric', month: 'short', year: sameYear ? undefined : 'numeric', timeZone,
  })
  return mode === 'list' ? date : `${date}, ${time}`
}

export function LocalTime({ iso, mode }: { iso: string; mode: 'list' | 'thread' }) {
  const [mounted, setMounted] = useState(false)
  useEffect(() => { setMounted(true) }, [])
  return (
    <time dateTime={iso} suppressHydrationWarning>
      {formatTime(iso, mode, mounted ? undefined : 'UTC')}
    </time>
  )
}

// ── Offer card ────────────────────────────────────────────────────────────────
// System row written when an offer is made or answered. Unknown kinds (added
// later, e.g. counter-offers) fall back to the row's own body text.

const OFFER_CARD_TEXT: Record<string, {
  title: string
  note?: string
  ordersLink?: boolean
  stoneLink?: boolean
}> = {
  offer_made:       { title: 'You made an offer' },
  offer_accepted:   { title: 'Offer accepted', note: 'Complete your payment in My orders.', ordersLink: true },
  offer_declined:   { title: 'Offer declined' },
  offer_expired:    { title: 'Offer expired' },
  offer_withdrawn:  { title: 'You withdrew your offer' },
  offer_countered:  { title: 'Counter-offer', note: 'Open for 48 hours. Accept or decline it on the stone page.', stoneLink: true },
  counter_accepted: { title: 'You accepted the counter-offer', note: 'Complete your payment in My orders.', ordersLink: true },
  counter_declined: { title: 'You declined the counter-offer' },
  counter_expired:  { title: 'Counter-offer expired' },
}

export function OfferCard({ message, stoneId }: { message: ThreadMessage; stoneId?: string | null }) {
  const text = OFFER_CARD_TEXT[message.kind]
  const amount = message.offer_amount != null ? formatEur(message.offer_amount) : null

  return (
    <div className={`msg-offer msg-offer-${message.kind}`}>
      <p className="msg-offer-title">{text?.title ?? message.body}</p>
      {text && amount && <p className="msg-offer-amount">{amount}</p>}
      {text?.note && <p className="msg-offer-note">{text.note}</p>}
      {text?.ordersLink && <Link href="/orders" className="pd-link" style={{ fontSize: 14 }}>Go to My orders →</Link>}
      {text?.stoneLink && stoneId && (
        <Link href={`/stones/${stoneId}`} className="pd-link" style={{ fontSize: 14 }}>View counter-offer →</Link>
      )}
      <p className="msg-time"><LocalTime iso={message.created_at} mode="thread" /></p>
    </div>
  )
}

// ── Stone card ────────────────────────────────────────────────────────────────
// Large: top of a thread. Small: under a message that links a stone.

export function MessageStoneCard({
  stone,
  size = 'large',
}: {
  stone: StoneCardData | null
  size?: 'large' | 'small'
}) {
  const small = size === 'small'

  if (!stone) {
    return (
      <div className={`msg-stone ${small ? 'msg-stone-sm' : ''}`}>
        <div className="msg-stone-thumb" />
        <div style={{ minWidth: 0 }}>
          <p className="msg-stone-title">Stone no longer listed</p>
          <p className="order-muted">This stone has been removed from GemWorkers.</p>
        </div>
      </div>
    )
  }

  const href = `/stones/${stone.id}`
  const linkable = stone.status !== 'unavailable'

  return (
    <div className={`msg-stone ${small ? 'msg-stone-sm' : ''}`}>
      <div className="msg-stone-thumb">
        {stone.image_url && (
          // eslint-disable-next-line @next/next/no-img-element
          <img src={stone.image_url} alt={stone.title} />
        )}
      </div>

      <div style={{ minWidth: 0, flex: 1 }}>
        {linkable ? (
          <Link href={href} className="msg-stone-title msg-stone-title-link">{stone.title}</Link>
        ) : (
          <p className="msg-stone-title">{stone.title}</p>
        )}

        <div className="msg-stone-meta">
          {stone.status === 'available' && stone.selling_price != null && (
            <span className="msg-stone-price">{formatEur(Number(stone.selling_price))}</span>
          )}
          {stone.status === 'reserved' && (
            <span className="order-pill msg-stone-badge">Reserved</span>
          )}
          {stone.status === 'unavailable' && (
            <span className="order-pill msg-stone-badge">No longer available</span>
          )}
        </div>

        {stone.status === 'available' && (
          <Link href={href} className="pd-link" style={{ fontSize: small ? 13 : 14 }}>
            {small ? 'View stone →' : 'View & buy →'}
          </Link>
        )}
        {stone.status === 'reserved' && !small && (
          <p className="order-muted">This stone is reserved at the moment.</p>
        )}
      </div>
    </div>
  )
}
