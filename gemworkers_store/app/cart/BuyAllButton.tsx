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
    } else {
      setErrorMsg(result.error)
      setState('error')
    }
  }

  if (state === 'error') {
    return (
      <div style={{
        border: '1px solid rgba(180,35,24,0.25)', borderRadius: 8,
        padding: '16px 18px', background: 'rgba(180,35,24,0.06)',
      }}>
        <p style={{
          fontSize: 13, color: '#B42318', lineHeight: 1.5, marginBottom: 14,
          fontFamily: 'var(--font-inter, system-ui)',
        }}>
          {errorMsg ?? 'Something went wrong — please try again.'}
        </p>
        <button
          onClick={() => { setErrorMsg(null); setState('idle') }}
          style={{
            fontSize: 13, fontWeight: 500, color: '#5A5045',
            background: '#F4EEE4', border: '1px solid #ECE5D8',
            borderRadius: 6, padding: '7px 16px', cursor: 'pointer',
            fontFamily: 'var(--font-inter, system-ui)',
          }}
        >
          Try again
        </button>
      </div>
    )
  }

  return (
    <div>
      <p style={{
        fontSize: 12, color: '#5A5045', marginBottom: 12,
        fontFamily: 'var(--font-inter, system-ui)',
      }}>
        Pay for everything in one go.
      </p>
      <button
        onClick={handleClick}
        disabled={state === 'loading'}
        style={{
          width: '100%', padding: '13px 0', fontSize: 13, fontWeight: 600,
          color: '#FBF8F3',
          background: state === 'loading' ? '#B89A63' : '#7A5A22',
          border: 'none', borderRadius: 6,
          cursor: state === 'loading' ? 'not-allowed' : 'pointer',
          letterSpacing: '0.06em',
          fontFamily: 'var(--font-inter, system-ui)',
        }}
      >
        {state === 'loading' ? 'Preparing checkout…' : 'Buy all'}
      </button>
    </div>
  )
}
