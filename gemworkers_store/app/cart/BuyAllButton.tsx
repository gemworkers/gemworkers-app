'use client'

import { useState } from 'react'
import { checkoutCart } from '@/app/actions/commerce'
import { pillDark, pillDisabled, pillOutlineSm, errorPanel } from '@/lib/ui'

type State = 'idle' | 'loading' | 'error'

export function BuyAllButton() {
  const [state, setState] = useState<State>('idle')
  const [errorMsg, setErrorMsg] = useState<string | null>(null)

  async function handleClick() {
    setState('loading')
    const result = await checkoutCart()
    if ('checkoutUrl' in result) {
      window.location.href = result.checkoutUrl
    } else {
      setErrorMsg(result.error)
      setState('error')
    }
  }

  if (state === 'error') {
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

  return (
    <div>
      <button
        onClick={handleClick}
        disabled={state === 'loading'}
        style={state === 'loading' ? pillDisabled : pillDark}
      >
        {state === 'loading' ? 'Checking out…' : 'Checkout'}
      </button>
      <p style={{ fontSize: 13, color: '#6B6052', marginTop: 10, textAlign: 'center' }}>
        Pay for everything in one go.
      </p>
    </div>
  )
}
