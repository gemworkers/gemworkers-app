// SERVER ONLY — GemWorkers' public company details (sql/public_company_info.sql),
// edited by the owner in admin → Taxes & duties → Company details. The same
// details go on every invoice, so the legal pages never disagree with them.

import { cache } from 'react'
import { createClient } from '@/lib/supabase/server'

export type CompanyInfo = {
  name: string
  address: string | null
  kvk: string | null
  vat: string | null
  eori: string | null
  email: string
}

export const companyInfo = cache(async (): Promise<CompanyInfo> => {
  const supabase = await createClient()
  const { data } = await supabase.from('public_company_info').select('*').maybeSingle()
  const c = data as Partial<CompanyInfo> | null
  return {
    name: c?.name || 'GemWorkers',
    address: c?.address || null,
    kvk: c?.kvk || null,
    vat: c?.vat || null,
    eori: c?.eori || null,
    email: c?.email || 'hello@gemworkers.com',
  }
})
