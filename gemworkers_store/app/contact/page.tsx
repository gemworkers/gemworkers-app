import { ContentPage } from '@/app/components/ContentPage'
import { ContactForm } from './ContactForm'

type Props = { searchParams: Promise<{ topic?: string }> }

export default async function ContactPage({ searchParams }: Props) {
  const params       = await searchParams
  const initialTopic = typeof params.topic === 'string' ? params.topic : undefined

  return (
    <ContentPage eyebrow="Customer Care" title="Contact Us">
      <p>
        Questions about a stone, an order, or looking for something special? Send us a
        message and we'll get back to you within 1–2 business days.
      </p>

      <div className="not-prose">
        <ContactForm initialTopic={initialTopic} />
        <p style={{
          fontSize: 13, color: '#5A5045', marginTop: 20,
          fontFamily: 'var(--font-inter, system-ui)',
        }}>
          Prefer email? Write to us at{' '}
          <a
            href="mailto:hello@gemworkers.com"
            style={{ color: '#7A5A22', textDecoration: 'none' }}
          >
            hello@gemworkers.com
          </a>
        </p>
      </div>
    </ContentPage>
  )
}
