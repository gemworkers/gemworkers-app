// SERVER ONLY — the buyer's currency, for an "≈ $380" hint next to euro prices.
// One currency inside GemWorkers: euros. Buyers outside the euro pay in their
// own currency through Stripe Adaptive Pricing (Stripe converts at checkout).
// Rates: the European Central Bank's daily reference rates, refreshed every 12 hours.

import { cache } from 'react'
import { currentShipToCode } from '@/lib/ship-to'
import type { FxContext } from '@/lib/price-shown'

const ECB_URL = 'https://www.ecb.europa.eu/stats/eurofxref/eurofxref-daily.xml'

// Ship-to country → currency. Countries not listed: euro countries show no
// conversion; everyone else sees US dollars.
const CURRENCY: Record<string, string> = {
  US: 'USD', GB: 'GBP', CH: 'CHF', LI: 'CHF', NO: 'NOK', SE: 'SEK', DK: 'DKK', IS: 'ISK',
  PL: 'PLN', CZ: 'CZK', HU: 'HUF', RO: 'RON', TR: 'TRY',
  AU: 'AUD', NZ: 'NZD', CA: 'CAD', JP: 'JPY', CN: 'CNY', HK: 'HKD', SG: 'SGD',
  IL: 'ILS', IN: 'INR', KR: 'KRW', MX: 'MXN', MY: 'MYR', PH: 'PHP', TH: 'THB',
  ZA: 'ZAR', ID: 'IDR', BR: 'BRL',
  AE: 'AED', SA: 'SAR', QA: 'QAR', BH: 'BHD', OM: 'OMR',
}

// Euro users: no conversion shown.
const EURO = new Set([
  'AT', 'BE', 'BG', 'CY', 'DE', 'EE', 'ES', 'FI', 'FR', 'GR', 'HR', 'IE', 'IT', 'LT', 'LU', 'LV',
  'MT', 'NL', 'PT', 'SI', 'SK', 'AD', 'MC', 'SM', 'VA', 'ME', 'XK',
])

// Gulf currencies are fixed to the US dollar (official pegs).
const USD_PEG: Record<string, number> = { AED: 3.6725, SAR: 3.75, QAR: 3.64, BHD: 0.376, OMR: 0.3845 }

const getRates = cache(async (): Promise<Record<string, number> | null> => {
  try {
    const res = await fetch(ECB_URL, { next: { revalidate: 43200 } })
    if (!res.ok) return null
    const xml = await res.text()
    const rates: Record<string, number> = {}
    for (const m of xml.matchAll(/currency='([A-Z]{3})'\s+rate='([0-9.]+)'/g)) rates[m[1]] = Number(m[2])
    return rates.USD ? rates : null
  } catch (e) {
    console.error('[fx] ECB rates not loaded:', e instanceof Error ? e.message : String(e))
    return null
  }
})

/** The buyer's currency and rate (1 EUR = rate), or null for euro buyers / no rates. */
export const fxContext = cache(async (): Promise<FxContext | null> => {
  const country = await currentShipToCode()
  if (EURO.has(country)) return null
  const code = CURRENCY[country] ?? 'USD'
  const rates = await getRates()
  if (!rates) return null
  const rate = USD_PEG[code] ? rates.USD * USD_PEG[code] : rates[code]
  return rate ? { code, rate } : null
})
