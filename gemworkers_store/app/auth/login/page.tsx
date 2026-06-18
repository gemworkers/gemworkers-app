'use client'

import { useState } from 'react'
import Link from 'next/link'
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
        <Link href="/" style={{ textDecoration: 'none', display: 'flex', alignItems: 'center', gap: 10 }}>
          <span style={{
            fontSize: 18, fontWeight: 700, letterSpacing: '0.13em',
            fontFamily: "Georgia, 'Times New Roman', serif", color: '#111',
          }}>
            GEMWORKERS
          </span>
          <span style={{
            fontSize: 9, fontWeight: 700, letterSpacing: '0.15em', color: '#9ca3af',
            border: '1px solid #e5e7eb', borderRadius: 3, padding: '2px 7px',
          }}>
            MARKETPLACE
          </span>
        </Link>
      </header>

      <main style={{ maxWidth: 420, margin: '64px auto', padding: '0 24px 80px' }}>
        <h1 style={{
          fontSize: 22, fontWeight: 700, color: '#111',
          fontFamily: "Georgia, 'Times New Roman', serif",
          marginBottom: 6,
        }}>
          Log in
        </h1>
        <p style={{ fontSize: 13, color: '#9ca3af', marginBottom: 28 }}>
          Don&apos;t have an account?{' '}
          <Link href="/auth/signup" style={{ color: '#374151', textDecoration: 'underline' }}>
            Sign up
          </Link>
        </p>

        <form onSubmit={handleSubmit} style={{
          background: '#fff', border: '1px solid #e5e7eb',
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
            {loading ? 'Logging in…' : 'Log in'}
          </button>
        </form>
      </main>
    </>
  )
}
