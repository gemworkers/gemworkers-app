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
        fontSize: 12, fontWeight: 500,
        color: isPending ? '#4a4440' : '#4a4440',
        background: 'none',
        border: '1px solid #2a2a30',
        borderRadius: 6, padding: '7px 16px',
        cursor: isPending ? 'not-allowed' : 'pointer',
        whiteSpace: 'nowrap',
        flexShrink: 0,
        opacity: isPending ? 0.5 : 1,
        fontFamily: 'var(--font-inter, system-ui)',
      }}
    >
      {isPending ? 'Removing…' : 'Remove'}
    </button>
  )
}
