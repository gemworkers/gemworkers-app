import Link from 'next/link'
import { countryName } from '@/lib/countries'
import { shownPrice, approxPrice, priceText, type PriceContext, type FxContext } from '@/lib/price-shown'
import { FavouriteButton } from './FavouriteButton'

export type StoneCardItem = {
  id: string
  title: string
  gem_type: string | null
  variety: string | null
  weight_value: number | null
  weight_unit: string | null
  origin_country?: string | null
  seller_country?: string | null
  selling_price: number | null
  sale_method: string | null
  shipping_cost: number | null
  image_url: string | null
}

export function StoneCard({ item, index = 0, priceCtx = null, favouriteIds, fx = null }: {
  item: StoneCardItem; index?: number; priceCtx?: PriceContext | null; fx?: FxContext | null
  /** This buyer's saved stones; null = logged out; undefined = no heart on this page. */
  favouriteIds?: string[] | null
}) {
  const gemLabel    = item.variety?.trim() || item.gem_type?.trim() || null
  const originLabel = item.origin_country?.trim() || null
  const hasWeight   = item.weight_value != null && Number(item.weight_value) > 0
  const weightLabel = hasWeight ? `${item.weight_value} ${item.weight_unit ?? ''}`.trim() : null
  const meta        = [weightLabel, originLabel].filter(Boolean).join(' · ') || gemLabel
  const initial     = gemLabel ? gemLabel.charAt(0).toUpperCase() : ''
  const shipsFrom   = countryName(item.seller_country)
  const cost        = item.shipping_cost == null ? null : Number(item.shipping_cost)
  // EU consumers see prices incl. VAT when the stone ships from inside the EU.
  const price       = item.selling_price == null ? null : shownPrice(Number(item.selling_price), item.seller_country, priceCtx)
  const shipShown   = cost == null ? null : shownPrice(cost, item.seller_country, priceCtx).amount

  return (
    <Link
      href={`/stones/${item.id}`}
      className="stone-card fade-up"
      style={{
        '--fade-delay': `${Math.min(index * 70, 560)}ms`,
        display: 'block', textDecoration: 'none', color: 'inherit',
      } as React.CSSProperties}
    >
      {/* ── Image ── */}
      <div style={{
        position: 'relative', aspectRatio: '1 / 1', overflow: 'hidden',
        borderRadius: 18, background: '#F4EEE4',
      }}>
        {favouriteIds !== undefined && (
          <FavouriteButton itemId={item.id} initial={!!favouriteIds?.includes(item.id)} loggedIn={favouriteIds !== null} />
        )}
        {item.image_url ? (
          // eslint-disable-next-line @next/next/no-img-element
          <img
            src={item.image_url}
            alt={item.title}
            className="stone-img"
            style={{ width: '100%', height: '100%', objectFit: 'cover', display: 'block' }}
          />
        ) : (
          <div style={{
            width: '100%', height: '100%',
            display: 'flex', alignItems: 'center', justifyContent: 'center',
            background: '#E9E1D2',
          }}>
            <span style={{
              fontSize: 52, color: '#B5A892', fontWeight: 300, lineHeight: 1,
              fontFamily: 'var(--font-cormorant, Georgia, serif)', userSelect: 'none',
            }}>
              {initial}
            </span>
          </div>
        )}
      </div>

      {/* ── Body ── */}
      <div style={{ paddingTop: 14 }}>
        {meta && (
          <p style={{ fontSize: 13, color: '#6B6052', marginBottom: 4, lineHeight: 1.4 }}>
            {meta}
          </p>
        )}

        <p style={{ fontSize: 17, fontWeight: 600, color: '#1F1B16', lineHeight: 1.3, marginBottom: 4 }}>
          {item.title}
        </p>

        {shipsFrom && (
          <p style={{ fontSize: 13, color: '#6B6052', marginBottom: 8 }}>
            Ships from {shipsFrom}
          </p>
        )}

        {item.sale_method === 'accept_offers' ? (
          <p style={{ fontSize: 17, fontWeight: 600, color: '#7A5A22' }}>
            Accepting offers
          </p>
        ) : item.selling_price != null ? (
          <p style={{ fontSize: 17, fontWeight: 600, color: '#1F1B16' }}>
            {priceText(price!.amount, fx)}
            {price!.inclVat && <span style={{ fontSize: 12, fontWeight: 400, color: '#6B6052' }}> incl. VAT</span>}
            {approxPrice(price!.amount, fx) && (
              <span style={{ display: 'block', fontSize: 12, fontWeight: 400, color: '#6B6052' }}>{approxPrice(price!.amount, fx)}</span>
            )}
          </p>
        ) : (
          <p style={{ fontSize: 17, color: '#6B6052' }}>—</p>
        )}

        {cost !== null && (
          <p style={{ fontSize: 12, marginTop: 4, color: '#6B6052' }}>
            {cost === 0 ? 'Free shipping' : `+ ${priceText(shipShown!, fx)} shipping`}
          </p>
        )}
      </div>
    </Link>
  )
}
