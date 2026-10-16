'use client'

import { useState } from 'react'
import { payAcceptedOffer } from '@/app/actions/commerce'
import { pillDark, pillDisabled } from '@/lib/ui'

// Dark pill that opens Stripe Checkout for an accepted offer's order.
// The amount shown is display-only; the server charges orders.order_total.
export function PayOfferButton({
  offerId,
  label,
  style,
}: {
  offerId: string
  label: string
  style?: React.CSSProperties
}) {
  const [loading, setLoading] = useState(false)
  const [error, setError] = useState<string | null>(null)

  async function handleClick() {
    setLoading(true)
    setError(null)
    const res = await payAcceptedOffer(offerId)
    if ('checkoutUrl' in res) {
      window.location.href = res.checkoutUrl
    } else {
      setError(res.error)
      setLoading(false)
    }
  }

  return (
    <div>
      <button
        onClick={handleClick}
        disabled={loading}
        style={{ ...(loading ? pillDisabled : pillDark), ...style }}
      >
        {loading ? 'Opening payment…' : label}
      </button>
      {error && (
        <p style={{ fontSize: 13, color: '#B42318', marginTop: 8, lineHeight: 1.5 }}>{error}</p>
      )}
    </div>
  )
}

// "Pay by 18 Oct, 14:30 (47 hours left)". Rendered on server and client, so the
// clock-dependent text is allowed to differ slightly at hydration.
export function PaymentDeadline({ dueAt, style }: { dueAt: string; style?: React.CSSProperties }) {
  const due = new Date(dueAt)
  const when = due.toLocaleString('en-IE', {
    day: 'numeric', month: 'short', hour: '2-digit', minute: '2-digit',
  })
  const msLeft = due.getTime() - Date.now()
  const hours = Math.floor(msLeft / 3_600_000)
  const left = msLeft <= 0
    ? 'deadline passed'
    : hours >= 1
      ? `${hours} ${hours === 1 ? 'hour' : 'hours'} left`
      : 'less than an hour left'

  return (
    <p suppressHydrationWarning style={{ fontSize: 14, color: '#6B6052', lineHeight: 1.5, ...style }}>
      Pay by {when} ({left})
    </p>
  )
}
