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
        fontSize: 14, fontWeight: 500, color: '#5A5045',
        background: 'none', border: 'none', padding: '6px 0',
        textDecoration: 'underline', textUnderlineOffset: 3,
        cursor: isPending ? 'not-allowed' : 'pointer',
        whiteSpace: 'nowrap', flexShrink: 0,
        opacity: isPending ? 0.5 : 1,
        fontFamily: 'var(--font-inter, system-ui)',
      }}
    >
      {isPending ? 'Removing…' : 'Remove'}
    </button>
  )
}
