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
          padding: '10px 0', border: '1px solid #2a2a30', borderRadius: 6,
          fontSize: 13, fontWeight: 500, color: '#9d9080',
          textDecoration: 'none', letterSpacing: '0.02em',
          fontFamily: 'var(--font-inter, system-ui)',
        }}
      >
        Log in to make an offer
      </Link>
    )
  }

  // ── Idle ──────────────────────────────────────────────────────────────────
  if (state === 'idle') {
    return (
      <button
        onClick={() => { setErrorMsg(null); setPriceInput(''); setNoteInput(''); setState('form') }}
        style={{
          width: '100%', padding: '10px 0', background: 'transparent',
          border: '1px solid #2a2a30', borderRadius: 6,
          fontSize: 13, fontWeight: 500, color: '#c9a962',
          cursor: 'pointer', letterSpacing: '0.04em',
          fontFamily: 'var(--font-inter, system-ui)',
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
        border: '1px solid #2a2a30', borderRadius: 8,
        padding: '16px', display: 'flex', flexDirection: 'column', gap: 10,
        background: '#16161a',
      }}>
        <p style={{
          fontSize: 13, fontWeight: 600, color: '#c9a962', margin: 0,
          fontFamily: 'var(--font-inter, system-ui)',
        }}>
          Make an offer
        </p>

        <div style={{ display: 'flex', gap: 6, alignItems: 'center' }}>
          <span style={{ fontSize: 14, color: '#9d9080', flexShrink: 0 }}>€</span>
          <input
            type="number" min="0.01" step="0.01"
            placeholder="Your price"
            value={priceInput}
            onChange={e => setPriceInput(e.target.value)}
            disabled={busy}
            autoFocus
            style={{
              flex: 1, padding: '8px 10px', fontSize: 14,
              border: '1px solid #2a2a30', borderRadius: 6,
              outline: 'none', color: '#f5f0e8',
              background: '#1e1e24',
              fontFamily: 'var(--font-inter, system-ui)',
            }}
          />
        </div>

        <input
          type="text"
          placeholder="Add a note (optional)"
          value={noteInput}
          onChange={e => setNoteInput(e.target.value)}
          maxLength={300}
          disabled={busy}
          style={{
            padding: '8px 10px', fontSize: 13,
            border: '1px solid #2a2a30', borderRadius: 6,
            outline: 'none', color: '#9d9080',
            background: '#1e1e24',
            fontFamily: 'var(--font-inter, system-ui)',
          }}
        />

        {errorMsg && (
          <p style={{ fontSize: 13, color: '#f87171', margin: 0 }}>{errorMsg}</p>
        )}

        <div style={{ display: 'flex', gap: 8 }}>
          <button
            onClick={handleSubmit}
            disabled={busy || !validPrice}
            style={{
              flex: 1, padding: '9px 0', fontSize: 13, fontWeight: 600,
              background: busy || !validPrice ? '#1e1e24' : '#c9a962',
              color: busy || !validPrice ? '#4a4440' : '#0e0e10',
              border: busy || !validPrice ? '1px solid #2a2a30' : 'none',
              borderRadius: 6,
              cursor: busy || !validPrice ? 'default' : 'pointer',
            }}
          >
            {busy ? 'Sending…' : 'Send offer'}
          </button>
          <button
            onClick={() => setState('idle')}
            disabled={busy}
            style={{
              padding: '9px 14px', fontSize: 13, background: 'transparent',
              border: '1px solid #2a2a30', borderRadius: 6,
              cursor: busy ? 'default' : 'pointer', color: '#9d9080',
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
        border: '1px solid #2a2a30', borderRadius: 8,
        padding: '14px 16px', display: 'flex', flexDirection: 'column', gap: 8,
        background: '#16161a',
      }}>
        <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between' }}>
          <span style={{ fontSize: 14, color: '#f5f0e8' }}>
            Your offer: <strong>{offer ? eur(offer.offered_price) : '—'}</strong>
          </span>
          <span style={{
            fontSize: 11, fontWeight: 600, color: '#c9a962',
            background: 'rgba(201,169,98,0.12)',
            border: '1px solid rgba(201,169,98,0.3)',
            borderRadius: 4, padding: '2px 8px',
          }}>
            Pending
          </span>
        </div>
        {errorMsg && (
          <p style={{ fontSize: 13, color: '#f87171', margin: 0 }}>{errorMsg}</p>
        )}
        <button
          onClick={handleWithdraw}
          disabled={busy}
          style={{
            padding: '7px 0', fontSize: 13, background: 'transparent',
            border: '1px solid #2a2a30', borderRadius: 6,
            cursor: busy ? 'default' : 'pointer', color: '#4a4440',
          }}
        >
          {busy ? 'Withdrawing…' : 'Withdraw offer'}
        </button>
      </div>
    )
  }

  // ── Accepted / Declined ───────────────────────────────────────────────────
  const accepted = state === 'accepted'
  const chip = accepted
    ? { label: 'Accepted', bg: 'rgba(74,222,128,0.1)', color: '#4ade80', border: 'rgba(74,222,128,0.3)' }
    : { label: 'Declined', bg: 'rgba(248,113,113,0.1)', color: '#f87171', border: 'rgba(248,113,113,0.3)' }

  return (
    <div style={{
      border: `1px solid ${chip.border}`, borderRadius: 8,
      padding: '14px 16px',
      display: 'flex', alignItems: 'center', justifyContent: 'space-between',
      background: '#16161a',
    }}>
      <span style={{ fontSize: 14, color: '#f5f0e8' }}>
        Your offer: <strong>{offer ? eur(offer.offered_price) : '—'}</strong>
      </span>
      <span style={{
        fontSize: 11, fontWeight: 600, color: chip.color,
        background: chip.bg,
        border: `1px solid ${chip.border}`,
        borderRadius: 4, padding: '2px 8px',
      }}>
        {chip.label}
      </span>
    </div>
  )
}
