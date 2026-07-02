'use client'

import { useEffect, useRef, useState } from 'react'
import Link from 'next/link'

const WORDS = ['Brilliance', 'in', 'every', 'stone']

export function HeroSection() {
  const [go, setGo] = useState(false)
  const glyphRef    = useRef<HTMLDivElement>(null)

  useEffect(() => {
    setGo(true)

    if (window.matchMedia('(prefers-reduced-motion: reduce)').matches) return

    let ticking = false
    function onScroll() {
      if (ticking) return
      ticking = true
      requestAnimationFrame(() => {
        const offset = Math.min(window.scrollY * 0.25, 35)
        if (glyphRef.current) glyphRef.current.style.transform = `translateY(${offset}px)`
        ticking = false
      })
    }
    window.addEventListener('scroll', onScroll, { passive: true })
    return () => window.removeEventListener('scroll', onScroll)
  }, [])

  return (
    <section
      className={`hero-section${go ? ' hero-go' : ''}`}
      style={{ textAlign: 'center', padding: '112px 32px 88px' }}
    >
      {/* ◇ glyph with parallax */}
      <div
        ref={glyphRef}
        style={{
          fontSize: 22, color: '#c9a962', marginBottom: 28, lineHeight: 1,
          fontFamily: 'var(--font-cormorant, Georgia, serif)', letterSpacing: '0.12em',
          willChange: 'transform',
        }}
      >
        ◇
      </div>

      <h1 style={{
        fontSize: 'clamp(44px, 7vw, 80px)',
        fontWeight: 300,
        letterSpacing: '0.08em',
        color: '#f5f0e8',
        fontFamily: 'var(--font-cormorant, Georgia, serif)',
        lineHeight: 1.1,
        marginBottom: 32,
        textTransform: 'uppercase',
      }}>
        {WORDS.map((word, i) => (
          <span
            key={i}
            className="hero-word"
            style={{ '--word-delay': `${i * 100}ms` } as React.CSSProperties}
          >
            {word}{i < WORDS.length - 1 ? ' ' : ''}
          </span>
        ))}
      </h1>

      {/* Gold rule with draw animation + shimmer */}
      <div style={{
        width: 56, margin: '0 auto 28px',
        position: 'relative', height: 1, overflow: 'hidden',
      }}>
        <div className="hero-rule gold-rule" style={{ position: 'absolute', inset: 0 }} />
        <div className="hero-shimmer" />
      </div>

      <p
        className="hero-sub"
        style={{
          fontSize: 'clamp(14px, 2vw, 17px)',
          color: '#9d9080',
          maxWidth: 480,
          margin: '0 auto 44px',
          lineHeight: 1.7,
          letterSpacing: '0.03em',
          fontFamily: 'var(--font-inter, system-ui)',
        }}
      >
        Direct from miners, cutters and craftspeople across the world.
      </p>

      <Link
        href="/shop/loose_stone"
        className="hero-cta btn-vault"
        style={{
          display: 'inline-block',
          padding: '13px 36px',
          border: '1px solid rgba(201,169,98,0.6)',
          borderRadius: 4,
          fontSize: 12,
          fontWeight: 600,
          letterSpacing: '0.14em',
          textTransform: 'uppercase',
          color: '#c9a962',
          textDecoration: 'none',
          fontFamily: 'var(--font-inter, system-ui)',
        }}
      >
        Browse the collection
      </Link>
    </section>
  )
}
