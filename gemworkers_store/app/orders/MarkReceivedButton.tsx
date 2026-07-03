'use client'

import { useRouter } from 'next/navigation'
import { useState } from 'react'
import { markOrderReceived } from '@/app/actions/commerce'

export function MarkReceivedButton({ orderId }: { orderId: string }) {
  const router = useRouter()
  const [loading, setLoading] = useState(false)
  const [err, setErr] = useState<string | null>(null)

  const handleClick = async () => {
    setLoading(true)
    setErr(null)
    const result = await markOrderReceived(orderId)
    if ('error' in result) {
      setErr(result.error)
      setLoading(false)
    } else {
      router.refresh()
    }
  }

  return (
    <div>
      <button
        onClick={handleClick}
        disabled={loading}
        style={{
          padding: '7px 18px',
          background: 'rgba(45,212,191,0.12)',
          color: '#2dd4bf',
          border: '1px solid rgba(45,212,191,0.4)',
          borderRadius: 6,
          fontSize: 12,
          fontWeight: 600,
          cursor: loading ? 'not-allowed' : 'pointer',
          letterSpacing: '0.04em',
          opacity: loading ? 0.6 : 1,
          fontFamily: 'var(--font-inter, system-ui)',
        }}
      >
        {loading ? 'Confirming…' : 'Mark as Received'}
      </button>
      {err && (
        <p style={{
          fontSize: 12, color: '#f87171', marginTop: 6,
          fontFamily: 'var(--font-inter, system-ui)',
        }}>
          {err}
        </p>
      )}
    </div>
  )
}
