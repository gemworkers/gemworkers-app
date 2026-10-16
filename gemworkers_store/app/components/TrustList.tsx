import Link from 'next/link'

const TRUST_LINKS = [
  { label: 'Natural gemstone, honestly described',              href: '/guarantee' },
  { label: 'Tracked shipping, dispatched in 1–5 business days', href: '/shipping' },
  { label: '30-day returns',                                    href: '/returns' },
]

// Small linked reassurance list (stone page, cart). Styles: .pd-trust in globals.css
export function TrustList({ style }: { style?: React.CSSProperties }) {
  return (
    <ul className="pd-trust" style={style}>
      {TRUST_LINKS.map(t => (
        <li key={t.href}><Link href={t.href}>{t.label}</Link></li>
      ))}
    </ul>
  )
}
