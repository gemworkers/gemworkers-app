// Prices shown to EU consumers must include VAT (EU Price Indication
// Directive / Dutch price rules). We only charge VAT when the stone ships from
// inside the EU to an EU buyer (sql/order_tax.sql), so only then is the shown
// price "incl. VAT". Everyone else — and verified EU businesses (reverse
// charge) — sees the price without VAT, as charged.
// The checkout calculation stays the single source of truth; this is display.

import { cache } from 'react'
import { createClient } from '@/lib/supabase/server'
import { createAdminClient } from '@/lib/supabase/admin'
import { currentShipToCode } from '@/lib/ship-to'
import type { PriceContext } from '@/lib/price-shown'

export type { PriceContext }

/** Null = show prices without VAT. One lookup per request. */
export const priceContext = cache(async (): Promise<PriceContext | null> => {
  const supabase = await createClient()
  const code = await currentShipToCode()

  const { data: rule } = await supabase
    .from('tax_rules')
    .select('mode, tax_rate, customs_union')
    .eq('country_code', code)
    .maybeSingle()
  const r = rule as { mode: string; tax_rate: string | number | null; customs_union: string | null } | null
  if (!r || r.mode !== 'collect' || r.tax_rate == null || !r.customs_union) return null

  // A verified EU business in another country pays 0% (reverse charge).
  const { data: { user } } = await supabase.auth.getUser()
  if (user) {
    const { data: biz } = await supabase
      .from('buyer_business')
      .select('vies_valid, vat_country, vies_checked_at')
      .maybeSingle()
    const b = biz as { vies_valid: boolean; vat_country: string | null; vies_checked_at: string | null } | null
    const fresh = b?.vies_checked_at && Date.now() - new Date(b.vies_checked_at).getTime() < 30 * 24 * 60 * 60 * 1000
    if (b?.vies_valid && fresh && b.vat_country === code) return { rate: 0, country: '', origins: [] }
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
})
