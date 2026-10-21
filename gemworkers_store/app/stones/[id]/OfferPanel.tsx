'use client'

import { useState } from 'react'
import Link from 'next/link'
import { submitOffer, withdrawOffer } from '@/app/actions/commerce'
import {
  pillOutline, pillDarkSm, pillOutlineSm, pillDisabledSm,
  panel, inputStyle, labelStyle,
} from '@/lib/ui'
import { PayOfferButton, PaymentDeadline } from '@/app/components/PayOfferButton'
import { PAY_WINDOW_CLOSING_MESSAGE } from '@/lib/offer-payment'
import { formatEur, formatEurExact } from '@/lib/money'

export type BuyerOffer = {
  id: string
  offered_price: number
  status: 'pending' | 'accepted' | 'declined' | 'expired'
}

// The pending_payment order created when the seller accepted this offer,
// still inside its payment window. Loaded server-side under the buyer's RLS.
export type PayableOrder = {
  orderTotal: number
  dueAt: string
  // false when < 35 min remain (computed server-side) — Pay button hidden
  canPay: boolean
}

type State =
  | 'idle'
  | 'form'
  | 'submitting'
  | 'pending'
  | 'withdrawing'
  | 'accepted'
  | 'declined'
  | 'expired'
  | 'error'

function initState(offer: BuyerOffer | null): State {
  if (!offer) return 'idle'
  if (offer.status === 'pending') return 'pending'
  if (offer.status === 'accepted') return 'accepted'
  if (offer.status === 'expired') return 'expired'
  return 'declined'
}

// Euros with up to 2 decimals, '.' or ',' as separator: "50", "49.8", "49,80".
const PRICE_RE = /^\d+([.,]\d{1,2})?$/

// Parses the typed offer exactly — never rounds. Returns the amount, or an
// error to show for anything that isn't a plain positive euro amount.
function parseOfferPrice(raw: string): { price: number } | { error: string } | null {
  const s = raw.trim()
  if (s === '') return null
  if (!PRICE_RE.test(s)) {
    return { error: 'Please enter an amount like 450, 49.80 or 49,80 (up to 2 decimals).' }
  }
  const price = Number(s.replace(',', '.'))
  if (!Number.isFinite(price) || price <= 0) {
    return { error: 'Your offer must be more than €0.' }
  }
  return { price }
}

const chipBase: React.CSSProperties = {
  fontSize: 12, fontWeight: 600, borderRadius: 14, padding: '3px 12px', whiteSpace: 'nowrap',
}

