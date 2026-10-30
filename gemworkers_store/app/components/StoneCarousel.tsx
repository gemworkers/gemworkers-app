'use client'

import { useEffect, useRef, useState } from 'react'
import { StoneCard, type StoneCardItem } from './StoneCard'
import type { PriceContext, FxContext } from '@/lib/price-shown'

// Homepage row of stone cards that slides sideways: arrows on desktop, swipe
// on phones (CSS scroll-snap). Same cards as the shop grid.
export function StoneCarousel({ items, priceCtx = null, favouriteIds, fx = null, label }: {
  items: StoneCardItem[]; priceCtx?: PriceContext | null; favouriteIds?: string[] | null
  fx?: FxContext | null; label: string
}) {
  const rowRef = useRef<HTMLDivElement>(null)
  const [atStart, setAtStart] = useState(true)
  const [atEnd, setAtEnd] = useState(false)

  useEffect(() => {
    const row = rowRef.current
    if (!row) return
    // Cards fade in once, like the shop grid.
    const cards = row.querySelectorAll<HTMLElement>('.fade-up')
    const io = new IntersectionObserver(entries => entries.forEach(e => {
      if (e.isIntersecting) { e.target.classList.add('visible'); io.unobserve(e.target) }
    }), { threshold: 0.05 })
    cards.forEach(c => io.observe(c))

    const onScroll = () => {
      setAtStart(row.scrollLeft < 8)
      setAtEnd(row.scrollLeft + row.clientWidth >= row.scrollWidth - 8)
    }
    onScroll()
    row.addEventListener('scroll', onScroll, { passive: true })
    window.addEventListener('resize', onScroll)
    return () => { io.disconnect(); row.removeEventListener('scroll', onScroll); window.removeEventListener('resize', onScroll) }
  }, [])

  const go = (dir: 1 | -1) => {
    const row = rowRef.current
    if (row) row.scrollBy({ left: dir * row.clientWidth * 0.9, behavior: 'smooth' })
  }

  return (
    <div className="carousel" role="region" aria-label={label}>
      <button type="button" className="carousel-arrow carousel-prev" onClick={() => go(-1)} disabled={atStart} aria-label="Previous">‹</button>
      <div ref={rowRef} className="carousel-row">
        {items.map((item, i) => (
          <div key={item.id} className="carousel-item">
            <StoneCard item={item} index={i} priceCtx={priceCtx} favouriteIds={favouriteIds} fx={fx} />
          </div>
        ))}
      </div>
      <button type="button" className="carousel-arrow carousel-next" onClick={() => go(1)} disabled={atEnd} aria-label="Next">›</button>
    </div>
  )
}
