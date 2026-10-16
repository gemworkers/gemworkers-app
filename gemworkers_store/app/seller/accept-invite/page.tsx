'use client'

import { useState, useEffect } from 'react'
import { createClient } from '@/lib/supabase/client'
import { AuthShell, authErrorStyle } from '@/app/components/AuthShell'
import { inputStyle, labelStyle, pillDark, pillDisabled } from '@/lib/ui'

export default function SellerAcceptInvitePage() {
  const [sessionReady, setSessionReady] = useState(false)
  const [sessionError, setSessionError] = useState<string | null>(null)
  const [password, setPassword] = useState('')
  const [confirmPassword, setConfirmPassword] = useState('')
  const [loading, setLoading] = useState(false)
  const [formError, setFormError] = useState<string | null>(null)
  const [success, setSuccess] = useState(false)
  const [sellerEmail, setSellerEmail] = useState<string | null>(null)

  useEffect(() => {
    async function establishSession() {
      const hash = window.location.hash.replace(/^#/, '')
      const params = new URLSearchParams(hash)

      const accessToken   = params.get('access_token')
      const refreshToken  = params.get('refresh_token')
      const type          = params.get('type')

      window.history.replaceState(null, '', window.location.pathname)

      if (type !== 'invite' || !accessToken || !refreshToken) {
        setSessionError(
          'This invite link is invalid or has expired. Please ask the GemWorkers owner to send a new invitation.'
        )
        return
      }

      const supabase = createClient()
      const { data, error } = await supabase.auth.setSession({
        access_token:  accessToken,
        refresh_token: refreshToken,
      })

      if (error || !data.session) {
        setSessionError(
          'This invite link is invalid or has expired. Please ask the GemWorkers owner to send a new invitation.'
        )
        return
      }

      setSellerEmail(data.session.user?.email ?? null)
      setSessionReady(true)
    }

    establishSession()
  }, [])

  async function handleSubmit(e: React.FormEvent) {
    e.preventDefault()
    setFormError(null)

    if (password.length < 8) {
      setFormError('Password must be at least 8 characters.')
      return
    }
    if (password !== confirmPassword) {
      setFormError('Passwords do not match.')
      return
    }

    setLoading(true)

    const supabase = createClient()
    const { error } = await supabase.auth.updateUser({ password })

    if (error) {
      setFormError(error.message)
      setLoading(false)
      return
    }

    setSuccess(true)
  }

  // ── STATE A — invalid/expired link ─────────────────────────────────────────
  if (sessionError) {
    return (
      <AuthShell title="Invitation link problem">
        <p style={{ fontSize: 15, color: '#5A5045', lineHeight: 1.6, margin: 0 }}>
          {sessionError}
        </p>
      </AuthShell>
    )
  }

  // ── STATE B — password set successfully ────────────────────────────────────
  if (success) {
    return (
      <AuthShell title="Password set" center>
        <p style={{ fontSize: 15, color: '#5A5045', lineHeight: 1.6, marginBottom: 10 }}>
          Your account is ready. Head to your seller dashboard to start listing your stones.
        </p>
        {sellerEmail && (
          <p style={{ fontSize: 14, color: '#5A5045', lineHeight: 1.6, marginBottom: 24 }}>
            Sign in with{' '}
            <strong style={{ color: '#1F1B16' }}>{sellerEmail}</strong>{' '}
            and the password you just chose.
          </p>
        )}
        <a href="https://sell.gemworkers.com" style={{ ...pillDark, marginTop: sellerEmail ? 0 : 14 }}>
          Go to Seller Dashboard
        </a>
      </AuthShell>
    )
  }

  // ── STATE D — session not yet established ──────────────────────────────────
  if (!sessionReady) {
    return (
      <AuthShell title="Welcome" center>
        <p style={{ fontSize: 15, color: '#5A5045', margin: 0 }}>
          Verifying your invitation…
        </p>
      </AuthShell>
    )
  }

  // ── STATE C — session ready, show set-password form ────────────────────────
  return (
    <AuthShell
      title="Set your password"
      intro="Welcome to GemWorkers. Choose a password to activate your seller account."
    >
      <form onSubmit={handleSubmit}>
        <div style={{ marginBottom: 18 }}>
          <label style={labelStyle}>Password</label>
          <input
            type="password" required minLength={8} autoComplete="new-password"
            value={password}
            onChange={e => setPassword(e.target.value)}
            style={inputStyle}
          />
        </div>

        <div style={{ marginBottom: 24 }}>
          <label style={labelStyle}>Confirm password</label>
          <input
            type="password" required minLength={8} autoComplete="new-password"
            value={confirmPassword}
            onChange={e => setConfirmPassword(e.target.value)}
            style={inputStyle}
          />
        </div>

        {formError && <p style={authErrorStyle}>{formError}</p>}

        <button type="submit" disabled={loading} style={loading ? pillDisabled : pillDark}>
          {loading ? 'Setting…' : 'Set password'}
        </button>
      </form>
    </AuthShell>
  )
}
