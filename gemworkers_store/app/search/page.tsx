import { priceContext } from '@/lib/display-price'
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
      .select('id, title, gem_type, variety, weight_value, weight_unit, origin_country, seller_country, selling_price, sale_method, shipping_cost, image_url')
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
      seller_country: row.seller_country as string | null,
      selling_price:  row.selling_price  != null ? Number(row.selling_price) : null,
      sale_method:    row.sale_method    as string | null,
      shipping_cost:  row.shipping_cost  != null ? Number(row.shipping_cost) : null,
      image_url:      row.image_url      as string | null,
    }))
  }

  return (
    <main className="pd-wrap browse-main">
      <nav aria-label="Breadcrumb" className="pd-crumbs">
        <Link href="/">Home</Link>
        <span aria-hidden="true">/</span>
        <span aria-current="page">Search</span>
      </nav>

      {/* ── Heading ── */}
      <h1 className="font-serif browse-title">
        {query ? <>Results for &lsquo;{query}&rsquo;</> : 'Search'}
      </h1>
      {query && !hasError && (
        <p className="browse-count">
          {items.length} {items.length === 1 ? 'stone' : 'stones'}
        </p>
      )}

      {/* ── Search form ── */}
      <form action="/search" method="get" role="search" className="browse-search">
        <input
          type="search"
          name="q"
          defaultValue={query}
          placeholder="Search by gem, variety or origin"
          aria-label="Search gemstones"
        />
        <button type="submit">Search</button>
      </form>

      {!query && (
        <p className="browse-count" style={{ marginTop: 0 }}>
          Find gemstones by name, type, variety or origin.
        </p>
      )}

      {hasError && (
        <p style={{ fontSize: 15, color: '#B42318', marginTop: 8 }}>
          Search failed — please try again.
        </p>
      )}

      {items.length > 0 && <StoneGrid items={items} className="home-arrivals-grid" priceCtx={await priceContext()} />}

      {query && !hasError && items.length === 0 && (
        <div className="browse-empty">
          <p>No stones matched &lsquo;{query}&rsquo;.</p>
          <Link href="/shop/loose_stone" className="pd-link">Browse loose gemstones</Link>
          <p style={{ marginTop: 14 }}>
            Can&apos;t find it?{' '}
            <Link href="/contact?topic=Request%20a%20stone" className="pd-link">Request a stone</Link>
          </p>
        </div>
      )}
    </main>
  )
}
