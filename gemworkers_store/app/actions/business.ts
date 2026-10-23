'use server'

import { revalidatePath } from 'next/cache'
import { createClient } from '@/lib/supabase/server'
import { createAdminClient } from '@/lib/supabase/admin'
import { checkVies, euVatCountry, normalizeVatNumber } from '@/lib/vies'

// Business details for a buyer (sql/order_tax_b2b.sql). Only the server writes
// buyer_business, so "verified" always comes from a real VIES check.

export type SaveBusinessResult =
  | { ok: true; message: string; verified: boolean }
  | { error: string }

export async function saveBusinessDetails(companyRaw: string, vatRaw: string): Promise<SaveBusinessResult> {
  const supabase = await createClient()
  const { data: { user } } = await supabase.auth.getUser()
  if (!user) return { error: 'Please log in first.' }

  const company = companyRaw.trim().replace(/\s+/g, ' ')
  if (!company) return { error: 'Please enter your company name.' }
  if (company.length > 200) return { error: 'The company name is too long.' }

  const vat = normalizeVatNumber(vatRaw)
  if (vat && !/^[A-Z0-9]{4,20}$/.test(vat)) return { error: 'This VAT number doesn’t look right.' }

  const vatCountry = vat ? euVatCountry(vat) : null
  let row: Record<string, unknown> = {
    buyer_id: user.id,
    company_name: company,
    vat_number: vat || null,
    vat_country: vatCountry,
    vies_valid: false,
    vies_name: null,
    vies_address: null,
    vies_reference: null,
    vies_checked_at: null,
    updated_at: new Date().toISOString(),
  }
  let message: string
  let verified = false

  if (!vat) {
    message = 'Saved. Your company name will appear on your orders.'
  } else if (!vatCountry) {
    // Outside the EU (e.g. UK, US, Switzerland): kept for invoices, no VIES.
    message = 'Saved. Your company and tax number will appear on your orders.'
  } else {
    const check = await checkVies(vat)
    if (check.status === 'invalid') {
      return { error: 'The EU VAT register (VIES) says this VAT number is not valid. Please check it.' }
    }
    if (check.status === 'unavailable') {
      message = 'Saved, but the EU VAT register (VIES) is not answering right now. Until it confirms your number, VAT is charged as for private buyers — please try again later.'
    } else {
      verified = true
      row = {
        ...row,
        vies_valid: true,
        vies_name: check.name,
        vies_address: check.address,
        vies_reference: check.reference,
        vies_checked_at: check.checkedAt,
      }
      message = `Verified in the EU VAT register${check.name ? `: ${check.name}` : ''}.`
    }
  }

  const admin = createAdminClient()
  const { error } = await admin.from('buyer_business').upsert(row, { onConflict: 'buyer_id' })
  if (error) {
    console.error('[saveBusinessDetails] save failed:', error.message)
    return { error: 'Could not save — please try again.' }
  }
  revalidatePath('/business')
  return { ok: true, message, verified }
}

export async function removeBusinessDetails(): Promise<{ ok: true } | { error: string }> {
  const supabase = await createClient()
  const { data: { user } } = await supabase.auth.getUser()
  if (!user) return { error: 'Please log in first.' }
  const { error } = await createAdminClient().from('buyer_business').delete().eq('buyer_id', user.id)
  if (error) return { error: 'Could not remove — please try again.' }
  revalidatePath('/business')
  return { ok: true }
}
