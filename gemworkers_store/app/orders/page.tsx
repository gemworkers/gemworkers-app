import { createClient } from '@/lib/supabase/server'
import { redirect } from 'next/navigation'
import Link from 'next/link'
import { StoreHeader } from '@/app/components/StoreHeader'
import { MarkReceivedButton } from './MarkReceivedButton'

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
  order_items: {
    inventory_item_id: string;
  }[];
};

// Stone details loaded from public_listings (same view as cart page).
// Absent when the stone is sold/unlisted — cards fall back to stored title.
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

const STATUS_COLOR: Record<string, string> = {
  confirmed: '#3b82f6',
  shipped:   '#f97316',
  received:  '#14b8a6',
  paid:      '#16a34a',
  cancelled: '#ef4444',
};

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
  return s.charAt(0).toUpperCase() + s.slice(1);
}

const STATUS_ORDER = [
  'pending_payment', 'confirmed', 'shipped', 'received', 'paid', 'cancelled',
]
function groupStatus(orders: BuyerOrder[]): string {
  if (orders.every(o => o.status === orders[0].status)) return orders[0].status
  return STATUS_ORDER.find(s => orders.some(o => o.status === s)) ?? orders[0].status
}

// ── Stone thumbnail ───────────────────────────────────────────────────────────
// Matches the cart page's photo/placeholder pattern exactly.

function StoneThumb({
  stone,
  fallbackInitial,
  size,
}: {
  stone: StoneDetails | null
  fallbackInitial: string   // first char of stored title, used when stone absent
  size: number
}) {
  const initial = stone?.gem_type?.charAt(0).toUpperCase()
    ?? fallbackInitial.charAt(0).toUpperCase()
    ?? '◇'

  if (stone?.image_url) {
    return (
      // eslint-disable-next-line @next/next/no-img-element
      <img
        src={stone.image_url}
        alt={stone.title}
        style={{
          width: size, height: size, objectFit: 'cover',
          borderRadius: 8, flexShrink: 0, display: 'block',
          border: '1px solid #f3f4f6',
        }}
      />
    )
  }

  return (
    <div style={{
      width: size, height: size, flexShrink: 0, borderRadius: 8,
      background: 'linear-gradient(145deg, #f6f3ef 0%, #ece8e2 100%)',
      display: 'flex', alignItems: 'center', justifyContent: 'center',
      border: '1px solid #f3f4f6',
    }}>
      <span style={{
        fontSize: Math.round(size * 0.4),
        color: '#c4b8ab', fontWeight: 300,
        fontFamily: "Georgia, 'Times New Roman', serif",
        lineHeight: 1, userSelect: 'none',
      }}>
        {initial}
      </span>
    </div>
  )
}

// ── Single-order card ─────────────────────────────────────────────────────────

