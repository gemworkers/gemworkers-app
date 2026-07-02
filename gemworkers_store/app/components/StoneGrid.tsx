'use client'

import { useEffect, useRef } from 'react'
import { StoneCard, type StoneCardItem } from './StoneCard'

export function StoneGrid({ items }: { items: StoneCardItem[] }) {
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
    <div ref={gridRef} className="stones-grid">
      {items.map((item, i) => <StoneCard key={item.id} item={item} index={i} />)}
    </div>
  )
}
