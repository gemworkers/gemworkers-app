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
  // Units in stock (sql/quantity_listings.sql): above 1 the buyer picks how many.
  stock?: number
}

type State = 'idle' | 'confirm' | 'loading' | 'error' | 'existing'

export function BuyButton({ itemId, itemTitle, sellingPrice, shippingCost, vatAmount = 0, vatLabel = 'VAT', isLoggedIn, fx, stock = 1 }: Props) {
  const [state, setState] = useState<State>('idle')
  const [qty, setQty] = useState(1)
  const maxQty = Math.min(Math.max(1, Math.floor(stock)), 99)
  const [errorMsg, setErrorMsg] = useState<string | null>(null)
  // Guest checkout (logged out): email + Turnstile, account made on the spot.
  const [email, setEmail] = useState('')
  const [captchaToken, setCaptchaToken] = useState<string | null>(null)
  const [captchaReset, setCaptchaReset] = useState(0)

  if (sellingPrice == null) return null

  const money = formatEur
  const formatted = money(sellingPrice)
  // Preview only — the server works out the real totals (one shipping per order).
  const goods = Math.round(sellingPrice * qty * 100) / 100
  const base1 = sellingPrice + (shippingCost ?? 0)
  const vatNow = qty === 1 || base1 <= 0 ? vatAmount
    : Math.round(vatAmount * (goods + (shippingCost ?? 0)) / base1 * 100) / 100
  const totalEur = paidTotal(goods + (shippingCost ?? 0), vatNow)
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
      const result = isLoggedIn ? await buyNow(itemId, qty) : await guestBuyNow(itemId, email, captchaToken, qty)
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
        {maxQty > 1 && (
          <label style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between', gap: 12, fontSize: 14, color: '#5A5045', marginBottom: 12 }}>
            <span>Quantity <span style={{ color: '#8A7F70' }}>({maxQty} available)</span></span>
            <select value={qty} onChange={e => setQty(Number(e.target.value))}
              style={{ ...inputStyle, width: 'auto', minWidth: 72, padding: '6px 10px' }}>
              {Array.from({ length: maxQty }, (_, i) => i + 1).map(n => <option key={n} value={n}>{n}</option>)}
            </select>
          </label>
        )}
        {(shippingCost != null && shippingCost > 0) || vatAmount > 0 || qty > 1 ? (
          <div style={{ marginBottom: 14 }}>
            <div style={{
              display: 'flex', justifyContent: 'space-between',
              fontSize: 14, color: '#5A5045', marginBottom: 4,
            }}>
              <span>{qty > 1 ? `${qty} × ${formatted}` : maxQty > 1 ? 'Item' : 'Stone'}</span>
              <span>{money(goods)}</span>
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
                <span>{formatEur(vatNow)}</span>
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
          {maxQty > 1
            ? `This reserves ${qty === 1 ? 'one' : qty} for you while you pay.`
            : 'This reserves the stone — it will no longer be available to other buyers.'}
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
