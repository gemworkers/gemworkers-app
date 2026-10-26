import type { Metadata, Viewport } from 'next'
import './globals.css'
import Link from 'next/link'
import Image from 'next/image'
import { Cormorant_Garamond, DM_Sans } from 'next/font/google'
import { createClient } from '@/lib/supabase/server'
import { StoreHeader } from '@/app/components/StoreHeader'
import { ShipToSelect } from '@/app/components/ShipToSelect'
import { loadShipCountries, currentShipToCode } from '@/lib/ship-to'

const cormorant = Cormorant_Garamond({
  subsets: ['latin'],
  weight: ['300', '400', '500', '600', '700'],
  variable: '--font-cormorant',
  display: 'swap',
})

const dmSans = DM_Sans({
  subsets: ['latin'],
  weight: ['400', '500', '600'],
  variable: '--font-inter',
  display: 'swap',
})

export const metadata: Metadata = {
  metadataBase: new URL('https://www.gemworkers.com'),
  title: 'GemWorkers — natural gemstones, mineral specimens & jewellery',
  description: 'Natural gemstones, mineral specimens and jewellery, honestly described. Tracked worldwide shipping and 30-day returns.',
  openGraph: { siteName: 'GemWorkers', type: 'website', locale: 'en_GB' },
  twitter: { card: 'summary_large_image' },
  // Google Search Console ownership (public token, URL-prefix property https://www.gemworkers.com)
  verification: { google: '3Ae1n6rrisU5F5FXaPMEJCkHQUHpszaM5Lez8hcAIt0' },
  // Installed on a phone (app/manifest.ts): name under the icon on iPhone.
  appleWebApp: { capable: true, title: 'GemWorkers', statusBarStyle: 'default' },
}

export const viewport: Viewport = { themeColor: '#1F1B16' }

const TRUST_POINTS = [
  '100% natural gemstones',
  'Tracked shipping worldwide',
  '30-day returns',
  'Certificates on request',
]

const SHOP_LINKS = [
  { label: 'Loose Gemstones', href: '/shop/loose_stone' },
  { label: 'Mineral Specimens', href: '/shop/specimen' },
  { label: 'Jewelry', href: '/shop/jewelry' },
]
const COMPANY_LINKS = [
  { label: 'About',      href: '/about' },
  { label: 'Our Makers', href: '/makers' },
  { label: 'Reviews',    href: '/reviews' },
  { label: 'Journal',    href: '/journal' },
  { label: 'Contact',    href: '/contact' },
]
const CUSTOMER_CARE_LINKS = [
  { label: 'Shipping',           href: '/shipping' },
  { label: 'Payment',            href: '/payment' },
  { label: 'Returns & Refunds',  href: '/returns' },
  { label: 'Our Guarantee',      href: '/guarantee' },
  { label: 'FAQ',                href: '/faq' },
  { label: 'Terms & Conditions', href: '/terms' },
  { label: 'Privacy Policy',     href: '/privacy' },
]

function Footer() {
  return (
    <footer style={{ background: '#FFFFFF', marginTop: 80, borderTop: '1px solid #ECE5D8' }}>
      <div className="gold-rule" />

      <div style={{
        maxWidth: 1400, margin: '0 auto',
        padding: '52px 32px 40px',
        display: 'flex', justifyContent: 'space-between',
        flexWrap: 'wrap', gap: 48, alignItems: 'flex-start',
      }}>
        {/* Brand */}
        <div>
          <Link href="/" style={{ textDecoration: 'none', lineHeight: 0, display: 'inline-block' }}>
            <Image src="/logo-white.png" alt="GemWorkers" height={90} width={124} style={{ display: 'block' }} />
          </Link>
        </div>

        {/* Links */}
        <div style={{ display: 'flex', gap: 60, flexWrap: 'wrap' }}>
          {[
            { title: 'Shop',          links: SHOP_LINKS },
            { title: 'Company',       links: COMPANY_LINKS },
            { title: 'Customer Care', links: CUSTOMER_CARE_LINKS },
          ].map(col => (
            <div key={col.title}>
              <p style={{
                fontSize: 9, fontWeight: 700, letterSpacing: '0.2em', textTransform: 'uppercase',
                color: '#7A5A22', marginBottom: 18,
              }}>
                {col.title}
              </p>
              <div style={{ display: 'flex', flexDirection: 'column', gap: 13 }}>
                {col.links.map(l => (
                  <Link key={l.href} href={l.href} className="nav-link"
                    style={{ fontSize: 13, color: '#5A5045', letterSpacing: '0.02em' }}>
                    {l.label}
                  </Link>
                ))}
              </div>
            </div>
          ))}
        </div>
      </div>

      <div style={{ margin: '0 32px' }}>
        <div className="gold-rule" style={{ opacity: 0.25 }} />
      </div>
      <div style={{
        maxWidth: 1400, margin: '0 auto', padding: '18px 32px',
        fontSize: 11, color: '#6B6052', letterSpacing: '0.05em',
      }}>
        © {new Date().getFullYear()} GemWorkers. All rights reserved.
      </div>
    </footer>
  )
}

export default async function RootLayout({ children }: { children: React.ReactNode }) {
  const supabase = await createClient()
  const [shipCountries, shipTo] = await Promise.all([
    loadShipCountries(supabase),
    currentShipToCode(),
  ])
  const { data: { user: authUser } } = await supabase.auth.getUser()

  let navUser: { displayName: string | null; unreadMessages: number } | null = null
  if (authUser) {
    const [{ data: buyer }, { data: unread }] = await Promise.all([
      supabase
        .from('buyers')
        .select('display_name')
        .eq('id', authUser.id)
        .maybeSingle(),
      supabase.rpc('buyer_unread_count'),
    ])
    navUser = {
      displayName: buyer?.display_name ?? authUser.email ?? null,
      unreadMessages: Number((unread as { messages?: number } | null)?.messages) || 0,
    }
  }

  return (
    <html lang="en" className={`${cormorant.variable} ${dmSans.variable}`}>
      <body>
        <div style={{ position: 'relative', zIndex: 1 }}>
          <div className="trust-strip">
            {TRUST_POINTS.map(t => <span key={t}>{t}</span>)}
            <ShipToSelect countries={shipCountries} current={shipTo} />
          </div>
          <StoreHeader user={navUser} />
          {children}
          <Footer />
        </div>
      </body>
    </html>
  )
}
