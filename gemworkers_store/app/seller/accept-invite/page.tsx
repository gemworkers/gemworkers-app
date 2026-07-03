'use client'

import { useState, useEffect } from 'react'
import Link from 'next/link'
import { createClient } from '@/lib/supabase/client'

const inputStyle: React.CSSProperties = {
  width: '100%', padding: '9px 12px', fontSize: 14,
  color: '#f5f0e8', background: '#1e1e24',
  border: '1px solid #2a2a30', borderRadius: 6,
  boxSizing: 'border-box', outline: 'none',
  fontFamily: 'var(--font-inter, system-ui)',
}

const labelStyle: React.CSSProperties = {
  display: 'block', fontSize: 11, fontWeight: 600,
  color: '#9d9080', marginBottom: 6, letterSpacing: '0.06em',
  fontFamily: 'var(--font-inter, system-ui)',
}

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
      <main style={{ maxWidth: 420, margin: '64px auto', padding: '0 24px 80px' }}>
        <div style={{
          background: '#16161a', border: '1px solid #2a2a30',
          borderRadius: 10, padding: 28,
        }}>
          <h1 style={{
            fontSize: 22, fontWeight: 300, color: '#f5f0e8',
            fontFamily: 'var(--font-cormorant, Georgia, serif)',
            marginBottom: 12, marginTop: 0,
          }}>
            Invitation link problem
          </h1>
          <p style={{
            fontSize: 14, color: '#9d9080', lineHeight: 1.6, margin: 0,
            fontFamily: 'var(--font-inter, system-ui)',
          }}>
            {sessionError}
          </p>
        </div>
      </main>
    )
  }

  // ── STATE B — password set successfully ────────────────────────────────────
  if (success) {
    return (
      <main style={{ maxWidth: 420, margin: '80px auto', padding: '0 24px', textAlign: 'center' }}>
        <div style={{
          fontSize: 42, marginBottom: 16, color: '#c9a962',
          fontFamily: 'var(--font-cormorant, Georgia, serif)',
        }}>✓</div>
        <h1 style={{
          fontSize: 24, fontWeight: 300, color: '#f5f0e8',
          fontFamily: 'var(--font-cormorant, Georgia, serif)',
          marginBottom: 10,
        }}>
          Password set
        </h1>
        <p style={{
          fontSize: 14, color: '#9d9080', lineHeight: 1.6, marginBottom: 8,
          fontFamily: 'var(--font-inter, system-ui)',
        }}>
          Your account is ready. Head to your seller dashboard to start listing your stones.
        </p>
        {sellerEmail && (
          <p style={{
            fontSize: 13, color: '#9d9080', lineHeight: 1.6, marginBottom: 28,
            fontFamily: 'var(--font-inter, system-ui)',
          }}>
            Sign in with{' '}
            <strong style={{ color: '#f5f0e8' }}>{sellerEmail}</strong>{' '}
            and the password you just chose.
          </p>
        )}
        <a
          href="https://sell.gemworkers.com"
          style={{
            display: 'inline-block', padding: '11px 28px',
            background: '#c9a962', color: '#0e0e10',
            border: 'none', borderRadius: 6,
            textDecoration: 'none', fontSize: 12, fontWeight: 600,
            letterSpacing: '0.1em',
            fontFamily: 'var(--font-inter, system-ui)',
          }}
        >
          Go to Seller Dashboard
        </a>
      </main>
    )
  }

  // ── STATE D — session not yet established ──────────────────────────────────
  if (!sessionReady) {
    return (
      <main style={{ maxWidth: 420, margin: '64px auto', padding: '0 24px 80px' }}>
        <div style={{
          background: '#16161a', border: '1px solid #2a2a30',
          borderRadius: 10, padding: 28, textAlign: 'center',
        }}>
          <p style={{
            fontSize: 14, color: '#9d9080', margin: 0,
            fontFamily: 'var(--font-inter, system-ui)',
          }}>
            Verifying your invitation…
          </p>
        </div>
      </main>
    )
  }

  // ── STATE C — session ready, show set-password form ────────────────────────
  return (
    <main style={{ maxWidth: 420, margin: '64px auto', padding: '0 24px 80px' }}>
      <h1 style={{
        fontSize: 28, fontWeight: 300, color: '#f5f0e8',
        fontFamily: 'var(--font-cormorant, Georgia, serif)',
        marginBottom: 6,
      }}>
        Set your password
      </h1>
      <p style={{
        fontSize: 13, color: '#9d9080', marginBottom: 28,
        fontFamily: 'var(--font-inter, system-ui)',
      }}>
        Welcome to GemWorkers. Choose a password to activate your seller account.
      </p>

      <form onSubmit={handleSubmit} style={{
        background: '#16161a', border: '1px solid #2a2a30',
        borderRadius: 10, padding: 28,
      }}>
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

        {formError && (
          <p style={{
            fontSize: 13, color: '#f87171',
            background: 'rgba(220,38,38,0.08)',
            border: '1px solid rgba(220,38,38,0.3)',
            borderRadius: 6, padding: '8px 12px', marginBottom: 16,
            fontFamily: 'var(--font-inter, system-ui)',
          }}>
            {formError}
          </p>
        )}

        <button
          type="submit"
          disabled={loading}
          style={{
            width: '100%', padding: '10px 0', fontSize: 13, fontWeight: 600,
            color: '#0e0e10', background: loading ? '#7a6234' : '#c9a962',
            border: 'none', borderRadius: 6,
            cursor: loading ? 'not-allowed' : 'pointer',
            letterSpacing: '0.06em',
            fontFamily: 'var(--font-inter, system-ui)',
          }}
        >
          {loading ? 'Setting…' : 'Set password'}
        </button>
      </form>
    </main>
  )
}
