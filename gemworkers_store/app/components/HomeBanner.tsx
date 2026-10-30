'use client'

import { useEffect, useState, type ReactNode } from 'react'

// Homepage banner: a few slides that change every 7 seconds (paused while the
// mouse is over it), with dots. The slides themselves are rendered by the page.
export function HomeBanner({ slides }: { slides: ReactNode[] }) {
  const [i, setI] = useState(0)
  const [paused, setPaused] = useState(false)
  const n = slides.length

  useEffect(() => {
    if (n < 2 || paused) return
    if (window.matchMedia('(prefers-reduced-motion: reduce)').matches) return
    const t = setInterval(() => setI(x => (x + 1) % n), 7000)
    return () => clearInterval(t)
  }, [n, paused])

  return (
    <section
      className="banner"
      aria-roledescription="carousel"
      onMouseEnter={() => setPaused(true)}
      onMouseLeave={() => setPaused(false)}
      onFocus={() => setPaused(true)}
      onBlur={() => setPaused(false)}
    >
      {slides.map((s, k) => (
        <div key={k} className={`banner-slide${k === i ? ' is-active' : ''}`} aria-hidden={k !== i} role="group"
          aria-roledescription="slide" aria-label={`${k + 1} of ${n}`}>
          {s}
        </div>
      ))}
      {n > 1 && (
        <div className="banner-dots">
          {slides.map((_, k) => (
            <button key={k} type="button" className={`banner-dot${k === i ? ' is-active' : ''}`}
              onClick={() => setI(k)} aria-label={`Show slide ${k + 1}`} aria-current={k === i} />
          ))}
        </div>
      )}
    </section>
  )
}