function SingleOrderCard({
  order,
  listingMap,
}: {
  order: BuyerOrder
  listingMap: Map<string, StoneDetails>
}) {
  const color       = STATUS_COLOR[order.status] ?? '#9ca3af'
  const rawTotal    = order.order_total   == null ? null : Number(order.order_total)
  const rawShipping = order.shipping_cost == null ? null : Number(order.shipping_cost)
  const rawStone    = rawTotal != null ? rawTotal - (rawShipping ?? 0) : null

  // First (and typically only) order item.
  const oi            = order.order_items[0]
  const itemId        = oi?.inventory_item_id ?? ''
  const stone         = listingMap.get(itemId) ?? null
  const storedTitle   = 'Stone'
  const displayTitle  = stone?.title ?? storedTitle
  const subtitle      = stone
    ? [stone.variety, stone.gem_type].filter(Boolean).join(' · ')
    : null

  return (
    <div style={{
      background: '#fff', border: '1px solid #e5e7eb',
      borderRadius: 10, padding: '20px 24px',
    }}>
      {/* ── Card header: date + status badge ── */}
      <div style={{
        display: 'flex', alignItems: 'center',
        justifyContent: 'space-between', marginBottom: 16,
      }}>
        <span style={{ fontSize: 12, color: '#9ca3af' }}>
          {formatDate(order.order_date)}
        </span>
        <span style={{
          fontSize: 11, fontWeight: 700, letterSpacing: '0.05em',
          color, border: `1px solid ${color}`, borderRadius: 6,
          padding: '3px 10px', background: `${color}1a`,
        }}>
          {statusLabel(order.status)}
        </span>
      </div>

      {/* ── Stone row: photo + name + price ── */}
      <div style={{ display: 'flex', gap: 16, alignItems: 'flex-start', marginBottom: 14 }}>
        <StoneThumb stone={stone} fallbackInitial={displayTitle} size={72} />

        <div style={{ flex: 1, minWidth: 0 }}>
          <p style={{
            fontSize: 15, fontWeight: 600, color: '#111',
            marginBottom: subtitle ? 3 : 6, lineHeight: 1.3,
          }}>
            {displayTitle}
          </p>
          {subtitle && (
            <p style={{ fontSize: 12, color: '#9ca3af', marginBottom: 6 }}>
              {subtitle}
            </p>
          )}
          <p style={{ fontSize: 11, color: '#b0b0b0', fontFamily: 'monospace' }}>
            {order.order_number}
          </p>
        </div>

        {rawTotal != null && (
          <div style={{ textAlign: 'right', flexShrink: 0 }}>
            <span style={{ fontSize: 16, fontWeight: 700, color: '#111' }}>
              {eur.format(rawTotal)}
            </span>
            {rawShipping != null && rawShipping > 0 && (
              <div style={{ fontSize: 11, color: '#b0b0b0', marginTop: 2 }}>
                {eur.format(rawStone!)} + {eur.format(rawShipping)} shipping
              </div>
            )}
          </div>
        )}
      </div>

      {/* ── Tracking number ── */}
      {order.tracking_number && (
        <p style={{ fontSize: 12, color: '#6b7280', marginBottom: 10 }}>
          Tracking:{' '}
          <span style={{ fontFamily: 'monospace', color: '#374151' }}>
            {order.tracking_number}
          </span>
        </p>
      )}

      {/* ── Status-specific content ── */}
      {order.status === 'confirmed' && (
        <p style={{ fontSize: 12, color: '#6b7280', fontStyle: 'italic' }}>
          Awaiting shipment
        </p>
      )}
      {order.status === 'shipped' && (
        <MarkReceivedButton orderId={order.id} />
      )}
      {order.status === 'received' && (
        <p style={{ fontSize: 12, fontWeight: 600, color: '#14b8a6' }}>
          ✓ Received
        </p>
      )}
    </div>
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
  void groupId  // used as React key by caller; suppress unused-var lint
  const status        = groupStatus(orders)
  const color         = STATUS_COLOR[status] ?? '#9ca3af'
  const combinedTotal = orders.reduce((sum, o) => sum + Number(o.order_total ?? 0), 0)
  const date          = orders[0].order_date
  const allSameStatus = orders.every(o => o.status === status)

  return (
    <div style={{
      background: '#fff', border: '1px solid #e5e7eb',
      borderRadius: 10, padding: '20px 24px',
    }}>
      {/* ── Group header ── */}
      <div style={{
        display: 'flex', alignItems: 'center',
        justifyContent: 'space-between', marginBottom: 16,
      }}>
        <span style={{ fontSize: 14, fontWeight: 700, color: '#111' }}>
          Order placed {formatDate(date)}&nbsp;&middot;&nbsp;{orders.length}{' '}
          {orders.length === 1 ? 'item' : 'items'}
        </span>
        <span style={{
          fontSize: 11, fontWeight: 700, letterSpacing: '0.05em',
          color, border: `1px solid ${color}`, borderRadius: 6,
          padding: '3px 10px', background: `${color}1a`,
        }}>
          {statusLabel(status)}
        </span>
      </div>

      {/* ── Per-order stone rows ── */}
      <div style={{ borderTop: '1px solid #f3f4f6' }}>
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
          const rowColor     = STATUS_COLOR[o.status] ?? '#9ca3af'

          return (
            <div key={o.id} style={{
              display: 'flex', gap: 14, alignItems: 'flex-start',
              padding: '12px 0', borderBottom: '1px solid #f3f4f6',
            }}>
              <StoneThumb stone={stone} fallbackInitial={displayTitle} size={60} />

              <div style={{ flex: 1, minWidth: 0 }}>
                <p style={{
                  fontSize: 14, fontWeight: 600, color: '#111',
                  marginBottom: subtitle ? 3 : 4, lineHeight: 1.3,
                }}>
                  {displayTitle}
                </p>
                {subtitle && (
                  <p style={{ fontSize: 12, color: '#9ca3af', marginBottom: 4 }}>
                    {subtitle}
                  </p>
                )}
                <div style={{ display: 'flex', alignItems: 'center', gap: 8 }}>
                  <span style={{ fontSize: 11, color: '#b0b0b0', fontFamily: 'monospace' }}>
                    {o.order_number}
                  </span>
                  {/* Per-order badge only when this order's status differs from group */}
                  {!allSameStatus && o.status !== status && (
                    <span style={{
                      fontSize: 10, fontWeight: 700, letterSpacing: '0.04em',
                      color: rowColor, border: `1px solid ${rowColor}`,
                      borderRadius: 4, padding: '1px 5px', background: `${rowColor}1a`,
                    }}>
                      {statusLabel(o.status)}
                    </span>
                  )}
                </div>
                {o.tracking_number && (
                  <p style={{ fontSize: 11, color: '#6b7280', marginTop: 3 }}>
                    Tracking:{' '}
                    <span style={{ fontFamily: 'monospace' }}>{o.tracking_number}</span>
                  </p>
                )}
                {o.status === 'shipped' && (
                  <div style={{ marginTop: 6 }}>
                    <MarkReceivedButton orderId={o.id} />
                  </div>
                )}
                {o.status === 'received' && (
                  <p style={{ fontSize: 12, fontWeight: 600, color: '#14b8a6', marginTop: 4 }}>
                    ✓ Received
                  </p>
                )}
              </div>

              {oTotal != null && (
                <span style={{
                  fontSize: 13, fontWeight: 600, color: '#374151',
                  flexShrink: 0, paddingTop: 2,
                }}>
                  {eur.format(oTotal)}
                </span>
              )}
            </div>
          )
        })}
      </div>

      {/* ── Combined total footer ── */}
      <div style={{
        display: 'flex', justifyContent: 'space-between', alignItems: 'baseline',
        fontSize: 12, color: '#9ca3af', marginTop: 12,
      }}>
        <span>{formatDate(date)}</span>
        <span style={{ fontWeight: 700, color: '#374151', fontSize: 13 }}>
          Total {eur.format(combinedTotal)}
        </span>
      </div>

      {/* ── Group-level status messages ── */}
      {allSameStatus && status === 'confirmed' && (
        <p style={{ fontSize: 12, color: '#6b7280', fontStyle: 'italic', marginTop: 10 }}>
          Awaiting shipment
        </p>
      )}
      {allSameStatus && status === 'received' && (
        <p style={{ fontSize: 12, fontWeight: 600, color: '#14b8a6', marginTop: 10 }}>
          ✓ Received
        </p>
      )}
    </div>
  )
}

