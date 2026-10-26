'use client'

import { useState } from 'react'

// Share a stone. Phones: the phone's own share menu (WhatsApp, Instagram,
// TikTok, Messages…). Computers: WhatsApp, Facebook, Pinterest, X, copy link.
// The preview (photo, name, description) comes from the stone page's
// OpenGraph data (generateMetadata in app/stones/[id]/page.tsx).
export function ShareButton({ url, title, image }: { url: string; title: string; image?: string | null }) {
  const [open, setOpen] = useState(false)
  const [copied, setCopied] = useState(false)

  async function share() {
    if (typeof navigator !== 'undefined' && navigator.share) {
      try {
        await navigator.share({ title, text: `${title} — GemWorkers`, url })
        return
      } catch {
        // Cancelled or not allowed: fall back to the list.
      }
    }
    setOpen(o => !o)
  }

  async function copy() {
    try {
      await navigator.clipboard.writeText(url)
      setCopied(true)
      setTimeout(() => setCopied(false), 2000)
    } catch {
      window.prompt('Copy this link:', url)
    }
  }

  const u = encodeURIComponent(url)
  const t = encodeURIComponent(`${title} — GemWorkers`)
  const links = [
    { label: 'WhatsApp', href: `https://wa.me/?text=${t}%20${u}` },
    { label: 'Facebook', href: `https://www.facebook.com/sharer/sharer.php?u=${u}` },
    { label: 'Pinterest', href: `https://www.pinterest.com/pin/create/button/?url=${u}&description=${t}${image ? `&media=${encodeURIComponent(image)}` : ''}` },
    { label: 'X', href: `https://x.com/intent/post?url=${u}&text=${t}` },
  ]

  return (
    <div style={{ position: 'relative', display: 'inline-block' }}>
      <button type="button" onClick={share} className="pd-link"
        style={{ background: 'none', border: 'none', padding: 0, cursor: 'pointer', fontSize: 14, display: 'inline-flex', alignItems: 'center', gap: 6 }}>
        <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round" aria-hidden="true">
          <path d="M4 12v7a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2v-7" /><path d="M16 6l-4-4-4 4" /><path d="M12 2v14" />
        </svg>
        Share
      </button>
      {open && (
        <div role="menu" style={{
          position: 'absolute', top: '100%', left: 0, marginTop: 8, zIndex: 20,
          background: '#FFFFFF', border: '1px solid #ECE5D8', borderRadius: 14, padding: 8,
          boxShadow: '0 8px 24px rgba(31,27,22,0.12)', minWidth: 180,
        }}>
          {links.map(l => (
            <a key={l.label} href={l.href} target="_blank" rel="noopener noreferrer" role="menuitem"
              onClick={() => setOpen(false)}
              style={{ display: 'block', padding: '8px 12px', fontSize: 14, color: '#1F1B16', textDecoration: 'none', borderRadius: 8 }}>
              {l.label}
            </a>
          ))}
          <button type="button" onClick={copy} role="menuitem"
            style={{ display: 'block', width: '100%', textAlign: 'left', padding: '8px 12px', fontSize: 14, color: '#1F1B16', background: 'none', border: 'none', cursor: 'pointer', borderRadius: 8 }}>
            {copied ? 'Link copied ✓' : 'Copy link'}
          </button>
        </div>
      )}
    </div>
  )
}
