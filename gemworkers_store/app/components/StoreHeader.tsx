'use client'

import { useState, useRef, useEffect } from 'react'
import Link from 'next/link'
import Image from 'next/image'
import { useRouter } from 'next/navigation'
import { signOut } from '@/app/actions/auth'
import type { CSSProperties, FormEvent } from 'react'

type NavUser = { displayName: string | null }

const SHOP_LINKS: { label: string; href: string }[] = [
  { label: 'Loose Gemstones', href: '/shop/loose_stone' },
  { label: 'Mineral Specimens', href: '/shop/specimen' },
  { label: 'Jewelry',           href: '/shop/jewelry' },
]

const NAV_LINKS: { label: string; href: string }[] = [
  { label: 'Our Makers', href: '/makers' },
  { label: 'Journal',    href: '/journal' },
  { label: 'About',      href: '/about' },
  { label: 'Contact',    href: '/contact' },
]

const navText: CSSProperties = {
  fontSize: 12, color: '#9d9080', letterSpacing: '0.06em', whiteSpace: 'nowrap',
  fontFamily: 'var(--font-inter, system-ui)',
}

export function StoreHeader({ user }: { user: NavUser | null }) {
  const [shopOpen, setShopOpen]     = useState(false)
  const [searchOpen, setSearchOpen] = useState(false)
  const [query, setQuery]           = useState('')
  const shopRef   = useRef<HTMLDivElement>(null)
  const searchRef = useRef<HTMLDivElement>(null)
  const inputRef  = useRef<HTMLInputElement>(null)
  const router    = useRouter()

  useEffect(() => {
    function onClickOutside(e: MouseEvent) {
      if (shopRef.current && !shopRef.current.contains(e.target as Node))
        setShopOpen(false)
      if (searchRef.current && !searchRef.current.contains(e.target as Node))
        setSearchOpen(false)
    }
    document.addEventListener('mousedown', onClickOutside)
    return () => document.removeEventListener('mousedown', onClickOutside)
  }, [])

  useEffect(() => {
    if (searchOpen) inputRef.current?.focus()
  }, [searchOpen])

  function handleSearch(e: FormEvent<HTMLFormElement>) {
    e.preventDefault()
    const q = query.trim()
    if (!q) return
    router.push(`/search?q=${encodeURIComponent(q)}`)
    setSearchOpen(false)
    setQuery('')
  }

  return (
    <header style={{
      position: 'sticky', top: 0, zIndex: 100,
      display: 'flex', alignItems: 'center', justifyContent: 'space-between',
      padding: '0 32px', height: 64, overflow: 'hidden',
      background: '#0e0e10',
      borderBottom: '1px solid rgba(201,169,98,0.15)',
    }}>

      {/* ── Left: logo + nav ── */}
      <div style={{ display: 'flex', alignItems: 'center', gap: 40 }}>
        <Link href="/" style={{ textDecoration: 'none', display: 'flex', alignItems: 'center', gap: 10, flexShrink: 0 }}>
          {/* 1374x1244 source → display at 38x34 */}
          <Image src="/logo-mark-white.png" alt="" width={38} height={34} style={{ display: 'block' }} />
          <span style={{
            fontFamily: 'var(--font-cormorant, Georgia, serif)',
            fontSize: 18, fontWeight: 400, color: '#f5f0e8',
            letterSpacing: '0.12em', textTransform: 'uppercase', lineHeight: 1,
          }}>
            GemWorkers
          </span>
        </Link>

        <nav style={{ display: 'flex', alignItems: 'center', gap: 28 }}>
          {/* Shop dropdown */}
          <div
            ref={shopRef}
            style={{ position: 'relative' }}
            onMouseEnter={() => setShopOpen(true)}
            onMouseLeave={() => setShopOpen(false)}
          >
            <button
              onClick={() => setShopOpen(v => !v)}
              className="nav-link"
              style={{
                ...navText,
                background: 'none', border: 'none', cursor: 'pointer',
                padding: 0, display: 'flex', alignItems: 'center', gap: 5,
              }}
            >
              Shop
              <svg width="10" height="6" viewBox="0 0 10 6" fill="none" style={{
                transition: 'transform 0.2s ease-out', flexShrink: 0,
                transform: shopOpen ? 'rotate(180deg)' : undefined,
              }}>
                <path d="M1 1l4 4 4-4" stroke="#c9a962" strokeWidth="1.5"
                  strokeLinecap="round" strokeLinejoin="round" />
              </svg>
            </button>

            {shopOpen && (
              <div style={{
                position: 'absolute', top: 'calc(100% + 12px)', left: 0,
                background: '#16161a', border: '1px solid #2a2a30',
                borderRadius: 6, boxShadow: '0 16px 48px rgba(0,0,0,0.7)',
                minWidth: 196, padding: '6px 0', zIndex: 200,
              }}>
                {SHOP_LINKS.map(sl => (
                  <Link
                    key={sl.href}
                    href={sl.href}
                    onClick={() => setShopOpen(false)}
                    style={{
                      display: 'block', padding: '10px 18px',
                      fontSize: 13, color: '#9d9080', textDecoration: 'none',
                      letterSpacing: '0.03em', transition: 'color 150ms ease, background 150ms ease',
                    }}
                    onMouseEnter={e => {
                      (e.currentTarget as HTMLAnchorElement).style.color = '#f5f0e8'
                      ;(e.currentTarget as HTMLAnchorElement).style.background = '#1e1e24'
                    }}
                    onMouseLeave={e => {
                      (e.currentTarget as HTMLAnchorElement).style.color = '#9d9080'
                      ;(e.currentTarget as HTMLAnchorElement).style.background = 'transparent'
                    }}
                  >
                    {sl.label}
                  </Link>
                ))}
              </div>
            )}
          </div>

          {NAV_LINKS.map(nl => (
            <Link key={nl.href} href={nl.href} className="nav-link" style={navText}>
              {nl.label}
            </Link>
          ))}
        </nav>
      </div>

      {/* ── Right: search + cart + auth ── */}
      <div style={{ display: 'flex', alignItems: 'center', gap: 20 }}>

        {/* Search */}
        <div ref={searchRef} style={{ display: 'flex', alignItems: 'center' }}>
          {searchOpen ? (
            <form onSubmit={handleSearch} style={{ display: 'flex', alignItems: 'center', gap: 6 }}>
              <input
                ref={inputRef}
                type="text"
                value={query}
                onChange={e => setQuery(e.target.value)}
                placeholder="Search stones…"
                style={{
                  width: 200, height: 32, padding: '0 12px',
                  border: '1px solid #2a2a30', borderRadius: 4,
                  fontSize: 13, color: '#f5f0e8', background: '#16161a',
                  outline: 'none', letterSpacing: '0.02em',
                  fontFamily: 'var(--font-inter, system-ui)',
                }}
              />
              <button type="submit"
                style={{ background: 'none', border: 'none', cursor: 'pointer', padding: 4, display: 'flex' }}>
                <svg width="16" height="16" viewBox="0 0 24 24" fill="none"
                  stroke="#9d9080" strokeWidth="1.75" strokeLinecap="round" strokeLinejoin="round">
                  <circle cx="11" cy="11" r="7" /><line x1="21" y1="21" x2="16.65" y2="16.65" />
                </svg>
              </button>
            </form>
          ) : (
            <button onClick={() => setSearchOpen(true)} aria-label="Open search"
              style={{ background: 'none', border: 'none', cursor: 'pointer', padding: 4, display: 'flex' }}>
              <svg width="17" height="17" viewBox="0 0 24 24" fill="none"
                stroke="#9d9080" strokeWidth="1.75" strokeLinecap="round" strokeLinejoin="round">
                <circle cx="11" cy="11" r="7" /><line x1="21" y1="21" x2="16.65" y2="16.65" />
              </svg>
            </button>
          )}
        </div>

        {user && <Link href="/cart" className="nav-link" style={navText}>Cart</Link>}

        {user ? (
          <div style={{ display: 'flex', alignItems: 'center', gap: 16 }}>
            <Link href="/orders" className="nav-link" style={navText}>My Orders</Link>
            <span style={{
              fontSize: 11, color: '#5c5346', fontFamily: 'var(--font-inter, system-ui)',
              maxWidth: 130, overflow: 'hidden', textOverflow: 'ellipsis', whiteSpace: 'nowrap',
            }}>
              {user.displayName}
            </span>
            <form action={signOut} style={{ display: 'inline' }}>
              <button type="submit" style={{
                fontSize: 11, color: '#5c5346', background: 'none', border: 'none',
                cursor: 'pointer', padding: 0, letterSpacing: '0.04em',
                fontFamily: 'var(--font-inter, system-ui)',
              }}>
                Log out
              </button>
            </form>
          </div>
        ) : (
          <div style={{ display: 'flex', alignItems: 'center', gap: 14 }}>
            <Link href="/auth/login" className="nav-link" style={navText}>Log in</Link>
            <Link href="/auth/signup" style={{
              fontSize: 11, fontWeight: 600, color: '#c9a962',
              border: '1px solid rgba(201,169,98,0.45)',
              padding: '5px 14px', borderRadius: 4,
              textDecoration: 'none', letterSpacing: '0.08em',
              fontFamily: 'var(--font-inter, system-ui)',
            }}>
              Sign up
            </Link>
          </div>
        )}
      </div>
    </header>
  )
}
