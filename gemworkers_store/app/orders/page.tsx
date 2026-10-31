import { createClient } from '@/lib/supabase/server'
import { redirect } from 'next/navigation'
import Link from 'next/link'
import { MarkReceivedButton } from './MarkReceivedButton'
import { pillOutline } from '@/lib/ui'
import { PayOfferButton, PaymentDeadline } from '@/app/components/PayOfferButton'
import { canStartOfferPayment, PAY_WINDOW_CLOSING_MESSAGE } from '@/lib/offer-payment'
import { formatEur, formatMoney } from '@/lib/money'
import { paidTotal } from '@/lib/tax'
import { ReturnPanel, type BuyerReturn } from './ReturnPanel'
import { canRequestReturn } from '@/lib/returns'
import { openOrderMessages } from '@/app/actions/messages'
import { cardImage } from '@/lib/media'

// ── Types ─────────────────────────────────────────────────────────────────────

// What the buyer paid, in euros incl. VAT (GemWorkers charges euros only).
function paidOf(o: BuyerOrder): { total: number; currency: string } | null {
  return o.order_total == null ? null : { total: paidTotal(o.order_total, o.tax_amount), currency: 'EUR' }
}

// Paid orders: ask GemWorkers a question about this order (sql/order_conversation.sql).
function OrderMessageButton({ order }: { order: BuyerOrder }) {
  if (!['paid', 'confirmed', 'shipped', 'received', 'refunded'].includes(order.status)) return null
  return (
    <form action={openOrderMessages} style={{ marginTop: 10 }}>
      <input type="hidden" name="orderId" value={order.id} />
      <button type="submit" className="pd-link" style={{ background: 'none', border: 0, padding: 0, cursor: 'pointer', fontSize: 14 }}>
        Message us about this order
      </button>
    </form>
  )
}

type BuyerOrder = {
  id: string;
  order_number: string;
  status: string;
  order_date: string;
  order_total: number | null;
  tax_amount: number | string | null;
  tax_scheme: string | null;
  shipping_cost: number | null;
  tracking_number: string | null;
  shipped_at: string | null;
  received_at: string | null;
  checkout_group_id: string | null;
  offer_id: string | null;
  payment_due_at: string | null;
  order_items: {
    inventory_item_id: string;
    quantity?: number | null;   // sql/quantity_listings.sql
  }[];
};

type InvoiceLink = { id: string; order_id: string; number: string; kind: 'invoice' | 'credit_note' }

// "Invoice GW-2026-00001 · Credit note GW-2026-00002" (sql/invoices_setup.sql).
function InvoiceLinks({ links }: { links: InvoiceLink[] | undefined }) {
  if (!links?.length) return null
  return (
    <p className="order-muted" style={{ marginTop: 8, fontSize: 13 }}>
      {links.map((l, i) => (
        <span key={l.id}>
          {i > 0 && ' · '}
          <Link href={`/invoices/${l.id}`} className="pd-link">
            {l.kind === 'credit_note' ? 'Credit note' : 'Invoice'} {l.number}
          </Link>
        </span>
      ))}
    </p>
  )
}

type StoneDetails = {
  id: string;
  title: string;
  image_url: string | null;
  gem_type: string | null;
  variety: string | null;
};

type DisplayEntry =
  | { type: 'solo';  order: BuyerOrder }
  | { type: 'group'; groupId: string; orders: BuyerOrder[] }

// ── Helpers ───────────────────────────────────────────────────────────────────

// Pill text colour; background is always neutral #F4EEE4
function statusColor(s: string): string {
  if (s === 'cancelled') return '#B42318'
  if (s === 'refunded') return '#6B6052'
  if (s === 'pending_payment') return '#7A5A22'
  return '#2B7A3D'
}

function formatDate(dateStr: string) {
  const d = new Date(dateStr);
  return d.toLocaleDateString('en-IE', {
    day: '2-digit', month: 'short', year: 'numeric',
  });
}

function statusLabel(s: string) {
  const words = s.replace(/_/g, ' ')
  return words.charAt(0).toUpperCase() + words.slice(1);
}

const STATUS_ORDER = [
  'pending_payment', 'confirmed', 'shipped', 'received', 'paid', 'refunded', 'cancelled',
]
function groupStatus(orders: BuyerOrder[]): string {
  if (orders.every(o => o.status === orders[0].status)) return orders[0].status
  return STATUS_ORDER.find(s => orders.some(o => o.status === s)) ?? orders[0].status
}

// ── Small pieces ──────────────────────────────────────────────────────────────

function StatusPill({ status, small = false, label }: { status: string; small?: boolean; label?: string }) {
  return (
    <span className="order-pill" style={{
      color: statusColor(status),
      fontSize: small ? 11 : 12,
      padding: small ? '2px 8px' : '4px 12px',
    }}>
      {label ?? statusLabel(status)}
    </span>
  )
}

