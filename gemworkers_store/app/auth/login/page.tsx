'use client'

import { useEffect, useState } from 'react'
import Link from 'next/link'
import { useRouter } from 'next/navigation'
import { createClient } from '@/lib/supabase/client'
import { safeNext } from '@/lib/safe-next'
import { AuthShell, authErrorStyle } from '@/app/components/AuthShell'
import { Turnstile, TURNSTILE_ENABLED, CAPTCHA_FAILED_MESSAGE, isCaptchaError } from '@/app/components/Turnstile'
import { inputStyle, labelStyle, pillDark, pillDisabled } from '@/lib/ui'

export default function LoginPage() {
  const router = useRouter()
  const [email, setEmail] = useState('')
  const [password, setPassword] = useState('')
  const [error, setError] = useState<string | null>(null)
  const [loading, setLoading] = useState(false)
  const [captchaToken, setCaptchaToken] = useState<string | null>(null)
  const [captchaReset, setCaptchaReset] = useState(0)
  const canSubmit = !loading && (!TURNSTILE_ENABLED || !!captchaToken)
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
    const { error: authError } = await supabase.auth.signInWithPassword({
      email,
      password,
      options: { captchaToken: captchaToken ?? undefined },
    })

    if (authError) {
      setError(isCaptchaError(authError.message) ? CAPTCHA_FAILED_MESSAGE : authError.message)
      setCaptchaReset(n => n + 1)
      setLoading(false)
    } else {
      router.push(next)
      router.refresh()
    }
  }


  return (
    <AuthShell
      title="Log in"
      intro={<>
        Don&apos;t have an account?{' '}
        <Link href={next === '/' ? '/auth/signup' : `/auth/signup?next=${encodeURIComponent(next)}`} className="pd-link">
          Sign up
        </Link>
      </>}
    >
      <form onSubmit={handleSubmit}>
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
          <label style={labelStyle}>Password</label>
          <input
            type="password" required autoComplete="current-password"
            value={password}
            onChange={e => setPassword(e.target.value)}
            style={inputStyle}
          />
        </div>

        <Turnstile onToken={setCaptchaToken} resetKey={captchaReset} />

        {error && <p style={authErrorStyle}>{error}</p>}

        <button type="submit" disabled={!canSubmit} style={canSubmit ? pillDark : pillDisabled}>
          {loading ? 'Logging in…' : 'Log in'}
        </button>
      </form>
    </AuthShell>
  )
}
