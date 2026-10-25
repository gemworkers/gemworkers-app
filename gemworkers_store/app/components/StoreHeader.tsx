'use client'

import { useState, useRef, useEffect } from 'react'
import Link from 'next/link'
import Image from 'next/image'
import { useRouter, usePathname } from 'next/navigation'
import { signOut } from '@/app/actions/auth'
import type { CSSProperties } from 'react'

type NavUser = { displayName: string | null; unreadMessages: number }

const SHOP_LINKS: { label: string; href: string }[] = [
  { label: 'Loose Gemstones', href: '/shop/loose_stone' },
  { label: 'Mineral Specimens', href: '/shop/specimen' },
  { label: 'Jewelry',           href: '/shop/jewelry' },
]

const NAV_LINKS: { label: string; href: string }[] = [
  { label: 'Our Makers', href: '/makers' },
  { label: 'Reviews',    href: '/reviews' },
  { label: 'Journal',    href: '/journal' },
  { label: 'About',      href: '/about' },
  { label: 'Contact',    href: '/contact' },
]

const navText: CSSProperties = {
  fontSize: 12, color: '#5A5045', letterSpacing: '0.06em', whiteSpace: 'nowrap',
  fontFamily: 'var(--font-inter, system-ui)',
}

// Unread replies next to "Messages" (buyer_unread_count)
function UnreadBadge({ count }: { count: number }) {
  if (count <= 0) return null
  return (
    <span className="nav-badge" aria-label={`${count} unread`}>
      {count > 9 ? '9+' : count}
    </span>
  )
}

