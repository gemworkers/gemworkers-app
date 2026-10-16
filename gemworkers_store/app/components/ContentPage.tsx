import type { ReactNode } from 'react'

interface ContentPageProps {
  eyebrow?: string
  title: string
  lastUpdated?: string
  children: ReactNode
}

export function ContentPage({ eyebrow, title, lastUpdated, children }: ContentPageProps) {
  return (
    <main style={{
      maxWidth: 768,
      margin: '0 auto',
      padding: 'clamp(56px, 8vw, 88px) 16px 120px',
    }}>
      <header style={{ marginBottom: 44 }}>
        {eyebrow && (
          <p style={{
            fontSize: 10,
            fontWeight: 700,
            letterSpacing: '0.2em',
            textTransform: 'uppercase',
            color: '#7A5A22',
            fontFamily: 'var(--font-inter, system-ui)',
            margin: '0 0 14px',
          }}>
            {eyebrow}
          </p>
        )}

        <h1 style={{
          fontFamily: 'var(--font-cormorant, Georgia, serif)',
          fontSize: 'clamp(34px, 5vw, 52px)',
          fontWeight: 400,
          color: '#1F1B16',
          lineHeight: 1.1,
          letterSpacing: '0.02em',
          margin: 0,
        }}>
          {title}
        </h1>

        {lastUpdated && (
          <p style={{
            fontSize: 12,
            color: '#6B6052',
            fontFamily: 'var(--font-inter, system-ui)',
            letterSpacing: '0.04em',
            margin: '12px 0 0',
          }}>
            Last updated {lastUpdated}
          </p>
        )}

        <div className="gold-rule" style={{ marginTop: 28 }} />
      </header>

      <div className="prose prose-vault max-w-none">
        {children}
      </div>
    </main>
  )
}