// ── Page ──────────────────────────────────────────────────────────────────────

export default async function BuyerOrdersPage() {
  const supabase = await createClient()
  const { data: { user } } = await supabase.auth.getUser()
  if (!user) redirect('/auth/login')

  // orders_buyer_select RLS scopes this to buyer_id = auth.uid() automatically.
  // inventory_item_id is needed to look up stone details from public_listings.
  const { data } = await supabase
    .from('orders')
    .select(`
      id, order_number, status, order_date, order_total, shipping_cost,
      tracking_number, shipped_at, received_at, checkout_group_id,
      order_items ( inventory_item_id )
    `)
    .order('created_at', { ascending: false })

  const orders = (data ?? []) as BuyerOrder[]

  // Fetch stone details via buyer_purchased_stones — a security_invoker=false
  // view that can read sold inventory_items but is scoped to buyer_id=auth.uid().
  // public_listings is NOT used here because it excludes sold stones.
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

  // Group orders for display: shared checkout_group_id → combined card.
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
    <>
      <style>{`
        body {
          background: #fafaf9;
          font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Helvetica, Arial, sans-serif;
        }
      `}</style>

      <StoreHeader />

      <main style={{ maxWidth: 720, margin: '0 auto', padding: '40px 24px 80px' }}>
        <h1 style={{ fontSize: 22, fontWeight: 700, color: '#111', marginBottom: 6 }}>
          My Orders
        </h1>
        <p style={{ fontSize: 14, color: '#9ca3af', marginBottom: 32 }}>
          Your purchase history from GemWorkers.
        </p>

        {entries.length === 0 ? (
          <div style={{ textAlign: 'center', padding: '80px 0' }}>
            <div style={{ fontSize: 44, color: '#d1d5db', marginBottom: 14, lineHeight: 1 }}>◇</div>
            <p style={{ fontSize: 15, color: '#9ca3af', marginBottom: 28 }}>
              You have no orders yet.
            </p>
            <Link href="/" style={{
              display: 'inline-block', padding: '10px 24px',
              background: '#111', color: '#fff', borderRadius: 6,
              textDecoration: 'none', fontSize: 13, fontWeight: 600,
              letterSpacing: '0.02em',
            }}>
              Browse stones
            </Link>
          </div>
        ) : (
          <div style={{ display: 'flex', flexDirection: 'column', gap: 16 }}>
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
    </>
  )
}
