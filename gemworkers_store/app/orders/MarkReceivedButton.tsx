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
          padding: '8px 20px',
          background: loading ? '#d1d5db' : '#14b8a6',
          color: '#fff',
          border: 'none',
          borderRadius: 6,
          fontSize: 13,
          fontWeight: 600,
          cursor: loading ? 'not-allowed' : 'pointer',
          letterSpacing: '0.02em',
        }}
      >
        {loading ? 'Confirming…' : 'Mark as Received'}
      </button>
      {err && (
        <p style={{ fontSize: 12, color: '#ef4444', marginTop: 6 }}>{err}</p>
      )}
    </div>
  )
}
