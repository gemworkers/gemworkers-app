import { createClient } from '@/lib/supabase/server'
import Link from 'next/link'
import { StoreHeader } from '@/app/components/StoreHeader'
import { BuyButton } from '@/app/stones/[id]/BuyButton'
import { RemoveButton } from './RemoveButton'

// ── Types ─────────────────────────────────────────────────────────────────────

// Columns from public_listings — only display fields, never internal ones.
type CartListing = {
  id: string
  title: string
  selling_price: number | null
  sale_method: string
  image_url: string | null
  gem_type: string | null
  variety: string | null
  seller_name: string | null
}

// ── Helpers ───────────────────────────────────────────────────────────────────

const eur = new Intl.NumberFormat('en-IE', {
  style: 'currency',
  currency: 'EUR',
  maximumFractionDigits: 0,
})

// ── Sub-components ────────────────────────────────────────────────────────────

function PageShell({ children }: { children: React.ReactNode }) {
  return (
    <>
      <style>{`
        body { background: #fafaf9; font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Helvetica, Arial, sans-serif; }
      `}</style>
      <StoreHeader />
      <main style={{ maxWidth: 780, margin: '0 auto', padding: '40px 32px 80px' }}>
        {children}
      </main>
    </>
  )
}

function PageTitle({ count }: { count: number }) {
  return (
    <div style={{ marginBottom: 32 }}>
      <h1 style={{
        fontSize: 24, fontWeight: 700, color: '#111',
        fontFamily: "Georgia, 'Times New Roman', serif",
        marginBottom: 4,
      }}>
        Cart
      </h1>
      <p style={{ fontSize: 13, color: '#9ca3af' }}>
        {count} {count === 1 ? 'item' : 'items'}
      </p>
    </div>
  )
}

// ── Page ──────────────────────────────────────────────────────────────────────

export default async function CartPage() {
  const supabase = await createClient()
  const { data: { user } } = await supabase.auth.getUser()

  // ── Logged-out ──────────────────────────────────────────────────────────────
  if (!user) {
    return (
      <PageShell>
        <div style={{ textAlign: 'center', padding: '80px 0' }}>
          <div style={{ fontSize: 40, color: '#d1d5db', marginBottom: 16, lineHeight: 1 }}>◇</div>
          <p style={{ fontSize: 16, fontWeight: 600, color: '#374151', marginBottom: 8 }}>
            Log in to view your cart
          </p>
          <p style={{ fontSize: 14, color: '#9ca3af', marginBottom: 28 }}>
            Save stones while you browse, then buy when you&apos;re ready.
          </p>
          <Link href="/auth/login" style={{
            display: 'inline-block', padding: '10px 24px',
            background: '#111', color: '#fff', borderRadius: 6,
            textDecoration: 'none', fontSize: 14, fontWeight: 600, letterSpacing: '0.02em',
          }}>
            Log in
          </Link>
        </div>
      </PageShell>
    )
  }

  // ── Fetch cart rows ─────────────────────────────────────────────────────────
  const { data: cartRows } = await supabase
    .from('storefront_cart')
    .select('inventory_item_id, added_at')
    .order('added_at', { ascending: true })

  // ── Empty cart ──────────────────────────────────────────────────────────────
  if (!cartRows || cartRows.length === 0) {
    return (
      <PageShell>
        <PageTitle count={0} />
        <div style={{ textAlign: 'center', padding: '60px 0' }}>
          <div style={{ fontSize: 40, color: '#d1d5db', marginBottom: 16, lineHeight: 1 }}>◇</div>
          <p style={{ fontSize: 15, color: '#9ca3af', marginBottom: 24 }}>
            Your cart is empty.
          </p>
          <Link href="/" style={{
            display: 'inline-block', padding: '10px 24px',
            background: '#111', color: '#fff', borderRadius: 6,
            textDecoration: 'none', fontSize: 14, fontWeight: 600, letterSpacing: '0.02em',
          }}>
            Browse stones
          </Link>
        </div>
      </PageShell>
    )
  }

  // ── Fetch public listing data for cart items ────────────────────────────────
  // Only reads from the public view — no internal tables.
  // Items filtered out by the view's WHERE clause (sold, unlisted, suspended seller)
  // will be absent from `listings` → shown as "No longer available".
  const itemIds = cartRows.map(r => r.inventory_item_id)
  const { data: listings } = await supabase
    .from('public_listings')
    .select('id, title, selling_price, sale_method, image_url, gem_type, variety, seller_name')
    .in('id', itemIds)

  const listingMap = new Map<string, CartListing>(
    (listings ?? []).map(l => [l.id, l as CartListing])
  )

  const cartItems = cartRows.map(row => ({
    itemId: row.inventory_item_id,
    listing: listingMap.get(row.inventory_item_id) ?? null,
  }))

  return (
    <PageShell>
      <PageTitle count={cartItems.length} />

      <div>
        {cartItems.map(({ itemId, listing }) =>
          listing ? (
            <AvailableItem key={itemId} itemId={itemId} listing={listing} />
          ) : (
            <UnavailableItem key={itemId} itemId={itemId} />
          )
        )}
      </div>
    </PageShell>
  )
}

