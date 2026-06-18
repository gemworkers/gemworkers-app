'use client'

import { useState } from 'react'
import Link from 'next/link'
import { addToCart, removeFromCart } from '@/app/actions/commerce'

type Props = {
  itemId: string
  isLoggedIn: boolean
  initialInCart: boolean
}

type State = 'idle' | 'loading_add' | 'in_cart' | 'loading_remove' | 'error'

export function CartButton({ itemId, isLoggedIn, initialInCart }: Props) {
  const [state, setState] = useState<State>(initialInCart ? 'in_cart' : 'idle')
  const [errorMsg, setErrorMsg] = useState<string | null>(null)

  // ── Logged-out ─────────────────────────────────────────────────────────────
  if (!isLoggedIn) {
    return (
      <Link
        href="/auth/login"
        style={{
          display: 'block', textAlign: 'center',
          padding: '9px 0', fontSize: 13, fontWeight: 500,
          color: '#6b7280', background: '#fff',
          border: '1px solid #e5e7eb', borderRadius: 6,
          textDecoration: 'none', letterSpacing: '0.02em',
        }}
      >
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
        style={{
          width: '100%', padding: '9px 0', fontSize: 13, fontWeight: 500,
          color: '#374151', background: '#fff',
          border: '1px solid #d1d5db', borderRadius: 6,
          cursor: 'pointer', letterSpacing: '0.02em',
        }}
      >
        Add to cart
      </button>
    )
  }

  // ── Adding ─────────────────────────────────────────────────────────────────
  if (state === 'loading_add') {
    return (
      <button disabled style={{
        width: '100%', padding: '9px 0', fontSize: 13, fontWeight: 500,
        color: '#9ca3af', background: '#fff',
        border: '1px solid #e5e7eb', borderRadius: 6,
        cursor: 'not-allowed',
      }}>
        Adding…
      </button>
    )
  }

  // ── In cart ────────────────────────────────────────────────────────────────
  if (state === 'in_cart') {
    return (
      <div style={{
        display: 'flex', alignItems: 'center', justifyContent: 'space-between',
        padding: '9px 12px',
        border: '1px solid #d1fae5', borderRadius: 6,
        background: '#f0fdf4',
      }}>
        <div style={{ display: 'flex', alignItems: 'center', gap: 10 }}>
          <span style={{ fontSize: 13, fontWeight: 600, color: '#059669' }}>In cart</span>
          <Link href="/cart" style={{
            fontSize: 13, color: '#374151',
            textDecoration: 'underline', textUnderlineOffset: 2,
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
            fontSize: 12, color: '#9ca3af', background: 'none', border: 'none',
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
      <div style={{
        padding: '9px 12px', fontSize: 13, color: '#9ca3af',
        border: '1px solid #e5e7eb', borderRadius: 6,
      }}>
        Removing…
      </div>
    )
  }

  // ── Error ──────────────────────────────────────────────────────────────────
  return (
    <div style={{
      display: 'flex', alignItems: 'center', gap: 10,
      padding: '9px 12px',
      border: '1px solid #fecaca', borderRadius: 6,
      background: '#fef2f2',
    }}>
      <span style={{ fontSize: 12, color: '#dc2626', flex: 1 }}>
        {errorMsg ?? 'Something went wrong.'}
      </span>
      <button
        onClick={() => { setErrorMsg(null); setState('idle') }}
        style={{
          fontSize: 12, color: '#374151', background: 'none',
          border: 'none', cursor: 'pointer', textDecoration: 'underline',
          textUnderlineOffset: 2, whiteSpace: 'nowrap',
        }}
      >
        Try again
      </button>
    </div>
  )
}
