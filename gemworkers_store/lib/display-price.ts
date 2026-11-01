// One price for everyone, VAT included (sql/vat_included_prices.sql, option B
// 2026-11-01): the price entered is what every buyer pays. Where we must charge
// VAT (stone ships from inside the EU to an EU consumer) it is inside that
// price and the store says "incl. VAT". Verified EU businesses (reverse charge)
// see — and pay — the price minus the Dutch VAT inside it.
// The checkout calculation stays the single source of truth; this is display.

import { cache } from 'react'
import { createClient } from '@/lib/supabase/server'
import { createAdminClient } from '@/lib/supabase/admin'
import { currentShipToCode } from '@/lib/ship-to'
import type { PriceContext } from '@/lib/price-shown'

export type { PriceContext }

/** Null = show prices without VAT. One lookup per request. */
export const priceContext = cache(async (): Promise<PriceContext | null> =>
  priceContextFor(await currentShipToCode(), true))

/** The same for a given ship-to country (the Google feed asks per country;
 *  withBusiness = false skips the logged-in buyer's VAT-number check). */
export async function priceContextFor(code: string, withBusiness: boolean): Promise<PriceContext | null> {
  const supabase = await createClient()

  const { data: rule } = await supabase
    .from('tax_rules')
    .select('mode, tax_rate, customs_union')
    .eq('country_code', code)
    .maybeSingle()
  const r = rule as { mode: string; tax_rate: string | number | null; customs_union: string | null } | null
  if (!r || r.mode !== 'collect' || r.tax_rate == null || r.customs_union !== 'EU') {
    // Buyer outside the EU: EU (NL) stones without their VAT, rounded up
    // (sql/non_eu_net_prices.sql). Business status doesn't matter: no VAT anyway.
    const [{ data: eu }, { data: nlx }] = await Promise.all([
      supabase.from('tax_rules').select('country_code').eq('customs_union', 'EU'),
      supabase.from('tax_rules').select('tax_rate').eq('country_code', 'NL').maybeSingle(),
    ])
    const rate = Number((nlx as { tax_rate: string | number | null } | null)?.tax_rate ?? 0)
    if (!(rate > 0)) return null
    return { rate: 0, country: '', origins: ((eu as { country_code: string }[] | null) ?? []).map(x => x.country_code), exportRate: rate }
  }

  // A verified EU business in another country pays 0% (reverse charge).
  const { data: { user } } = withBusiness ? await supabase.auth.getUser() : { data: { user: null } }
  if (user) {
    const { data: biz } = await supabase
      .from('buyer_business')
      .select('vies_valid, vat_country, vies_checked_at')
      .maybeSingle()
    const b = biz as { vies_valid: boolean; vat_country: string | null; vies_checked_at: string | null } | null
    const fresh = b?.vies_checked_at && Date.now() - new Date(b.vies_checked_at).getTime() < 30 * 24 * 60 * 60 * 1000
    if (b?.vies_valid && fresh && b.vat_country === code) {
      const [{ data: u }, { data: nlb }] = await Promise.all([
        supabase.from('tax_rules').select('country_code').eq('customs_union', r.customs_union),
        supabase.from('tax_rules').select('tax_rate').eq('country_code', 'NL').maybeSingle(),
      ])
      return {
        rate: 0, country: '',
        origins: ((u as { country_code: string }[] | null) ?? []).map(x => x.country_code),
        strip: Number((nlb as { tax_rate: string | number | null } | null)?.tax_rate ?? 0),
      }
    }
  }

  const [{ data: union }, { data: country }, { data: ossStart }, { data: nl }] = await Promise.all([
    supabase.from('tax_rules').select('country_code').eq('customs_union', r.customs_union),
    supabase.from('shipping_countries').select('name').eq('code', code).maybeSingle(),
    createAdminClient().from('store_settings').select('value').eq('key', 'oss_start_date').maybeSingle(),
    supabase.from('tax_rules').select('tax_rate').eq('country_code', 'NL').maybeSingle(),
  ])
  // Before the OSS start date, EU stones (all ship from NL) to another EU
  // country carry the Dutch rate — same rule as _tax_calc (sql/oss_start_date.sql).
  const start = (ossStart as { value: string | null } | null)?.value
  const today = new Date().toLocaleDateString('sv-SE', { timeZone: 'Europe/Amsterdam' })   // YYYY-MM-DD
  const nlRate = (nl as { tax_rate: string | number | null } | null)?.tax_rate
  const beforeOss = code !== 'NL' && !!start && today < start && nlRate != null
  return {
    rate: beforeOss ? Number(nlRate) : Number(r.tax_rate),
    country: (country as { name: string } | null)?.name ?? code,
    origins: ((union as { country_code: string }[] | null) ?? []).map(u => u.country_code),
  }
}
