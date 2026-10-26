'use client'

import { useEffect } from 'react'
import { usePathname } from 'next/navigation'

// Tells /api/v that a page was opened (anonymous views & visits,
// sql/page_views.sql). Runs only in a real browser, once per page.
export function ViewCounter() {
  const pathname = usePathname()
  useEffect(() => {
    if (!pathname) return
    const utm = new URLSearchParams(window.location.search).get('utm_source') ?? ''
    const body = JSON.stringify({ p: pathname, r: document.referrer, u: utm })
    try {
      if (navigator.sendBeacon) {
        navigator.sendBeacon('/api/v', new Blob([body], { type: 'application/json' }))
      } else {
        fetch('/api/v', { method: 'POST', body, keepalive: true, headers: { 'Content-Type': 'application/json' } })
      }
    } catch {
      // Counting must never disturb the shop.
    }
  }, [pathname])
  return null
}
