// Old Shopify addresses (Google results, TikTok product links, Pinterest, old
// posts) → the closest GemWorkers page. Used by middleware (301 redirect).
//   /products/<slug>, /de/products/<slug>, /collections/<c>/products/<slug>
//      → /search?q=<gem named in the slug>
//   /collections/<c>, /de/collections/<c>   → same, or /shop/all
//   /pages/…, /de, /fr-be …                 → homepage;  /blogs/… → /journal
const GEMS = [
  'rubellite', 'indicolite', 'paraiba', 'tourmaline', 'kunzite', 'hiddenite', 'spodumene', 'aquamarine',
  'morganite', 'heliodor', 'emerald', 'beryl', 'sapphire', 'ruby', 'spinel', 'spessartite', 'tsavorite',
  'garnet', 'topaz', 'peridot', 'amethyst', 'citrine', 'quartz', 'apatite', 'fluorite', 'lapis', 'opal',
  'zircon', 'tanzanite', 'sphene', 'kyanite', 'jade', 'turquoise', 'moonstone', 'hauyne', 'herkimer',
  'necklace', 'bracelet', 'ring', 'earrings', 'pendant',
]
const LOCALE = '(?:[a-z]{2}(?:-[a-z]{2})?/)?'

function gemIn(slug: string): string | null {
  const words = slug.toLowerCase().split(/[^a-z]+/)
  return GEMS.find(g => words.some(w => w === g || w === `${g}s` || w === `${g}es`)) ?? null
}

/** Target path for an old Shopify address, or null when it isn't one. */
export function oldShopifyTarget(pathname: string): string | null {
  const p = pathname.toLowerCase()
  let m = p.match(new RegExp(`^/${LOCALE}(?:collections/[^/]+/)?products/([^/]+)`))
  if (m) { const g = gemIn(m[1]); return g ? `/search?q=${g}` : '/shop/all' }
  m = p.match(new RegExp(`^/${LOCALE}collections/([^/]+)/?$`))
  if (m) { const g = gemIn(m[1]); return g ? `/search?q=${g}` : '/shop/all' }
  if (new RegExp(`^/${LOCALE}blogs(/|$)`).test(p)) return '/journal'
  if (new RegExp(`^/${LOCALE}pages(/|$)`).test(p)) return '/'
  if (/^\/[a-z]{2}(-[a-z]{2})?\/?$/.test(p)) return '/'          // /de, /fr-be
  return null
}
