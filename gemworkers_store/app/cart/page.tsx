import { createClient } from '@/lib/supabase/server'
import Link from 'next/link'
import { BuyButton } from '@/app/stones/[id]/BuyButton'
import { RemoveButton } from './RemoveButton'
import { BuyAllButton } from './BuyAllButton'
import { TrustList } from '@/app/components/TrustList'
import { countryName } from '@/lib/countries'
import { pillDark, pillOutline } from '@/lib/ui'

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

function isBuyable(listing: CartListing | null): listing is CartListing {
  return listing !== null &&
    listing.sale_method !== 'accept_offers' &&
    listing.selling_price !== null
}

// ── Sub-components ────────────────────────────────────────────────────────────

function PageShell({ children }: { children: React.ReactNode }) {
  return (
    <main className="pd-wrap browse-main">
      <nav aria-label="Breadcrumb" className="pd-crumbs">
        <Link href="/">Home</Link>
        <span aria-hidden="true">/</span>
        <span aria-current="page">Cart</span>
      </nav>
      {children}
    </main>
  )
}

function PageTitle({ count }: { count: number }) {
  return (
    <>
      <h1 className="font-serif browse-title">Cart</h1>
      <p className="browse-count">{count} {count === 1 ? 'item' : 'items'}</p>
    </>
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
        <h1 className="font-serif browse-title">Cart</h1>
        <div className="browse-empty">
          <p>Log in to view your cart. Save stones while you browse, then buy when you&apos;re ready.</p>
          <Link href="/auth/login?next=%2Fcart" style={{ ...pillDark, display: 'inline-flex', width: 'auto', marginTop: 12 }}>
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
        <div className="browse-empty">
          <p>Your cart is empty.</p>
          <Link href="/shop/loose_stone" style={{ ...pillOutline, display: 'inline-flex', width: 'auto', marginTop: 12 }}>
            Browse loose gemstones
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

  const buyableCount = cartItems.filter(({ listing }) => isBuyable(listing)).length

  const grandTotal = cartItems.reduce((sum, { listing }) => {
    if (!isBuyable(listing)) return sum
    return sum + Number(listing.selling_price) + Number(listing.shipping_cost ?? 0)
  }, 0)

  // Display-only split of grandTotal for the summary box
  const shippingTotal = cartItems.reduce((sum, { listing }) => {
    if (!isBuyable(listing)) return sum
    return sum + Number(listing.shipping_cost ?? 0)
  }, 0)
  const subtotal = grandTotal - shippingTotal

  return (
    <PageShell>
      <PageTitle count={cartItems.length} />

      <div className="cart-grid">
        <div className="cart-list">
          {cartItems.map(({ itemId, listing }) =>
            listing ? (
              <AvailableItem key={itemId} itemId={itemId} listing={listing} />
            ) : (
              <UnavailableItem key={itemId} itemId={itemId} />
            )
          )}
        </div>

        <aside className="cart-aside">
          {buyableCount > 0 && (
            <div className="cart-summary">
              <h2 className="font-serif" style={{ fontSize: 26, fontWeight: 500, marginBottom: 16 }}>
                Summary
              </h2>
              <div className="cart-sum-row">
                <span>Subtotal</span>
                <span>{eurDecimal.format(subtotal)}</span>
              </div>
              <div className="cart-sum-row">
                <span>Shipping</span>
                <span>{shippingTotal === 0 ? 'Free' : eurDecimal.format(shippingTotal)}</span>
              </div>
              <div className="cart-sum-row cart-sum-total">
                <span>Total</span>
                <span>{eurDecimal.format(grandTotal)}</span>
              </div>
              {buyableCount < cartItems.length && (
                <p style={{ fontSize: 13, color: '#6B6052', marginBottom: 16, lineHeight: 1.5 }}>
                  For the {buyableCount} available {buyableCount === 1 ? 'item' : 'items'} with a fixed price.
                </p>
              )}
              <BuyAllButton />
            </div>
          )}
          <TrustList style={{ marginTop: buyableCount > 0 ? 24 : 0, borderTop: 'none', paddingTop: 0 }} />
        </aside>
      </div>
    </PageShell>
  )
}

// ── Available item row ────────────────────────────────────────────────────────

function AvailableItem({ itemId, listing }: { itemId: string; listing: CartListing }) {
  const subtitle = [listing.variety, listing.gem_type]
    .filter(Boolean)
    .join(' · ') || null
  const cost = listing.shipping_cost == null ? null : Number(listing.shipping_cost)
  const shipFrom = countryName(listing.seller_country)

  return (
    <div className="cart-row">
      {/* Cover photo */}
      <Link href={`/stones/${itemId}`} className="cart-thumb">
        {listing.image_url && (
          // eslint-disable-next-line @next/next/no-img-element
          <img src={listing.image_url} alt={listing.title} />
        )}
      </Link>

      {/* Info */}
      <div className="cart-info">
        <div className="cart-info-top">
          <div style={{ minWidth: 0 }}>
            <Link href={`/stones/${itemId}`} className="cart-name">{listing.title}</Link>
            {subtitle && <p className="cart-sub">{subtitle}</p>}
            {shipFrom && <p className="cart-sub">Ships from {shipFrom}</p>}
          </div>
          <div className="cart-price">
            {listing.sale_method === 'accept_offers'
              ? <span style={{ fontSize: 14, fontWeight: 500, color: '#7A5A22' }}>Accepting offers</span>
              : listing.selling_price != null
                ? eur.format(listing.selling_price)
                : <span style={{ fontSize: 14, fontWeight: 400, color: '#6B6052' }}>Price on request</span>
            }
            {cost !== null && listing.selling_price != null && listing.sale_method !== 'accept_offers' && (
              <span className="cart-sub" style={{ display: 'block', fontWeight: 400 }}>
                {cost === 0 ? 'Free shipping' : `+ ${eur.format(cost)} shipping`}
              </span>
            )}
          </div>
        </div>

        {/* Actions */}
        <div className="cart-actions">
          {listing.sale_method !== 'accept_offers' && (
            <div className="cart-buy">
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

// ── Unavailable item row ──────────────────────────────────────────────────────

function UnavailableItem({ itemId }: { itemId: string }) {
  return (
    <div className="cart-row">
      <div className="cart-thumb" aria-hidden="true" />
      <div className="cart-info">
        <p className="cart-sub" style={{ fontSize: 15, marginBottom: 8 }}>
          This item is no longer available
        </p>
        <RemoveButton itemId={itemId} />
      </div>
    </div>
  )
}
