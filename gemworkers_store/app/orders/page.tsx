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
  tracking_number: string | null;
  shipped_at: string | null;
  received_at: string | null;
  order_items: {
    inventory_items: { title: string } | null;
  }[];
};

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

// ── Page ──────────────────────────────────────────────────────────────────────

export default async function BuyerOrdersPage() {
  const supabase = await createClient()
  const { data: { user } } = await supabase.auth.getUser()
  if (!user) redirect('/auth/login')

  // orders_buyer_select RLS scopes this to buyer_id = auth.uid() automatically.
  // We read only public-safe columns — never cost_price or seller internals.
  const { data } = await supabase
    .from('orders')
    .select(`
      id, order_number, status, order_date, order_total,
      tracking_number, shipped_at, received_at,
      order_items (
        inventory_items ( title )
      )
    `)
    .order('created_at', { ascending: false })

  const orders = (data ?? []) as BuyerOrder[]

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

        {orders.length === 0 ? (
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
            {orders.map(order => {
              const color = STATUS_COLOR[order.status] ?? '#9ca3af'
              const titles = order.order_items
                .map(oi => oi.inventory_items?.title)
                .filter(Boolean)
                .join(', ')

              return (
                <div key={order.id} style={{
                  background: '#fff',
                  border: '1px solid #e5e7eb',
                  borderRadius: 10,
                  padding: '20px 24px',
                }}>
                  {/* ── Order header ── */}
                  <div style={{
                    display: 'flex', alignItems: 'center',
                    justifyContent: 'space-between', marginBottom: 12,
                  }}>
                    <span style={{ fontSize: 14, fontWeight: 700, color: '#111' }}>
                      {order.order_number || '—'}
                    </span>
                    <span style={{
                      fontSize: 11, fontWeight: 700, letterSpacing: '0.05em',
                      color,
                      border: `1px solid ${color}`,
                      borderRadius: 6,
                      padding: '3px 10px',
                      background: `${color}1a`,
                    }}>
                      {statusLabel(order.status)}
                    </span>
                  </div>

                  {/* ── Item title(s) ── */}
                  {titles && (
                    <p style={{ fontSize: 13, color: '#374151', marginBottom: 10 }}>
                      {titles}
                    </p>
                  )}

                  {/* ── Date + total ── */}
                  <div style={{
                    display: 'flex', gap: 20,
                    fontSize: 12, color: '#9ca3af', marginBottom: 12,
                  }}>
                    <span>{formatDate(order.order_date)}</span>
                    {order.order_total != null && (
                      <span style={{ fontWeight: 600, color: '#374151' }}>
                        {eur.format(Number(order.order_total))}
                      </span>
                    )}
                  </div>

                  {/* ── Tracking number ── */}
                  {order.tracking_number && (
                    <p style={{ fontSize: 12, color: '#6b7280', marginBottom: 12 }}>
                      {'Tracking: '}
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
            })}
          </div>
        )}
      </main>
    </>
  )
}