export function OfferPanel({
  itemId,
  isLoggedIn,
  initialOffer,
  payable = null,
  isAvailable = false,
}: {
  itemId: string
  isLoggedIn: boolean
  initialOffer: BuyerOffer | null
  payable?: PayableOrder | null
  // Stone is available for offers — lets the buyer re-offer after an
  // expired/declined offer (SQL only blocks while an offer is 'pending').
  isAvailable?: boolean
}) {
  const [state, setState] = useState<State>(initState(initialOffer))
  const [offer, setOffer] = useState<BuyerOffer | null>(initialOffer)
  const [priceInput, setPriceInput] = useState('')
  const [noteInput, setNoteInput] = useState('')
  const [errorMsg, setErrorMsg] = useState<string | null>(null)

  function openForm() {
    setErrorMsg(null); setPriceInput(''); setNoteInput(''); setState('form')
  }

  const newOfferButton = isAvailable ? (
    <button onClick={openForm} style={pillOutline}>
      Make a new offer
    </button>
  ) : null

  // ── Logged-out ─────────────────────────────────────────────────────────────
  if (!isLoggedIn) {
    return (
      <Link href={`/auth/login?next=${encodeURIComponent(`/stones/${itemId}`)}`} style={pillOutline}>
        Log in to make an offer
      </Link>
    )
  }

  // ── Idle ──────────────────────────────────────────────────────────────────
  if (state === 'idle') {
    return (
      <button
        onClick={openForm}
        style={pillOutline}
      >
        Make an offer
      </button>
    )
  }

  // ── Form ──────────────────────────────────────────────────────────────────
  if (state === 'form' || state === 'submitting') {
    const busy = state === 'submitting'
    const parsedResult = parseOfferPrice(priceInput)
    const parsed = parsedResult && 'price' in parsedResult ? parsedResult.price : null
    const inputError = parsedResult && 'error' in parsedResult ? parsedResult.error : null
    const validPrice = parsed !== null

    async function handleSubmit() {
      if (parsed === null) return
      setState('submitting')
      setErrorMsg(null)
      const res = await submitOffer(itemId, parsed, noteInput.trim() || undefined)
      if ('error' in res) {
        setErrorMsg(res.error)
        setState('form')
      } else {
        setOffer({ id: res.offerId, offered_price: parsed, status: 'pending' })
        setState('pending')
      }
    }

    return (
      <div style={{ ...panel, display: 'flex', flexDirection: 'column', gap: 14 }}>
        <p style={{ fontSize: 15, fontWeight: 600, color: '#1F1B16', margin: 0 }}>
          Make an offer
        </p>

        <div>
          <label style={labelStyle} htmlFor="offer-price">Your price (€)</label>
          <input
            id="offer-price"
            type="text" inputMode="decimal" autoComplete="off"
            placeholder="e.g. 450"
            value={priceInput}
            onChange={e => setPriceInput(e.target.value)}
            disabled={busy}
            autoFocus
            aria-invalid={inputError ? true : undefined}
            aria-describedby={inputError ? 'offer-price-error' : undefined}
            style={inputStyle}
          />
          {inputError && (
            <p id="offer-price-error" style={{ fontSize: 13, color: '#B42318', margin: '6px 0 0' }}>
              {inputError}
            </p>
          )}
        </div>

        <div>
          <label style={labelStyle} htmlFor="offer-note">Note (optional)</label>
          <input
            id="offer-note"
            type="text"
            value={noteInput}
            onChange={e => setNoteInput(e.target.value)}
            maxLength={300}
            disabled={busy}
            style={inputStyle}
          />
        </div>

        {errorMsg && (
          <p style={{ fontSize: 13, color: '#B42318', margin: 0 }}>{errorMsg}</p>
        )}

        <div style={{ display: 'flex', gap: 10, flexWrap: 'wrap' }}>
          <button
            onClick={handleSubmit}
            disabled={busy || !validPrice}
            style={{
              ...(busy || !validPrice ? pillDisabledSm : pillDarkSm),
              flex: '1 1 160px', width: 'auto',
              cursor: busy || !validPrice ? 'default' : 'pointer',
            }}
          >
            {busy ? 'Sending…' : parsed !== null ? `Send offer of ${formatEurExact(parsed)}` : 'Send offer'}
          </button>
          <button
            onClick={() => setState(initState(offer))}
            disabled={busy}
            style={{ ...pillOutlineSm, flex: '1 1 100px', width: 'auto', cursor: busy ? 'default' : 'pointer' }}
          >
            Cancel
          </button>
        </div>
      </div>
    )
  }

  // ── Pending ───────────────────────────────────────────────────────────────
  if (state === 'pending' || state === 'withdrawing') {
    const busy = state === 'withdrawing'

    async function handleWithdraw() {
      if (!offer) return
      setState('withdrawing')
      setErrorMsg(null)
      const res = await withdrawOffer(offer.id)
      if ('error' in res) {
        setErrorMsg(res.error)
        setState('pending')
      } else {
        setOffer(null)
        setState('idle')
      }
    }

    return (
      <div style={{ ...panel, display: 'flex', flexDirection: 'column', gap: 12 }}>
        <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between', gap: 12 }}>
          <span style={{ fontSize: 15, color: '#1F1B16' }}>
            Your offer: <strong>{offer ? formatEur(offer.offered_price) : '—'}</strong>
          </span>
          <span style={{
            ...chipBase, color: '#7A5A22',
            background: 'rgba(122,90,34,0.10)', border: '1px solid rgba(122,90,34,0.3)',
          }}>
            Pending
          </span>
        </div>
        {errorMsg && (
          <p style={{ fontSize: 13, color: '#B42318', margin: 0 }}>{errorMsg}</p>
        )}
        <button
          onClick={handleWithdraw}
          disabled={busy}
          style={{ ...pillOutlineSm, cursor: busy ? 'default' : 'pointer' }}
        >
          {busy ? 'Withdrawing…' : 'Withdraw offer'}
        </button>
      </div>
    )
  }

  // ── Accepted, payable → pay for the offer ─────────────────────────────────
  if (state === 'accepted' && payable && offer) {
    return (
      <div style={{ ...panel, border: '1px solid rgba(43,122,61,0.3)', display: 'flex', flexDirection: 'column', gap: 14 }}>
        <p style={{ fontSize: 15, color: '#1F1B16', lineHeight: 1.5, margin: 0 }}>
          Your offer of <strong>{formatEur(offer.offered_price)}</strong> was accepted.
        </p>
        {payable.canPay ? (
          <>
            <PayOfferButton offerId={offer.id} label={`Pay ${formatEur(payable.orderTotal)}`} />
            <PaymentDeadline dueAt={payable.dueAt} style={{ margin: 0, textAlign: 'center' }} />
          </>
        ) : (
          <p style={{ fontSize: 14, color: '#5A5045', lineHeight: 1.6, margin: 0 }}>
            {PAY_WINDOW_CLOSING_MESSAGE}
          </p>
        )}
      </div>
    )
  }

  // ── Expired ───────────────────────────────────────────────────────────────
  if (state === 'expired') {
    return (
      <div style={{ display: 'flex', flexDirection: 'column', gap: 12 }}>
        <div style={panel}>
          <p style={{ fontSize: 15, color: '#5A5045', margin: 0 }}>This offer has expired.</p>
        </div>
        {newOfferButton}
      </div>
    )
  }

  // ── Accepted (not payable) / Declined ─────────────────────────────────────
  const accepted = state === 'accepted'
  const chip = accepted
    ? { label: 'Accepted', bg: 'rgba(43,122,61,0.08)', color: '#2B7A3D', border: 'rgba(43,122,61,0.3)' }
    : { label: 'Declined', bg: 'rgba(180,35,24,0.06)', color: '#B42318', border: 'rgba(180,35,24,0.25)' }

  const summary = (
    <div style={{
      ...panel, border: `1px solid ${chip.border}`,
      display: 'flex', alignItems: 'center', justifyContent: 'space-between', gap: 12,
    }}>
      <span style={{ fontSize: 15, color: '#1F1B16' }}>
        Your offer: <strong>{offer ? formatEur(offer.offered_price) : '—'}</strong>
      </span>
      <span style={{
        ...chipBase, color: chip.color,
        background: chip.bg, border: `1px solid ${chip.border}`,
      }}>
        {chip.label}
      </span>
    </div>
  )

  if (accepted || !newOfferButton) return summary

  return (
    <div style={{ display: 'flex', flexDirection: 'column', gap: 12 }}>
      {summary}
      {newOfferButton}
    </div>
  )
}
