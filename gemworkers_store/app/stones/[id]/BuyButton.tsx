'use client'

import { useState } from 'react'
import Link from 'next/link'
import { buyNow } from '@/app/actions/commerce'
import { pillDark, pillDisabled, pillDarkSm, pillOutlineSm, panel, errorPanel } from '@/lib/ui'
import { formatEur } from '@/lib/money'
import { paidTotal } from '@/lib/tax'

type Props = {
  itemId: string
  itemTitle: string
  sellingPrice: number | null
  shippingCost?: number | null
  // VAT we collect for the buyer's ship-to country (lib/tax.ts); 0 = none.
  vatAmount?: number
  vatLabel?: string
  isLoggedIn: boolean
}

type State = 'idle' | 'confirm' | 'loading' | 'error'

export function BuyButton({ itemId, itemTitle, sellingPrice, shippingCost, vatAmount = 0, vatLabel = 'VAT', isLoggedIn }: Props) {
  const [state, setState] = useState<State>('idle')
  const [errorMsg, setErrorMsg] = useState<string | null>(null)

  if (sellingPrice == null) return null

  const formatted = formatEur(sellingPrice)

  // ── Logged-out ────────────────────────────────────────────────────────────
  if (!isLoggedIn) {
    return (
      <Link href={`/auth/login?next=${encodeURIComponent(`/stones/${itemId}`)}`} style={pillDark}>
        Log in to buy
      </Link>
    )
  }

  // ── Idle ──────────────────────────────────────────────────────────────────
  if (state === 'idle') {
    return (
      <button onClick={() => setState('confirm')} style={pillDark}>
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
      <div style={panel}>
        <p style={{ fontSize: 15, fontWeight: 600, color: '#1F1B16', marginBottom: 10 }}>
          Confirm purchase
        </p>
        {(shippingCost != null && shippingCost > 0) || vatAmount > 0 ? (
          <div style={{ marginBottom: 14 }}>
            <div style={{
              display: 'flex', justifyContent: 'space-between',
              fontSize: 14, color: '#5A5045', marginBottom: 4,
            }}>
              <span>Stone</span>
              <span>{formatted}</span>
            </div>
            {shippingCost != null && shippingCost > 0 && (
              <div style={{
                display: 'flex', justifyContent: 'space-between',
                fontSize: 14, color: '#5A5045', marginBottom: 8,
              }}>
                <span>Shipping</span>
                <span>{formatEur(shippingCost)}</span>
              </div>
            )}
            {vatAmount > 0 && (
              <div style={{
                display: 'flex', justifyContent: 'space-between',
                fontSize: 14, color: '#5A5045', marginBottom: 8,
              }}>
                <span>{vatLabel}</span>
                <span>{formatEur(vatAmount)}</span>
              </div>
            )}
            <div style={{ height: 1, background: '#ECE5D8', marginBottom: 8 }} />
            <div style={{
              display: 'flex', justifyContent: 'space-between',
              fontSize: 15, fontWeight: 600, color: '#1F1B16',
            }}>
              <span>Total</span>
              <span>{formatEur(paidTotal(sellingPrice! + (shippingCost ?? 0), vatAmount))}</span>
            </div>
          </div>
        ) : (
          <p style={{ fontSize: 14, color: '#5A5045', lineHeight: 1.55, marginBottom: 6 }}>
            Buy <strong style={{ color: '#1F1B16' }}>{itemTitle}</strong> for{' '}
            <strong style={{ color: '#1F1B16' }}>{formatted}</strong>?
          </p>
        )}
        <p style={{ fontSize: 13, color: '#6B6052', marginBottom: 18, lineHeight: 1.5 }}>
          This reserves the stone — it will no longer be available to other buyers.
        </p>
        <div style={{ display: 'flex', gap: 10, flexWrap: 'wrap' }}>
          <button onClick={handleConfirm} style={{ ...pillDarkSm, flex: '1 1 160px', width: 'auto' }}>
            Confirm purchase
          </button>
          <button onClick={() => setState('idle')} style={{ ...pillOutlineSm, flex: '1 1 120px', width: 'auto' }}>
            Cancel
          </button>
        </div>
      </div>
    )
  }

  // ── Loading ───────────────────────────────────────────────────────────────
  if (state === 'loading') {
    return (
      <button disabled style={pillDisabled}>
        Placing order…
      </button>
    )
  }

  // ── Error ─────────────────────────────────────────────────────────────────
  return (
    <div style={errorPanel}>
      <p style={{ fontSize: 14, color: '#B42318', lineHeight: 1.5, marginBottom: 14 }}>
        {errorMsg ?? 'Something went wrong — please try again.'}
      </p>
      <button
        onClick={() => { setErrorMsg(null); setState('idle') }}
        style={{ ...pillOutlineSm, width: 'auto', display: 'inline-flex' }}
      >
        Try again
      </button>
    </div>
  )
}
