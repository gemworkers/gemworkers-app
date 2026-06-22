'use client'

import { useState } from 'react'
import { checkoutCart } from '@/app/actions/commerce'

type State = 'idle' | 'loading' | 'error'

export function BuyAllButton() {
  const [state, setState] = useState<State>('idle')
  const [errorMsg, setErrorMsg] = useState<string | null>(null)

  async function handleClick() {
    setState('loading')
    const result = await checkoutCart()
    if ('checkoutUrl' in result) {
      window.location.href = result.checkoutUrl
      // Stay in loading while the browser navigates to Stripe.
    } else {
      setErrorMsg(result.error)
      setState('error')
    }
  }

  if (state === 'error') {
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

  return (
    <div>
      <p style={{ fontSize: 13, color: '#9ca3af', marginBottom: 12 }}>
        Pay for everything in one go.
      </p>
      <button
        onClick={handleClick}
        disabled={state === 'loading'}
        style={{
          width: '100%', padding: '12px 0', fontSize: 14, fontWeight: 600,
          color: '#fff',
          background: state === 'loading' ? '#6b7280' : '#111',
          border: 'none', borderRadius: 6,
          cursor: state === 'loading' ? 'not-allowed' : 'pointer',
          letterSpacing: '0.02em',
        }}
      >
        {state === 'loading' ? 'Preparing checkout…' : 'Buy all'}
      </button>
    </div>
  )
}
