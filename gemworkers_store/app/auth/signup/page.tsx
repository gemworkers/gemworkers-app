'use client'

import { useEffect, useState } from 'react'
import Link from 'next/link'
import { useRouter } from 'next/navigation'
import { createClient } from '@/lib/supabase/client'
import { safeNext } from '@/lib/safe-next'
import { AuthShell, authErrorStyle } from '@/app/components/AuthShell'
import { Turnstile, TURNSTILE_ENABLED, CAPTCHA_FAILED_MESSAGE, isCaptchaError } from '@/app/components/Turnstile'
import { inputStyle, labelStyle, pillDark, pillDisabled } from '@/lib/ui'

export default function SignupPage() {
  const router = useRouter()
  const [email, setEmail] = useState('')
  const [password, setPassword] = useState('')
  const [displayName, setDisplayName] = useState('')
  const [error, setError] = useState<string | null>(null)
  const [loading, setLoading] = useState(false)
  const [captchaToken, setCaptchaToken] = useState<string | null>(null)
  const [captchaReset, setCaptchaReset] = useState(0)
  const canSubmit = !loading && (!TURNSTILE_ENABLED || !!captchaToken)
  const [checkEmail, setCheckEmail] = useState(false)
  const [next, setNext] = useState('/')

  // Read ?next= on the client (validated to a same-site relative path)
  useEffect(() => {
    setNext(safeNext(new URLSearchParams(window.location.search).get('next')))
  }, [])

  async function handleSubmit(e: React.FormEvent) {
    e.preventDefault()
    if (!canSubmit) return
    setError(null)
    setLoading(true)

    const supabase = createClient()

    const { data, error: signUpError } = await supabase.auth.signUp({
      email,
      password,
      options: {
        data: { source: 'storefront' },
        captchaToken: captchaToken ?? undefined,
      },
    })

    if (signUpError) {
      setError(isCaptchaError(signUpError.message) ? CAPTCHA_FAILED_MESSAGE : signUpError.message)
      setCaptchaReset(n => n + 1)
      setLoading(false)
      return
    }

    if (displayName.trim() && data.user) {
      await supabase
        .from('buyers')
        .update({ display_name: displayName.trim() })
        .eq('id', data.user.id)
    }

    if (data.session) {
      router.push(next)
      router.refresh()
    } else {
      setCheckEmail(true)
      setLoading(false)
    }
  }

  const loginHref = next === '/' ? '/auth/login' : `/auth/login?next=${encodeURIComponent(next)}`

  if (checkEmail) {
    return (
      <AuthShell title="Check your email" center>
        <p style={{ fontSize: 15, color: '#5A5045', lineHeight: 1.6, marginBottom: 24 }}>
          We sent a confirmation link to{' '}
          <strong style={{ color: '#1F1B16' }}>{email}</strong>.
          Click it to activate your account, then log in.
        </p>
        <Link href={loginHref} style={pillDark}>
          Go to Log in
        </Link>
      </AuthShell>
    )
  }

  return (
    <AuthShell
      title="Create an account"
      intro={<>
        Already have an account?{' '}
        <Link href={loginHref} className="pd-link">Log in</Link>
      </>}
    >
      <form onSubmit={handleSubmit}>
        <div style={{ marginBottom: 18 }}>
          <label style={labelStyle}>
            Display name{' '}
            <span style={{ fontWeight: 400, color: '#6B6052' }}>(optional)</span>
          </label>
          <input
            type="text" autoComplete="name"
            value={displayName}
            onChange={e => setDisplayName(e.target.value)}
            placeholder="How you'll appear to sellers"
            style={inputStyle}
          />
        </div>

        <div style={{ marginBottom: 18 }}>
          <label style={labelStyle}>Email</label>
          <input
            type="email" required autoComplete="email"
            value={email}
            onChange={e => setEmail(e.target.value)}
            style={inputStyle}
          />
        </div>

        <div style={{ marginBottom: 24 }}>
          <label style={labelStyle}>
            Password{' '}
            <span style={{ fontWeight: 400, color: '#6B6052' }}>(min 6 characters)</span>
          </label>
          <input
            type="password" required minLength={6} autoComplete="new-password"
            value={password}
            onChange={e => setPassword(e.target.value)}
            style={inputStyle}
          />
        </div>

        <Turnstile onToken={setCaptchaToken} resetKey={captchaReset} />

        {error && <p style={authErrorStyle}>{error}</p>}

        <button type="submit" disabled={!canSubmit} style={canSubmit ? pillDark : pillDisabled}>
          {loading ? 'Creating account…' : 'Create account'}
        </button>
      </form>
    </AuthShell>
  )
}
