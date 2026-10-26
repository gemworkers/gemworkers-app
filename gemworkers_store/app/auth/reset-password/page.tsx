'use client'

import { useEffect, useState } from 'react'
import Link from 'next/link'
import { useRouter } from 'next/navigation'
import { createClient } from '@/lib/supabase/client'
import { AuthShell, authErrorStyle } from '@/app/components/AuthShell'
import { inputStyle, labelStyle, pillDark, pillDisabled } from '@/lib/ui'

// Opened from the reset email: /auth/callback has already exchanged the code
// for a session, so the buyer is signed in and can set a new password.
export default function ResetPasswordPage() {
  const router = useRouter()
  const [checking, setChecking] = useState(true)
  const [signedIn, setSignedIn] = useState(false)
  const [password, setPassword] = useState('')
  const [confirm, setConfirm] = useState('')
  const [error, setError] = useState<string | null>(null)
  const [loading, setLoading] = useState(false)
  const [done, setDone] = useState(false)
  // ?welcome=1: first password for an account made at guest checkout.
  const [welcome, setWelcome] = useState(false)

  useEffect(() => {
    setWelcome(new URLSearchParams(window.location.search).get('welcome') === '1')
    // ?expired=1 comes from /auth/confirm when the link was used or expired.
    if (new URLSearchParams(window.location.search).get('expired') === '1') {
      setSignedIn(false)
      setChecking(false)
      return
    }
    createClient().auth.getUser().then(({ data }) => {
      setSignedIn(!!data.user)
      setChecking(false)
    })
  }, [])

  const canSubmit = !loading && password.length >= 8 && confirm.length >= 8

  async function handleSubmit(e: React.FormEvent) {
    e.preventDefault()
    if (!canSubmit) return
    if (password !== confirm) {
      setError('The two passwords don’t match.')
      return
    }
    setError(null)
    setLoading(true)
    const { error: updateError } = await createClient().auth.updateUser({ password, data: { guest: false } })
    if (updateError) {
      setError(updateError.message)
      setLoading(false)
      return
    }
    setDone(true)
    setLoading(false)
    router.refresh()
  }

  if (checking) {
    return <AuthShell title={welcome ? 'Choose your password' : 'Choose a new password'}><p style={{ fontSize: 15, color: '#5A5045' }}>One moment…</p></AuthShell>
  }

  if (!signedIn) {
    return (
      <AuthShell title="Link expired">
        <p style={{ fontSize: 15, color: '#5A5045', lineHeight: 1.6, marginBottom: 20 }}>
          This reset link has already been used or has expired. Each link works once, for one
          hour. Please request a new one.
        </p>
        <Link href="/auth/forgot-password" className="pd-link">Send a new link</Link>
      </AuthShell>
    )
  }

  if (done) {
    return (
      <AuthShell title={welcome ? 'Your account is ready' : 'Password changed'}>
        <p style={{ fontSize: 15, color: '#5A5045', lineHeight: 1.6, marginBottom: 20 }}>
          Your {welcome ? '' : 'new '}password is saved and you&apos;re logged in.
        </p>
        <Link href={welcome ? '/orders' : '/'} className="pd-link">{welcome ? 'See my orders' : 'Continue shopping'}</Link>
      </AuthShell>
    )
  }

  return (
    <AuthShell title={welcome ? 'Choose your password' : 'Choose a new password'}>
      {welcome && (
        <p style={{ fontSize: 15, color: '#5A5045', lineHeight: 1.6, marginBottom: 20 }}>
          Your GemWorkers account was made with your order. Choose a password to log in on any device.
        </p>
      )}
      <form onSubmit={handleSubmit}>
        <div style={{ marginBottom: 18 }}>
          <label style={labelStyle}>New password (at least 8 characters)</label>
          <input
            type="password" required minLength={8} autoComplete="new-password"
            value={password}
            onChange={e => setPassword(e.target.value)}
            style={inputStyle}
          />
        </div>
        <div style={{ marginBottom: 24 }}>
          <label style={labelStyle}>Repeat new password</label>
          <input
            type="password" required minLength={8} autoComplete="new-password"
            value={confirm}
            onChange={e => setConfirm(e.target.value)}
            style={inputStyle}
          />
        </div>

        {error && <p style={authErrorStyle}>{error}</p>}

        <button type="submit" disabled={!canSubmit} style={canSubmit ? pillDark : pillDisabled}>
          {loading ? 'Saving…' : welcome ? 'Save my password' : 'Save new password'}
        </button>
      </form>
    </AuthShell>
  )
}
