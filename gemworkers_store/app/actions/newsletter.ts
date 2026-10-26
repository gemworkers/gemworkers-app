'use server'

import { createAdminClient } from '@/lib/supabase/admin'
import { verifyTurnstile } from '@/lib/turnstile'
import { NEWSLETTER_CONSENT, SITE } from '@/lib/newsletter'
import { sendNewsletterConfirmEmail } from '@/lib/email/sendNewsletterConfirmEmail'

// Email sign-up (sql/newsletter.sql): pending + confirmation email. The answer
// is the same whether or not the email is already on the list, so nobody can
// find out who subscribed.
export async function subscribeNewsletter(
  rawEmail: string,
  captchaToken: string | null,
  source = 'footer',
): Promise<{ ok: true } | { error: string }> {
  const email = rawEmail.trim().toLowerCase()
  if (!/^[^\s@]+@[^\s@]+\.[^\s@]{2,}$/.test(email) || email.length > 254) {
    return { error: 'Please enter a valid email address.' }
  }
  if (!(await verifyTurnstile(captchaToken))) {
    return { error: 'Please complete the check and try again.' }
  }

  const admin = createAdminClient()
  const { data: existing } = await admin
    .from('newsletter_subscribers').select('id, status, confirm_token').eq('email', email).maybeSingle()
  const row = existing as { id: string; status: string; confirm_token: string } | null
  if (row?.status === 'confirmed') return { ok: true }

  let token = row?.confirm_token
  if (!row) {
    const { data, error } = await admin.from('newsletter_subscribers')
      .insert({ email, consent_text: NEWSLETTER_CONSENT, source })
      .select('confirm_token').single()
    if (error) { console.error('[newsletter] insert failed:', error.message); return { error: 'Sign-up failed — please try again.' } }
    token = (data as { confirm_token: string }).confirm_token
  } else if (row.status === 'unsubscribed') {
    // Signing up again: a fresh consent, a fresh confirmation.
    const { data, error } = await admin.from('newsletter_subscribers')
      .update({ status: 'pending', consent_text: NEWSLETTER_CONSENT, source, signed_up_at: new Date().toISOString(),
                confirmed_at: null, unsubscribed_at: null, confirm_token: crypto.randomUUID() })
      .eq('id', row.id).select('confirm_token').single()
    if (error) { console.error('[newsletter] re-subscribe failed:', error.message); return { error: 'Sign-up failed — please try again.' } }
    token = (data as { confirm_token: string }).confirm_token
  }

  try {
    await sendNewsletterConfirmEmail(email, `${SITE}/newsletter/confirm?token=${encodeURIComponent(token!)}`)
  } catch (e) {
    console.error('[newsletter] confirmation email failed:', e instanceof Error ? e.message : String(e))
    return { error: 'We could not send the confirmation email — please try again.' }
  }
  return { ok: true }
}

// Unsubscribe page button (POST, so email scanners opening the link don't unsubscribe people).
export async function unsubscribeNewsletter(token: string): Promise<{ ok: boolean }> {
  if (!/^[0-9a-f-]{36}$/i.test(token)) return { ok: false }
  const { data, error } = await createAdminClient().from('newsletter_subscribers')
    .update({ status: 'unsubscribed', unsubscribed_at: new Date().toISOString() })
    .eq('unsubscribe_token', token).select('id')
  return { ok: !error && (data?.length ?? 0) > 0 }
}
