// SERVER ONLY — prices in the buyer's currency. Rates: the European Central
// Bank's daily reference rates, refreshed every 12 hours.
// • US, UK, Australia, Canada: buyers SEE AND PAY local prices (Etsy style,
//   sql/local_currency.sql locks the currency per order at checkout).
// • Other non-euro countries: an "≈" hint; Stripe Adaptive Pricing (ON) lets
//   them pay in their own currency at checkout (Stripe converts our euro price).

import { cache } from 'react'
import { currentShipToCode } from '@/lib/ship-to'
import type { FxContext } from '@/lib/price-shown'
import { createAdminClient } from '@/lib/supabase/admin'

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

// Ship-to countries that see and pay their own currency.
const EXACT: Record<string, string> = { US: 'USD', GB: 'GBP', AU: 'AUD', CA: 'CAD' }

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
  return rate ? { code, rate, exact: EXACT[country] === code } : null
})

/** Offers: the buyer's currency for the current "Ship to" (US/GB/AU/CA), or
 *  null = offer in EUR. Saves today's rate to fx_rates first — the database
 *  converts the offer with that rate (sql/offers_local_currency.sql). */
export async function offerCurrencyNow(): Promise<{ code: string; rate: number } | null> {
  const cc = await chargeCurrencyFor(await currentShipToCode())
  if (!cc) return null
  const { error } = await createAdminClient()
    .from('fx_rates')
    .upsert({ currency: cc.code, rate: cc.rate, updated_at: new Date().toISOString() })
  if (error) {
    console.error('[fx] rate not saved for offers:', error.message)
    return null
  }
  return cc
}

/** Checkout: the currency and rate to charge an order shipped to [country]
 *  in (same rates as the prices shown), or null = charge in EUR. */
export async function chargeCurrencyFor(country: string): Promise<{ code: string; rate: number } | null> {
  const code = EXACT[country]
  if (!code) return null
  const rates = await getRates()
  const rate = rates?.[code]
  return rate ? { code, rate } : null
}
