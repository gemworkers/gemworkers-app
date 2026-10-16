'use client'

import { useState } from 'react'
import Link from 'next/link'
import { submitOffer, withdrawOffer } from '@/app/actions/commerce'
import {
  pillOutline, pillDarkSm, pillOutlineSm, pillDisabledSm,
  panel, inputStyle, labelStyle,
} from './ui'

export type BuyerOffer = {
  id: string
  offered_price: number
  status: 'pending' | 'accepted' | 'declined' | 'expired'
}

type State =
  | 'idle'
  | 'form'
  | 'submitting'
  | 'pending'
  | 'withdrawing'
  | 'accepted'
  | 'declined'
  | 'error'

function initState(offer: BuyerOffer | null): State {
  if (!offer) return 'idle'
  if (offer.status === 'pending') return 'pending'
  if (offer.status === 'accepted') return 'accepted'
  return 'declined'
}

const eur = (n: number) =>
  new Intl.NumberFormat('en-IE', {
    style: 'currency', currency: 'EUR', maximumFractionDigits: 0,
  }).format(n)

const chipBase: React.CSSProperties = {
  fontSize: 12, fontWeight: 600, borderRadius: 14, padding: '3px 12px', whiteSpace: 'nowrap',
}

export function OfferPanel({
  itemId,
  isLoggedIn,
  initialOffer,
}: {
  itemId: string
  isLoggedIn: boolean
  initialOffer: BuyerOffer | null
}) {
  const [state, setState] = useState<State>(initState(initialOffer))
  const [offer, setOffer] = useState<BuyerOffer | null>(initialOffer)
  const [priceInput, setPriceInput] = useState('')
  const [noteInput, setNoteInput] = useState('')
  const [errorMsg, setErrorMsg] = useState<string | null>(null)

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
        onClick={() => { setErrorMsg(null); setPriceInput(''); setNoteInput(''); setState('form') }}
        style={pillOutline}
      >
        Make an offer
      </button>
    )
  }

  // ── Form ──────────────────────────────────────────────────────────────────
  if (state === 'form' || state === 'submitting') {
    const busy = state === 'submitting'
    const parsed = parseFloat(priceInput.replace(',', '.'))
    const validPrice = !isNaN(parsed) && parsed > 0

    async function handleSubmit() {
      if (!validPrice) return
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
            type="number" min="0.01" step="0.01"
            placeholder="e.g. 450"
            value={priceInput}
            onChange={e => setPriceInput(e.target.value)}
            disabled={busy}
            autoFocus
            style={inputStyle}
          />
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
            {busy ? 'Sending…' : 'Send offer'}
          </button>
          <button
            onClick={() => setState('idle')}
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
            Your offer: <strong>{offer ? eur(offer.offered_price) : '—'}</strong>
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

  // ── Accepted / Declined ───────────────────────────────────────────────────
  const accepted = state === 'accepted'
  const chip = accepted
    ? { label: 'Accepted', bg: 'rgba(43,122,61,0.08)', color: '#2B7A3D', border: 'rgba(43,122,61,0.3)' }
    : { label: 'Declined', bg: 'rgba(180,35,24,0.06)', color: '#B42318', border: 'rgba(180,35,24,0.25)' }

  return (
    <div style={{
      ...panel, border: `1px solid ${chip.border}`,
      display: 'flex', alignItems: 'center', justifyContent: 'space-between', gap: 12,
    }}>
      <span style={{ fontSize: 15, color: '#1F1B16' }}>
        Your offer: <strong>{offer ? eur(offer.offered_price) : '—'}</strong>
      </span>
      <span style={{
        ...chipBase, color: chip.color,
        background: chip.bg, border: `1px solid ${chip.border}`,
      }}>
        {chip.label}
      </span>
    </div>
  )
}
