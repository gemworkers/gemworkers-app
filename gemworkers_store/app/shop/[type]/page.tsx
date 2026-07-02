import { createClient } from '@/lib/supabase/server'
import Link from 'next/link'
import { StoneGrid } from '@/app/components/StoneGrid'
import type { StoneCardItem } from '@/app/components/StoneCard'

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

type CategoryRow = {
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
  image_urls:     unknown
}

export default async function ShopCategoryPage({ params, searchParams }: PageProps) {
  const { type } = await params
  const { gem }  = await searchParams

  if (!VALID_TYPES.has(type)) {
    return (
      <main style={{ maxWidth: 1400, margin: '0 auto', padding: '80px 32px' }}>
        <p style={{
          fontSize: 24, fontWeight: 300, color: '#f5f0e8', marginBottom: 12,
          fontFamily: 'var(--font-cormorant, Georgia, serif)', letterSpacing: '0.05em',
        }}>
          Category not found.
        </p>
        <Link href="/" className="back-link" style={{ fontSize: 13 }}>
          ← Browse all stones
        </Link>
      </main>
    )
  }

  const label    = TYPE_LABELS[type]
  const supabase = await createClient()

  const { data, error } = await supabase
    .from('public_listing_details')
    .select('id, title, gem_type, variety, weight_value, weight_unit, origin_country, selling_price, sale_method, shipping_cost, image_urls')
    .eq('product_type', type)

  if (error) console.error('[shop] query error:', error.message)

  const allItems: StoneCardItem[] = (data ?? []).map((row: CategoryRow) => ({
    id:             row.id,
    title:          row.title,
    gem_type:       row.gem_type,
    variety:        row.variety,
    weight_value:   row.weight_value   != null ? Number(row.weight_value)  : null,
    weight_unit:    row.weight_unit,
    origin_country: row.origin_country,
    selling_price:  row.selling_price  != null ? Number(row.selling_price) : null,
    sale_method:    row.sale_method,
    shipping_cost:  row.shipping_cost  != null ? Number(row.shipping_cost) : null,
    image_url:      Array.isArray(row.image_urls)
      ? ((row.image_urls as string[])[0] ?? null)
      : null,
  }))

  const gemTypes = [
    ...new Set(allItems.map(i => i.gem_type).filter((g): g is string => !!g)),
  ].sort()

  const items = gem ? allItems.filter(i => i.gem_type === gem) : allItems

  return (
    <main style={{ maxWidth: 1400, margin: '0 auto', padding: '56px 32px 80px' }}>

      {/* ── Heading ── */}
      <div style={{ marginBottom: 36 }}>
        <p style={{
          fontSize: 9, fontWeight: 700, letterSpacing: '0.2em', textTransform: 'uppercase',
          color: '#c9a962', marginBottom: 12,
          fontFamily: 'var(--font-inter, system-ui)',
        }}>
          Shop
        </p>
        <h1 style={{
          fontSize: 'clamp(28px, 4vw, 44px)', fontWeight: 300, color: '#f5f0e8',
          fontFamily: 'var(--font-cormorant, Georgia, serif)',
          letterSpacing: '0.06em', lineHeight: 1.15,
        }}>
          {label}
        </h1>
      </div>

      <div className="gold-rule" style={{ marginBottom: 36 }} />

      {/* ── Gem-type filter chips ── */}
      {gemTypes.length > 0 && (
        <div style={{ display: 'flex', flexWrap: 'wrap', gap: 8, marginBottom: 32 }}>
          <Link href={`/shop/${type}`} style={{
            fontSize: 11, padding: '5px 14px', borderRadius: 20,
            border: `1px solid ${!gem ? '#c9a962' : '#2a2a30'}`,
            background: !gem ? 'rgba(201,169,98,0.12)' : 'transparent',
            color: !gem ? '#c9a962' : '#9d9080',
            textDecoration: 'none', letterSpacing: '0.06em',
            fontFamily: 'var(--font-inter, system-ui)',
            transition: 'border-color 200ms, color 200ms',
          }}>
            All
          </Link>
          {gemTypes.map(g => (
            <Link key={g} href={`/shop/${type}?gem=${encodeURIComponent(g)}`} style={{
              fontSize: 11, padding: '5px 14px', borderRadius: 20,
              border: `1px solid ${gem === g ? '#c9a962' : '#2a2a30'}`,
              background: gem === g ? 'rgba(201,169,98,0.12)' : 'transparent',
              color: gem === g ? '#c9a962' : '#9d9080',
              textDecoration: 'none', letterSpacing: '0.06em',
              fontFamily: 'var(--font-inter, system-ui)',
              transition: 'border-color 200ms, color 200ms',
            }}>
              {g}
            </Link>
          ))}
        </div>
      )}

      {/* ── Result count ── */}
      <p style={{
        fontSize: 11, color: '#4a4440', marginBottom: 28, letterSpacing: '0.06em',
        fontFamily: 'var(--font-inter, system-ui)',
      }}>
        {items.length === 0
          ? 'No listings found'
          : `${items.length} ${items.length === 1 ? 'listing' : 'listings'}${gem ? ` · ${gem}` : ''}`}
      </p>

      {/* ── Grid or empty state ── */}
      {items.length === 0 ? (
        <div style={{ textAlign: 'center', padding: '100px 0' }}>
          <div style={{
            fontSize: 28, color: '#2a2a30', marginBottom: 16,
            fontFamily: 'var(--font-cormorant, Georgia, serif)',
          }}>◇</div>
          <p style={{
            fontSize: 15, color: '#4a4440', letterSpacing: '0.04em',
            fontFamily: 'var(--font-inter, system-ui)',
          }}>
            {gem ? `No ${gem} listed in this category yet.` : 'No listings in this category yet.'}
          </p>
        </div>
      ) : (
        <StoneGrid items={items} />
      )}
    </main>
  )
}
