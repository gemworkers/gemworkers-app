'use server'

import { sendContactEmail } from '@/lib/email/sendContactEmail'
import { TOPICS, type ContactState } from '@/app/contact/contact-shared'

export type { ContactState }

function isValidEmail(email: string): boolean {
  return /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email)
}

export async function submitContact(
  _prev: ContactState,
  formData: FormData
): Promise<ContactState> {
  const honeypot   = (formData.get('website') as string | null) ?? ''
  const renderTime = parseInt((formData.get('renderTime') as string) ?? '0', 10)

  // Spam guards — silently succeed so bots get no signal
  if (honeypot.length > 0) return { ok: true }
  if (!isNaN(renderTime) && Date.now() - renderTime < 3000) return { ok: true }

  const name    = ((formData.get('name')    as string) ?? '').trim()
  const email   = ((formData.get('email')   as string) ?? '').trim()
  const topic   = ((formData.get('topic')   as string) ?? '').trim()
  const message = ((formData.get('message') as string) ?? '').trim()

  if (name.length < 1 || name.length > 100)
    return { ok: false, error: 'Please enter your name (maximum 100 characters).' }

  if (!isValidEmail(email))
    return { ok: false, error: 'Please enter a valid email address.' }

  if (!(TOPICS as readonly string[]).includes(topic))
    return { ok: false, error: 'Please select a topic.' }

  if (message.length < 10 || message.length > 5000)
    return { ok: false, error: 'Your message must be between 10 and 5,000 characters.' }

  try {
    await sendContactEmail({ name, email, topic, message })
    return { ok: true }
  } catch (err) {
    console.error('[submitContact] failed to send email:', err)
    return {
      ok:    false,
      error: "We couldn't send your message. Please email hello@gemworkers.com directly.",
    }
  }
}
