import { createClient } from '@/lib/supabase/server'
import Link from 'next/link'
import { StoneGrid } from '@/app/components/StoneGrid'
import type { StoneCardItem } from '@/app/components/StoneCard'

const TYPE_LABELS: Record<string, string> = {
  loose_stone: 'Loose Gemstones',
  specimen:    'Mineral Specimens',
  jewelry:     'Jewelry',
}

// Singular / plural noun for the count line
const TYPE_NOUNS: Record<string, [string, string]> = {
  loose_stone: ['stone', 'stones'],
  specimen:    ['specimen', 'specimens'],
  jewelry:     ['piece', 'pieces'],
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
  seller_country: string | null
  selling_price:  number | null
  sale_method:    string | null
  shipping_cost:  number | null
  image_urls:     unknown
}

function Breadcrumb({ label }: { label: string }) {
  return (
    <nav aria-label="Breadcrumb" className="pd-crumbs">
      <Link href="/">Home</Link>
      <span aria-hidden="true">/</span>
      <span aria-current="page">{label}</span>
    </nav>
  )
}

export default async function ShopCategoryPage({ params, searchParams }: PageProps) {
  const { type } = await params
  const { gem }  = await searchParams

  if (!VALID_TYPES.has(type)) {
    return (
      <main className="pd-wrap browse-main">
        <Breadcrumb label="Not found" />
        <h1 className="font-serif browse-title">Category not found</h1>
        <div className="browse-empty">
          <p>This category doesn&apos;t exist.</p>
          <Link href="/shop/loose_stone" className="pd-link">Browse loose gemstones</Link>
        </div>
      </main>
    )
  }

  const label    = TYPE_LABELS[type]
  const [one, many] = TYPE_NOUNS[type]
  const supabase = await createClient()

  const { data, error } = await supabase
    .from('public_listing_details')
    .select('id, title, gem_type, variety, weight_value, weight_unit, origin_country, seller_country, selling_price, sale_method, shipping_cost, image_urls')
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
    seller_country: row.seller_country,
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
    <main className="pd-wrap browse-main">
      <Breadcrumb label={label} />

      {/* ── Heading ── */}
      <h1 className="font-serif browse-title">{label}</h1>
      <p className="browse-count">
        {items.length} {items.length === 1 ? one : many}{gem ? ` · ${gem}` : ''}
      </p>

      {/* ── Gem-type filter chips ── */}
      {gemTypes.length > 0 && (
        <div className="browse-chips">
          <Link href={`/shop/${type}`} className={`browse-chip${!gem ? ' is-active' : ''}`}>
            All
          </Link>
          {gemTypes.map(g => (
            <Link
              key={g}
              href={`/shop/${type}?gem=${encodeURIComponent(g)}`}
              className={`browse-chip${gem === g ? ' is-active' : ''}`}
            >
              {g}
            </Link>
          ))}
        </div>
      )}

      {/* ── Grid or empty state ── */}
      {items.length === 0 ? (
        <div className="browse-empty">
          <p>
            {gem ? `No ${gem} listed in this category yet.` : 'Nothing listed in this category yet — check back soon.'}
          </p>
          <Link href="/shop/loose_stone" className="pd-link">Browse loose gemstones</Link>
        </div>
      ) : (
        <StoneGrid items={items} className="home-arrivals-grid" />
      )}
    </main>
  )
}
