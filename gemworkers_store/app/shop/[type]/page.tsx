import { createClient } from '@/lib/supabase/server'
import Link from 'next/link'

const TYPE_LABELS: Record<string, string> = {
  loose_stone: 'Loose Gemstones',
  specimen:    'Mineral Specimens',
  jewelry:     'Jewelry',
}

const VALID_TYPES = new Set(['loose_stone', 'specimen', 'jewelry'])

type PageProps = {
  params:       Promise<{ type: string }>
  searchParams: Promise<{ gem?: string }>
}

type CategoryItem = {
  id:             string
  title:          string
  gem_type:       string | null
  variety:        string | null
  weight_value:   number | null
  weight_unit:    string | null
  origin_country: string | null
  selling_price:  number | null
  sale_method:    string | null
  shipping_cost:  number | null
  image_url:      string | null
}

const eur = new Intl.NumberFormat('en-IE', {
  style: 'currency', currency: 'EUR', maximumFractionDigits: 0,
})

export default async function ShopCategoryPage({ params, searchParams }: PageProps) {
  const { type } = await params
  const { gem }  = await searchParams

  if (!VALID_TYPES.has(type)) {
    return (
      <main style={{ maxWidth: 1400, margin: '0 auto', padding: '80px 32px' }}>
        <p style={{ fontSize: 24, fontWeight: 700, color: '#111', marginBottom: 12,
          fontFamily: "Georgia, 'Times New Roman', serif" }}>
          Category not found.
        </p>
        <Link href="/" style={{ fontSize: 13, color: '#9ca3af', textDecoration: 'none' }}>
          ← Browse all stones
        </Link>
      </main>
    )
  }

  const label    = TYPE_LABELS[type]
  const supabase = await createClient()

  // public_listing_details carries product_type (public_listings does not).
  // image_urls is a jsonb array here — we extract [0] below.
  const { data, error } = await supabase
    .from('public_listing_details')
    .select('id, title, gem_type, variety, weight_value, weight_unit, origin_country, selling_price, sale_method, shipping_cost, image_urls')
    .eq('product_type', type)

  if (error) console.error('[shop] query error:', error.message)

  const allItems: CategoryItem[] = (data ?? []).map(row => ({
    id:             row.id             as string,
    title:          row.title          as string,
    gem_type:       row.gem_type       as string | null,
    variety:        row.variety        as string | null,
    weight_value:   row.weight_value   != null ? Number(row.weight_value)  : null,
    weight_unit:    row.weight_unit    as string | null,
    origin_country: row.origin_country as string | null,
    selling_price:  row.selling_price  != null ? Number(row.selling_price) : null,
    sale_method:    row.sale_method    as string | null,
    shipping_cost:  row.shipping_cost  != null ? Number(row.shipping_cost) : null,
    image_url:      Array.isArray(row.image_urls)
      ? ((row.image_urls as unknown as string[])[0] ?? null)
      : null,
  }))

  // Distinct gem types from this category's data — never hardcoded.
  const gemTypes = [
    ...new Set(allItems.map(i => i.gem_type).filter((g): g is string => !!g)),
  ].sort()

  const items = gem ? allItems.filter(i => i.gem_type === gem) : allItems

  return (
    <main style={{ maxWidth: 1400, margin: '0 auto', padding: '48px 32px 80px' }}>

      {/* ── Heading ── */}
      <div style={{ marginBottom: 32 }}>
        <p style={{
          fontSize: 11, fontWeight: 700, letterSpacing: '0.14em',
          color: '#9ca3af', textTransform: 'uppercase', marginBottom: 10,
        }}>
          Shop
        </p>
        <h1 style={{
          fontSize: 32, fontWeight: 700, color: '#111',
          fontFamily: "Georgia, 'Times New Roman', serif", lineHeight: 1.2,
        }}>
          {label}
        </h1>
      </div>

      {/* ── Gem-type filter chips (data-driven) ── */}
      {gemTypes.length > 0 && (
        <div style={{ display: 'flex', flexWrap: 'wrap', gap: 8, marginBottom: 28 }}>
          <Link
            href={`/shop/${type}`}
            style={{
              fontSize: 12, padding: '5px 14px', borderRadius: 20,
              border: `1px solid ${!gem ? '#111' : '#e5e7eb'}`,
              background: !gem ? '#111' : '#fff',
              color: !gem ? '#fff' : '#374151',
              textDecoration: 'none', letterSpacing: '0.02em',
            }}
          >
            All
          </Link>
          {gemTypes.map(g => (
            <Link
              key={g}
              href={`/shop/${type}?gem=${encodeURIComponent(g)}`}
              style={{
                fontSize: 12, padding: '5px 14px', borderRadius: 20,
                border: `1px solid ${gem === g ? '#111' : '#e5e7eb'}`,
                background: gem === g ? '#111' : '#fff',
                color: gem === g ? '#fff' : '#374151',
                textDecoration: 'none', letterSpacing: '0.02em',
              }}
            >
              {g}
            </Link>
          ))}
        </div>
      )}

      {/* ── Result count ── */}
      <p style={{ fontSize: 12, color: '#9ca3af', marginBottom: 24, letterSpacing: '0.04em' }}>
        {items.length === 0
          ? 'No listings found'
          : `${items.length} ${items.length === 1 ? 'listing' : 'listings'}${gem ? ` · ${gem}` : ''}`}
      </p>

      {/* ── Grid or empty state ── */}
      {items.length === 0 ? (
        <div style={{ textAlign: 'center', padding: '100px 0' }}>
          <div style={{ fontSize: 36, color: '#d1d5db', marginBottom: 14 }}>◇</div>
          <p style={{ fontSize: 15, color: '#9ca3af' }}>
            {gem
              ? `No ${gem} listed in this category yet.`
              : 'No listings in this category yet.'}
          </p>
        </div>
      ) : (
        <div className="stones-grid">
          {items.map(item => <StoneCard key={item.id} item={item} />)}
        </div>
      )}
    </main>
  )
}

