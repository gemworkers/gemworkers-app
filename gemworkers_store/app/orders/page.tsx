import { createClient } from '@/lib/supabase/server'
import { redirect } from 'next/navigation'
import Link from 'next/link'
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
  confirmed: '#60a5fa',
  shipped:   '#fb923c',
  received:  '#2dd4bf',
  paid:      '#4ade80',
  cancelled: '#f87171',
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

function StoneThumb({
  stone,
  fallbackInitial,
  size,
}: {
  stone: StoneDetails | null
  fallbackInitial: string
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
          border: '1px solid #2a2a30',
        }}
      />
    )
  }

  return (
    <div style={{
      width: size, height: size, flexShrink: 0, borderRadius: 8,
      background: 'linear-gradient(145deg, #1e1e24 0%, #252530 100%)',
      display: 'flex', alignItems: 'center', justifyContent: 'center',
      border: '1px solid #2a2a30',
    }}>
      <span style={{
        fontSize: Math.round(size * 0.4),
        color: '#3a3530', fontWeight: 300,
        fontFamily: 'var(--font-cormorant, Georgia, serif)',
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
  const color       = STATUS_COLOR[order.status] ?? '#9d9080'
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

  return (
    <div style={{
      background: '#16161a', border: '1px solid #2a2a30',
      borderRadius: 10, padding: '20px 24px',
    }}>
      {/* Card header */}
      <div style={{
        display: 'flex', alignItems: 'center',
        justifyContent: 'space-between', marginBottom: 16,
      }}>
        <span style={{
          fontSize: 11, color: '#9d9080',
          fontFamily: 'var(--font-inter, system-ui)',
        }}>
          {formatDate(order.order_date)}
        </span>
        <span style={{
          fontSize: 10, fontWeight: 700, letterSpacing: '0.06em',
          color, border: `1px solid ${color}33`, borderRadius: 5,
          padding: '3px 10px', background: `${color}1a`,
          fontFamily: 'var(--font-inter, system-ui)',
        }}>
          {statusLabel(order.status)}
        </span>
      </div>

      {/* Stone row */}
      <div style={{ display: 'flex', gap: 16, alignItems: 'flex-start', marginBottom: 14 }}>
        <StoneThumb stone={stone} fallbackInitial={displayTitle} size={72} />

        <div style={{ flex: 1, minWidth: 0 }}>
          <p style={{
            fontSize: 16, fontWeight: 300, color: '#f5f0e8',
            marginBottom: subtitle ? 3 : 6, lineHeight: 1.3,
            fontFamily: 'var(--font-cormorant, Georgia, serif)',
          }}>
            {displayTitle}
          </p>
          {subtitle && (
            <p style={{
              fontSize: 12, color: '#9d9080', marginBottom: 6,
              fontFamily: 'var(--font-inter, system-ui)',
            }}>
              {subtitle}
            </p>
          )}
          <p style={{
            fontSize: 10, color: '#4a4440', fontFamily: 'monospace',
            letterSpacing: '0.04em',
          }}>
            {order.order_number}
          </p>
        </div>

        {rawTotal != null && (
          <div style={{ textAlign: 'right', flexShrink: 0 }}>
            <span style={{
              fontSize: 17, fontWeight: 400, color: '#f5f0e8',
              fontFamily: 'var(--font-cormorant, Georgia, serif)',
            }}>
              {eur.format(rawTotal)}
            </span>
            {rawShipping != null && rawShipping > 0 && (
              <div style={{
                fontSize: 11, color: '#4a4440', marginTop: 2,
                fontFamily: 'var(--font-inter, system-ui)',
              }}>
                {eur.format(rawStone!)} + {eur.format(rawShipping)} shipping
              </div>
            )}
          </div>
        )}
      </div>

      {order.tracking_number && (
        <p style={{
          fontSize: 12, color: '#9d9080', marginBottom: 10,
          fontFamily: 'var(--font-inter, system-ui)',
        }}>
          Tracking:{' '}
          <span style={{ fontFamily: 'monospace', color: '#f5f0e8' }}>
            {order.tracking_number}
          </span>
        </p>
      )}

      {order.status === 'confirmed' && (
        <p style={{
          fontSize: 12, color: '#9d9080', fontStyle: 'italic',
          fontFamily: 'var(--font-inter, system-ui)',
        }}>
          Awaiting shipment
        </p>
      )}
      {order.status === 'shipped' && (
        <MarkReceivedButton orderId={order.id} />
      )}
      {order.status === 'received' && (
        <p style={{
          fontSize: 12, fontWeight: 600, color: '#2dd4bf',
          fontFamily: 'var(--font-inter, system-ui)',
        }}>
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
  void groupId
  const status        = groupStatus(orders)
  const color         = STATUS_COLOR[status] ?? '#9d9080'
  const combinedTotal = orders.reduce((sum, o) => sum + Number(o.order_total ?? 0), 0)
  const date          = orders[0].order_date
  const allSameStatus = orders.every(o => o.status === status)

  return (
    <div style={{
      background: '#16161a', border: '1px solid #2a2a30',
      borderRadius: 10, padding: '20px 24px',
    }}>
      {/* Group header */}
      <div style={{
        display: 'flex', alignItems: 'center',
        justifyContent: 'space-between', marginBottom: 16,
      }}>
        <span style={{
          fontSize: 14, fontWeight: 300, color: '#f5f0e8',
          fontFamily: 'var(--font-cormorant, Georgia, serif)',
        }}>
          Order placed {formatDate(date)}&nbsp;&middot;&nbsp;{orders.length}{' '}
          {orders.length === 1 ? 'item' : 'items'}
        </span>
        <span style={{
          fontSize: 10, fontWeight: 700, letterSpacing: '0.06em',
          color, border: `1px solid ${color}33`, borderRadius: 5,
          padding: '3px 10px', background: `${color}1a`,
          fontFamily: 'var(--font-inter, system-ui)',
        }}>
          {statusLabel(status)}
        </span>
      </div>

      {/* Per-order stone rows */}
      <div style={{ borderTop: '1px solid #2a2a30' }}>
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
          const rowColor     = STATUS_COLOR[o.status] ?? '#9d9080'

          return (
            <div key={o.id} style={{
              display: 'flex', gap: 14, alignItems: 'flex-start',
              padding: '12px 0', borderBottom: '1px solid #2a2a30',
            }}>
              <StoneThumb stone={stone} fallbackInitial={displayTitle} size={60} />

              <div style={{ flex: 1, minWidth: 0 }}>
                <p style={{
                  fontSize: 15, fontWeight: 300, color: '#f5f0e8',
                  marginBottom: subtitle ? 3 : 4, lineHeight: 1.3,
                  fontFamily: 'var(--font-cormorant, Georgia, serif)',
                }}>
                  {displayTitle}
                </p>
                {subtitle && (
                  <p style={{
                    fontSize: 12, color: '#9d9080', marginBottom: 4,
                    fontFamily: 'var(--font-inter, system-ui)',
                  }}>
                    {subtitle}
                  </p>
                )}
                <div style={{ display: 'flex', alignItems: 'center', gap: 8 }}>
                  <span style={{
                    fontSize: 10, color: '#4a4440', fontFamily: 'monospace',
                  }}>
                    {o.order_number}
                  </span>
                  {!allSameStatus && o.status !== status && (
                    <span style={{
                      fontSize: 9, fontWeight: 700, letterSpacing: '0.05em',
                      color: rowColor, border: `1px solid ${rowColor}33`,
                      borderRadius: 4, padding: '1px 5px', background: `${rowColor}1a`,
                      fontFamily: 'var(--font-inter, system-ui)',
                    }}>
                      {statusLabel(o.status)}
                    </span>
                  )}
                </div>
                {o.tracking_number && (
                  <p style={{
                    fontSize: 11, color: '#9d9080', marginTop: 3,
                    fontFamily: 'var(--font-inter, system-ui)',
                  }}>
                    Tracking:{' '}
                    <span style={{ fontFamily: 'monospace', color: '#f5f0e8' }}>
                      {o.tracking_number}
                    </span>
                  </p>
                )}
                {o.status === 'shipped' && (
                  <div style={{ marginTop: 6 }}>
                    <MarkReceivedButton orderId={o.id} />
                  </div>
                )}
                {o.status === 'received' && (
                  <p style={{
                    fontSize: 12, fontWeight: 600, color: '#2dd4bf', marginTop: 4,
                    fontFamily: 'var(--font-inter, system-ui)',
                  }}>
                    ✓ Received
                  </p>
                )}
              </div>

              {oTotal != null && (
                <span style={{
                  fontSize: 14, fontWeight: 400, color: '#f5f0e8',
                  flexShrink: 0, paddingTop: 2,
                  fontFamily: 'var(--font-cormorant, Georgia, serif)',
                }}>
                  {eur.format(oTotal)}
                </span>
              )}
            </div>
          )
        })}
      </div>

      {/* Combined total footer */}
      <div style={{
        display: 'flex', justifyContent: 'space-between', alignItems: 'baseline',
        fontSize: 12, color: '#9d9080', marginTop: 12,
        fontFamily: 'var(--font-inter, system-ui)',
      }}>
        <span>{formatDate(date)}</span>
        <span style={{
          fontWeight: 600, color: '#f5f0e8', fontSize: 14,
          fontFamily: 'var(--font-cormorant, Georgia, serif)',
        }}>
          Total {eur.format(combinedTotal)}
        </span>
      </div>

      {allSameStatus && status === 'confirmed' && (
        <p style={{
          fontSize: 12, color: '#9d9080', fontStyle: 'italic', marginTop: 10,
          fontFamily: 'var(--font-inter, system-ui)',
        }}>
          Awaiting shipment
        </p>
      )}
      {allSameStatus && status === 'received' && (
        <p style={{
          fontSize: 12, fontWeight: 600, color: '#2dd4bf', marginTop: 10,
          fontFamily: 'var(--font-inter, system-ui)',
        }}>
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

  const { data } = await supabase
    .from('orders')
    .select(`
      id, order_number, status, order_date, order_total, shipping_cost,
      tracking_number, shipped_at, received_at, checkout_group_id,
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
    <main style={{ maxWidth: 720, margin: '0 auto', padding: '40px 24px 80px' }}>
      <h1 style={{
        fontSize: 28, fontWeight: 300, color: '#f5f0e8', marginBottom: 6,
        fontFamily: 'var(--font-cormorant, Georgia, serif)',
      }}>
        My Orders
      </h1>
      <p style={{
        fontSize: 13, color: '#9d9080', marginBottom: 32,
        fontFamily: 'var(--font-inter, system-ui)',
      }}>
        Your purchase history from GemWorkers.
      </p>

      {entries.length === 0 ? (
        <div style={{ textAlign: 'center', padding: '80px 0' }}>
          <div style={{
            fontSize: 44, color: '#2a2a30', marginBottom: 14, lineHeight: 1,
            fontFamily: 'var(--font-cormorant, Georgia, serif)',
          }}>◇</div>
          <p style={{
            fontSize: 14, color: '#9d9080', marginBottom: 28,
            fontFamily: 'var(--font-inter, system-ui)',
          }}>
            You have no orders yet.
          </p>
          <Link href="/" style={{
            display: 'inline-block', padding: '11px 28px',
            border: '1px solid rgba(201,169,98,0.5)', color: '#c9a962',
            borderRadius: 6, textDecoration: 'none', fontSize: 12,
            fontWeight: 600, letterSpacing: '0.1em',
            fontFamily: 'var(--font-inter, system-ui)',
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
  )
}
