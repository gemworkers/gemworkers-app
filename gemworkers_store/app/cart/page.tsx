import { createClient } from '@/lib/supabase/server'
import Link from 'next/link'
import { BuyButton } from '@/app/stones/[id]/BuyButton'
import { RemoveButton } from './RemoveButton'
import { BuyAllButton } from './BuyAllButton'
import { countryName } from '@/lib/countries'

// ── Types ─────────────────────────────────────────────────────────────────────

type CartListing = {
  id: string
  title: string
  selling_price: number | null
  sale_method: string
  image_url: string | null
  gem_type: string | null
  variety: string | null
  seller_country: string | null
  shipping_cost: number | null
}

// ── Helpers ───────────────────────────────────────────────────────────────────

const eur = new Intl.NumberFormat('en-IE', {
  style: 'currency',
  currency: 'EUR',
  maximumFractionDigits: 0,
})

const eurDecimal = new Intl.NumberFormat('en-IE', {
  style: 'currency',
  currency: 'EUR',
  minimumFractionDigits: 2,
  maximumFractionDigits: 2,
})

// ── Sub-components ────────────────────────────────────────────────────────────

function PageShell({ children }: { children: React.ReactNode }) {
  return (
    <main style={{ maxWidth: 780, margin: '0 auto', padding: '40px 32px 80px' }}>
      {children}
    </main>
  )
}

function PageTitle({ count }: { count: number }) {
  return (
    <div style={{ marginBottom: 32 }}>
      <h1 style={{
        fontSize: 28, fontWeight: 300, color: '#f5f0e8',
        fontFamily: 'var(--font-cormorant, Georgia, serif)',
        marginBottom: 4,
      }}>
        Cart
      </h1>
      <p style={{
        fontSize: 12, color: '#9d9080',
        fontFamily: 'var(--font-inter, system-ui)',
      }}>
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
          <div style={{
            fontSize: 40, color: '#2a2a30', marginBottom: 16, lineHeight: 1,
            fontFamily: 'var(--font-cormorant, Georgia, serif)',
          }}>◇</div>
          <p style={{
            fontSize: 18, fontWeight: 300, color: '#f5f0e8', marginBottom: 8,
            fontFamily: 'var(--font-cormorant, Georgia, serif)',
          }}>
            Log in to view your cart
          </p>
          <p style={{
            fontSize: 13, color: '#9d9080', marginBottom: 28,
            fontFamily: 'var(--font-inter, system-ui)',
          }}>
            Save stones while you browse, then buy when you&apos;re ready.
          </p>
          <Link href="/auth/login" style={{
            display: 'inline-block', padding: '11px 28px',
            border: '1px solid rgba(201,169,98,0.5)', color: '#c9a962',
            borderRadius: 6, textDecoration: 'none', fontSize: 12,
            fontWeight: 600, letterSpacing: '0.1em',
            fontFamily: 'var(--font-inter, system-ui)',
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
          <div style={{
            fontSize: 40, color: '#2a2a30', marginBottom: 16, lineHeight: 1,
            fontFamily: 'var(--font-cormorant, Georgia, serif)',
          }}>◇</div>
          <p style={{
            fontSize: 14, color: '#9d9080', marginBottom: 24,
            fontFamily: 'var(--font-inter, system-ui)',
          }}>
            Your cart is empty.
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
      </PageShell>
    )
  }

  // ── Fetch public listing data ───────────────────────────────────────────────
  const itemIds = cartRows.map(r => r.inventory_item_id)
  const { data: listings } = await supabase
    .from('public_listings')
    .select('id, title, selling_price, sale_method, image_url, gem_type, variety, seller_country, shipping_cost')
    .in('id', itemIds)

  const listingMap = new Map<string, CartListing>(
    (listings ?? []).map(l => [l.id, l as CartListing])
  )

  const cartItems = cartRows.map(row => ({
    itemId: row.inventory_item_id,
    listing: listingMap.get(row.inventory_item_id) ?? null,
  }))

  const buyableCount = cartItems.filter(({ listing }) =>
    listing !== null &&
    listing.sale_method !== 'accept_offers' &&
    listing.selling_price !== null
  ).length

  const grandTotal = cartItems.reduce((sum, { listing }) => {
    if (
      listing === null ||
      listing.sale_method === 'accept_offers' ||
      listing.selling_price === null
    ) return sum
    return sum + Number(listing.selling_price) + Number(listing.shipping_cost ?? 0)
  }, 0)

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

      {buyableCount > 0 && (
        <div style={{ marginTop: 40, paddingTop: 32, borderTop: '1px solid #2a2a30' }}>
          <div style={{
            display: 'flex', justifyContent: 'space-between',
            fontSize: 13, fontWeight: 600, color: '#f5f0e8',
            marginBottom: 16,
            fontFamily: 'var(--font-inter, system-ui)',
          }}>
            <span>Total for all available items</span>
            <span>{eurDecimal.format(grandTotal)}</span>
          </div>
          <BuyAllButton />
        </div>
      )}
    </PageShell>
  )
}

