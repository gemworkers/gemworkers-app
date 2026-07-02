import type { Metadata } from 'next'
import './globals.css'
import Link from 'next/link'
import Image from 'next/image'
import { Cormorant_Garamond, Inter } from 'next/font/google'
import { createClient } from '@/lib/supabase/server'
import { StoreHeader } from '@/app/components/StoreHeader'
import { AmbientBackground } from '@/app/components/AmbientBackground'

const cormorant = Cormorant_Garamond({
  subsets: ['latin'],
  weight: ['300', '400', '500', '600', '700'],
  variable: '--font-cormorant',
  display: 'swap',
})

const inter = Inter({
  subsets: ['latin'],
  variable: '--font-inter',
  display: 'swap',
})

export const metadata: Metadata = {
  title: 'GemWorkers',
  description: 'Curated gemstones, minerals and jewelry, direct from specialist sellers.',
}

const SHOP_LINKS = [
  { label: 'Loose Gemstones', href: '/shop/loose_stone' },
  { label: 'Mineral Specimens', href: '/shop/specimen' },
  { label: 'Jewelry', href: '/shop/jewelry' },
]
const COMPANY_LINKS = [
  { label: 'About',      href: '/about' },
  { label: 'Our Makers', href: '/makers' },
  { label: 'Journal',    href: '/journal' },
  { label: 'Contact',    href: '/contact' },
]

function Footer() {
  return (
    <footer style={{ background: '#0e0e10', marginTop: 80 }}>
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
        <div style={{ display: 'flex', gap: 60 }}>
          {[{ title: 'Shop', links: SHOP_LINKS }, { title: 'Company', links: COMPANY_LINKS }].map(col => (
            <div key={col.title}>
              <p style={{
                fontSize: 9, fontWeight: 700, letterSpacing: '0.2em', textTransform: 'uppercase',
                color: '#c9a962', marginBottom: 18,
              }}>
                {col.title}
              </p>
              <div style={{ display: 'flex', flexDirection: 'column', gap: 13 }}>
                {col.links.map(l => (
                  <Link key={l.href} href={l.href} className="nav-link"
                    style={{ fontSize: 13, color: '#9d9080', letterSpacing: '0.02em' }}>
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
        fontSize: 11, color: '#4a4440', letterSpacing: '0.05em',
      }}>
        © {new Date().getFullYear()} GemWorkers. All rights reserved.
      </div>
    </footer>
  )
}

export default async function RootLayout({ children }: { children: React.ReactNode }) {
  const supabase = await createClient()
  const { data: { user: authUser } } = await supabase.auth.getUser()

  let navUser: { displayName: string | null } | null = null
  if (authUser) {
    const { data: buyer } = await supabase
      .from('buyers')
      .select('display_name')
      .eq('id', authUser.id)
      .maybeSingle()
    navUser = { displayName: buyer?.display_name ?? authUser.email ?? null }
  }

  return (
    <html lang="en" className={`${cormorant.variable} ${inter.variable}`}>
      <body>
        <AmbientBackground />
        <div style={{ position: 'relative', zIndex: 1 }}>
          <StoreHeader user={navUser} />
          {children}
          <Footer />
        </div>
      </body>
    </html>
  )
}
