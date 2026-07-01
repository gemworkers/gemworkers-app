'use client'

import { useState, useEffect } from 'react'
import Link from 'next/link'
import { createClient } from '@/lib/supabase/client'

const inputStyle: React.CSSProperties = {
  width: '100%', padding: '9px 12px', fontSize: 14, color: '#111',
  border: '1px solid #e5e7eb', borderRadius: 6, boxSizing: 'border-box',
  background: '#fff', outline: 'none',
}

const labelStyle: React.CSSProperties = {
  display: 'block', fontSize: 12, fontWeight: 600, color: '#374151', marginBottom: 6,
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

      // Clear tokens from the address bar so they don't linger.
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
      <>
        <style>{`
          body { background: #fafaf9; font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Helvetica, Arial, sans-serif; }
        `}</style>
        <header style={{
          display: 'flex', alignItems: 'center',
          padding: '0 32px', height: 60,
          borderBottom: '1px solid #e5e7eb',
          background: '#fff',
        }}>
          <Link href="/" style={{ textDecoration: 'none' }}>
            <span style={{
              fontSize: 18, fontWeight: 700, letterSpacing: '0.13em',
              fontFamily: "Georgia, 'Times New Roman', serif", color: '#111',
            }}>
              GEMWORKERS
            </span>
          </Link>
        </header>
        <main style={{ maxWidth: 420, margin: '64px auto', padding: '0 24px 80px' }}>
          <div style={{
            background: '#fff', border: '1px solid #e5e7eb',
            borderRadius: 10, padding: 28,
          }}>
            <h1 style={{
              fontSize: 20, fontWeight: 700, color: '#111',
              fontFamily: "Georgia, 'Times New Roman', serif",
              marginBottom: 12, marginTop: 0,
            }}>
              Invitation link problem
            </h1>
            <p style={{ fontSize: 14, color: '#6b7280', lineHeight: 1.6, margin: 0 }}>
              {sessionError}
            </p>
          </div>
        </main>
      </>
    )
  }

  // ── STATE B — password set successfully ────────────────────────────────────
  if (success) {
    return (
      <>
        <style>{`
          body { background: #fafaf9; font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Helvetica, Arial, sans-serif; }
        `}</style>
        <header style={{
          display: 'flex', alignItems: 'center',
          padding: '0 32px', height: 60,
          borderBottom: '1px solid #e5e7eb',
          background: '#fff',
        }}>
          <Link href="/" style={{ textDecoration: 'none' }}>
            <span style={{
              fontSize: 18, fontWeight: 700, letterSpacing: '0.13em',
              fontFamily: "Georgia, 'Times New Roman', serif", color: '#111',
            }}>
              GEMWORKERS
            </span>
          </Link>
        </header>
        <main style={{ maxWidth: 420, margin: '80px auto', padding: '0 24px', textAlign: 'center' }}>
          <div style={{ fontSize: 42, marginBottom: 16, color: '#9ca3af' }}>✓</div>
          <h1 style={{
            fontSize: 20, fontWeight: 700, color: '#111',
            fontFamily: "Georgia, 'Times New Roman', serif",
            marginBottom: 10,
          }}>
            Password set
          </h1>
          <p style={{ fontSize: 14, color: '#6b7280', lineHeight: 1.6, marginBottom: 8 }}>
            Your account is ready. Head to your seller dashboard to start listing your stones.
          </p>
          {sellerEmail && (
            <p style={{ fontSize: 13, color: '#9ca3af', lineHeight: 1.6, marginBottom: 28 }}>
              Sign in with{' '}
              <strong style={{ color: '#374151' }}>{sellerEmail}</strong>{' '}
              and the password you just chose.
            </p>
          )}
          <a
            href="https://sell.gemworkers.com"
            style={{
              display: 'inline-block', padding: '10px 24px',
              background: '#111', color: '#fff', borderRadius: 6,
              textDecoration: 'none', fontSize: 14, fontWeight: 600,
              letterSpacing: '0.02em',
            }}
          >
            Go to Seller Dashboard
          </a>
        </main>
      </>
    )
  }

  const header = (
    <header style={{
      display: 'flex', alignItems: 'center',
      padding: '0 32px', height: 60,
      borderBottom: '1px solid #e5e7eb',
      background: '#fff',
    }}>
      <Link href="/" style={{ textDecoration: 'none' }}>
        <span style={{
          fontSize: 18, fontWeight: 700, letterSpacing: '0.13em',
          fontFamily: "Georgia, 'Times New Roman', serif", color: '#111',
        }}>
          GEMWORKERS
        </span>
      </Link>
    </header>
  )

  const bodyStyle = (
    <style>{`
      body { background: #fafaf9; font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Helvetica, Arial, sans-serif; }
    `}</style>
  )

  // ── STATE D — session not yet established (briefly on load) ────────────────
  if (!sessionReady) {
    return (
      <>
        {bodyStyle}
        {header}
        <main style={{ maxWidth: 420, margin: '64px auto', padding: '0 24px 80px' }}>
          <div style={{
            background: '#fff', border: '1px solid #e5e7eb',
            borderRadius: 10, padding: 28, textAlign: 'center',
          }}>
            <p style={{ fontSize: 14, color: '#9ca3af', margin: 0 }}>
              Verifying your invitation…
            </p>
          </div>
        </main>
      </>
    )
  }

  // ── STATE C — session ready, show set-password form ────────────────────────
  return (
    <>
      {bodyStyle}
      {header}
      <main style={{ maxWidth: 420, margin: '64px auto', padding: '0 24px 80px' }}>
        <h1 style={{
          fontSize: 22, fontWeight: 700, color: '#111',
          fontFamily: "Georgia, 'Times New Roman', serif",
          marginBottom: 6,
        }}>
          Set your password
        </h1>
        <p style={{ fontSize: 13, color: '#9ca3af', marginBottom: 28 }}>
          Welcome to GemWorkers. Choose a password to activate your seller account.
        </p>

        <form onSubmit={handleSubmit} style={{
          background: '#fff', border: '1px solid #e5e7eb',
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
              fontSize: 13, color: '#dc2626',
              background: '#fef2f2', border: '1px solid #fecaca',
              borderRadius: 6, padding: '8px 12px', marginBottom: 16,
            }}>
              {formError}
            </p>
          )}

          <button
            type="submit"
            disabled={loading}
            style={{
              width: '100%', padding: '10px 0', fontSize: 14, fontWeight: 600,
              color: '#fff', background: loading ? '#6b7280' : '#111',
              border: 'none', borderRadius: 6,
              cursor: loading ? 'not-allowed' : 'pointer',
              letterSpacing: '0.02em',
            }}
          >
            {loading ? 'Setting…' : 'Set password'}
          </button>
        </form>
      </main>
    </>
  )
}
