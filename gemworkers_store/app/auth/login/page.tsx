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

export default function LoginPage() {
  const router = useRouter()
  const [email, setEmail] = useState('')
  const [password, setPassword] = useState('')
  const [error, setError] = useState<string | null>(null)
  const [loading, setLoading] = useState(false)

  async function handleSubmit(e: React.FormEvent) {
    e.preventDefault()
    setError(null)
    setLoading(true)

    const supabase = createClient()
    const { error: authError } = await supabase.auth.signInWithPassword({ email, password })

    if (authError) {
      setError(authError.message)
      setLoading(false)
    } else {
      router.push('/')
      router.refresh()
    }
  }

  return (
    <main style={{ maxWidth: 420, margin: '64px auto', padding: '0 24px 80px' }}>
      <h1 style={{
        fontSize: 28, fontWeight: 300, color: '#f5f0e8',
        fontFamily: 'var(--font-cormorant, Georgia, serif)',
        marginBottom: 6,
      }}>
        Log in
      </h1>
      <p style={{
        fontSize: 13, color: '#9d9080', marginBottom: 28,
        fontFamily: 'var(--font-inter, system-ui)',
      }}>
        Don&apos;t have an account?{' '}
        <Link href="/auth/signup" style={{ color: '#c9a962', textDecoration: 'none' }}>
          Sign up
        </Link>
      </p>

      <form onSubmit={handleSubmit} style={{
        background: '#16161a', border: '1px solid #2a2a30',
        borderRadius: 10, padding: 28,
      }}>
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
          {loading ? 'Logging in…' : 'Log in'}
        </button>
      </form>
    </main>
  )
}