// ── Stone card ─────────────────────────────────────────────────────────────────
// Mirrors app/page.tsx card exactly (same inline styles and logic).

function StoneCard({ item }: { item: CategoryItem }) {
  const gemLabel    = item.variety?.trim() || item.gem_type?.trim() || null
  const originLabel = item.origin_country?.trim() || null
  const subtitle    = [gemLabel, originLabel].filter(Boolean).join(' · ')
  const initial     = gemLabel ? gemLabel.charAt(0).toUpperCase() : '◇'
  const hasWeight   = item.weight_value != null && Number(item.weight_value) > 0
  const cost        = item.shipping_cost == null ? null : Number(item.shipping_cost)

  return (
    <Link
      href={`/stones/${item.id}`}
      className="stone-card"
      style={{
        display: 'block', textDecoration: 'none', color: 'inherit',
        border: '1px solid #e5e7eb', borderRadius: 10, overflow: 'hidden',
        background: '#fff',
      }}
    >
      <div style={{ position: 'relative', aspectRatio: '1', overflow: 'hidden' }}>
        {item.image_url ? (
          // eslint-disable-next-line @next/next/no-img-element
          <img
            src={item.image_url}
            alt={item.title}
            style={{ width: '100%', height: '100%', objectFit: 'cover', display: 'block' }}
          />
        ) : (
          <div style={{
            width: '100%', height: '100%',
            display: 'flex', alignItems: 'center', justifyContent: 'center',
            background: 'linear-gradient(145deg, #f6f3ef 0%, #ece8e2 100%)',
          }}>
            <span style={{
              fontSize: 48, color: '#c4b8ab', fontWeight: 300,
              fontFamily: "Georgia, 'Times New Roman', serif",
              lineHeight: 1, userSelect: 'none',
            }}>
              {initial}
            </span>
          </div>
        )}
        {hasWeight && (
          <div style={{
            position: 'absolute', top: 8, right: 8,
            background: 'rgba(255,255,255,0.92)', backdropFilter: 'blur(6px)',
            borderRadius: 4, padding: '2px 8px',
            fontSize: 11, fontWeight: 600, color: '#374151', letterSpacing: '0.03em',
          }}>
            {item.weight_value} {item.weight_unit}
          </div>
        )}
      </div>

      <div style={{ padding: '12px 14px 14px' }}>
        <p style={{
          fontSize: 14, fontWeight: 600, color: '#111',
          lineHeight: 1.35, marginBottom: subtitle ? 4 : 10,
        }}>
          {item.title}
        </p>
        {subtitle && (
          <p style={{ fontSize: 12, color: '#9ca3af', marginBottom: 10, lineHeight: 1.4 }}>
            {subtitle}
          </p>
        )}
        <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between' }}>
          {item.sale_method === 'accept_offers' ? (
            <span style={{ fontSize: 13, color: '#9ca3af', fontStyle: 'italic' }}>Offers</span>
          ) : item.selling_price != null ? (
            <span style={{ fontSize: 15, fontWeight: 700, color: '#111', letterSpacing: '-0.01em' }}>
              {eur.format(item.selling_price)}
            </span>
          ) : (
            <span style={{ fontSize: 13, color: '#d1d5db' }}>—</span>
          )}
        </div>
        {cost !== null && (
          <p style={{ fontSize: 11, marginTop: 5, color: cost === 0 ? '#16a34a' : '#6b7280' }}>
            {cost === 0 ? 'Free shipping' : `+ €${cost.toFixed(0)} shipping`}
          </p>
        )}
      </div>
    </Link>
  )
}
