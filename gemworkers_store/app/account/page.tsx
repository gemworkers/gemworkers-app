import Link from 'next/link'
import { redirect } from 'next/navigation'
import { createClient } from '@/lib/supabase/server'
import { ContentPage } from '@/app/components/ContentPage'
import { NameForm, EmailForm, PasswordForm, DeleteForm } from './AccountForms'

export const metadata = { title: 'My account · GemWorkers' }

const section = { borderTop: '1px solid #ECE5D8', paddingTop: 24, marginTop: 28 } as const

export default async function AccountPage({ searchParams }: { searchParams: Promise<{ email?: string }> }) {
  const { email: emailFlag } = await searchParams
  const supabase = await createClient()
  const { data: { user } } = await supabase.auth.getUser()
  if (!user) redirect('/auth/login?next=%2Faccount')

  const [{ data: buyer }, { data: biz }] = await Promise.all([
    supabase.from('buyers').select('display_name').eq('id', user.id).maybeSingle(),
    supabase.from('buyer_business').select('company_name, vat_number, vies_valid').maybeSingle(),
  ])
  const name = (buyer as { display_name: string | null } | null)?.display_name ?? ''
  const b = biz as { company_name: string; vat_number: string | null; vies_valid: boolean } | null

  return (
    <ContentPage eyebrow="Your account" title="My account">
      {emailFlag === 'changed' && (
        <p style={{ color: '#2F6B3B' }}>Your email address has been changed.</p>
      )}

      <p>
        <Link href="/orders" className="pd-link">My orders</Link> ·{' '}
        <Link href="/messages" className="pd-link">Messages</Link>
      </p>

      <section style={section}>
        <h2>Your name</h2>
        <NameForm initial={name} />
      </section>

      <section style={section}>
        <h2>Email</h2>
        <EmailForm current={user.email ?? ''} />
      </section>

      <section style={section}>
        <h2>Password</h2>
        <PasswordForm />
      </section>

      <section style={section}>
        <h2>Buying for a business</h2>
        <p>
          {b
            ? <>{b.company_name}{b.vat_number ? ` · VAT ${b.vat_number}` : ''} — {b.vies_valid ? '✓ verified' : 'not verified'}. </>
            : 'Add your company and VAT number so they appear on your invoices. '}
          <Link href="/business" className="pd-link">{b ? 'Change business details' : 'Add business details'}</Link>
        </p>
      </section>

      <section style={section}>
        <h2>Delete account</h2>
        <DeleteForm />
      </section>
    </ContentPage>
  )
}
