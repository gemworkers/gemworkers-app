'use client'

import { useRouter } from 'next/navigation'
import { useState } from 'react'
import { markOrderReceived } from '@/app/actions/commerce'
import { pillOutlineSm, pillDisabledSm } from '@/lib/ui'

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
          ...(loading ? pillDisabledSm : pillOutlineSm),
          width: 'auto', display: 'inline-flex', height: 40, padding: '0 20px',
        }}
      >
        {loading ? 'Confirming…' : 'Mark as received'}
      </button>
      {err && (
        <p style={{ fontSize: 13, color: '#B42318', marginTop: 8 }}>
          {err}
        </p>
      )}
    </div>
  )
}