function StoneThumb({ stone, size }: { stone: StoneDetails | null; size: number }) {
  return (
    <div className="order-thumb" style={{ width: size, height: size }}>
      {stone?.image_url && (
        // eslint-disable-next-line @next/next/no-img-element
        <img src={cardImage(stone.image_url)} alt={stone.title} />
      )}
    </div>
  )
}

function Tracking({ number }: { number: string }) {
  return (
    <p className="order-muted" style={{ marginTop: 6 }}>
      Tracking:{' '}
      <span style={{ fontFamily: 'monospace', color: '#1F1B16' }}>{number}</span>
    </p>
  )
}

function Received() {
  return (
    <p style={{ fontSize: 14, fontWeight: 600, color: '#2B7A3D', marginTop: 8 }}>
      ✓ Received
    </p>
  )
}

// Shipped / received orders can be reviewed once (submit_review).
const REVIEWABLE = ['shipped', 'received', 'paid']

function ReviewLink({ order, reviewed }: { order: BuyerOrder; reviewed: Set<string> }) {
  if (!REVIEWABLE.includes(order.status)) return null
  if (reviewed.has(order.id)) {
    return <p className="order-muted" style={{ marginTop: 8 }}>✓ Thank you for your review</p>
  }
  return (
    <Link href={`/reviews/write/${order.id}`} className="pd-link" style={{ display: 'inline-block', marginTop: 10, fontSize: 14 }}>
      Write a review →
    </Link>
  )
}

function AwaitingShipment() {
  return <p className="order-muted" style={{ marginTop: 8 }}>Awaiting shipment</p>
}

// ── Single-order card ─────────────────────────────────────────────────────────

function SingleOrderCard({
  order,
  listingMap,
  reviewed,
  returns,
  invoices,
}: {
  order: BuyerOrder
  listingMap: Map<string, StoneDetails>
  reviewed: Set<string>
  returns: Map<string, BuyerReturn>
  invoices: Map<string, InvoiceLink[]>
}) {
  const rawTotal    = order.order_total   == null ? null : Number(order.order_total)
  const rawShipping = order.shipping_cost == null ? null : Number(order.shipping_cost)
  const rawStone    = rawTotal != null ? rawTotal - (rawShipping ?? 0) : null
  const rawVat      = Number(order.tax_amount ?? 0)

  const oi            = order.order_items[0]
  const itemId        = oi?.inventory_item_id ?? ''
  const stone         = listingMap.get(itemId) ?? null
  const storedTitle   = 'Stone'
  const displayTitle  = (stone?.title ?? storedTitle) + (Number(oi?.quantity ?? 1) > 1 ? ` × ${oi!.quantity}` : '')
  const subtitle      = stone
    ? [stone.variety, stone.gem_type].filter(Boolean).join(' · ')
    : null

  // Accepted-offer order still inside its payment window
  const awaitingOfferPayment =
    order.status === 'pending_payment' &&
    order.offer_id != null &&
    order.payment_due_at != null &&
    new Date(order.payment_due_at).getTime() > Date.now()

  return (
    <article className="order-card">
      {/* Card header */}
      <div className="order-head">
        <div>
          <p className="order-number">{order.order_number}</p>
          <p className="order-muted">{formatDate(order.order_date)}</p>
        </div>
        <StatusPill
          status={order.status}
          label={awaitingOfferPayment ? 'Awaiting payment' : undefined}
        />
      </div>

      {/* Stone row */}
      <div className="order-item">
        <StoneThumb stone={stone} size={72} />
        <div style={{ flex: 1, minWidth: 0 }}>
          <p className="order-name">{displayTitle}</p>
          {subtitle && <p className="order-muted">{subtitle}</p>}
          {order.tracking_number && <Tracking number={order.tracking_number} />}
          {order.status === 'confirmed' && <AwaitingShipment />}
          {order.status === 'shipped' && (
            <div style={{ marginTop: 12 }}><MarkReceivedButton orderId={order.id} /></div>
          )}
          {order.status === 'received' && <Received />}
          <ReviewLink order={order} reviewed={reviewed} />
          <ReturnPanel orderId={order.id} ret={returns.get(order.id) ?? null} eligible={canRequestReturn(order)} />
          <OrderMessageButton order={order} />
          <InvoiceLinks links={invoices.get(order.id)} />
          {awaitingOfferPayment && (
            <div style={{ marginTop: 14, maxWidth: 320 }}>
              {canStartOfferPayment(order.payment_due_at!) ? (
                <>
                  <PayOfferButton offerId={order.offer_id!} label="Pay now" />
                  <PaymentDeadline dueAt={order.payment_due_at!} style={{ marginTop: 8 }} />
                </>
              ) : (
                <p className="order-muted">{PAY_WINDOW_CLOSING_MESSAGE}</p>
              )}
            </div>
          )}
        </div>
      </div>

      {rawTotal != null && (
        <div className="order-total">
          <span className="order-muted">
            {(rawShipping != null && rawShipping > 0) || rawVat > 0
              ? [formatEur(rawStone!),
                 rawShipping != null && rawShipping > 0 ? `${formatEur(rawShipping)} shipping` : null,
                 rawVat > 0 ? `${formatEur(rawVat)} VAT` : null,
                ].filter(Boolean).join(' + ')
              : 'Total'}
          </span>
          <span className="order-total-amount">{formatEur(paidTotal(rawTotal, rawVat))}</span>
        </div>
      )}
      {order.tax_scheme === 'reverse_charge' && (
        <p className="order-muted" style={{ marginTop: 6 }}>VAT reverse charged (intra-EU supply, 0% VAT)</p>
      )}
    </article>
  )
}

