'use client'

import { useState } from 'react'
import Link from 'next/link'
import { useRouter } from 'next/navigation'
import { createClient } from '@/lib/supabase/client'

const inputStyle: React.CSSProperties = {
  width: '100%', padding: '9px 12px', fontSize: 14,
  color: '#1F1B16', background: '#F4EEE4',
  border: '1px solid #ECE5D8', borderRadius: 6,
  boxSizing: 'border-box', outline: 'none',
  fontFamily: 'var(--font-inter, system-ui)',
}

const labelStyle: React.CSSProperties = {
  display: 'block', fontSize: 11, fontWeight: 600,
  color: '#5A5045', marginBottom: 6, letterSpacing: '0.06em',
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
          fontSize: 42, marginBottom: 16, color: '#7A5A22',
          fontFamily: 'var(--font-cormorant, Georgia, serif)',
        }}>✉</div>
        <h1 style={{
          fontSize: 24, fontWeight: 300, color: '#1F1B16',
          fontFamily: 'var(--font-cormorant, Georgia, serif)',
          marginBottom: 10,
        }}>
          Check your email
        </h1>
        <p style={{
          fontSize: 14, color: '#5A5045', lineHeight: 1.6, marginBottom: 28,
          fontFamily: 'var(--font-inter, system-ui)',
        }}>
          We sent a confirmation link to{' '}
          <strong style={{ color: '#1F1B16' }}>{email}</strong>.
          Click it to activate your account, then log in.
        </p>
        <Link href="/auth/login" style={{
          display: 'inline-block', padding: '11px 28px',
          border: '1px solid rgba(122,90,34,0.5)', color: '#7A5A22',
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
        fontSize: 28, fontWeight: 300, color: '#1F1B16',
        fontFamily: 'var(--font-cormorant, Georgia, serif)',
        marginBottom: 6,
      }}>
        Create an account
      </h1>
      <p style={{
        fontSize: 13, color: '#5A5045', marginBottom: 28,
        fontFamily: 'var(--font-inter, system-ui)',
      }}>
        Already have an account?{' '}
        <Link href="/auth/login" style={{ color: '#7A5A22', textDecoration: 'none' }}>
          Log in
        </Link>
      </p>

      <form onSubmit={handleSubmit} style={{
        background: '#FFFFFF', border: '1px solid #ECE5D8',
        borderRadius: 10, padding: 28,
      }}>
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
            style={{ ...inputStyle, color: displayName ? '#1F1B16' : '#6B6052' }}
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

        {error && (
          <p style={{
            fontSize: 13, color: '#B42318',
            background: 'rgba(180,35,24,0.06)',
            border: '1px solid rgba(180,35,24,0.25)',
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
            color: '#FBF8F3', background: loading ? '#B89A63' : '#7A5A22',
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
