'use client'

import { useState, useRef, useEffect } from 'react'
import Link from 'next/link'
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

  const navLink: CSSProperties = {
    fontSize: 13, color: '#374151', textDecoration: 'none',
    letterSpacing: '0.02em', whiteSpace: 'nowrap',
  }

  return (
    <header style={{
      position: 'sticky', top: 0, zIndex: 100,
      display: 'flex', alignItems: 'center', justifyContent: 'space-between',
      padding: '0 32px', height: 60,
      background: '#fff', borderBottom: '1px solid #e5e7eb',
    }}>

      {/* ── Left: logo + nav ── */}
      <div style={{ display: 'flex', alignItems: 'center', gap: 36 }}>
        <Link href="/" style={{ textDecoration: 'none', display: 'flex', alignItems: 'center', gap: 10 }}>
          <span style={{
            fontSize: 18, fontWeight: 700, letterSpacing: '0.13em',
            fontFamily: "Georgia, 'Times New Roman', serif", color: '#111',
          }}>
            GEMWORKERS
          </span>
        </Link>

        <nav style={{ display: 'flex', alignItems: 'center', gap: 24 }}>
          {/* Shop dropdown */}
          <div
            ref={shopRef}
            style={{ position: 'relative' }}
            onMouseEnter={() => setShopOpen(true)}
            onMouseLeave={() => setShopOpen(false)}
          >
            <button
              onClick={() => setShopOpen(v => !v)}
              style={{
                ...navLink,
                background: 'none', border: 'none', cursor: 'pointer',
                padding: 0, display: 'flex', alignItems: 'center', gap: 5,
              }}
            >
              Shop
              <svg
                width="10" height="6" viewBox="0 0 10 6" fill="none"
                style={{
                  transition: 'transform 0.15s',
                  transform: shopOpen ? 'rotate(180deg)' : undefined,
                }}
              >
                <path d="M1 1l4 4 4-4" stroke="#9ca3af" strokeWidth="1.5"
                  strokeLinecap="round" strokeLinejoin="round" />
              </svg>
            </button>

            {shopOpen && (
              <div style={{
                position: 'absolute', top: 'calc(100% + 8px)', left: 0,
                background: '#fff', border: '1px solid #e5e7eb',
                borderRadius: 8, boxShadow: '0 8px 24px rgba(0,0,0,0.08)',
                minWidth: 196, padding: '6px 0', zIndex: 200,
              }}>
                {SHOP_LINKS.map(sl => (
                  <Link
                    key={sl.href}
                    href={sl.href}
                    onClick={() => setShopOpen(false)}
                    style={{
                      display: 'block', padding: '10px 18px',
                      fontSize: 13, color: '#374151', textDecoration: 'none',
                      letterSpacing: '0.02em',
                    }}
                    onMouseEnter={e => { (e.currentTarget as HTMLAnchorElement).style.background = '#f9fafb' }}
                    onMouseLeave={e => { (e.currentTarget as HTMLAnchorElement).style.background = 'transparent' }}
                  >
                    {sl.label}
                  </Link>
                ))}
              </div>
            )}
          </div>

          {NAV_LINKS.map(nl => (
            <Link key={nl.href} href={nl.href} style={navLink}>{nl.label}</Link>
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
                  border: '1px solid #e5e7eb', borderRadius: 6,
                  fontSize: 13, color: '#111', background: '#fafaf9',
                  outline: 'none', letterSpacing: '0.01em',
                }}
              />
              <button
                type="submit"
                style={{ background: 'none', border: 'none', cursor: 'pointer', padding: 4, display: 'flex' }}
              >
                <svg width="16" height="16" viewBox="0 0 24 24" fill="none"
                  stroke="#374151" strokeWidth="1.75" strokeLinecap="round" strokeLinejoin="round">
                  <circle cx="11" cy="11" r="7" />
                  <line x1="21" y1="21" x2="16.65" y2="16.65" />
                </svg>
              </button>
            </form>
          ) : (
            <button
              onClick={() => setSearchOpen(true)}
              aria-label="Open search"
              style={{ background: 'none', border: 'none', cursor: 'pointer', padding: 4, display: 'flex' }}
            >
              <svg width="17" height="17" viewBox="0 0 24 24" fill="none"
                stroke="#9ca3af" strokeWidth="1.75" strokeLinecap="round" strokeLinejoin="round">
                <circle cx="11" cy="11" r="7" />
                <line x1="21" y1="21" x2="16.65" y2="16.65" />
              </svg>
            </button>
          )}
        </div>

        {user && <Link href="/cart" style={navLink}>Cart</Link>}

        {/* Auth */}
        {user ? (
          <div style={{ display: 'flex', alignItems: 'center', gap: 16 }}>
            <Link href="/orders" style={navLink}>My Orders</Link>
            <span style={{
              fontSize: 12, color: '#374151', fontWeight: 500, letterSpacing: '0.01em',
              maxWidth: 140, overflow: 'hidden', textOverflow: 'ellipsis', whiteSpace: 'nowrap',
            }}>
              {user.displayName}
            </span>
            <form action={signOut} style={{ display: 'inline' }}>
              <button type="submit" style={{
                fontSize: 12, color: '#6b7280', background: 'none', border: 'none',
                cursor: 'pointer', padding: 0, letterSpacing: '0.02em',
              }}>
                Log out
              </button>
            </form>
          </div>
        ) : (
          <div style={{ display: 'flex', alignItems: 'center', gap: 16 }}>
            <Link href="/auth/login" style={navLink}>Log in</Link>
            <Link href="/auth/signup" style={{
              fontSize: 12, fontWeight: 600, color: '#fff',
              background: '#111', padding: '6px 14px', borderRadius: 5,
              textDecoration: 'none', letterSpacing: '0.02em',
            }}>
              Sign up
            </Link>
          </div>
        )}
      </div>
    </header>
  )
}
