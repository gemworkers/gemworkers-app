'use client'

import { useState } from 'react'
import Link from 'next/link'
import { buyNow, guestBuyNow } from '@/app/actions/commerce'
import { pillDark, pillDisabled, pillDarkSm, pillOutlineSm, panel, errorPanel, inputStyle, labelStyle } from '@/lib/ui'
import { Turnstile, TURNSTILE_ENABLED } from '@/app/components/Turnstile'
import { formatEur } from '@/lib/money'
import { approxPrice, type FxContext } from '@/lib/price-shown'
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
  // Buyers outside the euro: an "≈ $" hint (Stripe charges their currency).
  fx?: FxContext | null
}

type State = 'idle' | 'confirm' | 'loading' | 'error' | 'existing'

export function BuyButton({ itemId, itemTitle, sellingPrice, shippingCost, vatAmount = 0, vatLabel = 'VAT', isLoggedIn, fx }: Props) {
  const [state, setState] = useState<State>('idle')
  const [errorMsg, setErrorMsg] = useState<string | null>(null)
  // Guest checkout (logged out): email + Turnstile, account made on the spot.
  const [email, setEmail] = useState('')
  const [captchaToken, setCaptchaToken] = useState<string | null>(null)
  const [captchaReset, setCaptchaReset] = useState(0)

  if (sellingPrice == null) return null

  const money = formatEur
  const formatted = money(sellingPrice)
  const totalEur = paidTotal(sellingPrice + (shippingCost ?? 0), vatAmount)
  const totalText = formatEur(totalEur)
  const totalApprox = approxPrice(totalEur, fx)

  const loginHref = `/auth/login?next=${encodeURIComponent(`/stones/${itemId}`)}`
  const guestReady = /^[^\s@]+@[^\s@]+\.[^\s@]{2,}$/.test(email.trim()) && (!TURNSTILE_ENABLED || !!captchaToken)

  // ── Email already has an account (guest checkout) ──────────────────────────
  if (state === 'existing') {
    return (
      <div style={panel}>
        <p style={{ fontSize: 14, color: '#5A5045', lineHeight: 1.6, marginBottom: 14 }}>
          This email already has a GemWorkers account (maybe from an earlier order). Please log in
          to buy — no password yet? Use <strong>Forgot password</strong> on the login page and we&apos;ll
          email you a link.
        </p>
        <Link href={loginHref} style={pillDarkSm}>Log in to buy</Link>
      </div>
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
      const result = isLoggedIn ? await buyNow(itemId) : await guestBuyNow(itemId, email, captchaToken)
      if ('checkoutUrl' in result) {
        window.location.href = result.checkoutUrl
      } else if ('existing' in result) {
        setState('existing')
      } else {
        setErrorMsg(result.error)
        setCaptchaReset(n => n + 1)
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
                <span>{money(shippingCost)}</span>
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
              <span>{totalText}</span>
            </div>
            {totalApprox && (
              <p style={{ fontSize: 12, color: '#6B6052', textAlign: 'right', marginTop: 4 }}>
                {totalApprox} · you pay the exact amount in your currency
              </p>
            )}
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
        {!isLoggedIn && (
          <div style={{ marginBottom: 16 }}>
            <label htmlFor="guest-email" style={labelStyle}>Your email</label>
            <input
              id="guest-email" type="email" autoComplete="email" inputMode="email"
              value={email} onChange={e => setEmail(e.target.value)} style={inputStyle}
              placeholder="you@example.com"
            />
            <p style={{ fontSize: 12, color: '#6B6052', lineHeight: 1.5, margin: '8px 0 12px' }}>
              No account needed — we create one with this email so you can follow your order,
              return it or leave a review. Already have one? <Link href={loginHref} className="pd-link">Log in</Link>
            </p>
            <Turnstile onToken={setCaptchaToken} resetKey={captchaReset} />
          </div>
        )}
        <div style={{ display: 'flex', gap: 10, flexWrap: 'wrap' }}>
          <button
            onClick={handleConfirm}
            disabled={!isLoggedIn && !guestReady}
            style={{ ...(isLoggedIn || guestReady ? pillDarkSm : pillDisabled), flex: '1 1 160px', width: 'auto' }}
          >
            {isLoggedIn ? 'Confirm purchase' : 'Continue to payment'}
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
