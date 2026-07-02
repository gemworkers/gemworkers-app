import { createClient } from '@/lib/supabase/server'
import Link from 'next/link'
import { StoneGrid } from '@/app/components/StoneGrid'
import type { StoneCardItem } from '@/app/components/StoneCard'

type PageProps = {
  searchParams: Promise<{ q?: string }>
}

export default async function SearchPage({ searchParams }: PageProps) {
  const { q } = await searchParams
  const query = q?.trim() ?? ''

  const supabase = await createClient()
  let items: StoneCardItem[] = []
  let hasError = false

  if (query) {
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
    <main style={{ maxWidth: 1400, margin: '0 auto', padding: '56px 32px 80px' }}>

      {/* ── Heading ── */}
      <p style={{
        fontSize: 9, fontWeight: 700, letterSpacing: '0.2em', textTransform: 'uppercase',
        color: '#c9a962', marginBottom: 14,
        fontFamily: 'var(--font-inter, system-ui)',
      }}>
        Search
      </p>

      {query ? (
        <h1 style={{
          fontSize: 'clamp(26px, 4vw, 40px)', fontWeight: 300, color: '#f5f0e8',
          fontFamily: 'var(--font-cormorant, Georgia, serif)',
          letterSpacing: '0.04em', lineHeight: 1.2, marginBottom: 8,
        }}>
          &ldquo;{query}&rdquo;
        </h1>
      ) : (
        <h1 style={{
          fontSize: 'clamp(26px, 4vw, 40px)', fontWeight: 300, color: '#4a4440',
          fontFamily: 'var(--font-cormorant, Georgia, serif)',
          letterSpacing: '0.04em', lineHeight: 1.2, marginBottom: 0,
        }}>
          What are you looking for?
        </h1>
      )}

      {!query && (
        <p style={{
          fontSize: 14, color: '#5c5346', marginTop: 12, lineHeight: 1.6,
          fontFamily: 'var(--font-inter, system-ui)',
        }}>
          Use the search bar above to find gemstones by name, type, variety, or origin.
        </p>
      )}

      {query && !hasError && (
        <>
          <div className="gold-rule" style={{ margin: '24px 0 28px' }} />
          <p style={{
            fontSize: 11, color: '#4a4440', marginBottom: 28, letterSpacing: '0.06em',
            fontFamily: 'var(--font-inter, system-ui)',
          }}>
            {items.length === 0 ? 'No results' : `${items.length} ${items.length === 1 ? 'result' : 'results'}`}
          </p>
        </>
      )}

      {hasError && (
        <p style={{
          fontSize: 13, color: '#ef4444', marginTop: 12,
          fontFamily: 'var(--font-inter, system-ui)',
        }}>
          Search failed — please try again.
        </p>
      )}

      {items.length > 0 && <StoneGrid items={items} />}

      {query && !hasError && items.length === 0 && (
        <div style={{ textAlign: 'center', padding: '80px 0' }}>
          <div style={{
            fontSize: 28, color: '#2a2a30', marginBottom: 16,
            fontFamily: 'var(--font-cormorant, Georgia, serif)',
          }}>◇</div>
          <p style={{
            fontSize: 15, color: '#4a4440', marginBottom: 24,
            fontFamily: 'var(--font-inter, system-ui)',
          }}>
            No stones matched &ldquo;{query}&rdquo;
          </p>
          <Link href="/" style={{
            fontSize: 12, color: '#9d9080', letterSpacing: '0.06em',
            textDecoration: 'none',
            fontFamily: 'var(--font-inter, system-ui)',
          }}>
            Browse all stones →
          </Link>
        </div>
      )}
    </main>
  )
}
