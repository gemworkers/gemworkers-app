'use client'

import { useState } from 'react'
import Link from 'next/link'
import { buyNow } from '@/app/actions/commerce'

const eur = new Intl.NumberFormat('en-IE', {
  style: 'currency',
  currency: 'EUR',
  maximumFractionDigits: 0,
})

type Props = {
  itemId: string
  itemTitle: string
  sellingPrice: number | null
  shippingCost?: number | null
  isLoggedIn: boolean
}

type State = 'idle' | 'confirm' | 'loading' | 'error'

export function BuyButton({ itemId, itemTitle, sellingPrice, shippingCost, isLoggedIn }: Props) {
  const [state, setState] = useState<State>('idle')
  const [errorMsg, setErrorMsg] = useState<string | null>(null)

  if (sellingPrice == null) return null

  const formatted = eur.format(sellingPrice)

  // ── Logged-out ────────────────────────────────────────────────────────────
  if (!isLoggedIn) {
    return (
      <Link
        href="/auth/login"
        style={{
          display: 'block', textAlign: 'center',
          padding: '11px 0', fontSize: 13, fontWeight: 600,
          color: '#c9a962',
          border: '1px solid rgba(201,169,98,0.5)', borderRadius: 6,
          textDecoration: 'none', letterSpacing: '0.06em',
          fontFamily: 'var(--font-inter, system-ui)',
        }}
      >
        Log in to buy
      </Link>
    )
  }

  // ── Idle ──────────────────────────────────────────────────────────────────
  if (state === 'idle') {
    return (
      <button
        onClick={() => setState('confirm')}
        style={{
          width: '100%', padding: '11px 0', fontSize: 13, fontWeight: 600,
          color: '#0e0e10', background: '#c9a962',
          border: 'none', borderRadius: 6,
          cursor: 'pointer', letterSpacing: '0.06em',
          fontFamily: 'var(--font-inter, system-ui)',
        }}
      >
        Buy now
      </button>
    )
  }

  // ── Confirm ───────────────────────────────────────────────────────────────
  if (state === 'confirm') {
    async function handleConfirm() {
      setState('loading')
      const result = await buyNow(itemId)
      if ('checkoutUrl' in result) {
        window.location.href = result.checkoutUrl
      } else {
        setErrorMsg(result.error)
        setState('error')
      }
    }

    return (
      <div style={{
        border: '1px solid #2a2a30', borderRadius: 8,
        padding: '16px 18px', background: '#16161a',
      }}>
        <p style={{
          fontSize: 13, fontWeight: 600, color: '#f5f0e8',
          marginBottom: 6, fontFamily: 'var(--font-inter, system-ui)',
        }}>
          Confirm purchase
        </p>
        {shippingCost != null && shippingCost > 0 ? (
          <div style={{ marginBottom: 14 }}>
            <div style={{
              display: 'flex', justifyContent: 'space-between',
              fontSize: 13, color: '#9d9080', marginBottom: 3,
            }}>
              <span>Stone</span>
              <span>{formatted}</span>
            </div>
            <div style={{
              display: 'flex', justifyContent: 'space-between',
              fontSize: 13, color: '#9d9080', marginBottom: 6,
            }}>
              <span>Shipping</span>
              <span>{eur.format(shippingCost)}</span>
            </div>
            <div style={{ height: 1, background: '#2a2a30', marginBottom: 6 }} />
            <div style={{
              display: 'flex', justifyContent: 'space-between',
              fontSize: 14, fontWeight: 700, color: '#f5f0e8',
            }}>
              <span>Total</span>
              <span>{eur.format(sellingPrice! + shippingCost)}</span>
            </div>
          </div>
        ) : (
          <p style={{ fontSize: 13, color: '#9d9080', lineHeight: 1.55, marginBottom: 4 }}>
            Buy <strong style={{ color: '#f5f0e8' }}>{itemTitle}</strong> for{' '}
            <strong style={{ color: '#f5f0e8' }}>{formatted}</strong>?
          </p>
        )}
        <p style={{ fontSize: 12, color: '#4a4440', marginBottom: 18 }}>
          This reserves the stone — it will no longer be available to other buyers.
        </p>
        <div style={{ display: 'flex', gap: 10 }}>
          <button
            onClick={handleConfirm}
            style={{
              flex: 1, padding: '9px 0', fontSize: 13, fontWeight: 600,
              color: '#0e0e10', background: '#c9a962',
              border: 'none', borderRadius: 6,
              cursor: 'pointer', letterSpacing: '0.04em',
            }}
          >
            Confirm purchase
          </button>
          <button
            onClick={() => setState('idle')}
            style={{
              flex: 1, padding: '9px 0', fontSize: 13, fontWeight: 500,
              color: '#9d9080',
              background: '#1e1e24', border: '1px solid #2a2a30',
              borderRadius: 6, cursor: 'pointer',
            }}
          >
            Cancel
          </button>
        </div>
      </div>
    )
  }

  // ── Loading ───────────────────────────────────────────────────────────────
  if (state === 'loading') {
    return (
      <button
        disabled
        style={{
          width: '100%', padding: '11px 0', fontSize: 13, fontWeight: 600,
          color: '#0e0e10', background: '#7a6234',
          border: 'none', borderRadius: 6,
          cursor: 'not-allowed', letterSpacing: '0.06em',
        }}
      >
        Placing order…
      </button>
    )
  }

  // ── Error ─────────────────────────────────────────────────────────────────
  return (
    <div style={{
      border: '1px solid rgba(220,38,38,0.35)', borderRadius: 8,
      padding: '16px 18px', background: 'rgba(220,38,38,0.08)',
    }}>
      <p style={{ fontSize: 13, color: '#f87171', lineHeight: 1.5, marginBottom: 14 }}>
        {errorMsg ?? 'Something went wrong — please try again.'}
      </p>
      <button
        onClick={() => { setErrorMsg(null); setState('idle') }}
        style={{
          fontSize: 13, fontWeight: 500, color: '#9d9080',
          background: '#1e1e24', border: '1px solid #2a2a30',
          borderRadius: 6, padding: '7px 16px', cursor: 'pointer',
        }}
      >
        Try again
      </button>
    </div>
  )
}
