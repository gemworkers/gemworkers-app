'use client'

import { useState } from 'react'
import Link from 'next/link'
import { useRouter } from 'next/navigation'
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
        data: { source: 'storefront' },
      },
    })

    if (signUpError) {
      setError(signUpError.message)
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
      router.push('/')
      router.refresh()
    } else {
      setCheckEmail(true)
      setLoading(false)
    }
  }

  if (checkEmail) {
    return (
      <main style={{ maxWidth: 420, margin: '80px auto', padding: '0 24px', textAlign: 'center' }}>
        <div style={{
          fontSize: 42, marginBottom: 16, color: '#c9a962',
          fontFamily: 'var(--font-cormorant, Georgia, serif)',
        }}>✉</div>
        <h1 style={{
          fontSize: 24, fontWeight: 300, color: '#f5f0e8',
          fontFamily: 'var(--font-cormorant, Georgia, serif)',
          marginBottom: 10,
        }}>
          Check your email
        </h1>
        <p style={{
          fontSize: 14, color: '#9d9080', lineHeight: 1.6, marginBottom: 28,
          fontFamily: 'var(--font-inter, system-ui)',
        }}>
          We sent a confirmation link to{' '}
          <strong style={{ color: '#f5f0e8' }}>{email}</strong>.
          Click it to activate your account, then log in.
        </p>
        <Link href="/auth/login" style={{
          display: 'inline-block', padding: '11px 28px',
          border: '1px solid rgba(201,169,98,0.5)', color: '#c9a962',
          borderRadius: 6, textDecoration: 'none', fontSize: 12,
          fontWeight: 600, letterSpacing: '0.1em',
          fontFamily: 'var(--font-inter, system-ui)',
        }}>
          Go to Log in
        </Link>
      </main>
    )
  }

  return (
    <main style={{ maxWidth: 420, margin: '64px auto', padding: '0 24px 80px' }}>
      <h1 style={{
        fontSize: 28, fontWeight: 300, color: '#f5f0e8',
        fontFamily: 'var(--font-cormorant, Georgia, serif)',
        marginBottom: 6,
      }}>
        Create an account
      </h1>
      <p style={{
        fontSize: 13, color: '#9d9080', marginBottom: 28,
        fontFamily: 'var(--font-inter, system-ui)',
      }}>
        Already have an account?{' '}
        <Link href="/auth/login" style={{ color: '#c9a962', textDecoration: 'none' }}>
          Log in
        </Link>
      </p>

      <form onSubmit={handleSubmit} style={{
        background: '#16161a', border: '1px solid #2a2a30',
        borderRadius: 10, padding: 28,
      }}>
        <div style={{ marginBottom: 18 }}>
          <label style={labelStyle}>
            Display name{' '}
            <span style={{ fontWeight: 400, color: '#4a4440' }}>(optional)</span>
          </label>
          <input
            type="text" autoComplete="name"
            value={displayName}
            onChange={e => setDisplayName(e.target.value)}
            placeholder="How you'll appear to sellers"
            style={{ ...inputStyle, color: displayName ? '#f5f0e8' : '#4a4440' }}
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
            <span style={{ fontWeight: 400, color: '#4a4440' }}>(min 6 characters)</span>
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
            fontSize: 13, color: '#f87171',
            background: 'rgba(220,38,38,0.08)',
            border: '1px solid rgba(220,38,38,0.3)',
            borderRadius: 6, padding: '8px 12px', marginBottom: 16,
            fontFamily: 'var(--font-inter, system-ui)',
          }}>
            {error}
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
          {loading ? 'Creating account…' : 'Create account'}
        </button>
      </form>
    </main>
  )
}
