import Link from 'next/link'
import { redirect } from 'next/navigation'
import { createClient } from '@/lib/supabase/server'
import { ContentPage } from '@/app/components/ContentPage'
import { BusinessForm } from './BusinessForm'

export const metadata = { title: 'Buying for a business · GemWorkers' }

type BusinessRow = {
  company_name: string
  vat_number: string | null
  vat_country: string | null
  vies_valid: boolean
  vies_name: string | null
  vies_checked_at: string | null
}

// Business details (sql/order_tax_b2b.sql). The buyer reads their own row;
// saving goes through app/actions/business.ts (server + VIES check).
export default async function BusinessPage() {
  const supabase = await createClient()
  const { data: { user } } = await supabase.auth.getUser()
  if (!user) redirect('/auth/login?next=%2Fbusiness')

  const { data } = await supabase
    .from('buyer_business')
    .select('company_name, vat_number, vat_country, vies_valid, vies_name, vies_checked_at')
    .maybeSingle()
  const b = data as BusinessRow | null

  return (
    <ContentPage eyebrow="Your account" title="Buying for a business">
      <p>
        Add your company details and they appear on your orders and invoices. Business
        buyers in the EU outside the Netherlands with a valid VAT number pay{' '}
        <strong>0% VAT</strong> on stones shipped from the Netherlands — the VAT is
        &ldquo;reverse charged&rdquo; and you declare it in your own VAT return.
      </p>
      <p>
        We check EU VAT numbers in the European Commission&apos;s VAT register (VIES). Until
        your number is confirmed, VAT is charged as for private buyers. Businesses outside
        the EU can add their company and tax number for their records.
      </p>

      {b && (
        <p style={{ fontSize: 15, lineHeight: 1.6 }}>
          <strong>Status:</strong>{' '}
          {b.vat_country
            ? b.vies_valid
              ? `✓ VAT number verified${b.vies_name ? ` — ${b.vies_name}` : ''}`
              : 'VAT number not confirmed yet — VAT is charged as for private buyers'
            : 'Company saved'}
        </p>
      )}

      <BusinessForm
        initialCompany={b?.company_name ?? ''}
        initialVat={b?.vat_number ?? ''}
        hasDetails={!!b}
      />

      <p style={{ fontSize: 14, marginTop: 28 }}>
        <Link href="/cart" className="pd-link">Back to cart</Link>
      </p>
    </ContentPage>
  )
}
