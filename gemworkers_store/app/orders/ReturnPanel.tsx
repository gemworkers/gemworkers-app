'use client'

import { useState } from 'react'
import Link from 'next/link'
import { requestReturn, withdrawReturn, addReturnTracking } from '@/app/actions/returns'
import { inputStyle, pillDarkSm, pillDisabledSm, pillOutlineSm } from '@/lib/ui'
import { formatEur } from '@/lib/money'

export type BuyerReturn = {
  id: string
  order_id: string
  status: 'requested' | 'approved' | 'received' | 'refunded' | 'rejected' | 'withdrawn' | 'expired'
  faulty: boolean
  return_address: string | null
  return_tracking: string | null
  decision_note: string | null
  refunded_at: string | null
  refund_amount: number | string | null
}

const muted = { fontSize: 14, color: '#5A5045', lineHeight: 1.55 } as const

// refundShown: the refund in the currency the buyer paid (set by My orders).
export function ReturnPanel({ orderId, ret, eligible, refundShown }: { orderId: string; ret: BuyerReturn | null; eligible: boolean; refundShown?: string | null }) {
  const [open, setOpen] = useState(false)
  const [reason, setReason] = useState('')
  const [faulty, setFaulty] = useState(false)
  const [tracking, setTracking] = useState(ret?.return_tracking ?? '')
  const [busy, setBusy] = useState(false)
  const [error, setError] = useState<string | null>(null)
  const [saved, setSaved] = useState<string | null>(null)

  async function run(action: () => Promise<{ ok: true } | { error: string }>): Promise<boolean> {
    setBusy(true)
    setError(null)
    const res = await action()
    setBusy(false)
    if ('error' in res) { setError(res.error); return false }
    setOpen(false)
    return true
  }

  const errorLine = error && <p style={{ fontSize: 13, color: '#B42318', marginTop: 8 }}>{error}</p>
  const status = ret?.status

  if (status === 'requested') {
    return (
      <div style={{ marginTop: 12 }}>
        <p style={muted}>↩ Return requested — we&apos;ll reply by email within 2 business days.</p>
        <button disabled={busy} onClick={() => run(() => withdrawReturn(ret!.id))}
          style={{ ...pillOutlineSm, width: 'auto', padding: '0 18px', marginTop: 8 }}>
          Cancel return
        </button>
        {errorLine}
      </div>
    )
  }

  if (status === 'approved') {
    return (
      <div style={{ marginTop: 12, maxWidth: 460 }}>
        <p style={muted}><strong>Return approved.</strong> Please send the stone to:</p>
        <p style={{ ...muted, whiteSpace: 'pre-line', margin: '6px 0 10px', color: '#1F1B16' }}>{ret!.return_address}</p>
        <ul style={{ ...muted, fontSize: 13, paddingLeft: 18, margin: '0 0 10px' }}>
          <li>Pack it well, with any certificate and the original packaging.</li>
          <li>Use a tracked and insured service{ret!.faulty ? ' — we refund your return shipping.' : '.'}</li>
          <li>Sending from outside the EU? Mark the customs form &ldquo;Returned goods&rdquo; and add your order number.</li>
        </ul>
        {ret!.decision_note && <p style={{ ...muted, fontSize: 13 }}>Note from GemWorkers: {ret!.decision_note}</p>}
        {(saved ?? ret!.return_tracking) && (
          <p style={{ ...muted, fontSize: 13, color: '#2B7A3D' }}>✓ Tracking saved: {saved ?? ret!.return_tracking}</p>
        )}
        <div style={{ display: 'flex', gap: 8, flexWrap: 'wrap', marginTop: 8 }}>
          <input value={tracking} onChange={e => setTracking(e.target.value)} maxLength={100}
            placeholder="Return tracking number" style={{ ...inputStyle, flex: '1 1 180px', width: 'auto', fontSize: 16 }} />
          <button disabled={busy || !tracking.trim()} onClick={async () => {
              setSaved(null)
              if (await run(() => addReturnTracking(ret!.id, tracking))) setSaved(tracking.trim())
            }}
            style={{ ...(busy || !tracking.trim() ? pillDisabledSm : pillDarkSm), width: 'auto', padding: '0 18px' }}>
            {ret!.return_tracking || saved ? 'Update tracking' : 'Save tracking'}
          </button>
        </div>
        <button disabled={busy} onClick={() => run(() => withdrawReturn(ret!.id))}
          style={{ ...pillOutlineSm, width: 'auto', padding: '0 18px', marginTop: 10 }}>
          Cancel return
        </button>
        {errorLine}
      </div>
    )
  }

  if (status === 'received') {
    return <p style={{ ...muted, marginTop: 12 }}>↩ We&apos;ve received your return and are checking it. Your refund follows within 14 days.</p>
  }

  if (status === 'refunded') {
    return (
      <p style={{ ...muted, marginTop: 12 }}>
        ✓ Refunded {refundShown ?? (ret!.refund_amount != null ? formatEur(ret!.refund_amount) : '')} to your original payment method
        {ret!.decision_note ? ` — ${ret!.decision_note}` : ''}.
      </p>
    )
  }

  const rejected = status === 'rejected' && (
    <p style={{ ...muted, marginTop: 12 }}>Return declined{ret!.decision_note ? `: ${ret!.decision_note}` : '.'}</p>
  )

  if (status === 'expired') {
    return (
      <p style={{ ...muted, marginTop: 12 }}>
        Return closed — the stone wasn&apos;t sent back within 30 days. Already sent it? Email{' '}
        <a href="mailto:hello@gemworkers.com">hello@gemworkers.com</a> with the tracking number.
      </p>
    )
  }

  if (!eligible || status === 'rejected') return rejected || null

  // No return yet (or the buyer withdrew one): offer to start it.
  if (!open) {
    return (
      <p style={{ marginTop: 10, fontSize: 14 }}>
        <button onClick={() => setOpen(true)} className="pd-link"
          style={{ background: 'none', border: 0, padding: 0, cursor: 'pointer', fontSize: 14 }}>
          Return this stone
        </button>
      </p>
    )
  }

  return (
    <div style={{ marginTop: 12, maxWidth: 460 }}>
      <p style={{ ...muted, marginBottom: 8 }}>
        You can return within 30 days of delivery — no reason needed. See{' '}
        <Link href="/returns" className="pd-link">Returns &amp; Refunds</Link>.
      </p>
      <textarea value={reason} onChange={e => setReason(e.target.value)} maxLength={1000} rows={3}
        placeholder="Reason (optional)" style={{ ...inputStyle, fontSize: 16, resize: 'vertical' }} />
      <label style={{ ...muted, display: 'flex', gap: 8, alignItems: 'flex-start', margin: '8px 0 12px' }}>
        <input type="checkbox" checked={faulty} onChange={e => setFaulty(e.target.checked)} style={{ marginTop: 4 }} />
        The stone is damaged or not as described
      </label>
      <div style={{ display: 'flex', gap: 8, flexWrap: 'wrap' }}>
        <button disabled={busy} onClick={() => run(() => requestReturn(orderId, reason, faulty))}
          style={{ ...(busy ? pillDisabledSm : pillDarkSm), width: 'auto', padding: '0 20px' }}>
          {busy ? 'Sending…' : 'Request return'}
        </button>
        <button disabled={busy} onClick={() => setOpen(false)}
          style={{ ...pillOutlineSm, width: 'auto', padding: '0 18px' }}>
          Never mind
        </button>
      </div>
      {errorLine}
    </div>
  )
}
