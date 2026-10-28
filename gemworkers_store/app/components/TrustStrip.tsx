import Link from 'next/link'

// Stone page: why it's safe to buy here. Facts only — each line links to the
// page that promises it (Guarantee, Returns, Shipping, Payment). Nothing here
// leads away from the shop (the Etsy record is on the About page only).
const ITEMS: { text: string; href: string }[] = [
  { text: 'Natural stone, every known treatment disclosed', href: '/guarantee' },
  { text: 'Lab-check promise: full refund if an independent lab disagrees', href: '/guarantee' },
  { text: '30-day returns', href: '/returns' },
  { text: 'Tracked shipping, signature for high-value orders', href: '/shipping' },
  { text: 'Secure checkout by Stripe', href: '/payment' },
]

export function TrustStrip() {
  return (
    <ul style={{
      listStyle: 'none', margin: '20px 0 0', padding: '16px 0 0',
      borderTop: '1px solid #ECE5D8', display: 'grid', gap: 8,
    }}>
      {ITEMS.map(i => (
        <li key={i.text} style={{ display: 'flex', gap: 8, alignItems: 'baseline', fontSize: 13, lineHeight: 1.45 }}>
          <span aria-hidden="true" style={{ color: '#2B7A3D', fontWeight: 700 }}>✓</span>
          <Link href={i.href} style={{ color: '#5A5045', textDecoration: 'none' }}>{i.text}</Link>
        </li>
      ))}
    </ul>
  )
}
