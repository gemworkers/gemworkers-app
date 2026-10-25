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

/** Buyer's currency for approximate prices (lib/fx.ts). 1 EUR = rate. */
export type FxContext = { code: string; rate: number }

/** "≈ US$395" — rounded, display only (buyers pay in EUR). Null when not needed. */
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
