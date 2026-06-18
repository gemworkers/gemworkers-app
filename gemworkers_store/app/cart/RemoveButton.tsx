'use client'

import { useRouter } from 'next/navigation'
import { useTransition } from 'react'
import { removeFromCart } from '@/app/actions/commerce'

export function RemoveButton({ itemId }: { itemId: string }) {
  const router = useRouter()
  const [isPending, startTransition] = useTransition()

  return (
    <button
      onClick={() =>
        startTransition(async () => {
          await removeFromCart(itemId)
          router.refresh()
        })
      }
      disabled={isPending}
      style={{
        fontSize: 13, fontWeight: 500,
        color: isPending ? '#9ca3af' : '#6b7280',
        background: 'none',
        border: '1px solid #e5e7eb',
        borderRadius: 6, padding: '7px 16px',
        cursor: isPending ? 'not-allowed' : 'pointer',
        whiteSpace: 'nowrap',
        flexShrink: 0,
      }}
    >
      {isPending ? 'Removing…' : 'Remove'}
    </button>
  )
}
