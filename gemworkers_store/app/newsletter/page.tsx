import Link from 'next/link'
import { ContentPage } from '@/app/components/ContentPage'

export const metadata = { title: 'Newsletter · GemWorkers', robots: { index: false } }

// Landing page after the confirmation link (app/newsletter/confirm/route.ts).
export default async function NewsletterPage({ searchParams }: { searchParams: Promise<{ confirmed?: string; invalid?: string }> }) {
  const { confirmed, invalid } = await searchParams
  const title = confirmed ? 'You’re on the list' : invalid ? 'Link not valid' : 'New stones, first'
  return (
    <ContentPage eyebrow="Newsletter" title={title}>
      {confirmed ? (
        <p>Thank you! We&apos;ll email you when new stones arrive. Every email has a link to unsubscribe.</p>
      ) : invalid ? (
        <p>This confirmation link has already been used or is not valid. You can sign up again at the bottom of any page.</p>
      ) : (
        <p>Sign up at the bottom of any page to hear about new stones first.</p>
      )}
      <p><Link href="/" className="pd-link">Continue to the shop</Link></p>
    </ContentPage>
  )
}
