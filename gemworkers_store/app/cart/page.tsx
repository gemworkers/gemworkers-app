import { createClient } from '@/lib/supabase/server'
import Link from 'next/link'
import { BuyButton } from '@/app/stones/[id]/BuyButton'
import { RemoveButton } from './RemoveButton'
import { BuyAllButton } from './BuyAllButton'
import { TrustList } from '@/app/components/TrustList'
import { countryName } from '@/lib/countries'
import { pillDark, pillOutline } from '@/lib/ui'
import { formatEur, formatMoney } from '@/lib/money'
import { currentShipToCode } from '@/lib/ship-to'
import { priceContext } from '@/lib/display-price'
import { shownPrice, approxPrice, priceText, localPrice, type PriceContext, type FxContext } from '@/lib/price-shown'
import { fxContext } from '@/lib/fx'
import { taxQuote, taxNote, paidTotal, ratePercent, type TaxQuote } from '@/lib/tax'

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

  // ── Tax for the buyer's "Ship to" country (same calculation as checkout) ──
  const shipToCode = await currentShipToCode()
  const { data: shipToData } = await supabase
    .from('shipping_countries').select('name, enabled').eq('code', shipToCode).maybeSingle()
  const shipTo = shipToData as { name: string; enabled: boolean } | null
  const buyableIds = cartItems.filter(({ listing }) => isBuyable(listing)).map(({ itemId }) => itemId)
  const quoteList = shipTo?.enabled
    ? await Promise.all(buyableIds.map(id => taxQuote(supabase, id, shipToCode)))
    : []
  const quoteMap = new Map<string, TaxQuote>()
  quoteList.forEach((q, i) => { if (q) quoteMap.set(buyableIds[i], q) })
  const quotes = [...quoteMap.values()]
  const pctx = shipTo?.enabled ? await priceContext() : null
  const fx = await fxContext()
  const vatTotal = quotes.reduce((sum, q) => paidTotal(sum, q.taxAmount), 0)
  const vatRates = [...new Set(quotes.filter(q => q.taxAmount > 0 && q.taxRate != null).map(q => ratePercent(q.taxRate!)))]
  const payTotal = paidTotal(grandTotal, vatTotal)
  // US / UK / AU / CA: each stone and its shipping in the buyer's currency,
  // rounded like checkout charges them (sql/local_currency.sql).
  const cur = fx?.exact ? fx.code : 'EUR'
  const local = (eur: number) => (fx?.exact ? localPrice(eur, fx.rate) : eur)
  const buyable = cartItems.flatMap(({ listing }) => (isBuyable(listing) ? [listing] : []))
  const subShown = fx?.exact ? buyable.reduce((s, l) => s + local(Number(l.selling_price)), 0) : subtotal
  const shipShown = fx?.exact ? buyable.reduce((s, l) => s + local(Number(l.shipping_cost ?? 0)), 0) : shippingTotal
  const totalShown = fx?.exact ? subShown + shipShown : payTotal
  // Under-minimum warning first (e.g. UK), else one import reminder if any stone needs it.
  const cartTaxNote =
    quotes.map(q => taxNote(q, shipTo?.name ?? shipToCode, true, fx)).find(n => n?.warn) ??
    taxNote(quotes.find(q => q.scheme === 'buyer_pays') ?? null, shipTo?.name ?? shipToCode, false, fx)

  return (
    <PageShell>
      <PageTitle count={cartItems.length} />

      <div className="cart-grid">
        <div className="cart-list">
          {cartItems.map(({ itemId, listing }) =>
            listing ? (
              <AvailableItem key={itemId} itemId={itemId} listing={listing} quote={quoteMap.get(itemId) ?? null} pctx={pctx} fx={fx} />
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
                <span>Subtotal{vatTotal > 0 ? ' (excl. VAT)' : ''}</span>
                <span>{formatMoney(subShown, cur)}</span>
              </div>
              <div className="cart-sum-row">
                <span>Shipping</span>
                <span>{shipShown === 0 ? 'Free' : formatMoney(shipShown, cur)}</span>
              </div>
              {vatTotal > 0 && (
                <div className="cart-sum-row">
                  <span>VAT{vatRates.length === 1 ? ` ${vatRates[0]}%` : ''} ({shipTo?.name})</span>
                  <span>{formatEur(vatTotal)}</span>
                </div>
              )}
              <div className="cart-sum-row cart-sum-total">
                <span>Total</span>
                <span>{formatMoney(totalShown, cur)}</span>
              </div>
              {approxPrice(payTotal, fx) && (
                <p style={{ fontSize: 13, color: '#6B6052', margin: '-4px 0 12px', textAlign: 'right' }}>
                  {approxPrice(payTotal, fx)} · you pay in euros
                </p>
              )}
              {shipTo?.enabled && (
                <p style={{ fontSize: 13, marginBottom: 12 }}>
                  <Link href="/business" className="pd-link">Buying for a business? Add your VAT number</Link>
                </p>
              )}
              {cartTaxNote && (
                <p style={{ fontSize: 13, color: cartTaxNote.warn ? '#B42318' : '#6B6052', marginBottom: 16, lineHeight: 1.5 }}>
                  {cartTaxNote.text}
                </p>
              )}
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

function AvailableItem({ itemId, listing, quote, pctx, fx }: { itemId: string; listing: CartListing; quote: TaxQuote | null; pctx: PriceContext | null; fx: FxContext | null }) {
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
                ? <>
                    {priceText(shownPrice(Number(listing.selling_price), listing.seller_country, pctx).amount, fx)}
                    {shownPrice(0, listing.seller_country, pctx).inclVat && (
                      <span style={{ fontSize: 12, fontWeight: 400, color: '#6B6052' }}> incl. VAT</span>
                    )}
                  </>
                : <span style={{ fontSize: 14, fontWeight: 400, color: '#6B6052' }}>Price on request</span>
            }
            {cost !== null && listing.selling_price != null && listing.sale_method !== 'accept_offers' && (
              <span className="cart-sub" style={{ display: 'block', fontWeight: 400 }}>
                {cost === 0 ? 'Free shipping' : `+ ${priceText(shownPrice(cost, listing.seller_country, pctx).amount, fx)} shipping`}
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
                vatAmount={quote?.taxAmount ?? 0}
                vatLabel={quote?.taxRate != null ? `${quote.taxName || 'VAT'} ${ratePercent(quote.taxRate)}%` : 'VAT'}
                isLoggedIn={true}
                fx={fx}
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
