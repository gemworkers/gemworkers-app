import { NextRequest } from 'next/server'
import { createClient } from '@/lib/supabase/server'
import { priceContextFor } from '@/lib/display-price'
import { shownPrice } from '@/lib/price-shown'
import { SITE_URL, stoneSeoDescription, type SeoStone } from '@/lib/seo'

// Google Merchant Center product feed, one per target country:
//   https://www.gemworkers.com/api/feed/google?country=NL   (or US, DE, GB …)
// Every listed stone with a price and a photo. Price and shipping are exactly
// what a buyer in that country sees on the stone page (incl. VAT for EU
// buyers of NL stones, none otherwise); each link carries ?ship_to=XX so the
// page shows that same price. Never any seller identity. Google reads it daily.

export const revalidate = 3600

type Row = SeoStone & {
  shipping_cost: number | string | null
  seller_country: string | null
  prep_days: number | null
  delivery_days_min: number | null
  delivery_days_max: number | null
}

const esc = (s: string) =>
  s.replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;').replace(/"/g, '&quot;')
const money = (n: number) => `${n.toFixed(2)} EUR`

const TYPE: Record<string, string> = { loose_stone: 'Loose gemstones', specimen: 'Mineral specimens', jewelry: 'Jewellery' }

export async function GET(req: NextRequest) {
  const country = (req.nextUrl.searchParams.get('country') ?? 'NL').toUpperCase()
  if (!/^[A-Z]{2}$/.test(country)) return new Response('Bad country', { status: 400 })

  const supabase = await createClient()
  const [{ data: listed }, { data: ship }, ctx] = await Promise.all([
    supabase.from('public_listings').select('id'),
    supabase.from('shipping_countries').select('enabled').eq('code', country).maybeSingle(),
    priceContextFor(country, false),
  ])
  const ids = ((listed as { id: string }[] | null) ?? []).map(l => l.id)
  const shipsThere = (ship as { enabled: boolean } | null)?.enabled === true

  let rows: Row[] = []
  if (ids.length > 0 && shipsThere) {
    const { data } = await supabase
      .from('public_listing_details')
      .select('id, title, product_type, description, selling_price, sale_method, image_urls, gem_type, variety, species, jewelry_type, weight_value, weight_unit, origin_country, shape, treatment, certification_lab, status, shipping_cost, seller_country, prep_days, delivery_days_min, delivery_days_max')
      .in('id', ids)
    rows = ((data as Row[] | null) ?? []).filter(r =>
      r.status === 'available' && r.sale_method !== 'accept_offers' &&
      r.selling_price != null && Number(r.selling_price) > 0 && (r.image_urls?.length ?? 0) > 0)
  }

  const items = rows.map(r => {
    const price = shownPrice(Number(r.selling_price), r.seller_country, ctx).amount
    const shipCost = shownPrice(Number(r.shipping_cost ?? 0), r.seller_country, ctx).amount
    const images = (r.image_urls ?? []).slice(0, 11)
    const gem = [r.variety, r.gem_type ?? r.species ?? r.jewelry_type].filter(Boolean).join(' ')
    // Handling = preparation days (3–5 working days if not set); transit = the stone's delivery estimate.
    const handlingMin = r.prep_days ?? 3
    const handlingMax = r.prep_days ?? 5
    const transitMin = r.delivery_days_min ?? (r.seller_country === 'NL' ? 2 : 8)
    const transitMax = r.delivery_days_max ?? (r.seller_country === 'NL' ? 15 : 30)
    return `    <item>
      <g:id>${esc(r.id)}</g:id>
      <g:title>${esc(r.title.slice(0, 150))}</g:title>
      <g:description>${esc(stoneSeoDescription(r))}</g:description>
      <g:link>${SITE_URL}/stones/${esc(r.id)}?ship_to=${country}</g:link>
      <g:image_link>${esc(images[0])}</g:image_link>
${images.slice(1).map(u => `      <g:additional_image_link>${esc(u)}</g:additional_image_link>`).join('\n')}
      <g:availability>in_stock</g:availability>
      <g:price>${money(price)}</g:price>
      <g:condition>new</g:condition>
      <g:brand>GemWorkers</g:brand>
      <g:identifier_exists>no</g:identifier_exists>
      <g:product_type>${esc([TYPE[r.product_type] ?? 'Gemstones', gem].filter(Boolean).join(' > '))}</g:product_type>
      <g:shipping>
        <g:country>${country}</g:country>
        <g:price>${money(shipCost)}</g:price>
        <g:min_handling_time>${handlingMin}</g:min_handling_time>
        <g:max_handling_time>${handlingMax}</g:max_handling_time>
        <g:min_transit_time>${transitMin}</g:min_transit_time>
        <g:max_transit_time>${transitMax}</g:max_transit_time>
      </g:shipping>
    </item>`
  })

  const xml = `<?xml version="1.0" encoding="UTF-8"?>
<rss version="2.0" xmlns:g="http://base.google.com/ns/1.0">
  <channel>
    <title>GemWorkers — ${country}</title>
    <link>${SITE_URL}</link>
    <description>Natural gemstones, mineral specimens and jewellery from GemWorkers</description>
${items.join('\n')}
  </channel>
</rss>
`
  return new Response(xml, { headers: { 'Content-Type': 'application/xml; charset=utf-8', 'Cache-Control': 'public, max-age=3600' } })
}
