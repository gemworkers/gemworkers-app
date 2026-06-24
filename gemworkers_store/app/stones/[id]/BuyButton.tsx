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

  // No asking price → direct buy is not available (offer flow is a future step).
  if (sellingPrice == null) return null

  const formatted = eur.format(sellingPrice)

  // ── Logged-out ────────────────────────────────────────────────────────────
  if (!isLoggedIn) {
    return (
      <Link
        href="/auth/login"
        style={{
          display: 'block', textAlign: 'center',
          padding: '11px 0', fontSize: 14, fontWeight: 600,
          color: '#374151', background: '#fff',
          border: '1.5px solid #d1d5db', borderRadius: 6,
          textDecoration: 'none', letterSpacing: '0.02em',
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
          width: '100%', padding: '11px 0', fontSize: 14, fontWeight: 600,
          color: '#fff', background: '#111', border: 'none', borderRadius: 6,
          cursor: 'pointer', letterSpacing: '0.02em',
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
        // Redirect the buyer to the Stripe-hosted checkout page.
        // The order is confirmed only after successful payment (webhook step).
        window.location.href = result.checkoutUrl
        // Stay in loading state while the browser navigates away.
      } else {
        setErrorMsg(result.error)
        setState('error')
      }
    }

    return (
      <div style={{
        border: '1px solid #e5e7eb', borderRadius: 8,
        padding: '16px 18px', background: '#fff',
      }}>
        <p style={{ fontSize: 14, fontWeight: 600, color: '#111', marginBottom: 6 }}>
          Confirm purchase
        </p>
        {shippingCost != null && shippingCost > 0 ? (
          <div style={{ marginBottom: 14 }}>
            <div style={{
              display: 'flex', justifyContent: 'space-between',
              fontSize: 13, color: '#6b7280', marginBottom: 3,
            }}>
              <span>Stone</span>
              <span>{formatted}</span>
            </div>
            <div style={{
              display: 'flex', justifyContent: 'space-between',
              fontSize: 13, color: '#6b7280', marginBottom: 6,
            }}>
              <span>Shipping</span>
              <span>{eur.format(shippingCost)}</span>
            </div>
            <div style={{ height: 1, background: '#e5e7eb', marginBottom: 6 }} />
            <div style={{
              display: 'flex', justifyContent: 'space-between',
              fontSize: 14, fontWeight: 700, color: '#111',
            }}>
              <span>Total</span>
              <span>{eur.format(sellingPrice! + shippingCost)}</span>
            </div>
          </div>
        ) : (
          <p style={{ fontSize: 13, color: '#374151', lineHeight: 1.55, marginBottom: 4 }}>
            Buy <strong>{itemTitle}</strong> for <strong>{formatted}</strong>?
          </p>
        )}
        <p style={{ fontSize: 12, color: '#9ca3af', marginBottom: 18 }}>
          This reserves the stone — it will no longer be available to other buyers.
        </p>
        <div style={{ display: 'flex', gap: 10 }}>
          <button
            onClick={handleConfirm}
            style={{
              flex: 1, padding: '9px 0', fontSize: 13, fontWeight: 600,
              color: '#fff', background: '#111', border: 'none', borderRadius: 6,
              cursor: 'pointer', letterSpacing: '0.02em',
            }}
          >
            Confirm purchase
          </button>
          <button
            onClick={() => setState('idle')}
            style={{
              flex: 1, padding: '9px 0', fontSize: 13, fontWeight: 500,
              color: '#374151', background: '#f3f4f6', border: 'none', borderRadius: 6,
              cursor: 'pointer',
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
          width: '100%', padding: '11px 0', fontSize: 14, fontWeight: 600,
          color: '#fff', background: '#6b7280', border: 'none', borderRadius: 6,
          cursor: 'not-allowed', letterSpacing: '0.02em',
        }}
      >
        Placing order…
      </button>
    )
  }

  // ── Error ─────────────────────────────────────────────────────────────────
  return (
    <div style={{
      border: '1px solid #fecaca', borderRadius: 8,
      padding: '16px 18px', background: '#fef2f2',
    }}>
      <p style={{ fontSize: 13, color: '#dc2626', lineHeight: 1.5, marginBottom: 14 }}>
        {errorMsg ?? 'Something went wrong — please try again.'}
      </p>
      <button
        onClick={() => { setErrorMsg(null); setState('idle') }}
        style={{
          fontSize: 13, fontWeight: 500, color: '#374151',
          background: '#fff', border: '1px solid #e5e7eb',
          borderRadius: 6, padding: '7px 16px', cursor: 'pointer',
        }}
      >
        Try again
      </button>
    </div>
  )
}
