import { formatMoney } from './money'

// Display only (server and browser). See lib/display-price.ts for when VAT is included.

/** Serializable — passed to client components (StoneGrid). */
export type PriceContext = {
  rate: number          // buyer's country VAT, e.g. 0.21
  country: string       // buyer's country name, e.g. "Netherlands"
  origins: string[]     // ship-from countries that trigger VAT (same customs union)
  // Verified EU business (reverse charge): the Dutch VAT inside the price is
  // taken off for them (sql/vat_included_prices.sql), so they see the net price.
  strip?: number
  // Buyer outside the EU: EU stones without the VAT inside them, rounded up
  // (sql/non_eu_net_prices.sql — same rule as _net_price_round).
  exportRate?: number
}

/** Price without VAT, rounded up: to the next €10 (below €20: next €1). */
export function netRound(net: number): number {
  const cents = Math.round(net * 100)
  return cents >= 2000 ? Math.ceil(cents / 1000) * 10 : Math.ceil(cents / 100)
}

/** The amount to show for a price (stone or shipping) of a stone shipped from
 *  [shipsFrom]. One price for everyone, VAT included (sql/vat_included_prices.sql):
 *  the amount is the entered price; inclVat says whether VAT is inside it. */
export function shownPrice(
  amount: number, shipsFrom: string | null | undefined, ctx: PriceContext | null,
  kind: 'price' | 'shipping' = 'price',
) {
  const inUnion = !!ctx && !!shipsFrom && ctx.origins.includes(shipsFrom)
  if (inUnion && ctx!.exportRate && ctx!.exportRate > 0) {
    const net = Math.round(amount / (1 + ctx!.exportRate) * 100) / 100
    return { amount: amount <= 0 ? 0 : kind === 'shipping' ? Math.ceil(Math.round(net * 100) / 100) : netRound(net), inclVat: false }
  }
  if (inUnion && ctx!.strip && ctx!.strip > 0) {
    return { amount: Math.round(amount / (1 + ctx!.strip) * 100) / 100, inclVat: false }
  }
  return { amount, inclVat: inUnion && ctx!.rate > 0 }
}

/** The VAT already inside a price, e.g. €121 at 21% → €21. */
export function vatInside(gross: number, rate: number): number {
  return rate > 0 ? Math.round(gross * rate / (1 + rate) * 100) / 100 : 0
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
