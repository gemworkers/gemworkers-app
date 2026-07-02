import type { Metadata } from 'next'
import './globals.css'
import Link from 'next/link'
import Image from 'next/image'
import { createClient } from '@/lib/supabase/server'
import { StoreHeader } from '@/app/components/StoreHeader'

export const metadata: Metadata = {
  title: 'GemWorkers',
  description: 'Curated gemstones, minerals and jewelry, direct from specialist sellers.',
}

function Footer() {
  const shopLinks = [
    { label: 'Loose Gemstones', href: '/shop/loose_stone' },
    { label: 'Mineral Specimens', href: '/shop/specimen' },
    { label: 'Jewelry', href: '/shop/jewelry' },
  ]
  const companyLinks = [
    { label: 'About',      href: '/about' },
    { label: 'Our Makers', href: '/makers' },
    { label: 'Journal',    href: '/journal' },
    { label: 'Contact',    href: '/contact' },
  ]

  return (
    <footer style={{
      borderTop: '1px solid #e5e7eb', background: '#fff',
      padding: '52px 32px 44px', marginTop: 80,
    }}>
      <div style={{
        maxWidth: 1400, margin: '0 auto',
        display: 'flex', justifyContent: 'space-between',
        flexWrap: 'wrap', gap: 40, alignItems: 'flex-start',
      }}>
        {/* Brand */}
        <div>
          <Image
            src="/logo-black.png"
            alt="GemWorkers"
            height={90}
            width={124}
            style={{ display: 'block' }}
          />
        </div>

        {/* Links */}
        <div style={{ display: 'flex', gap: 56 }}>
          <div>
            <p style={{
              fontSize: 10, fontWeight: 700, letterSpacing: '0.12em',
              color: '#9ca3af', textTransform: 'uppercase', marginBottom: 16,
            }}>
              Shop
            </p>
            <div style={{ display: 'flex', flexDirection: 'column', gap: 11 }}>
              {shopLinks.map(l => (
                <Link key={l.href} href={l.href}
                  style={{ fontSize: 13, color: '#374151', textDecoration: 'none' }}>
                  {l.label}
                </Link>
              ))}
            </div>
          </div>
          <div>
            <p style={{
              fontSize: 10, fontWeight: 700, letterSpacing: '0.12em',
              color: '#9ca3af', textTransform: 'uppercase', marginBottom: 16,
            }}>
              Company
            </p>
            <div style={{ display: 'flex', flexDirection: 'column', gap: 11 }}>
              {companyLinks.map(l => (
                <Link key={l.href} href={l.href}
                  style={{ fontSize: 13, color: '#374151', textDecoration: 'none' }}>
                  {l.label}
                </Link>
              ))}
            </div>
          </div>
        </div>
      </div>

      <div style={{
        maxWidth: 1400, margin: '36px auto 0', paddingTop: 24,
        borderTop: '1px solid #f3f4f6',
        fontSize: 11, color: '#9ca3af',
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
    <html lang="en">
      <body>
        <StoreHeader user={navUser} />
        {children}
        <Footer />
      </body>
    </html>
  )
}
