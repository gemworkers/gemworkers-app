import Image from 'next/image'
import Link from 'next/link'
import type { CSSProperties } from 'react'

// Centred auth layout: logo, title, optional intro line, then the card.
export function AuthShell({
  title,
  intro,
  children,
  center = false,
}: {
  title: string
  intro?: React.ReactNode
  children?: React.ReactNode
  center?: boolean
}) {
  return (
    <main className="auth-wrap">
      <Link href="/" className="auth-logo" aria-label="GemWorkers home">
        <Image src="/logo-horizontal-black.png" alt="GemWorkers" width={3801} height={607} priority />
      </Link>
      <h1 className="font-serif auth-title">{title}</h1>
      {intro && <p className="auth-intro">{intro}</p>}
      {children && (
        <div className="auth-card" style={center ? { textAlign: 'center' } : undefined}>
          {children}
        </div>
      )}
    </main>
  )
}

export const authErrorStyle: CSSProperties = {
  fontSize: 14, color: '#B42318', lineHeight: 1.5,
  background: 'rgba(180,35,24,0.06)',
  border: '1px solid rgba(180,35,24,0.25)',
  borderRadius: 12, padding: '10px 14px', marginBottom: 18,
}
