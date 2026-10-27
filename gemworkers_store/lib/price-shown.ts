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

/** Buyer's currency (lib/fx.ts), display only: 1 EUR = rate. GemWorkers
 *  prices, offers and records are always euros; Stripe (Adaptive Pricing)
 *  shows and charges the exact amount in the buyer's currency at payment. */
export type FxContext = { code: string; rate: number }

/** "€349" — every GemWorkers price is in euros. */
export function priceText(eur: number): string {
  return formatMoney(eur, 'EUR')
}

/** "≈ $380" — rounded, display only. Null for euro buyers. */
export function approxPrice(eur: number, fx: FxContext | null | undefined): string | null {
  if (!fx || !(eur > 0)) return null
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
