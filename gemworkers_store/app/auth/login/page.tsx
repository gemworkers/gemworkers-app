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
        fontSize: 28, fontWeight: 300, color: '#1F1B16',
        fontFamily: 'var(--font-cormorant, Georgia, serif)',
        marginBottom: 6,
      }}>
        Log in
      </h1>
      <p style={{
        fontSize: 13, color: '#5A5045', marginBottom: 28,
        fontFamily: 'var(--font-inter, system-ui)',
      }}>
        Don&apos;t have an account?{' '}
        <Link href="/auth/signup" style={{ color: '#7A5A22', textDecoration: 'none' }}>
          Sign up
        </Link>
      </p>

      <form onSubmit={handleSubmit} style={{
        background: '#FFFFFF', border: '1px solid #ECE5D8',
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
          {loading ? 'Logging in…' : 'Log in'}
        </button>
      </form>
    </main>
  )
}
