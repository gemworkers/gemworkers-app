// SERVER ONLY — not a server action (must not be callable from the browser).

import { createAdminClient } from '@/lib/supabase/admin'
import { checkVies } from '@/lib/vies'

// At checkout: re-check an EU VAT number in VIES when the last check is more
// than 7 days old (the tax rules accept a check up to 30 days old). Never
// throws; if VIES doesn't answer the old result stays until it expires.
export async function refreshBusinessCheck(buyerId: string): Promise<void> {
  const admin = createAdminClient()
  const { data } = await admin
    .from('buyer_business')
    .select('vat_number, vat_country, vies_checked_at')
    .eq('buyer_id', buyerId)
    .maybeSingle()
  const b = data as { vat_number: string | null; vat_country: string | null; vies_checked_at: string | null } | null
  if (!b?.vat_number || !b.vat_country) return
  const age = b.vies_checked_at ? Date.now() - new Date(b.vies_checked_at).getTime() : Infinity
  if (age < 7 * 24 * 60 * 60 * 1000) return

  const check = await checkVies(b.vat_number)
  if (check.status === 'unavailable') return
  await admin.from('buyer_business').update(
    check.status === 'valid'
      ? { vies_valid: true, vies_name: check.name, vies_address: check.address,
          vies_reference: check.reference, vies_checked_at: check.checkedAt, updated_at: new Date().toISOString() }
      : { vies_valid: false, vies_reference: null, vies_checked_at: new Date().toISOString(), updated_at: new Date().toISOString() },
  ).eq('buyer_id', buyerId)
}
