// Old Shopify product links (/products/<slug>) still live on TikTok product
// links, Google, Pinterest and old posts. Send them to a GemWorkers search for
// the gem named in the slug (e.g. …-kunzite-crystal-… → /search?q=kunzite),
// keeping utm_* so the visit's source is still counted. 301 = moved for good.
import { NextResponse, type NextRequest } from 'next/server'

const GEMS = [
  'rubellite', 'indicolite', 'paraiba', 'tourmaline', 'kunzite', 'hiddenite', 'spodumene', 'aquamarine',
  'morganite', 'heliodor', 'emerald', 'beryl', 'sapphire', 'ruby', 'spinel', 'spessartite', 'tsavorite',
  'garnet', 'topaz', 'peridot', 'amethyst', 'citrine', 'quartz', 'apatite', 'fluorite', 'lapis', 'opal',
  'zircon', 'tanzanite', 'sphene', 'kyanite', 'jade', 'turquoise', 'moonstone', 'hauyne', 'herkimer', 'necklace', 'bracelet',
]

export async function GET(req: NextRequest, { params }: { params: Promise<{ slug: string }> }) {
  const { slug } = await params
  const words = slug.toLowerCase().split(/[^a-z]+/)
  const gem = GEMS.find(g => words.includes(g))
  const url = new URL(gem ? `/search?q=${gem}` : '/search', 'https://www.gemworkers.com')
  for (const [k, v] of req.nextUrl.searchParams) if (k.startsWith('utm_')) url.searchParams.set(k, v)
  return NextResponse.redirect(url, 301)
}
