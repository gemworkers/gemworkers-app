// SERVER ONLY — EU VAT number check (VIES, European Commission).
//
// Sends GemWorkers' own BTW-id as the requester, so VIES returns a
// consultation number — the official proof that the buyer's number was
// checked (kept on buyer_business / orders, sql/order_tax_b2b.sql). The BTW-id
// comes from admin → Taxes & duties → Company details (public_company_info);
// GEMWORKERS_VAT_NUMBER in Vercel overrides it if ever needed.

import { createClient } from '@supabase/supabase-js'

// VAT prefixes of EU member states (Greece uses EL; XI = Northern Ireland goods).
const EU_PREFIXES = new Set([
  'AT', 'BE', 'BG', 'CY', 'CZ', 'DE', 'DK', 'EE', 'EL', 'ES', 'FI', 'FR', 'HR', 'HU',
  'IE', 'IT', 'LT', 'LU', 'LV', 'MT', 'NL', 'PL', 'PT', 'RO', 'SE', 'SI', 'SK', 'XI',
])

// "de 123.456-789" → "DE123456789"
export function normalizeVatNumber(raw: string): string {
  return raw.toUpperCase().replace(/[^A-Z0-9]/g, '')
}

// EU VAT number → its country (ISO code; EL → GR, XI → GB). Null if not EU.
export function euVatCountry(vat: string): string | null {
  const prefix = vat.slice(0, 2)
  if (!EU_PREFIXES.has(prefix)) return null
  return prefix === 'EL' ? 'GR' : prefix === 'XI' ? 'GB' : prefix
}

export type ViesResult =
  | { status: 'valid'; name: string | null; address: string | null; reference: string | null; checkedAt: string }
  | { status: 'invalid' }
  | { status: 'unavailable' }

const VIES_URL = 'https://ec.europa.eu/taxation_customs/vies/rest-api/check-vat-number'

function clean(v: unknown): string | null {
  const s = typeof v === 'string' ? v.trim() : ''
  return s && s !== '---' ? s : null
}

// GemWorkers' BTW-id, cached for 10 minutes (read without the buyer's login).
let requesterCache: { vat: string; at: number } | null = null
async function requesterVat(): Promise<string> {
  const fromEnv = normalizeVatNumber(process.env.GEMWORKERS_VAT_NUMBER ?? '')
  if (fromEnv) return fromEnv
  if (requesterCache && Date.now() - requesterCache.at < 600_000) return requesterCache.vat
  let vat = ''
  try {
    const db = createClient(process.env.NEXT_PUBLIC_SUPABASE_URL!, process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY!)
    const { data } = await db.from('public_company_info').select('vat').maybeSingle()
    vat = normalizeVatNumber((data as { vat: string | null } | null)?.vat ?? '')
  } catch {
    // No requester: VIES still checks the number, just without a consultation number.
  }
  // Only a real EU VAT number (e.g. NL123456789B01) can be the requester.
  if (!euVatCountry(vat) || vat.length < 8) vat = ''
  requesterCache = { vat, at: Date.now() }
  return vat
}

export async function checkVies(vat: string): Promise<ViesResult> {
  const requester = await requesterVat()
  try {
    const res = await fetch(VIES_URL, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({
        countryCode: vat.slice(0, 2),
        vatNumber: vat.slice(2),
        ...(requester.length > 2 && {
          requesterMemberStateCode: requester.slice(0, 2),
          requesterNumber: requester.slice(2),
        }),
      }),
      signal: AbortSignal.timeout(10_000),
      cache: 'no-store',
    })
    const body = await res.json().catch(() => null) as Record<string, unknown> | null
    if (!res.ok || !body || typeof body.valid !== 'boolean') return { status: 'unavailable' }
    if (!body.valid) return { status: 'invalid' }
    return {
      status: 'valid',
      name: clean(body.name),
      address: clean(body.address),
      reference: clean(body.requestIdentifier),
      checkedAt: typeof body.requestDate === 'string' ? body.requestDate : new Date().toISOString(),
    }
  } catch (err) {
    console.error('[vies] check failed:', err instanceof Error ? err.message : String(err))
    return { status: 'unavailable' }
  }
}
