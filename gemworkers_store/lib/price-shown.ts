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