// ── Grouped-order card ────────────────────────────────────────────────────────

function GroupedOrderCard({
  groupId,
  orders,
  listingMap,
  reviewed,
  returns,
  invoices,
}: {
  groupId: string
  orders: BuyerOrder[]
  listingMap: Map<string, StoneDetails>
  reviewed: Set<string>
  returns: Map<string, BuyerReturn>
  invoices: Map<string, InvoiceLink[]>
}) {
  void groupId
  const status        = groupStatus(orders)
  const paid          = orders.map(paidOf)
  const groupCurrency = paid.find(p => p)?.currency ?? 'EUR'   // one payment = one currency
  const combinedTotal = paid.reduce((sum, p) => paidTotal(sum, p?.total ?? 0), 0)
  const date          = orders[0].order_date
  const allSameStatus = orders.every(o => o.status === status)

  return (
    <article className="order-card">
      {/* Group header */}
      <div className="order-head">
        <div>
          <p className="order-number">
            {orders.length} {orders.length === 1 ? 'item' : 'items'}
          </p>
          <p className="order-muted">Placed {formatDate(date)}</p>
        </div>
        <StatusPill status={status} />
      </div>

      {/* Per-order stone rows */}
      <div>
        {orders.map(o => {
          const oi           = o.order_items[0]
          const itemId       = oi?.inventory_item_id ?? ''
          const stone        = listingMap.get(itemId) ?? null
          const storedTitle  = 'Stone'
          const displayTitle = (stone?.title ?? storedTitle) + (Number(oi?.quantity ?? 1) > 1 ? ` × ${oi!.quantity}` : '')
          const subtitle     = stone
            ? [stone.variety, stone.gem_type].filter(Boolean).join(' · ')
            : null
          const oPaid        = paidOf(o)

          return (
            <div key={o.id} className="order-item order-item-ruled">
              <StoneThumb stone={stone} size={64} />

              <div style={{ flex: 1, minWidth: 0 }}>
                <p className="order-name">{displayTitle}</p>
                {subtitle && <p className="order-muted">{subtitle}</p>}
                <div style={{ display: 'flex', alignItems: 'center', gap: 8, flexWrap: 'wrap', marginTop: 4 }}>
                  <span className="order-muted" style={{ fontFamily: 'monospace' }}>{o.order_number}</span>
                  {!allSameStatus && o.status !== status && <StatusPill status={o.status} small />}
                </div>
                {o.tracking_number && <Tracking number={o.tracking_number} />}
                {o.status === 'shipped' && (
                  <div style={{ marginTop: 12 }}><MarkReceivedButton orderId={o.id} /></div>
                )}
                {o.status === 'received' && <Received />}
                <ReviewLink order={o} reviewed={reviewed} />
                <ReturnPanel orderId={o.id} ret={returns.get(o.id) ?? null} eligible={canRequestReturn(o)} />
                <OrderMessageButton order={o} />
                <InvoiceLinks links={invoices.get(o.id)} />
              </div>

              {oPaid != null && (
                <span style={{ fontSize: 15, fontWeight: 600, color: '#1F1B16', flexShrink: 0 }}>
                  {formatMoney(oPaid.total, oPaid.currency)}
                </span>
              )}
            </div>
          )
        })}
      </div>

      {allSameStatus && status === 'confirmed' && <AwaitingShipment />}
      {allSameStatus && status === 'received' && <Received />}

      {/* Combined total footer */}
      <div className="order-total">
        <span className="order-muted">Total</span>
        <span className="order-total-amount">{formatMoney(combinedTotal, groupCurrency)}</span>
      </div>
      {orders.some(o => o.tax_scheme === 'reverse_charge') && (
        <p className="order-muted" style={{ marginTop: 6 }}>VAT reverse charged (intra-EU supply, 0% VAT)</p>
      )}
    </article>
  )
}

