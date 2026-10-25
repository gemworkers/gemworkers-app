import { formatMoney } from './money'

// Display only (server and browser). See lib/display-price.ts for when VAT is included.

/** Serializable — passed to client components (StoneGrid). */
export type PriceContext = {
  rate: number          // buyer's country VAT, e.g. 0.21
  country: string       // buyer's country name, e.g. "Netherlands"
  origins: string[]     // ship-from countries that trigger VAT (same customs union)
}

/** The amount to show for a price (stone or shipping) of a stone shipped from [shipsFrom]. */
export function shownPrice(amount: number, shipsFrom: string | null | undefined, ctx: PriceContext | null) {
  const incl = !!ctx && ctx.rate > 0 && !!shipsFrom && ctx.origins.includes(shipsFrom)
  return {
    amount: incl ? Math.round(amount * (1 + ctx!.rate) * 100) / 100 : amount,
    inclVat: incl,
  }
}

/** Buyer's currency (lib/fx.ts). 1 EUR = rate. exact = the buyer sees and
 *  pays local prices (USD, GBP, AUD, CAD); otherwise only an "≈" hint. */
export type FxContext = { code: string; rate: number; exact: boolean }

// Local prices: euro × ECB rate × 1.02, rounded UP — below 50 to a whole
// number, from 50 to the next 5 or 0. MUST match public._local_price (SQL,
// sql/local_currency.sql), which sets what checkout charges.
export const LOCAL_MARKUP = 0.02

export function localPrice(eur: number, rate: number): number {
  if (!(eur > 0)) return 0
  // Snap float noise (49.999999 → 50) before rounding up, like exact numeric.
  const v = Math.round(eur * rate * (1 + LOCAL_MARKUP) * 1e6) / 1e6
  return v < 50 ? Math.ceil(v) : Math.ceil(v / 5) * 5
}

/** The amount in the buyer's own currency when they pay in it, else the euro amount. */
export function displayAmount(eur: number, fx: FxContext | null | undefined): number {
  return fx?.exact ? localPrice(eur, fx.rate) : eur
}

/** "$395" for a US buyer, "€349" otherwise. */
export function priceText(eur: number, fx: FxContext | null | undefined): string {
  return formatMoney(displayAmount(eur, fx), fx?.exact ? fx.code : 'EUR')
}

/** "$", "£", "A$", "C$" or "€" — for labels like "Price from $". */
export function currencySymbol(fx: FxContext | null | undefined): string {
  const symbols: Record<string, string> = { USD: '$', GBP: '£', AUD: 'A$', CAD: 'C$' }
  return symbols[fx?.exact ? fx.code : ''] ?? '€'
}

/** "≈ US$395" — rounded, display only (buyers pay in EUR). Null when not needed. */
export function approxPrice(eur: number, fx: FxContext | null | undefined): string | null {
  if (!fx || fx.exact || !(eur > 0)) return null
  const v = eur * fx.rate
  const digits = v >= 100 ? 0 : 2
  try {
    return '≈ ' + new Intl.NumberFormat('en-GB', {
      style: 'currency', currency: fx.code, currencyDisplay: 'symbol',
      maximumFractionDigits: digits, minimumFractionDigits: digits,
    }).format(digits === 0 ? Math.round(v) : v)
  } catch {
    return `≈ ${Math.round(v)} ${fx.code}`
  }
}