// ── Available item card ───────────────────────────────────────────────────────

function AvailableItem({ itemId, listing }: { itemId: string; listing: CartListing }) {
  const subtitle = [listing.variety, listing.gem_type]
    .filter(Boolean)
    .join(' · ') || null

  return (
    <div style={{
      display: 'flex', gap: 20, padding: '24px 0',
      borderBottom: '1px solid #f3f4f6',
      alignItems: 'flex-start',
    }}>
      {/* Cover photo */}
      <Link href={`/stones/${itemId}`} style={{ flexShrink: 0, display: 'block' }}>
        {listing.image_url ? (
          // eslint-disable-next-line @next/next/no-img-element
          <img
            src={listing.image_url}
            alt={listing.title}
            style={{
              width: 104, height: 104, objectFit: 'cover',
              borderRadius: 8, display: 'block',
              border: '1px solid #f3f4f6',
            }}
          />
        ) : (
          <div style={{
            width: 104, height: 104, borderRadius: 8,
            background: 'linear-gradient(145deg, #f6f3ef 0%, #ece8e2 100%)',
            display: 'flex', alignItems: 'center', justifyContent: 'center',
            border: '1px solid #f3f4f6',
          }}>
            <span style={{
              fontSize: 36, color: '#c4b8ab', fontWeight: 300,
              fontFamily: "Georgia, 'Times New Roman', serif", lineHeight: 1,
              userSelect: 'none',
            }}>
              {listing.gem_type?.charAt(0).toUpperCase() ?? '◇'}
            </span>
          </div>
        )}
      </Link>

      {/* Info */}
      <div style={{ flex: 1, minWidth: 0 }}>
        <Link href={`/stones/${itemId}`} style={{ textDecoration: 'none' }}>
          <p style={{
            fontSize: 15, fontWeight: 600, color: '#111',
            lineHeight: 1.35, marginBottom: subtitle ? 4 : 8,
          }}>
            {listing.title}
          </p>
        </Link>
        {subtitle && (
          <p style={{ fontSize: 12, color: '#9ca3af', marginBottom: 8 }}>
            {subtitle}
          </p>
        )}
        <p style={{ fontSize: 22, fontWeight: 700, color: '#111', marginBottom: 16, letterSpacing: '-0.01em' }}>
          {listing.sale_method === 'accept_offers'
            ? <span style={{ fontSize: 14, fontWeight: 400, color: '#9ca3af' }}>Accepting offers</span>
            : listing.selling_price != null
              ? eur.format(listing.selling_price)
              : <span style={{ fontSize: 14, fontWeight: 400, color: '#d1d5db' }}>Price on request</span>
          }
        </p>

        {/* Actions */}
        <div style={{ display: 'flex', gap: 10, alignItems: 'flex-start' }}>
          {/* BuyButton: shown for buy_now and both; hidden for accept_offers */}
          {listing.sale_method !== 'accept_offers' && (
            <div style={{ flex: 1 }}>
              <BuyButton
                itemId={itemId}
                itemTitle={listing.title}
                sellingPrice={listing.selling_price}
                isLoggedIn={true}
              />
            </div>
          )}
          <RemoveButton itemId={itemId} />
        </div>
      </div>
    </div>
  )
}

// ── Unavailable item card ─────────────────────────────────────────────────────

function UnavailableItem({ itemId }: { itemId: string }) {
  return (
    <div style={{
      display: 'flex', gap: 20, padding: '24px 0',
      borderBottom: '1px solid #f3f4f6',
      alignItems: 'center',
    }}>
      {/* Placeholder */}
      <div style={{
        flexShrink: 0, width: 104, height: 104, borderRadius: 8,
        background: '#f9fafb',
        display: 'flex', alignItems: 'center', justifyContent: 'center',
        border: '1px solid #f3f4f6',
      }}>
        <span style={{ fontSize: 32, color: '#e5e7eb', lineHeight: 1 }}>◇</span>
      </div>

      {/* Info */}
      <div style={{ flex: 1 }}>
        <p style={{ fontSize: 14, color: '#9ca3af', marginBottom: 12 }}>
          This item is no longer available
        </p>
        <RemoveButton itemId={itemId} />
      </div>
    </div>
  )
}
