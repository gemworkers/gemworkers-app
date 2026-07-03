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
          color: '#9d9080', background: 'transparent',
          border: '1px solid #2a2a30', borderRadius: 6,
          textDecoration: 'none', letterSpacing: '0.02em',
          fontFamily: 'var(--font-inter, system-ui)',
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
          color: '#9d9080', background: 'transparent',
          border: '1px solid #2a2a30', borderRadius: 6,
          cursor: 'pointer', letterSpacing: '0.02em',
          fontFamily: 'var(--font-inter, system-ui)',
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
        color: '#4a4440', background: 'transparent',
        border: '1px solid #2a2a30', borderRadius: 6,
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
        border: '1px solid rgba(45,212,191,0.3)', borderRadius: 6,
        background: 'rgba(45,212,191,0.08)',
      }}>
        <div style={{ display: 'flex', alignItems: 'center', gap: 10 }}>
          <span style={{ fontSize: 13, fontWeight: 600, color: '#2dd4bf' }}>In cart</span>
          <Link href="/cart" style={{
            fontSize: 13, color: '#9d9080',
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
            fontSize: 12, color: '#4a4440', background: 'none', border: 'none',
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
        padding: '9px 12px', fontSize: 13, color: '#4a4440',
        border: '1px solid #2a2a30', borderRadius: 6,
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
      border: '1px solid rgba(220,38,38,0.35)', borderRadius: 6,
      background: 'rgba(220,38,38,0.08)',
    }}>
      <span style={{ fontSize: 12, color: '#f87171', flex: 1 }}>
        {errorMsg ?? 'Something went wrong.'}
      </span>
      <button
        onClick={() => { setErrorMsg(null); setState('idle') }}
        style={{
          fontSize: 12, color: '#9d9080', background: 'none',
          border: 'none', cursor: 'pointer', textDecoration: 'underline',
          textUnderlineOffset: 2, whiteSpace: 'nowrap',
        }}
      >
        Try again
      </button>
    </div>
  )
}
