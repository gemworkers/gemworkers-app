import { createClient } from '@/lib/supabase/server'
import Link from 'next/link'

type SearchItem = {
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

type PageProps = {
  searchParams: Promise<{ q?: string }>
}

const eur = new Intl.NumberFormat('en-IE', {
  style: 'currency', currency: 'EUR', maximumFractionDigits: 0,
})

export default async function SearchPage({ searchParams }: PageProps) {
  const { q } = await searchParams
  const query = q?.trim() ?? ''

  const supabase = await createClient()
  let items: SearchItem[] = []
  let hasError = false

  if (query) {
    // Escape SQL LIKE wildcards so they're treated as literals.
    const safe = query.replace(/%/g, '\\%').replace(/_/g, '\\_')

    const { data, error } = await supabase
      .from('public_listings')
      .select('id, title, gem_type, variety, weight_value, weight_unit, origin_country, selling_price, sale_method, shipping_cost, image_url')
      .or(`title.ilike.%${safe}%,gem_type.ilike.%${safe}%,variety.ilike.%${safe}%,origin_country.ilike.%${safe}%`)

    if (error) {
      console.error('[search] query error:', error.message)
      hasError = true
    }

    items = (data ?? []).map(row => ({
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
      image_url:      row.image_url      as string | null,
    }))
  }

  return (
    <main style={{ maxWidth: 1400, margin: '0 auto', padding: '48px 32px 80px' }}>

      {/* ── Heading ── */}
      <p style={{
        fontSize: 11, fontWeight: 700, letterSpacing: '0.14em',
        color: '#9ca3af', textTransform: 'uppercase', marginBottom: 10,
      }}>
        Search
      </p>

      {query ? (
        <h1 style={{
          fontSize: 28, fontWeight: 700, color: '#111',
          fontFamily: "Georgia, 'Times New Roman', serif",
          lineHeight: 1.2, marginBottom: 6,
        }}>
          &ldquo;{query}&rdquo;
        </h1>
      ) : (
        <h1 style={{
          fontSize: 28, fontWeight: 400, color: '#9ca3af',
          fontFamily: "Georgia, 'Times New Roman', serif",
          lineHeight: 1.2, marginBottom: 0,
        }}>
          What are you looking for?
        </h1>
      )}

      {/* ── No-query prompt ── */}
      {!query && (
        <p style={{ fontSize: 14, color: '#6b7280', marginTop: 12 }}>
          Use the search bar above to find gemstones by name, type, variety, or origin.
        </p>
      )}

      {/* ── Result count / error ── */}
      {query && !hasError && (
        <p style={{ fontSize: 12, color: '#9ca3af', marginBottom: 32, marginTop: 6, letterSpacing: '0.04em' }}>
          {items.length === 0
            ? 'No results'
            : `${items.length} ${items.length === 1 ? 'result' : 'results'}`}
        </p>
      )}
      {hasError && (
        <p style={{ fontSize: 13, color: '#ef4444', marginTop: 12 }}>
          Search failed — please try again.
        </p>
      )}

      {/* ── Grid ── */}
      {items.length > 0 && (
        <div className="stones-grid">
          {items.map(item => <SearchCard key={item.id} item={item} />)}
        </div>
      )}

      {/* ── No-results state ── */}
      {query && !hasError && items.length === 0 && (
        <div style={{ textAlign: 'center', padding: '80px 0' }}>
          <div style={{ fontSize: 36, color: '#d1d5db', marginBottom: 14 }}>◇</div>
          <p style={{ fontSize: 15, color: '#9ca3af', marginBottom: 20 }}>
            No stones matched &ldquo;{query}&rdquo;
          </p>
          <Link href="/" style={{ fontSize: 13, color: '#374151', textDecoration: 'none' }}>
            Browse all stones →
          </Link>
        </div>
      )}
    </main>
  )
}

// ── Search result card ─────────────────────────────────────────────────────────
// Mirrors app/page.tsx card exactly (same inline styles and logic).

function SearchCard({ item }: { item: SearchItem }) {
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
