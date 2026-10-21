'use client'

import { useEffect, useRef, useState } from 'react'
import { useRouter } from 'next/navigation'
import { sendBuyerMessage, markConversationRead, type AttachableStone } from '@/app/actions/messages'
import { pillDarkSm, pillDisabledSm, inputStyle } from '@/lib/ui'
import { LocalTime, MessageStoneCard, type StoneCardData, type ThreadMessage } from '../shared'
import { AttachStonePicker, AttachedStoneChip } from '../AttachStonePicker'

const MAX_LEN = 2000
// Buyers can't subscribe to Realtime, so the thread re-fetches on a timer.
const REFRESH_MS = 20_000

export function ThreadView({
  conversationId,
  stone,
  stones,
  messages,
  closed,
  unreadCount,
}: {
  conversationId: string
  stone: StoneCardData | null
  // message_stone_cards for the conversation stone + every linked stone
  stones: Record<string, StoneCardData>
  messages: ThreadMessage[]
  closed: boolean
  unreadCount: number
}) {
  const router = useRouter()
  const [body, setBody] = useState('')
  // Picked stone wins over a pasted stone link (one linked stone per message)
  const [attached, setAttached] = useState<AttachableStone | null>(null)
  const [sending, setSending] = useState(false)
  const [errorMsg, setErrorMsg] = useState<string | null>(null)
  const endRef = useRef<HTMLDivElement>(null)
  const seenCount = useRef(messages.length)

  // Unread replies on screen → mark read, then refresh so the header dot clears.
  useEffect(() => {
    if (unreadCount === 0) return
    let cancelled = false
    markConversationRead(conversationId).then(res => {
      if (!cancelled && 'ok' in res) router.refresh()
    })
    return () => { cancelled = true }
  }, [conversationId, unreadCount, router])

  // Poll for new messages while the tab is visible; catch up when it returns.
  useEffect(() => {
    const tick = () => { if (document.visibilityState === 'visible') router.refresh() }
    const timer = setInterval(tick, REFRESH_MS)
    document.addEventListener('visibilitychange', tick)
    return () => {
      clearInterval(timer)
      document.removeEventListener('visibilitychange', tick)
    }
  }, [router])

  // Open at the latest message; follow new ones as they arrive.
  useEffect(() => {
    endRef.current?.scrollIntoView({ block: 'end' })
  }, [])
  useEffect(() => {
    if (messages.length > seenCount.current) {
      endRef.current?.scrollIntoView({ behavior: 'smooth', block: 'end' })
    }
    seenCount.current = messages.length
  }, [messages.length])

  const canSend = !sending && body.trim().length > 0 && body.length <= MAX_LEN

  async function handleSend() {
    if (!canSend) return
    setSending(true)
    setErrorMsg(null)
    const res = await sendBuyerMessage(conversationId, body, attached?.id ?? null)
    if ('error' in res) {
      setErrorMsg(res.error)
    } else {
      setBody('')
      setAttached(null)
      router.refresh()
    }
    setSending(false)
  }

  return (
    <div className="msg-thread">
      <MessageStoneCard stone={stone} />

      <div className="msg-bubbles">
        {messages.map(m => {
          const linked = m.linked_inventory_item_id
          return (
            <div key={m.id} className={`msg-bubble-row ${m.is_mine ? 'is-mine' : ''}`}>
              {!m.is_mine && <p className="msg-sender">GemWorkers</p>}
              <div className="msg-bubble">{m.body}</div>
              {linked && (
                <div className="msg-linked">
                  <MessageStoneCard stone={stones[linked] ?? null} size="small" />
                </div>
              )}
              <p className="msg-time"><LocalTime iso={m.created_at} mode="thread" /></p>
            </div>
          )
        })}
        <div ref={endRef} />
      </div>

      {closed ? (
        <p className="msg-closed">This conversation is closed</p>
      ) : (
        <div className="msg-reply">
          {attached && (
            <AttachedStoneChip stone={attached} onRemove={() => setAttached(null)} disabled={sending} />
          )}

          <label htmlFor="msg-reply-body" className="sr-only">Your reply</label>
          <textarea
            id="msg-reply-body"
            rows={3}
            maxLength={MAX_LEN}
            value={body}
            onChange={e => setBody(e.target.value)}
            onKeyDown={e => {
              if (e.key === 'Enter' && (e.metaKey || e.ctrlKey)) { e.preventDefault(); handleSend() }
            }}
            disabled={sending}
            placeholder="Write a reply…"
            style={{ ...inputStyle, resize: 'vertical', lineHeight: 1.5, minHeight: 88 }}
          />

          {errorMsg && (
            <p role="alert" style={{ fontSize: 13, color: '#B42318', margin: 0, lineHeight: 1.5 }}>
              {errorMsg}
            </p>
          )}

          <div className="msg-reply-foot">
            <span style={{ fontSize: 12, color: '#6B6052' }}>{body.length} / {MAX_LEN}</span>
            <div className="msg-reply-actions">
              <AttachStonePicker onPick={setAttached} align="right" disabled={sending} />
              <button
                onClick={handleSend}
                disabled={!canSend}
                style={{
                  ...(canSend ? pillDarkSm : pillDisabledSm),
                  width: 'auto', minWidth: 120,
                  cursor: canSend ? 'pointer' : 'default',
                }}
              >
                {sending ? 'Sending…' : 'Send'}
              </button>
            </div>
          </div>
        </div>
      )}
    </div>
  )
}
