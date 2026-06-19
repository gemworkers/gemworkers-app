'use client'

import { useState } from 'react'
import Link from 'next/link'
import { submitOffer, withdrawOffer } from '@/app/actions/commerce'

export type BuyerOffer = {
  id: string
  offered_price: number
  status: 'pending' | 'accepted' | 'declined' | 'expired'
}

type State =
  | 'idle'        // no active offer — shows "Make an offer" button
  | 'form'        // price + note inputs visible
  | 'submitting'  // form submit in flight
  | 'pending'     // buyer has a pending offer
  | 'withdrawing' // withdraw call in flight
  | 'accepted'    // read-only: seller accepted
  | 'declined'    // read-only: seller declined (also covers expired)
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
      <Link
        href="/auth/login"
        style={{
          display: 'block', textAlign: 'center',
          padding: '10px 0', border: '1px solid #d1d5db', borderRadius: 6,
          fontSize: 14, fontWeight: 500, color: '#374151',
          textDecoration: 'none', letterSpacing: '0.01em',
        }}
      >
        Log in to make an offer
      </Link>
    )
  }

  // ── Idle: no active offer ─────────────────────────────────────────────────
  if (state === 'idle') {
    return (
      <button
        onClick={() => { setErrorMsg(null); setPriceInput(''); setNoteInput(''); setState('form') }}
        style={{
          width: '100%', padding: '10px 0', background: 'transparent',
          border: '1px solid #d1d5db', borderRadius: 6,
          fontSize: 14, fontWeight: 500, color: '#374151',
          cursor: 'pointer', letterSpacing: '0.01em',
        }}
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
      <div style={{
        border: '1px solid #e5e7eb', borderRadius: 8,
        padding: '16px', display: 'flex', flexDirection: 'column', gap: 10,
      }}>
        <p style={{ fontSize: 13, fontWeight: 600, color: '#374151', margin: 0 }}>
          Make an offer
        </p>

        {/* Price input */}
        <div style={{ display: 'flex', gap: 6, alignItems: 'center' }}>
          <span style={{ fontSize: 14, color: '#374151', flexShrink: 0 }}>€</span>
          <input
            type="number"
            min="0.01"
            step="0.01"
            placeholder="Your price"
            value={priceInput}
            onChange={e => setPriceInput(e.target.value)}
            disabled={busy}
            autoFocus
            style={{
              flex: 1, padding: '8px 10px', fontSize: 14,
              border: '1px solid #d1d5db', borderRadius: 6,
              outline: 'none', color: '#111',
            }}
          />
        </div>

        {/* Optional note */}
        <input
          type="text"
          placeholder="Add a note (optional)"
          value={noteInput}
          onChange={e => setNoteInput(e.target.value)}
          maxLength={300}
          disabled={busy}
          style={{
            padding: '8px 10px', fontSize: 13,
            border: '1px solid #d1d5db', borderRadius: 6,
            outline: 'none', color: '#374151',
          }}
        />

        {errorMsg && (
          <p style={{ fontSize: 13, color: '#dc2626', margin: 0 }}>{errorMsg}</p>
        )}

        <div style={{ display: 'flex', gap: 8 }}>
          <button
            onClick={handleSubmit}
            disabled={busy || !validPrice}
            style={{
              flex: 1, padding: '9px 0', fontSize: 14, fontWeight: 600,
              background: busy || !validPrice ? '#f3f4f6' : '#111',
              color: busy || !validPrice ? '#9ca3af' : '#fff',
              border: 'none', borderRadius: 6,
              cursor: busy || !validPrice ? 'default' : 'pointer',
            }}
          >
            {busy ? 'Sending…' : 'Send offer'}
          </button>
          <button
            onClick={() => setState('idle')}
            disabled={busy}
            style={{
              padding: '9px 14px', fontSize: 14, background: 'transparent',
              border: '1px solid #e5e7eb', borderRadius: 6,
              cursor: busy ? 'default' : 'pointer', color: '#374151',
            }}
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
      <div style={{
        border: '1px solid #e5e7eb', borderRadius: 8,
        padding: '14px 16px', display: 'flex', flexDirection: 'column', gap: 8,
      }}>
        <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between' }}>
          <span style={{ fontSize: 14, color: '#374151' }}>
            Your offer: <strong>{offer ? eur(offer.offered_price) : '—'}</strong>
          </span>
          <span style={{
            fontSize: 12, fontWeight: 600, color: '#92400e',
            background: '#fef3c7', borderRadius: 4, padding: '2px 8px',
          }}>
            Pending
          </span>
        </div>
        {errorMsg && (
          <p style={{ fontSize: 13, color: '#dc2626', margin: 0 }}>{errorMsg}</p>
        )}
        <button
          onClick={handleWithdraw}
          disabled={busy}
          style={{
            padding: '7px 0', fontSize: 13, background: 'transparent',
            border: '1px solid #e5e7eb', borderRadius: 6,
            cursor: busy ? 'default' : 'pointer', color: '#6b7280',
          }}
        >
          {busy ? 'Withdrawing…' : 'Withdraw offer'}
        </button>
      </div>
    )
  }

  // ── Accepted / Declined (read-only) ───────────────────────────────────────
  const accepted = state === 'accepted'
  const chip = accepted
    ? { label: 'Accepted', bg: '#dcfce7', color: '#166534', border: '#bbf7d0' }
    : { label: 'Declined', bg: '#fee2e2', color: '#991b1b', border: '#fecaca' }

  return (
    <div style={{
      border: `1px solid ${chip.border}`, borderRadius: 8,
      padding: '14px 16px',
      display: 'flex', alignItems: 'center', justifyContent: 'space-between',
    }}>
      <span style={{ fontSize: 14, color: '#374151' }}>
        Your offer: <strong>{offer ? eur(offer.offered_price) : '—'}</strong>
      </span>
      <span style={{
        fontSize: 12, fontWeight: 600, color: chip.color,
        background: chip.bg, borderRadius: 4, padding: '2px 8px',
      }}>
        {chip.label}
      </span>
    </div>
  )
}
