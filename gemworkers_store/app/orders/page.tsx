import { createClient } from '@/lib/supabase/server'
import { redirect } from 'next/navigation'
import Link from 'next/link'
import { MarkReceivedButton } from './MarkReceivedButton'
import { pillOutline } from '@/lib/ui'
import { PayOfferButton, PaymentDeadline } from '@/app/components/PayOfferButton'
import { canStartOfferPayment, PAY_WINDOW_CLOSING_MESSAGE } from '@/lib/offer-payment'

// ── Types ─────────────────────────────────────────────────────────────────────

type BuyerOrder = {
  id: string;
  order_number: string;
  status: string;
  order_date: string;
  order_total: number | null;
  shipping_cost: number | null;
  tracking_number: string | null;
  shipped_at: string | null;
  received_at: string | null;
  checkout_group_id: string | null;
  offer_id: string | null;
  payment_due_at: string | null;
  order_items: {
    inventory_item_id: string;
  }[];
};

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
  if (s === 'pending_payment') return '#7A5A22'
  return '#2B7A3D'
}

const eur = new Intl.NumberFormat('en-IE', {
  style: 'currency', currency: 'EUR', maximumFractionDigits: 0,
});

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
  'pending_payment', 'confirmed', 'shipped', 'received', 'paid', 'cancelled',
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
        <img src={stone.image_url} alt={stone.title} />
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

function AwaitingShipment() {
  return <p className="order-muted" style={{ marginTop: 8 }}>Awaiting shipment</p>
}

// ── Single-order card ─────────────────────────────────────────────────────────

function SingleOrderCard({
  order,
  listingMap,
}: {
  order: BuyerOrder
  listingMap: Map<string, StoneDetails>
}) {
  const rawTotal    = order.order_total   == null ? null : Number(order.order_total)
  const rawShipping = order.shipping_cost == null ? null : Number(order.shipping_cost)
  const rawStone    = rawTotal != null ? rawTotal - (rawShipping ?? 0) : null

  const oi            = order.order_items[0]
  const itemId        = oi?.inventory_item_id ?? ''
  const stone         = listingMap.get(itemId) ?? null
  const storedTitle   = 'Stone'
  const displayTitle  = stone?.title ?? storedTitle
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
            {rawShipping != null && rawShipping > 0
              ? `${eur.format(rawStone!)} + ${eur.format(rawShipping)} shipping`
              : 'Total'}
          </span>
          <span className="order-total-amount">{eur.format(rawTotal)}</span>
        </div>
      )}
    </article>
  )
}

// ── Grouped-order card ────────────────────────────────────────────────────────

function GroupedOrderCard({
  groupId,
  orders,
  listingMap,
}: {
  groupId: string
  orders: BuyerOrder[]
  listingMap: Map<string, StoneDetails>
}) {
  void groupId
  const status        = groupStatus(orders)
  const combinedTotal = orders.reduce((sum, o) => sum + Number(o.order_total ?? 0), 0)
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
          const displayTitle = stone?.title ?? storedTitle
          const subtitle     = stone
            ? [stone.variety, stone.gem_type].filter(Boolean).join(' · ')
            : null
          const oTotal       = o.order_total != null ? Number(o.order_total) : null

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
              </div>

              {oTotal != null && (
                <span style={{ fontSize: 15, fontWeight: 600, color: '#1F1B16', flexShrink: 0 }}>
                  {eur.format(oTotal)}
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
        <span className="order-total-amount">{eur.format(combinedTotal)}</span>
      </div>
    </article>
  )
}

// ── Page ──────────────────────────────────────────────────────────────────────

export default async function BuyerOrdersPage() {
  const supabase = await createClient()
  const { data: { user } } = await supabase.auth.getUser()
  if (!user) redirect('/auth/login')

  const { data } = await supabase
    .from('orders')
    .select(`
      id, order_number, status, order_date, order_total, shipping_cost,
      tracking_number, shipped_at, received_at, checkout_group_id,
      offer_id, payment_due_at,
      order_items ( inventory_item_id )
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
          <Link href="/shop/loose_stone" style={{ ...pillOutline, display: 'inline-flex', width: 'auto', marginTop: 12 }}>
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
                />
              : <GroupedOrderCard
                  key={entry.groupId}
                  groupId={entry.groupId}
                  orders={entry.orders}
                  listingMap={listingMap}
                />
          )}
        </div>
      )}
    </main>
  )
}
