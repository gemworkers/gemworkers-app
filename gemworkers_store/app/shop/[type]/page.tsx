import { priceContext } from '@/lib/display-price'
import { createClient } from '@/lib/supabase/server'
import Link from 'next/link'
import { StoneGrid } from '@/app/components/StoneGrid'
import type { StoneCardItem } from '@/app/components/StoneCard'
import { shownPrice } from '@/lib/price-shown'
import { countryName } from '@/lib/countries'
import { favouriteIds } from '@/lib/favourites'
import { fxContext } from '@/lib/fx'

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
  // Filters live in the URL so a filtered page can be bookmarked or shared.
  searchParams: Promise<{ gem?: string; min?: string; max?: string; from?: string; cert?: string; sort?: string }>
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
  certification_lab?: string | null
  // Present once public_views_available_only.sql is applied; absent before.
  status?:        string | null
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

const TYPE_SEO: Record<string, string> = {
  loose_stone: 'Natural loose gemstones — tourmaline, sapphire, aquamarine and more, cut and certified on request.',
  specimen:    'Natural mineral specimens and crystals, collected from the source.',
  jewelry:     'Handmade jewellery with natural gemstones.',
}

export async function generateMetadata({ params }: { params: Promise<{ type: string }> }) {
  const { type } = await params
  const label = TYPE_LABELS[type] ?? 'Shop'
  const description = `${TYPE_SEO[type] ?? 'Natural gemstones, specimens and jewellery.'} Tracked worldwide shipping and 30-day returns.`
  return {
    title: `${label} · GemWorkers`,
    description,
    alternates: { canonical: `/shop/${type}` },
    openGraph: { title: `${label} · GemWorkers`, description, url: `/shop/${type}` },
  }
}

export default async function ShopCategoryPage({ params, searchParams }: PageProps) {
  const { type } = await params
  const { gem, min, max, from, cert, sort } = await searchParams

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
    // '*' rather than a column list: naming `status` would fail against views
    // that predate it. Reserved stones keep their detail page but stay off the grid.
    .select('*')
    .eq('product_type', type)

  if (error) console.error('[shop] query error:', error.message)

  const rows = ((data ?? []) as CategoryRow[])
    .filter(row => (row.status ?? 'available') === 'available')

  const allItems: StoneCardItem[] = rows.map((row: CategoryRow) => ({
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

  // ── Filters (price is the price shown to this buyer, incl. VAT where it applies) ──
  const pctx = await priceContext()
  const certified = new Set(rows.filter(r => (r.certification_lab ?? '').trim() !== '').map(r => r.id))
  const shipsFrom = [...new Set(allItems.map(i => i.seller_country).filter((c): c is string => !!c))]
    .sort((a, b) => (countryName(a) ?? a).localeCompare(countryName(b) ?? b))
  const toNum = (v?: string) => {
    const n = Number((v ?? '').replace(',', '.'))
    return v && Number.isFinite(n) && n >= 0 ? n : null
  }
  const minN = toNum(min)
  const maxN = toNum(max)
  const priceOf = (i: StoneCardItem) =>
    i.selling_price == null || i.sale_method === 'accept_offers' ? null : shownPrice(i.selling_price, i.seller_country, pctx).amount

  let items = allItems.filter(i => {
    if (gem && i.gem_type !== gem) return false
    if (from && i.seller_country !== from) return false
    if (cert === '1' && !certified.has(i.id)) return false
    if (minN != null || maxN != null) {
      const p = priceOf(i)
      if (p == null) return false
      if (minN != null && p < minN) return false
      if (maxN != null && p > maxN) return false
    }
    return true
  })
  if (sort === 'price_asc' || sort === 'price_desc') {
    const dir = sort === 'price_asc' ? 1 : -1
    items = [...items].sort((a, b) => {
      const pa = priceOf(a), pb = priceOf(b)
      if (pa == null) return 1
      if (pb == null) return -1
      return (pa - pb) * dir
    })
  }
  const filtered = !!(min || max || from || cert || (sort && sort !== 'default'))

  // Chip links keep the other filters.
  const href = (over: Record<string, string | undefined>) => {
    const p = new URLSearchParams()
    const all = { gem, min, max, from, cert, sort, ...over }
    for (const [k, v] of Object.entries(all)) if (v) p.set(k, v)
    const q = p.toString()
    return `/shop/${type}${q ? `?${q}` : ''}`
  }
  const favs = await favouriteIds()

  return (
    <main className="pd-wrap browse-main">
      <Breadcrumb label={label} />

      {/* ── Heading ── */}
      <h1 className="font-serif browse-title">{label}</h1>
      <p className="browse-count">
        {items.length} {items.length === 1 ? one : many}{gem ? ` · ${gem}` : ''}{filtered ? ' · filtered' : ''}
      </p>

      {/* ── Gem-type filter chips ── */}
      {gemTypes.length > 0 && (
        <div className="browse-chips">
          <Link href={href({ gem: undefined })} className={`browse-chip${!gem ? ' is-active' : ''}`}>
            All
          </Link>
          {gemTypes.map(g => (
            <Link
              key={g}
              href={href({ gem: g })}
              className={`browse-chip${gem === g ? ' is-active' : ''}`}
            >
              {g}
            </Link>
          ))}
        </div>
      )}

      {/* ── More filters (plain form: works without JavaScript) ── */}
      <form method="get" action={`/shop/${type}`} className="browse-filters">
        {gem && <input type="hidden" name="gem" value={gem} />}
        <label className="browse-filter">
          <span>Price from €</span>
          <input name="min" inputMode="decimal" defaultValue={min ?? ''} placeholder="0" />
        </label>
        <label className="browse-filter">
          <span>to €</span>
          <input name="max" inputMode="decimal" defaultValue={max ?? ''} placeholder="any" />
        </label>
        {shipsFrom.length > 1 && (
          <label className="browse-filter">
            <span>Ships from</span>
            <select name="from" defaultValue={from ?? ''}>
              <option value="">Anywhere</option>
              {shipsFrom.map(c => <option key={c} value={c}>{countryName(c)}</option>)}
            </select>
          </label>
        )}
        <label className="browse-filter">
          <span>Sort</span>
          <select name="sort" defaultValue={sort ?? 'default'}>
            <option value="default">Recommended</option>
            <option value="price_asc">Price: low to high</option>
            <option value="price_desc">Price: high to low</option>
          </select>
        </label>
        <label className="browse-filter browse-filter-check">
          <input type="checkbox" name="cert" value="1" defaultChecked={cert === '1'} />
          <span>Certified only</span>
        </label>
        <button type="submit" className="browse-chip is-active">Apply</button>
        {filtered && <Link href={href({ min: undefined, max: undefined, from: undefined, cert: undefined, sort: undefined })} className="pd-link" style={{ fontSize: 14 }}>Clear filters</Link>}
      </form>

      {/* ── Grid or empty state ── */}
      {items.length === 0 ? (
        <div className="browse-empty">
          <p>
            {filtered ? 'Nothing matches these filters — try a wider price range or clear the filters.' : gem ? `No ${gem} listed in this category yet.` : 'Nothing listed in this category yet — check back soon.'}
          </p>
          <Link href="/shop/loose_stone" className="pd-link">Browse loose gemstones</Link>
        </div>
      ) : (
        <StoneGrid items={items} className="home-arrivals-grid" priceCtx={pctx} favouriteIds={favs} fx={await fxContext()} />
      )}
    </main>
  )
}
