'use client'

import { useState, useTransition } from 'react'
import { useRouter } from 'next/navigation'
import { setCartQuantity } from '@/app/actions/commerce'

// How many of a multi-stock listing (sql/quantity_listings.sql) are in the cart.
export function QuantitySelect({ itemId, quantity, stock }: { itemId: string; quantity: number; stock: number }) {
  const router = useRouter()
  const [value, setValue] = useState(quantity)
  const [pending, start] = useTransition()
  const max = Math.min(Math.max(1, stock), 99)

  return (
    <label className="cart-sub" style={{ display: 'inline-flex', alignItems: 'center', gap: 8, marginTop: 6 }}>
      Quantity
      <select
        value={value}
        disabled={pending}
        onChange={e => {
          const q = Number(e.target.value)
          setValue(q)
          start(async () => {
            await setCartQuantity(itemId, q)
            router.refresh()
          })
        }}
        style={{ padding: '4px 8px', borderRadius: 8, border: '1px solid #DDD3C2', background: '#fff', fontSize: 14 }}
      >
        {Array.from({ length: max }, (_, i) => i + 1).map(n => <option key={n} value={n}>{n}</option>)}
      </select>
      <span style={{ color: '#8A7F70' }}>of {stock}</span>
    </label>
  )
}
