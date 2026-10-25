import Link from 'next/link'
import { redirect } from 'next/navigation'
import { createClient } from '@/lib/supabase/server'
import { StoneGrid } from '@/app/components/StoneGrid'
import type { StoneCardItem } from '@/app/components/StoneCard'
import { priceContext } from '@/lib/display-price'
import { favouriteIds } from '@/lib/favourites'
import { fxContext } from '@/lib/fx'

export const metadata = { title: 'Favourites · GemWorkers' }

// The buyer's saved stones that are still for sale (sql/favourites.sql).
export default async function FavouritesPage() {
  const supabase = await createClient()
  const { data: { user } } = await supabase.auth.getUser()
  if (!user) redirect('/auth/login?next=%2Ffavourites')

  const ids = (await favouriteIds()) ?? []
  let items: StoneCardItem[] = []
  if (ids.length > 0) {
    const { data } = await supabase
      .from('public_listings')
      .select('id, title, gem_type, variety, weight_value, weight_unit, origin_country, seller_country, selling_price, sale_method, shipping_cost, image_url')
      .in('id', ids)
    items = ((data ?? []) as StoneCardItem[]).map(i => ({
      ...i,
      weight_value: i.weight_value != null ? Number(i.weight_value) : null,
      selling_price: i.selling_price != null ? Number(i.selling_price) : null,
      shipping_cost: i.shipping_cost != null ? Number(i.shipping_cost) : null,
    }))
  }
  const gone = ids.length - items.length

  return (
    <main className="pd-wrap browse-main">
      <nav aria-label="Breadcrumb" className="pd-crumbs">
        <Link href="/">Home</Link>
        <span aria-hidden="true">/</span>
        <span aria-current="page">Favourites</span>
      </nav>
      <h1 className="font-serif browse-title">Favourites</h1>
      <p className="browse-count">
        {items.length} saved {items.length === 1 ? 'stone' : 'stones'}
        {gone > 0 ? ` · ${gone} no longer available` : ''}
      </p>
      {items.length === 0 ? (
        <div className="browse-empty">
          <p>Tap the heart on any stone to save it here.</p>
          <Link href="/shop/loose_stone" className="pd-link">Browse loose gemstones</Link>
        </div>
      ) : (
        <StoneGrid items={items} className="home-arrivals-grid" priceCtx={await priceContext()} favouriteIds={ids} fx={await fxContext()} />
      )}
    </main>
  )
}
