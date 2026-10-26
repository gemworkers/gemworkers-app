import { ContentPage } from '@/app/components/ContentPage'
import { UnsubscribeButton } from './UnsubscribeButton'

export const metadata = { title: 'Unsubscribe · GemWorkers', robots: { index: false } }

// Link in every newsletter email: ?token=<unsubscribe_token>. A button (not the
// link itself) unsubscribes, so email scanners opening links don't.
export default async function UnsubscribePage({ searchParams }: { searchParams: Promise<{ token?: string }> }) {
  const { token } = await searchParams
  return (
    <ContentPage eyebrow="Newsletter" title="Unsubscribe">
      <p>Don&apos;t want our emails about new stones anymore? Click below and you won&apos;t get them again.</p>
      <UnsubscribeButton token={token ?? ''} />
    </ContentPage>
  )
}
