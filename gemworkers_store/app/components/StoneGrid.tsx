'use client'

import { useEffect, useRef } from 'react'
import { StoneCard, type StoneCardItem } from './StoneCard'
import type { PriceContext } from '@/lib/price-shown'

export function StoneGrid({ items, className = 'stones-grid', priceCtx = null }: { items: StoneCardItem[]; className?: string; priceCtx?: PriceContext | null }) {
  const gridRef = useRef<HTMLDivElement>(null)

  useEffect(() => {
    const cards = gridRef.current?.querySelectorAll<HTMLElement>('.fade-up')
    if (!cards || cards.length === 0) return

    const observer = new IntersectionObserver(
      entries => {
        entries.forEach(entry => {
          if (entry.isIntersecting) {
            entry.target.classList.add('visible')
            observer.unobserve(entry.target)
          }
        })
      },
      { threshold: 0.05 }
    )

    cards.forEach(card => observer.observe(card))
    return () => observer.disconnect()
  }, [])

  return (
    <div ref={gridRef} className={className}>
      {items.map((item, i) => <StoneCard key={item.id} item={item} index={i} priceCtx={priceCtx} />)}
    </div>
  )
}
