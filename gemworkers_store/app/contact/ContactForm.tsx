'use client'

import { useActionState, useState } from 'react'
import { submitContact } from '@/app/actions/contact'
import { TOPICS, type ContactState } from './contact-shared'

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

const fieldStyle: React.CSSProperties = { marginBottom: 18 }

interface ContactFormProps {
  initialTopic?: string
}

export function ContactForm({ initialTopic }: ContactFormProps) {
  const [state, formAction, isPending] = useActionState<ContactState, FormData>(
    submitContact,
    { ok: false }
  )

  // Set once at mount — used server-side to detect sub-3s bot submissions
  const [renderTime] = useState(() => Date.now().toString())

  const validInitialTopic = (TOPICS as readonly string[]).includes(initialTopic ?? '')
    ? (initialTopic ?? '')
    : ''

  // Controlled field state — preserves values across failed submissions
  // (React 19 resets uncontrolled form elements after a server action completes)
  const [name,    setName]    = useState('')
  const [email,   setEmail]   = useState('')
  const [topic,   setTopic]   = useState(validInitialTopic)
  const [message, setMessage] = useState('')

  if (state.ok) {
    return (
      <p style={{
        fontSize: 15, lineHeight: 1.7, color: '#1F1B16',
        background: '#F4EEE4', border: '1px solid #ECE5D8',
        borderRadius: 8, padding: '20px 24px',
        fontFamily: 'var(--font-inter, system-ui)',
      }}>
        Thank you, your message has been sent. We aim to reply within 1–2 business days.
      </p>
    )
  }

  return (
    <form action={formAction} style={{
      background: '#FFFFFF', border: '1px solid #ECE5D8',
      borderRadius: 10, padding: 28,
    }}>
      {/* Honeypot — hidden from real users, filled only by bots */}
      <input
        type="text"
        name="website"
        tabIndex={-1}
        autoComplete="off"
        aria-hidden="true"
        style={{ position: 'absolute', left: '-9999px', width: 1, height: 1, overflow: 'hidden' }}
      />
      <input type="hidden" name="renderTime" value={renderTime} />

      {state.error && (
        <p style={{
          fontSize: 13, color: '#B42318',
          background: 'rgba(180,35,24,0.06)',
          border: '1px solid rgba(180,35,24,0.25)',
          borderRadius: 6, padding: '8px 12px', marginBottom: 20,
          fontFamily: 'var(--font-inter, system-ui)',
        }}>
          {state.error}
        </p>
      )}

      <div style={fieldStyle}>
        <label style={labelStyle}>Name</label>
        <input
          type="text"
          name="name"
          required
          autoComplete="name"
          value={name}
          onChange={e => setName(e.target.value)}
          style={inputStyle}
        />
      </div>

      <div style={fieldStyle}>
        <label style={labelStyle}>Email</label>
        <input
          type="email"
          name="email"
          required
          autoComplete="email"
          value={email}
          onChange={e => setEmail(e.target.value)}
          style={inputStyle}
        />
      </div>

      <div style={fieldStyle}>
        <label style={labelStyle}>Topic</label>
        <select
          name="topic"
          required
          value={topic}
          onChange={e => setTopic(e.target.value)}
          style={{
            ...inputStyle,
            cursor: 'pointer',
            appearance: 'none',
            backgroundImage: "url(\"data:image/svg+xml,%3Csvg width='10' height='6' viewBox='0 0 10 6' fill='none' xmlns='http://www.w3.org/2000/svg'%3E%3Cpath d='M1 1l4 4 4-4' stroke='%235A5045' stroke-width='1.5' stroke-linecap='round' stroke-linejoin='round'/%3E%3C/svg%3E\")",
            backgroundRepeat: 'no-repeat',
            backgroundPosition: 'right 12px center',
            paddingRight: 32,
          } as React.CSSProperties}
        >
          <option value="" disabled>Select a topic…</option>
          {TOPICS.map(t => (
            <option key={t} value={t}>{t}</option>
          ))}
        </select>
      </div>

      <div style={{ marginBottom: 24 }}>
        <label style={labelStyle}>Message</label>
        <textarea
          name="message"
          required
          rows={6}
          value={message}
          onChange={e => setMessage(e.target.value)}
          style={{ ...inputStyle, resize: 'vertical', lineHeight: 1.6 } as React.CSSProperties}
        />
      </div>

      <button
        type="submit"
        disabled={isPending}
        style={{
          width: '100%', padding: '10px 0', fontSize: 13, fontWeight: 600,
          color: '#FBF8F3', background: isPending ? '#B89A63' : '#7A5A22',
          border: 'none', borderRadius: 6,
          cursor: isPending ? 'not-allowed' : 'pointer',
          letterSpacing: '0.06em',
          fontFamily: 'var(--font-inter, system-ui)',
        }}
      >
        {isPending ? 'Sending…' : 'Send message'}
      </button>
    </form>
  )
}
