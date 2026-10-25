// Search engines and link previews: titles, descriptions and Google's
// Product data (schema.org JSON-LD) for stone pages. Never includes the
// seller's identity — only "Ships from {country}".

export const SITE_URL = 'https://www.gemworkers.com'

export type SeoStone = {
  id: string
  title: string
  product_type: 'loose_stone' | 'specimen' | 'jewelry'
  description: string | null
  selling_price: number | string | null
  sale_method: string | null
  image_urls: string[] | null
  gem_type: string | null
  variety: string | null
  species?: string | null
  jewelry_type?: string | null
  weight_value: number | string | null
  weight_unit: string | null
  origin_country: string | null
  shape?: string | null
  treatment?: string | null
  certification_lab?: string | null
  status?: string | null
}

const TYPE_WORD: Record<SeoStone['product_type'], string> = {
  loose_stone: 'loose gemstone',
  specimen: 'mineral specimen',
  jewelry: 'jewellery',
}

function weightText(s: SeoStone): string | null {
  const w = Number(s.weight_value ?? 0)
  return w > 0 ? `${Number(w.toFixed(2))} ${s.weight_unit ?? ''}`.trim() : null
}

/** "Rubellite Tourmaline 7.5 ct — Madagascar" (the brand is added by the layout title). */
export function stoneSeoTitle(s: SeoStone): string {
  const parts = [s.title, weightText(s), s.origin_country ? `— ${s.origin_country}` : null]
  return parts.filter(Boolean).join(' ').slice(0, 90)
}

/** One readable sentence, ~155 characters, for Google results and link previews. */
export function stoneSeoDescription(s: SeoStone): string {
  const what = [s.variety, s.gem_type ?? s.species ?? s.jewelry_type].filter(Boolean).join(' ') || TYPE_WORD[s.product_type]
  const facts = [
    weightText(s),
    s.shape ? `${s.shape.toLowerCase()} cut` : null,
    s.origin_country ? `from ${s.origin_country}` : null,
    s.certification_lab ? `certified by ${s.certification_lab}` : null,
  ].filter(Boolean).join(', ')
  const own = (s.description ?? '').replace(/\s+/g, ' ').trim()
  const base = `Natural ${what.toLowerCase()}${facts ? `, ${facts}` : ''}. ${own}`.trim()
  const tail = ' Tracked worldwide shipping and 30-day returns at GemWorkers.'
  const room = 155 - tail.length
  return (base.length > room ? base.slice(0, room - 1).replace(/\s+\S*$/, '') + '…' : base) + tail
}

/** Google Product rich result. Prices in EUR without VAT (as charged outside the EU). */
export function stoneJsonLd(s: SeoStone, shippingCountry?: string | null) {
  const price = s.selling_price == null ? null : Number(s.selling_price)
  const url = `${SITE_URL}/stones/${s.id}`
  const images = (s.image_urls ?? []).filter(Boolean).slice(0, 6)
  const offer =
    price != null && s.sale_method !== 'accept_offers'
      ? {
          '@type': 'Offer',
          url,
          price: price.toFixed(2),
          priceCurrency: 'EUR',
          availability: s.status === 'reserved' ? 'https://schema.org/LimitedAvailability' : 'https://schema.org/InStock',
          itemCondition: 'https://schema.org/NewCondition',
          seller: { '@type': 'Organization', name: 'GemWorkers' },
          ...(shippingCountry && {
            shippingDetails: {
              '@type': 'OfferShippingDetails',
              shippingOrigin: { '@type': 'DefinedRegion', addressCountry: shippingCountry },
            },
          }),
          hasMerchantReturnPolicy: {
            '@type': 'MerchantReturnPolicy',
            returnPolicyCategory: 'https://schema.org/MerchantReturnFiniteReturnWindow',
            merchantReturnDays: 30,
            returnMethod: 'https://schema.org/ReturnByMail',
            returnFees: 'https://schema.org/ReturnShippingFees',
          },
        }
      : undefined

  return {
    '@context': 'https://schema.org',
    '@type': 'Product',
    name: s.title,
    description: stoneSeoDescription(s),
    url,
    ...(images.length > 0 && { image: images }),
    brand: { '@type': 'Brand', name: 'GemWorkers' },
    category: TYPE_WORD[s.product_type],
    ...(s.origin_country && { countryOfOrigin: s.origin_country }),
    ...(offer && { offers: offer }),
  }
}
