'use client'

import { useEffect, useRef, useState } from 'react'
import { searchAttachableStones, type AttachableStone } from '@/app/actions/messages'
import { pillQuiet, inputStyle } from '@/lib/ui'

// "Attach a stone" for buyer messages: a quiet button that opens a searchable
// list of public stones (popover on desktop, bottom sheet on mobile), plus the
// removable chip shown above the textarea once a stone is picked.
// One stone per message; the DB re-checks that it is still publicly visible.

const SEARCH_DEBOUNCE_MS = 250

const eur = new Intl.NumberFormat('en-IE', {
  style: 'currency', currency: 'EUR', maximumFractionDigits: 0,
})

function GemIcon() {
  return (
    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" aria-hidden="true"
      stroke="currentColor" strokeWidth="1.75" strokeLinecap="round" strokeLinejoin="round">
      <path d="M6 3h12l4 6-10 12L2 9z" /><path d="M2 9h20" /><path d="M12 21L8 9l4-6 4 6z" />
    </svg>
  )
}

export function AttachedStoneChip({
  stone,
  onRemove,
  disabled = false,
}: {
  stone: AttachableStone
  onRemove: () => void
  disabled?: boolean
}) {
  return (
    <div className="msg-attach-chip">
      <GemIcon />
      <span className="msg-attach-chip-text">Attached: {stone.title}</span>
      <button
        type="button"
        onClick={onRemove}
        disabled={disabled}
        aria-label={`Remove ${stone.title}`}
        className="msg-attach-chip-remove"
      >
        ✕
      </button>
    </div>
  )
}

export function AttachStonePicker({
  onPick,
  align = 'left',
  disabled = false,
}: {
  onPick: (stone: AttachableStone) => void
  // Which edge of the button the desktop popover lines up with
  align?: 'left' | 'right'
  disabled?: boolean
}) {
  const [open, setOpen] = useState(false)
  const [query, setQuery] = useState('')
  const [stones, setStones] = useState<AttachableStone[] | null>(null)
  const [loading, setLoading] = useState(false)
  const [errorMsg, setErrorMsg] = useState<string | null>(null)
  const wrapRef = useRef<HTMLDivElement>(null)
  const requestId = useRef(0)

  // Search (debounced) while open; only the latest response is kept.
  useEffect(() => {
    if (!open) return
    const id = ++requestId.current
    setLoading(true)
    const timer = setTimeout(async () => {
      const res = await searchAttachableStones(query)
      if (id !== requestId.current) return
      if ('error' in res) {
        setErrorMsg(res.error)
        setStones(null)
      } else {
        setErrorMsg(null)
        setStones(res.stones)
      }
      setLoading(false)
    }, query ? SEARCH_DEBOUNCE_MS : 0)
    return () => clearTimeout(timer)
  }, [open, query])

  // Close on Escape or a click outside.
  useEffect(() => {
    if (!open) return
    const onKey = (e: KeyboardEvent) => { if (e.key === 'Escape') setOpen(false) }
    const onDown = (e: MouseEvent) => {
      if (wrapRef.current && !wrapRef.current.contains(e.target as Node)) setOpen(false)
    }
    document.addEventListener('keydown', onKey)
    document.addEventListener('mousedown', onDown)
    return () => {
      document.removeEventListener('keydown', onKey)
      document.removeEventListener('mousedown', onDown)
    }
  }, [open])

  function pick(stone: AttachableStone) {
    onPick(stone)
    setOpen(false)
  }

  return (
    <div ref={wrapRef} className={`msg-attach ${align === 'right' ? 'align-right' : ''}`}>
      <button
        type="button"
        onClick={() => setOpen(o => !o)}
        disabled={disabled}
        aria-expanded={open}
        style={{
          ...pillQuiet, height: 44, width: 'auto', gap: 8, padding: '0 18px',
          cursor: disabled ? 'default' : 'pointer',
        }}
      >
        <GemIcon /> Attach a stone
      </button>

      {open && (
        <div className="msg-attach-panel" role="dialog" aria-label="Attach a stone">
          <div className="msg-attach-head">
            <label htmlFor="msg-attach-search" className="sr-only">Search stones</label>
            <input
              id="msg-attach-search"
              type="search"
              autoFocus
              autoComplete="off"
              maxLength={60}
              value={query}
              onChange={e => setQuery(e.target.value)}
              placeholder="Search by title or gem type"
              style={inputStyle}
            />
            <button
              type="button"
              onClick={() => setOpen(false)}
              aria-label="Close"
              className="msg-attach-close"
            >
              ✕
            </button>
          </div>

          <div className="msg-attach-list">
            {errorMsg ? (
              <p role="alert" className="msg-attach-note" style={{ color: '#B42318' }}>{errorMsg}</p>
            ) : stones === null ? (
              <p className="msg-attach-note">Loading…</p>
            ) : stones.length === 0 ? (
              <p className="msg-attach-note">{loading ? 'Searching…' : 'No stones found.'}</p>
            ) : (
              <ul style={{ listStyle: 'none', margin: 0, padding: 0, opacity: loading ? 0.6 : 1 }}>
                {stones.map(s => (
                  <li key={s.id}>
                    <button type="button" onClick={() => pick(s)} className="msg-attach-item">
                      <span className="msg-attach-thumb">
                        {s.image_url && (
                          // eslint-disable-next-line @next/next/no-img-element
                          <img src={s.image_url} alt="" />
                        )}
                      </span>
                      <span style={{ minWidth: 0, flex: 1 }}>
                        <span className="msg-attach-title">{s.title}</span>
                        {s.gem_type && <span className="msg-attach-sub">{s.gem_type}</span>}
                      </span>
                      {s.selling_price != null && (
                        <span className="msg-attach-price">{eur.format(s.selling_price)}</span>
                      )}
                    </button>
                  </li>
                ))}
              </ul>
            )}
          </div>
        </div>
      )}
    </div>
  )
}
