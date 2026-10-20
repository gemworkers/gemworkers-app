'use client'

import { useEffect, useRef, useState } from 'react'
import Link from 'next/link'
import { askAboutStone } from '@/app/actions/messages'
import {
  pillQuiet, pillDarkSm, pillOutlineSm, pillDisabledSm,
  panel, inputStyle, labelStyle,
} from '@/lib/ui'

const MAX_LEN = 2000

type State = 'closed' | 'open' | 'sending' | 'sent'

const helperText: React.CSSProperties = {
  fontSize: 13, color: '#6B6052', lineHeight: 1.55, margin: 0,
}

export function AskPanel({
  itemId,
  existingConversationId,
  needsFirstName,
  autoOpen = false,
}: {
  itemId: string
  // The buyer's conversation about this stone, if one exists (buyer_conversations)
  existingConversationId: string | null
  // No buyers.display_name and no previous order name → ask for a first name
  needsFirstName: boolean
  // ?ask=1 on the URL (returning from login)
  autoOpen?: boolean
}) {
  const [state, setState] = useState<State>(autoOpen ? 'open' : 'closed')
  const [body, setBody] = useState('')
  const [firstName, setFirstName] = useState('')
  const [errorMsg, setErrorMsg] = useState<string | null>(null)
  const [conversationId, setConversationId] = useState<string | null>(null)
  const panelRef = useRef<HTMLDivElement>(null)

  // Bring the auto-opened panel into view after returning from login.
  useEffect(() => {
    if (autoOpen && !existingConversationId) {
      panelRef.current?.scrollIntoView({ behavior: 'smooth', block: 'center' })
    }
  }, [autoOpen, existingConversationId])

  // ── Already talking about this stone ──────────────────────────────────────
  if (existingConversationId) {
    return (
      <Link href={`/messages/${existingConversationId}`} style={pillQuiet}>
        Continue conversation →
      </Link>
    )
  }

  // ── Sent ──────────────────────────────────────────────────────────────────
  if (state === 'sent' && conversationId) {
    return (
      <div style={{ ...panel, display: 'flex', flexDirection: 'column', gap: 8 }}>
        <p style={{ fontSize: 15, color: '#1F1B16', margin: 0 }}>
          Sent — we&apos;ll reply in your Messages.
        </p>
        <Link href={`/messages/${conversationId}`} className="pd-link" style={{ fontSize: 14 }}>
          View conversation →
        </Link>
      </div>
    )
  }

  // ── Closed ────────────────────────────────────────────────────────────────
  if (state === 'closed') {
    return (
      <button onClick={() => { setErrorMsg(null); setState('open') }} style={pillQuiet}>
        Ask about this stone
      </button>
    )
  }

  // ── Form ──────────────────────────────────────────────────────────────────
  const busy = state === 'sending'
  const trimmedLen = body.trim().length
  const canSend =
    !busy && trimmedLen > 0 && body.length <= MAX_LEN &&
    (!needsFirstName || firstName.trim().length > 0)

  async function handleSend() {
    if (!canSend) return
    setState('sending')
    setErrorMsg(null)
    const res = await askAboutStone(itemId, body, needsFirstName ? firstName : undefined)
    if ('error' in res) {
      setErrorMsg(res.error)
      setState('open')
    } else {
      setConversationId(res.conversationId)
      setState('sent')
    }
  }

  return (
    <div ref={panelRef} style={{ ...panel, display: 'flex', flexDirection: 'column', gap: 14 }}>
      <h2 className="font-serif" style={{ fontSize: 24, fontWeight: 500, color: '#1F1B16', margin: 0 }}>
        Ask about this stone
      </h2>

      {needsFirstName && (
        <div>
          <label style={labelStyle} htmlFor="ask-first-name">Your first name</label>
          <input
            id="ask-first-name"
            type="text"
            autoComplete="given-name"
            maxLength={50}
            value={firstName}
            onChange={e => setFirstName(e.target.value)}
            disabled={busy}
            style={inputStyle}
          />
        </div>
      )}

      <div>
        <label style={labelStyle} htmlFor="ask-body">Your question</label>
        <textarea
          id="ask-body"
          rows={5}
          maxLength={MAX_LEN}
          value={body}
          onChange={e => setBody(e.target.value)}
          disabled={busy}
          autoFocus={!needsFirstName}
          placeholder="e.g. Is this stone heated? Could you share a photo in daylight?"
          style={{ ...inputStyle, resize: 'vertical', lineHeight: 1.5, minHeight: 110 }}
        />
        <p style={{ fontSize: 12, color: '#6B6052', margin: '6px 0 0', textAlign: 'right' }}>
          {body.length} / {MAX_LEN}
        </p>
      </div>

      {errorMsg && (
        <p role="alert" style={{ fontSize: 13, color: '#B42318', margin: 0, lineHeight: 1.5 }}>
          {errorMsg}
        </p>
      )}

      <div style={{ display: 'flex', gap: 10, flexWrap: 'wrap' }}>
        <button
          onClick={handleSend}
          disabled={!canSend}
          style={{
            ...(canSend ? pillDarkSm : pillDisabledSm),
            flex: '1 1 160px', width: 'auto',
            cursor: canSend ? 'pointer' : 'default',
          }}
        >
          {busy ? 'Sending…' : 'Send'}
        </button>
        <button
          onClick={() => setState('closed')}
          disabled={busy}
          style={{ ...pillOutlineSm, flex: '1 1 100px', width: 'auto', cursor: busy ? 'default' : 'pointer' }}
        >
          Cancel
        </button>
      </div>

      <p style={helperText}>
        Our gem specialists usually reply within 24 hours. Everything stays here on
        GemWorkers, covered by our guarantee.
      </p>
    </div>
  )
}