// ── Page ──────────────────────────────────────────────────────────────────────

export default async function BuyerOrdersPage() {
  const supabase = await createClient()
  const { data: { user } } = await supabase.auth.getUser()
  if (!user) redirect('/auth/login?next=%2Forders')

  const { data } = await supabase
    .from('orders')
    .select(`
      id, order_number, status, order_date, order_total, tax_amount, tax_scheme, shipping_cost,
      tracking_number, shipped_at, received_at, checkout_group_id,
      offer_id, payment_due_at,
      order_items ( inventory_item_id, quantity )
    `)
    .order('created_at', { ascending: false })

  const orders = (data ?? []) as BuyerOrder[]

  const allItemIds = [
    ...new Set(
      orders.flatMap(o => o.order_items.map(oi => oi.inventory_item_id).filter(Boolean))
    ),
  ]

  const listingMap = new Map<string, StoneDetails>()
  if (allItemIds.length > 0) {
    const { data: listings } = await supabase
      .from('buyer_purchased_stones')
      .select('id, title, image_url, gem_type, variety')
      .in('id', allItemIds)
    for (const l of listings ?? []) {
      listingMap.set(l.id, l as StoneDetails)
    }
  }

  // reviews_buyer_select RLS: only this buyer's own reviews.
  const reviewed = new Set<string>()
  if (orders.length > 0) {
    const { data: myReviews } = await supabase
      .from('reviews')
      .select('order_id')
      .in('order_id', orders.map(o => o.id))
    for (const r of myReviews ?? []) reviewed.add(r.order_id as string)
  }

  // Returns (buyer_returns view: this buyer's own, buyer-safe columns).
  const returns = new Map<string, BuyerReturn>()
  if (orders.length > 0) {
    const { data: myReturns } = await supabase
      .from('buyer_returns')
      .select('id, order_id, status, faulty, return_address, return_tracking, decision_note, refunded_at, refund_amount')
      .in('order_id', orders.map(o => o.id))
    for (const r of (myReturns ?? []) as BuyerReturn[]) returns.set(r.order_id, r)
  }

  // Invoices and credit notes (buyer_invoices: this buyer's own).
  const invoices = new Map<string, InvoiceLink[]>()
  if (orders.length > 0) {
    const { data: myInvoices } = await supabase
      .from('buyer_invoices')
      .select('id, order_id, number, kind')
      .in('order_id', orders.map(o => o.id))
      .order('number')
    for (const inv of (myInvoices ?? []) as InvoiceLink[]) {
      invoices.set(inv.order_id, [...(invoices.get(inv.order_id) ?? []), inv])
    }
  }

  const entries: DisplayEntry[] = []
  const groupIndex = new Map<string, number>()

  for (const order of orders) {
    if (!order.checkout_group_id) {
      entries.push({ type: 'solo', order })
    } else {
      const idx = groupIndex.get(order.checkout_group_id)
      if (idx !== undefined) {
        (entries[idx] as Extract<DisplayEntry, { type: 'group' }>).orders.push(order)
      } else {
        groupIndex.set(order.checkout_group_id, entries.length)
        entries.push({ type: 'group', groupId: order.checkout_group_id, orders: [order] })
      }
    }
  }

  return (
    <main className="pd-wrap browse-main">
      <nav aria-label="Breadcrumb" className="pd-crumbs">
        <Link href="/">Home</Link>
        <span aria-hidden="true">/</span>
        <span aria-current="page">Orders</span>
      </nav>

      <h1 className="font-serif browse-title">My orders</h1>
      <p className="browse-count">Your purchase history from GemWorkers.</p>

      {entries.length === 0 ? (
        <div className="browse-empty">
          <p>You have no orders yet.</p>
          <Link href="/shop/all" style={{ ...pillOutline, display: 'inline-flex', width: 'auto', marginTop: 12 }}>
            Browse loose gemstones
          </Link>
        </div>
      ) : (
        <div className="order-list">
          {entries.map(entry =>
            entry.type === 'solo'
              ? <SingleOrderCard
                  key={entry.order.id}
                  order={entry.order}
                  listingMap={listingMap}
                  reviewed={reviewed}
                  returns={returns}
                  invoices={invoices}
                />
              : <GroupedOrderCard
                  key={entry.groupId}
                  groupId={entry.groupId}
                  orders={entry.orders}
                  listingMap={listingMap}
                  reviewed={reviewed}
                  returns={returns}
                  invoices={invoices}
                />
          )}
        </div>
      )}
    </main>
  )
}
