'use client'

import { useState } from 'react'
import Link from 'next/link'
import { createClient } from '@/lib/supabase/client'
import { AuthShell, authErrorStyle } from '@/app/components/AuthShell'
import { Turnstile, TURNSTILE_ENABLED, CAPTCHA_FAILED_MESSAGE, isCaptchaError } from '@/app/components/Turnstile'
import { inputStyle, labelStyle, pillDark, pillDisabled } from '@/lib/ui'

// Buyer asks for a password-reset email. The link goes through /auth/callback
// (PKCE code exchange, same browser) and lands on /auth/reset-password.
export default function ForgotPasswordPage() {
  const [email, setEmail] = useState('')
  const [error, setError] = useState<string | null>(null)
  const [loading, setLoading] = useState(false)
  const [sent, setSent] = useState(false)
  const [captchaToken, setCaptchaToken] = useState<string | null>(null)
  const [captchaReset, setCaptchaReset] = useState(0)
  const canSubmit = !loading && email.trim() !== '' && (!TURNSTILE_ENABLED || !!captchaToken)

  async function handleSubmit(e: React.FormEvent) {
    e.preventDefault()
    if (!canSubmit) return
    setError(null)
    setLoading(true)

    const supabase = createClient()
    const redirectTo = `${window.location.origin}/auth/callback?next=${encodeURIComponent('/auth/reset-password')}`
    const { error: authError } = await supabase.auth.resetPasswordForEmail(email.trim(), {
      redirectTo,
      captchaToken: captchaToken ?? undefined,
    })

    if (authError) {
      setError(isCaptchaError(authError.message) ? CAPTCHA_FAILED_MESSAGE : authError.message)
      setCaptchaReset(n => n + 1)
      setLoading(false)
      return
    }
    // Same message whether or not the email has an account.
    setSent(true)
    setLoading(false)
  }

  if (sent) {
    return (
      <AuthShell title="Check your email">
        <p style={{ fontSize: 15, color: '#5A5045', lineHeight: 1.6, marginBottom: 20 }}>
          If an account exists for <strong>{email.trim()}</strong>, we&apos;ve sent a link to choose a
          new password. Open it on this device. It can take a minute or two — please check your
          spam folder too.
        </p>
        <Link href="/auth/login" className="pd-link">Back to log in</Link>
      </AuthShell>
    )
  }

  return (
    <AuthShell
      title="Forgot your password?"
      intro={<>Enter your email and we&apos;ll send you a link to choose a new password.</>}
    >
      <form onSubmit={handleSubmit}>
        <div style={{ marginBottom: 24 }}>
          <label style={labelStyle}>Email</label>
          <input
            type="email" required autoComplete="email"
            value={email}
            onChange={e => setEmail(e.target.value)}
            style={inputStyle}
          />
        </div>

        <Turnstile onToken={setCaptchaToken} resetKey={captchaReset} />

        {error && <p style={authErrorStyle}>{error}</p>}

        <button type="submit" disabled={!canSubmit} style={canSubmit ? pillDark : pillDisabled}>
          {loading ? 'Sending…' : 'Send reset link'}
        </button>

        <p style={{ fontSize: 14, marginTop: 20 }}>
          <Link href="/auth/login" className="pd-link">Back to log in</Link>
        </p>
      </form>
    </AuthShell>
  )
}
