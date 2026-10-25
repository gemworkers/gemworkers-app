'use client'

import { useState } from 'react'
import { setFavourite } from '@/app/actions/favourites'

// Heart toggle. loggedIn = false sends the visitor to log in first and back.
export function FavouriteButton({
  itemId,
  initial,
  loggedIn,
  variant = 'card',
}: {
  itemId: string
  initial: boolean
  loggedIn: boolean
  variant?: 'card' | 'page'
}) {
  const [on, setOn] = useState(initial)
  const [busy, setBusy] = useState(false)

  async function toggle(e: React.MouseEvent) {
    // Cards sit inside a link: don't open the stone.
    e.preventDefault()
    e.stopPropagation()
    if (!loggedIn) {
      window.location.href = `/auth/login?next=${encodeURIComponent(window.location.pathname + window.location.search)}`
      return
    }
    if (busy) return
    const next = !on
    setOn(next)
    setBusy(true)
    const r = await setFavourite(itemId, next)
    setBusy(false)
    if ('error' in r) {
      setOn(!next)
      if (r.login) window.location.href = `/auth/login?next=${encodeURIComponent(window.location.pathname)}`
    }
  }

  const label = on ? 'Remove from favourites' : 'Save to favourites'
  const heart = (
    <svg width={variant === 'card' ? 18 : 20} height={variant === 'card' ? 18 : 20} viewBox="0 0 24 24" aria-hidden="true"
      fill={on ? '#B42318' : 'none'} stroke={on ? '#B42318' : '#1F1B16'} strokeWidth="1.8" strokeLinejoin="round">
      <path d="M12 20.5s-7.5-4.6-9.3-9.1C1.4 8.1 3.4 4.5 7 4.5c2 0 3.4 1.1 5 3 1.6-1.9 3-3 5-3 3.6 0 5.6 3.6 4.3 6.9-1.8 4.5-9.3 9.1-9.3 9.1z" />
    </svg>
  )

  if (variant === 'page') {
    return (
      <button type="button" onClick={toggle} aria-pressed={on} aria-label={label}
        className="pd-link"
        style={{ display: 'inline-flex', alignItems: 'center', gap: 8, background: 'none', border: 0, padding: 0, cursor: 'pointer', fontSize: 14 }}>
        {heart}{on ? 'Saved to favourites' : 'Save to favourites'}
      </button>
    )
  }
  return (
    <button type="button" onClick={toggle} aria-pressed={on} aria-label={label} title={label}
      style={{
        position: 'absolute', top: 10, right: 10, zIndex: 2,
        width: 36, height: 36, borderRadius: 18, border: 0, cursor: 'pointer',
        display: 'flex', alignItems: 'center', justifyContent: 'center',
        background: 'rgba(255,255,255,0.88)', boxShadow: '0 1px 4px rgba(0,0,0,0.12)',
      }}>
      {heart}
    </button>
  )
}
