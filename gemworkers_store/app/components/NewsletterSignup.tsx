'use client'

import { useState } from 'react'
import Link from 'next/link'
import { subscribeNewsletter } from '@/app/actions/newsletter'
import { Turnstile, TURNSTILE_ENABLED } from '@/app/components/Turnstile'
import { inputStyle, pillDarkSm, pillDisabled } from '@/lib/ui'

// "New stones, first" (sql/newsletter.sql, double opt-in). The robot check
// only loads once someone starts typing, so pages stay light.
export function NewsletterSignup() {
  const [email, setEmail] = useState('')
  const [started, setStarted] = useState(false)
  const [token, setToken] = useState<string | null>(null)
  const [reset, setReset] = useState(0)
  const [state, setState] = useState<'idle' | 'sending' | 'sent' | 'error'>('idle')
  const [msg, setMsg] = useState<string | null>(null)

  const valid = /^[^\s@]+@[^\s@]+\.[^\s@]{2,}$/.test(email.trim()) && (!TURNSTILE_ENABLED || !!token)

  async function submit(e: React.FormEvent) {
    e.preventDefault()
    if (!valid) return
    setState('sending')
    const res = await subscribeNewsletter(email, token)
    if ('ok' in res) {
      setState('sent')
    } else {
      setMsg(res.error)
      setState('error')
      setReset(n => n + 1)
    }
  }

  if (state === 'sent') {
    return (
      <div style={{ maxWidth: 380 }}>
        <p style={{ fontSize: 15, fontWeight: 600, color: '#1F1B16', marginBottom: 6 }}>Almost done — check your inbox</p>
        <p style={{ fontSize: 13, color: '#5A5045', lineHeight: 1.6 }}>
          We sent a confirmation link to <strong>{email.trim()}</strong>. Click it and you&apos;re on the list.
        </p>
      </div>
    )
  }

  return (
    <form onSubmit={submit} style={{ maxWidth: 380 }}>
      <p style={{ fontSize: 9, fontWeight: 700, letterSpacing: '0.2em', textTransform: 'uppercase', color: '#7A5A22', marginBottom: 12 }}>
        New stones, first
      </p>
      <p style={{ fontSize: 13, color: '#5A5045', lineHeight: 1.6, marginBottom: 12 }}>
        Every stone is one of a kind. Get an email when new ones arrive — no spam, unsubscribe anytime.
      </p>
      <div style={{ display: 'flex', gap: 8, flexWrap: 'wrap' }}>
        <input
          type="email" inputMode="email" autoComplete="email" placeholder="you@example.com"
          aria-label="Your email"
          value={email}
          onChange={e => { setEmail(e.target.value); setStarted(true) }}
          onFocus={() => setStarted(true)}
          style={{ ...inputStyle, flex: '1 1 200px', height: 44 }}
        />
        <button type="submit" disabled={!valid || state === 'sending'}
          style={{ ...(valid ? pillDarkSm : pillDisabled), height: 44, width: 'auto', padding: '0 20px' }}>
          {state === 'sending' ? 'Sending…' : 'Sign up'}
        </button>
      </div>
      {started && <div style={{ marginTop: 10 }}><Turnstile onToken={setToken} resetKey={reset} /></div>}
      {state === 'error' && msg && <p style={{ fontSize: 13, color: '#B42318', marginTop: 8 }}>{msg}</p>}
      <p style={{ fontSize: 11, color: '#6B6052', lineHeight: 1.5, marginTop: 10 }}>
        By signing up you agree to receive emails from GemWorkers about new stones and offers.
        See our <Link href="/privacy" className="pd-link">Privacy Policy</Link>.
      </p>
    </form>
  )
}
