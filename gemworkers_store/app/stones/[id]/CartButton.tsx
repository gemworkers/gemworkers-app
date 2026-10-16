'use client'

import { useState } from 'react'
import Link from 'next/link'
import { addToCart, removeFromCart } from '@/app/actions/commerce'
import { pillOutline, pillDisabled } from '@/lib/ui'

type Props = {
  itemId: string
  isLoggedIn: boolean
  initialInCart: boolean
}

type State = 'idle' | 'loading_add' | 'in_cart' | 'loading_remove' | 'error'

const barStyle: React.CSSProperties = {
  display: 'flex', alignItems: 'center', justifyContent: 'space-between', gap: 12,
  minHeight: 52, padding: '8px 24px', borderRadius: 28, boxSizing: 'border-box',
}

export function CartButton({ itemId, isLoggedIn, initialInCart }: Props) {
  const [state, setState] = useState<State>(initialInCart ? 'in_cart' : 'idle')
  const [errorMsg, setErrorMsg] = useState<string | null>(null)

  // ── Logged-out ─────────────────────────────────────────────────────────────
  if (!isLoggedIn) {
    return (
      <Link href={`/auth/login?next=${encodeURIComponent(`/stones/${itemId}`)}`} style={pillOutline}>
        Log in to save
      </Link>
    )
  }

  // ── Idle ───────────────────────────────────────────────────────────────────
  if (state === 'idle') {
    return (
      <button
        onClick={async () => {
          setState('loading_add')
          const result = await addToCart(itemId)
          if ('ok' in result) {
            setState('in_cart')
          } else {
            setErrorMsg(result.error)
            setState('error')
          }
        }}
        style={pillOutline}
      >
        Add to cart
      </button>
    )
  }

  // ── Adding ─────────────────────────────────────────────────────────────────
  if (state === 'loading_add') {
    return (
      <button disabled style={pillDisabled}>
        Adding…
      </button>
    )
  }

  // ── In cart ────────────────────────────────────────────────────────────────
  if (state === 'in_cart') {
    return (
      <div style={{
        ...barStyle,
        border: '1px solid rgba(46,122,111,0.35)',
        background: 'rgba(46,122,111,0.08)',
      }}>
        <div style={{ display: 'flex', alignItems: 'center', gap: 12 }}>
          <span style={{ fontSize: 15, fontWeight: 600, color: '#2E7A6F' }}>In cart</span>
          <Link href="/cart" style={{
            fontSize: 14, color: '#1F1B16',
            textDecoration: 'underline', textUnderlineOffset: 3,
          }}>
            View cart
          </Link>
        </div>
        <button
          onClick={async () => {
            setState('loading_remove')
            const result = await removeFromCart(itemId)
            if ('ok' in result) {
              setState('idle')
            } else {
              setErrorMsg(result.error)
              setState('error')
            }
          }}
          style={{
            fontSize: 14, color: '#5A5045', background: 'none', border: 'none',
            cursor: 'pointer', padding: 0,
          }}
        >
          Remove
        </button>
      </div>
    )
  }

  // ── Removing ───────────────────────────────────────────────────────────────
  if (state === 'loading_remove') {
    return (
      <div style={{ ...barStyle, fontSize: 14, color: '#6B6052', border: '1px solid #ECE5D8' }}>
        Removing…
      </div>
    )
  }

  // ── Error ──────────────────────────────────────────────────────────────────
  return (
    <div style={{
      ...barStyle,
      border: '1px solid rgba(180,35,24,0.25)',
      background: 'rgba(180,35,24,0.06)',
    }}>
      <span style={{ fontSize: 13, color: '#B42318', flex: 1 }}>
        {errorMsg ?? 'Something went wrong.'}
      </span>
      <button
        onClick={() => { setErrorMsg(null); setState('idle') }}
        style={{
          fontSize: 14, color: '#1F1B16', background: 'none',
          border: 'none', cursor: 'pointer', textDecoration: 'underline',
          textUnderlineOffset: 3, whiteSpace: 'nowrap', padding: 0,
        }}
      >
        Try again
      </button>
    </div>
  )
}