export function StoreHeader({ user }: { user: NavUser | null }) {
  const [shopOpen, setShopOpen]     = useState(false)
  const [searchOpen, setSearchOpen] = useState(false)
  const [mobileOpen, setMobileOpen] = useState(false)
  const [query, setQuery]           = useState('')
  const shopRef   = useRef<HTMLDivElement>(null)
  const searchRef = useRef<HTMLDivElement>(null)
  const inputRef  = useRef<HTMLInputElement>(null)
  const router   = useRouter()
  const pathname = usePathname()

  // Close mobile menu on route change
  useEffect(() => { setMobileOpen(false) }, [pathname])

  // Close mobile menu when viewport widens to desktop
  useEffect(() => {
    function onResize() { if (window.innerWidth > 768) setMobileOpen(false) }
    window.addEventListener('resize', onResize)
    return () => window.removeEventListener('resize', onResize)
  }, [])

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

  function handleSearch(e: React.FormEvent<HTMLFormElement>) {
    e.preventDefault()
    const q = query.trim()
    if (!q) return
    router.push(`/search?q=${encodeURIComponent(q)}`)
    setSearchOpen(false)
    setQuery('')
    setMobileOpen(false)
  }

  return (
    <>
      <header style={{
        position: 'sticky', top: 0, zIndex: 100,
        display: 'flex', alignItems: 'center', justifyContent: 'space-between',
        padding: '0 32px', height: 64,
        background: '#FFFFFF',
        borderBottom: '1px solid #ECE5D8',
        /* NO overflow:hidden — that was clipping the dropdown */
      }}>

        {/* ── Left: logo + desktop nav ── */}
        <div style={{ display: 'flex', alignItems: 'center', gap: 36 }}>
          <Link href="/" style={{ textDecoration: 'none', display: 'flex', alignItems: 'center', flexShrink: 0 }}>
            <Image src="/logo-horizontal-black.png" alt="GemWorkers" width={3801} height={607} priority className="header-logo" />
          </Link>

          <nav className="header-nav-desktop">
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
                  <path d="M1 1l4 4 4-4" stroke="#7A5A22" strokeWidth="1.5"
                    strokeLinecap="round" strokeLinejoin="round" />
                </svg>
              </button>

              {shopOpen && (
                <div style={{
                  position: 'absolute', top: 'calc(100% + 12px)', left: 0,
                  background: '#FFFFFF', border: '1px solid #ECE5D8',
                  borderRadius: 6, boxShadow: '0 16px 48px rgba(0,0,0,0.10)',
                  minWidth: 196, padding: '6px 0', zIndex: 200,
                }}>
                  {SHOP_LINKS.map(sl => (
                    <Link
                      key={sl.href} href={sl.href}
                      onClick={() => setShopOpen(false)}
                      style={{
                        display: 'block', padding: '10px 18px',
                        fontSize: 13, color: '#5A5045', textDecoration: 'none',
                        letterSpacing: '0.03em', transition: 'color 150ms ease, background 150ms ease',
                      }}
                      onMouseEnter={e => {
                        (e.currentTarget as HTMLAnchorElement).style.color = '#1F1B16'
                        ;(e.currentTarget as HTMLAnchorElement).style.background = '#F4EEE4'
                      }}
                      onMouseLeave={e => {
                        (e.currentTarget as HTMLAnchorElement).style.color = '#5A5045'
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

        {/* ── Right: desktop search + cart + auth ── */}
        <div className="header-right-desktop">
          <div ref={searchRef} style={{ display: 'flex', alignItems: 'center' }}>
            {searchOpen ? (
              <form onSubmit={handleSearch} style={{ display: 'flex', alignItems: 'center', gap: 6 }}>
                <input
                  ref={inputRef} type="text" value={query}
                  onChange={e => setQuery(e.target.value)}
                  placeholder="Search stones…"
                  style={{
                    width: 200, height: 32, padding: '0 12px',
                    border: '1px solid #ECE5D8', borderRadius: 4,
                    fontSize: 13, color: '#1F1B16', background: '#FFFFFF',
                    outline: 'none', letterSpacing: '0.02em',
                    fontFamily: 'var(--font-inter, system-ui)',
                  }}
                />
                <button type="submit" style={{ background: 'none', border: 'none', cursor: 'pointer', padding: 4, display: 'flex' }}>
                  <svg width="16" height="16" viewBox="0 0 24 24" fill="none"
                    stroke="#5A5045" strokeWidth="1.75" strokeLinecap="round" strokeLinejoin="round">
                    <circle cx="11" cy="11" r="7" /><line x1="21" y1="21" x2="16.65" y2="16.65" />
                  </svg>
                </button>
              </form>
            ) : (
              <button onClick={() => setSearchOpen(true)} aria-label="Open search"
                style={{ background: 'none', border: 'none', cursor: 'pointer', padding: 4, display: 'flex' }}>
                <svg width="17" height="17" viewBox="0 0 24 24" fill="none"
                  stroke="#5A5045" strokeWidth="1.75" strokeLinecap="round" strokeLinejoin="round">
                  <circle cx="11" cy="11" r="7" /><line x1="21" y1="21" x2="16.65" y2="16.65" />
                </svg>
              </button>
            )}
          </div>

          {user && <Link href="/cart" className="nav-link" style={navText}>Cart</Link>}

          {user ? (
            <div style={{ display: 'flex', alignItems: 'center', gap: 16 }}>
              <Link href="/orders" className="nav-link" style={navText}>My Orders</Link>
              <Link href="/messages" className="nav-link" style={navText}>
                Messages<UnreadBadge count={user.unreadMessages} />
              </Link>
              <Link href="/account" title="My account" style={{
                fontSize: 11, color: '#6B6052', fontFamily: 'var(--font-inter, system-ui)',
                maxWidth: 130, overflow: 'hidden', textOverflow: 'ellipsis', whiteSpace: 'nowrap',
                textDecoration: 'none',
              }}>
                {user.displayName}
              </Link>
              <form action={signOut} style={{ display: 'inline' }}>
                <button type="submit" style={{
                  fontSize: 11, color: '#6B6052', background: 'none', border: 'none',
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
                fontSize: 11, fontWeight: 600, color: '#7A5A22',
                border: '1px solid rgba(122,90,34,0.45)',
                padding: '5px 14px', borderRadius: 4,
                textDecoration: 'none', letterSpacing: '0.08em',
                fontFamily: 'var(--font-inter, system-ui)',
              }}>
                Sign up
              </Link>
            </div>
          )}
        </div>

        {/* ── Mobile hamburger ── */}
        <button
          className="header-burger"
          onClick={() => setMobileOpen(v => !v)}
          aria-label={mobileOpen ? 'Close menu' : 'Open menu'}
        >
          {mobileOpen ? (
            <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor"
              strokeWidth="1.75" strokeLinecap="round">
              <line x1="18" y1="6" x2="6" y2="18" /><line x1="6" y1="6" x2="18" y2="18" />
            </svg>
          ) : (
            <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor"
              strokeWidth="1.75" strokeLinecap="round">
              <line x1="3" y1="6" x2="21" y2="6" />
              <line x1="3" y1="12" x2="21" y2="12" />
              <line x1="3" y1="18" x2="21" y2="18" />
            </svg>
          )}
        </button>
      </header>

      {/* ── Mobile menu overlay ── */}
      {mobileOpen && (
        <div className="mobile-menu">
          <p className="mobile-menu-section-label">Shop</p>
          {SHOP_LINKS.map(sl => (
            <Link key={sl.href} href={sl.href} className="mobile-menu-link"
              onClick={() => setMobileOpen(false)}>
              {sl.label}
            </Link>
          ))}

          <div className="mobile-menu-divider" />

          {NAV_LINKS.map(nl => (
            <Link key={nl.href} href={nl.href} className="mobile-menu-link"
              onClick={() => setMobileOpen(false)}>
              {nl.label}
            </Link>
          ))}

          <div className="mobile-menu-divider" />

          {/* Search */}
          <form onSubmit={handleSearch} style={{ marginBottom: 20 }}>
            <div style={{ display: 'flex', gap: 8 }}>
              <input
                type="text" value={query}
                onChange={e => setQuery(e.target.value)}
                placeholder="Search stones…"
                style={{
                  flex: 1, height: 40, padding: '0 12px',
                  border: '1px solid #ECE5D8', borderRadius: 4,
                  fontSize: 14, color: '#1F1B16', background: '#FFFFFF',
                  outline: 'none', fontFamily: 'var(--font-inter, system-ui)',
                }}
              />
              <button type="submit" style={{
                height: 40, padding: '0 16px', background: 'none',
                border: '1px solid #ECE5D8', borderRadius: 4,
                cursor: 'pointer', color: '#5A5045', fontSize: 13,
                fontFamily: 'var(--font-inter, system-ui)',
              }}>
                Go
              </button>
            </div>
          </form>

          <div className="mobile-menu-divider" />

          {user ? (
            <div style={{ display: 'flex', flexDirection: 'column', gap: 0 }}>
              <Link href="/cart" className="mobile-menu-link" onClick={() => setMobileOpen(false)}>Cart</Link>
              <Link href="/orders" className="mobile-menu-link" onClick={() => setMobileOpen(false)}>My Orders</Link>
              <Link href="/messages" className="mobile-menu-link" onClick={() => setMobileOpen(false)}>
                Messages<UnreadBadge count={user.unreadMessages} />
              </Link>
              <Link href="/account" className="mobile-menu-link" onClick={() => setMobileOpen(false)}>My account</Link>
              <form action={signOut}>
                <button type="submit" style={{
                  display: 'block', padding: '12px 0', fontSize: 18, fontWeight: 300,
                  color: '#5A5045', background: 'none', border: 'none', cursor: 'pointer',
                  fontFamily: 'var(--font-cormorant, Georgia, serif)',
                  letterSpacing: '0.04em',
                }}>
                  Log out
                </button>
              </form>
            </div>
          ) : (
            <div style={{ display: 'flex', flexDirection: 'column', gap: 12, paddingTop: 8 }}>
              <Link href="/auth/login" className="mobile-menu-link" onClick={() => setMobileOpen(false)}>Log in</Link>
              <Link href="/auth/signup" onClick={() => setMobileOpen(false)} style={{
                display: 'inline-block', padding: '12px 28px', borderRadius: 4,
                border: '1px solid rgba(122,90,34,0.6)', color: '#7A5A22',
                fontSize: 12, fontWeight: 600, letterSpacing: '0.14em', textTransform: 'uppercase',
                textDecoration: 'none', fontFamily: 'var(--font-inter, system-ui)',
                alignSelf: 'flex-start', marginTop: 4,
              }}>
                Sign up
              </Link>
            </div>
          )}
        </div>
      )}
    </>
  )
}
