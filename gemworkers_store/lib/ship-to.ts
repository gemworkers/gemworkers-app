// SERVER ONLY — ship-to country (tax & duties plan, step 1).
// The buyer's chosen country lives in the gw_ship_to cookie (set by the
// header chooser). First visit: Vercel's IP country header, else US.
// public.shipping_countries (sql/shipping_countries.sql) says where we ship.
import { cookies, headers } from 'next/headers'
import type { SupabaseClient } from '@supabase/supabase-js'

export const SHIP_TO_COOKIE = 'gw_ship_to'
const CODE_RE = /^[A-Z]{2}$/

export type ShipCountry = {
  code: string
  name: string
  region: string
  enabled: boolean
}

export async function currentShipToCode(): Promise<string> {
  const fromCookie = (await cookies()).get(SHIP_TO_COOKIE)?.value?.toUpperCase()
  if (fromCookie && CODE_RE.test(fromCookie)) return fromCookie
  const fromIp = (await headers()).get('x-vercel-ip-country')?.toUpperCase()
  if (fromIp && CODE_RE.test(fromIp)) return fromIp
  return 'US'
}

export async function loadShipCountries(supabase: SupabaseClient): Promise<ShipCountry[]> {
  const { data } = await supabase
    .from('shipping_countries')
    .select('code, name, region, enabled')
    .order('sort_order')
    .order('name')
  return (data ?? []) as ShipCountry[]
}

// Checkout guard: the chosen country must be one we ship to. Stripe is then
// told to accept only that country, so the address always matches.
export async function checkoutShipTo(
  supabase: SupabaseClient,
): Promise<{ code: string; name: string } | { error: string }> {
  const code = await currentShipToCode()
  const { data } = await supabase
    .from('shipping_countries')
    .select('code, name, enabled')
    .eq('code', code)
    .maybeSingle()
  const row = data as { code: string; name: string; enabled: boolean } | null
  if (!row || !row.enabled) {
    const name = row?.name ?? code
    return {
      error: `We don't ship to ${name}. Please choose another "Ship to" country at the top of the page, or contact us at hello@gemworkers.com.`,
    }
  }
  return { code: row.code, name: row.name }
}