// ── Available item card ───────────────────────────────────────────────────────

function AvailableItem({ itemId, listing }: { itemId: string; listing: CartListing }) {
  const subtitle = [listing.variety, listing.gem_type]
    .filter(Boolean)
    .join(' · ') || null
  const cost = listing.shipping_cost == null ? null : Number(listing.shipping_cost)
  const shipFrom = countryName(listing.seller_country)

  return (
    <div style={{
      display: 'flex', gap: 20, padding: '24px 0',
      borderBottom: '1px solid #2a2a30',
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
              border: '1px solid #2a2a30',
            }}
          />
        ) : (
          <div style={{
            width: 104, height: 104, borderRadius: 8,
            background: 'linear-gradient(145deg, #1e1e24 0%, #252530 100%)',
            display: 'flex', alignItems: 'center', justifyContent: 'center',
            border: '1px solid #2a2a30',
          }}>
            <span style={{
              fontSize: 36, color: '#3a3530', fontWeight: 300,
              fontFamily: 'var(--font-cormorant, Georgia, serif)', lineHeight: 1,
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
            fontSize: 16, fontWeight: 300, color: '#f5f0e8',
            lineHeight: 1.3, marginBottom: subtitle ? 4 : 8,
            fontFamily: 'var(--font-cormorant, Georgia, serif)',
          }}>
            {listing.title}
          </p>
        </Link>
        {subtitle && (
          <p style={{
            fontSize: 12, color: '#9d9080',
            marginBottom: shipFrom ? 3 : 8,
            fontFamily: 'var(--font-inter, system-ui)',
          }}>
            {subtitle}
          </p>
        )}
        {shipFrom && (
          <p style={{
            fontSize: 12, color: '#9d9080', marginBottom: 8,
            fontFamily: 'var(--font-inter, system-ui)',
          }}>
            Ships from {shipFrom}
          </p>
        )}
        <p style={{
          fontSize: 24, fontWeight: 400, color: '#f5f0e8',
          marginBottom: 16, letterSpacing: '-0.01em',
          fontFamily: 'var(--font-cormorant, Georgia, serif)',
        }}>
          {listing.sale_method === 'accept_offers'
            ? <span style={{ fontSize: 14, fontWeight: 300, color: '#9d9080' }}>Accepting offers</span>
            : listing.selling_price != null
              ? eur.format(listing.selling_price)
              : <span style={{ fontSize: 14, fontWeight: 300, color: '#4a4440' }}>Price on request</span>
          }
        </p>

        {/* Stone / Shipping / Total */}
        {cost !== null && cost > 0 && listing.selling_price != null && (
          <div style={{ marginBottom: 16 }}>
            <div style={{
              display: 'flex', justifyContent: 'space-between',
              fontSize: 12, color: '#9d9080', marginBottom: 3,
            }}>
              <span>Stone</span>
              <span>{eur.format(Number(listing.selling_price))}</span>
            </div>
            <div style={{
              display: 'flex', justifyContent: 'space-between',
              fontSize: 12, color: '#9d9080', marginBottom: 5,
            }}>
              <span>Shipping</span>
              <span>{eur.format(cost)}</span>
            </div>
            <div style={{ height: 1, background: '#2a2a30', marginBottom: 5 }} />
            <div style={{
              display: 'flex', justifyContent: 'space-between',
              fontSize: 13, fontWeight: 600, color: '#f5f0e8',
            }}>
              <span>Total</span>
              <span>{eur.format(Number(listing.selling_price) + cost)}</span>
            </div>
          </div>
        )}

        {/* Actions */}
        <div style={{ display: 'flex', gap: 10, alignItems: 'flex-start' }}>
          {listing.sale_method !== 'accept_offers' && (
            <div style={{ flex: 1 }}>
              <BuyButton
                itemId={itemId}
                itemTitle={listing.title}
                sellingPrice={listing.selling_price}
                shippingCost={cost}
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
      borderBottom: '1px solid #2a2a30',
      alignItems: 'center',
    }}>
      {/* Placeholder */}
      <div style={{
        flexShrink: 0, width: 104, height: 104, borderRadius: 8,
        background: '#1e1e24',
        display: 'flex', alignItems: 'center', justifyContent: 'center',
        border: '1px solid #2a2a30',
      }}>
        <span style={{
          fontSize: 32, color: '#3a3530', lineHeight: 1,
          fontFamily: 'var(--font-cormorant, Georgia, serif)',
        }}>◇</span>
      </div>

      {/* Info */}
      <div style={{ flex: 1 }}>
        <p style={{
          fontSize: 13, color: '#9d9080', marginBottom: 12,
          fontFamily: 'var(--font-inter, system-ui)',
        }}>
          This item is no longer available
        </p>
        <RemoveButton itemId={itemId} />
      </div>
    </div>
  )
}
