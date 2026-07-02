'use client'

import { useState } from 'react'
import Link from 'next/link'
import Image from 'next/image'
import { useRouter } from 'next/navigation'
import { createClient } from '@/lib/supabase/client'

const inputStyle: React.CSSProperties = {
  width: '100%', padding: '9px 12px', fontSize: 14, color: '#111',
  border: '1px solid #e5e7eb', borderRadius: 6, boxSizing: 'border-box',
  background: '#fff', outline: 'none',
}

const labelStyle: React.CSSProperties = {
  display: 'block', fontSize: 12, fontWeight: 600, color: '#374151', marginBottom: 6,
}

export default function SignupPage() {
  const router = useRouter()
  const [email, setEmail] = useState('')
  const [password, setPassword] = useState('')
  const [displayName, setDisplayName] = useState('')
  const [error, setError] = useState<string | null>(null)
  const [loading, setLoading] = useState(false)
  const [checkEmail, setCheckEmail] = useState(false)

  async function handleSubmit(e: React.FormEvent) {
    e.preventDefault()
    setError(null)
    setLoading(true)

    const supabase = createClient()

    const { data, error: signUpError } = await supabase.auth.signUp({
      email,
      password,
      options: {
        // Trigger handle_new_buyer() only for storefront signups.
        data: { source: 'storefront' },
      },
    })

    if (signUpError) {
      setError(signUpError.message)
      setLoading(false)
      return
    }

    // The trigger creates the buyers row with email only.
    // If buyer provided a display_name, update it now.
    if (displayName.trim() && data.user) {
      await supabase
        .from('buyers')
        .update({ display_name: displayName.trim() })
        .eq('id', data.user.id)
    }

    if (data.session) {
      // Email confirmation disabled → buyer is logged in immediately.
      router.push('/')
      router.refresh()
    } else {
      // Email confirmation enabled → ask buyer to check their inbox.
      setCheckEmail(true)
      setLoading(false)
    }
  }

  if (checkEmail) {
    return (
      <>
        <style>{`body { background: #fafaf9; font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Helvetica, Arial, sans-serif; }`}</style>
        <main style={{ maxWidth: 420, margin: '80px auto', padding: '0 24px', textAlign: 'center' }}>
          <div style={{ fontSize: 42, marginBottom: 16, color: '#9ca3af' }}>✉</div>
          <h1 style={{
            fontSize: 20, fontWeight: 700, color: '#111',
            fontFamily: "Georgia, 'Times New Roman', serif",
            marginBottom: 10,
          }}>
            Check your email
          </h1>
          <p style={{ fontSize: 14, color: '#6b7280', lineHeight: 1.6, marginBottom: 28 }}>
            We sent a confirmation link to <strong style={{ color: '#374151' }}>{email}</strong>.
            Click it to activate your account, then log in.
          </p>
          <Link href="/auth/login" style={{
            display: 'inline-block', padding: '10px 24px',
            background: '#111', color: '#fff', borderRadius: 6,
            textDecoration: 'none', fontSize: 14, fontWeight: 600, letterSpacing: '0.02em',
          }}>
            Go to Log in
          </Link>
        </main>
      </>
    )
  }

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
        <Link href="/" style={{ textDecoration: 'none', lineHeight: 0 }}>
          <Image src="/logo-black.png" alt="GemWorkers" height={44} width={61} style={{ display: 'block' }} />
        </Link>
      </header>

      <main style={{ maxWidth: 420, margin: '64px auto', padding: '0 24px 80px' }}>
        <h1 style={{
          fontSize: 22, fontWeight: 700, color: '#111',
          fontFamily: "Georgia, 'Times New Roman', serif",
          marginBottom: 6,
        }}>
          Create an account
        </h1>
        <p style={{ fontSize: 13, color: '#9ca3af', marginBottom: 28 }}>
          Already have an account?{' '}
          <Link href="/auth/login" style={{ color: '#374151', textDecoration: 'underline' }}>
            Log in
          </Link>
        </p>

        <form onSubmit={handleSubmit} style={{
          background: '#fff', border: '1px solid #e5e7eb',
          borderRadius: 10, padding: 28,
        }}>
          <div style={{ marginBottom: 18 }}>
            <label style={labelStyle}>
              Display name{' '}
              <span style={{ fontWeight: 400, color: '#9ca3af' }}>(optional)</span>
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
              <span style={{ fontWeight: 400, color: '#9ca3af' }}>(min 6 characters)</span>
            </label>
            <input
              type="password" required minLength={6} autoComplete="new-password"
              value={password}
              onChange={e => setPassword(e.target.value)}
              style={inputStyle}
            />
          </div>

          {error && (
            <p style={{
              fontSize: 13, color: '#dc2626',
              background: '#fef2f2', border: '1px solid #fecaca',
              borderRadius: 6, padding: '8px 12px', marginBottom: 16,
            }}>
              {error}
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
            {loading ? 'Creating account…' : 'Create account'}
          </button>
        </form>
      </main>
    </>
  )
}
