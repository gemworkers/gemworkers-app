import type { SupabaseClient } from '@supabase/supabase-js'
import { formatEur } from '@/lib/money'
import { priceText } from '@/lib/price-shown'

// Tax at checkout (sql/order_tax.sql). We only collect VAT that the law
// requires (stone ships from NL to an EU buyer); everywhere else the buyer
// pays import tax/duty on delivery and we only show an estimate as a reminder.

export type TaxScheme = 'domestic' | 'oss' | 'reverse_charge' | 'buyer_pays' | 'none'

export type TaxQuote = {
  scheme: TaxScheme
  taxName: string | null
  taxRate: number | null
  taxAmount: number
  importEstimate: number | null
  minOrderEur: number | null
  goodsTotal: number
}

// Messages raised by apply_order_tax that are safe to show the buyer.
const BUYER_MESSAGES = [/^Orders shipped to .+ must be at least/, /^We don't ship to this country/]

// 0.19 → "19", 0.255 → "25.5"
export function ratePercent(rate: number): string {
  return String(Number((rate * 100).toFixed(2)))
}

// Display quote for one stone (listed price + its shipping). Null if unavailable.
export async function taxQuote(
  supabase: SupabaseClient,
  itemId: string,
  shipTo: string,
): Promise<TaxQuote | null> {
  const { data, error } = await supabase.rpc('tax_quote', { p_item_id: itemId, p_ship_to: shipTo })
  const row = Array.isArray(data) ? data[0] : null
  if (error || !row) return null
  const num = (v: unknown) => (v == null ? null : Number(v))
  return {
    scheme: row.scheme as TaxScheme,
    taxName: row.tax_name ?? null,
    taxRate: num(row.tax_rate),
    taxAmount: Number(row.tax_amount ?? 0),
    importEstimate: num(row.import_estimate),
    minOrderEur: num(row.min_order_eur),
    goodsTotal: Number(row.goods_total ?? 0),
  }
}

// Stamps the buyer's pending orders with the tax for the ship-to country.
// The amount to charge is then read back from orders.tax_amount.
export async function applyOrderTax(
  supabase: SupabaseClient,
  orderIds: string[],
  shipTo: string,
): Promise<{ ok: true } | { error: string }> {
  const { error } = await supabase.rpc('apply_order_tax', { p_order_ids: orderIds, p_ship_to: shipTo })
  if (!error) return { ok: true }
  if (BUYER_MESSAGES.some(re => re.test(error.message))) return { error: error.message }
  console.error('[applyOrderTax] failed:', error.message)
  return { error: 'Payment setup failed — please try again.' }
}

type OrderTaxRow = { tax_amount: string | number | null; tax_name: string | null; tax_rate: string | number | null }

type OrderBuyerRow = { tax_scheme: string | null; buyer_company: string | null; buyer_vat_number: string | null }

/** Note above Stripe's Pay button: reverse charge for a verified EU business,
 *  or the neutral import-duties line when the buyer pays those on delivery. */
export function checkoutText(orders: OrderBuyerRow[]): { submit: { message: string } } | undefined {
  const o = orders.find(x => x.tax_scheme === 'reverse_charge')
  if (o) return { submit: { message: `VAT reverse charged (intra-EU supply, 0% VAT) — ${o.buyer_company ?? 'your business'}, VAT ${o.buyer_vat_number ?? ''}`.trim() } }
  if (orders.some(x => x.tax_scheme === 'buyer_pays')) {
    return { submit: { message: 'Import duties and taxes may be charged by your country on delivery.' } }
  }
  return undefined
}

// Stripe line item for the collected VAT, or null when there is none.
export function vatLineItem(order: OrderTaxRow, countryName: string) {
  const cents = Math.round(Number(order.tax_amount ?? 0) * 100)
  if (!Number.isInteger(cents) || cents <= 0) return null
  const rate = order.tax_rate == null ? null : Number(order.tax_rate)
  const label = `${order.tax_name || 'VAT'}${rate != null ? ` ${ratePercent(rate)}%` : ''} (${countryName})`
  return {
    quantity: 1,
    price_data: { currency: 'eur', unit_amount: cents, product_data: { name: label } },
  }
}

// What the buyer paid for one order: goods + shipping + collected VAT.
// Summed in cents so it never drifts.
export function paidTotal(orderTotal: string | number | null, taxAmount: string | number | null): number {
  return (Math.round(Number(orderTotal ?? 0) * 100) + Math.round(Number(taxAmount ?? 0) * 100)) / 100
}

// The one line buyers see under the price (stone page, cart).
// hasPrice = false for "Make an offer" stones: no amounts, just the rule.
export function taxNote(
  q: TaxQuote | null,
  countryName: string,
  hasPrice: boolean,
): { text: string; warn: boolean } | null {
  if (!q) return null
  const money = (v: number) => priceText(v)
  if (hasPrice && q.minOrderEur != null && q.goodsTotal < q.minOrderEur) {
    return { text: `Orders shipped to ${countryName} must be at least ${money(q.minOrderEur)}.`, warn: true }
  }
  if (q.scheme === 'reverse_charge') {
    return { text: `0% VAT — reverse charge for your verified business (${countryName})`, warn: false }
  }
  if ((q.scheme === 'domestic' || q.scheme === 'oss') && q.taxRate != null) {
    const name = q.taxName || 'VAT'
    return hasPrice
      ? { text: `Includes ${formatEur(q.taxAmount)} ${name} (${ratePercent(q.taxRate)}%) for ${countryName} · total ${formatEur(paidTotal(q.goodsTotal, q.taxAmount))} with shipping`, warn: false }
      : { text: `Offers are before ${name} — ${ratePercent(q.taxRate)}% ${name} for ${countryName} is added at checkout`, warn: false }
  }
  // Import duties the buyer pays on delivery: no note on stone page or cart
  // (Zakaria 2026-10-30, like Etsy / Gemrock) — one neutral line on Stripe's
  // payment page instead (checkoutText) and the full story on /shipping.
  return null
}
