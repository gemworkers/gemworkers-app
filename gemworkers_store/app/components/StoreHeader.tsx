import { createClient } from '@/lib/supabase/server'
import Link from 'next/link'
import { signOut } from '@/app/actions/auth'

export async function StoreHeader() {
  const supabase = await createClient()
  const { data: { user } } = await supabase.auth.getUser()

  let displayName: string | null = null
  if (user) {
    const { data: buyer } = await supabase
      .from('buyers')
      .select('display_name')
      .eq('id', user.id)
      .maybeSingle()
    displayName = buyer?.display_name ?? user.email ?? null
  }

  return (
    <header style={{
      display: 'flex', alignItems: 'center', justifyContent: 'space-between',
      padding: '0 32px', height: 60,
      borderBottom: '1px solid #e5e7eb',
      background: '#fff', position: 'sticky', top: 0, zIndex: 10,
    }}>
      <Link href="/" style={{ textDecoration: 'none', display: 'flex', alignItems: 'center', gap: 10 }}>
        <span style={{
          fontSize: 18, fontWeight: 700, letterSpacing: '0.13em',
          fontFamily: "Georgia, 'Times New Roman', serif", color: '#111',
        }}>
          GEMWORKERS
        </span>
        <span style={{
          fontSize: 9, fontWeight: 700, letterSpacing: '0.15em', color: '#9ca3af',
          border: '1px solid #e5e7eb', borderRadius: 3, padding: '2px 7px',
        }}>
          MARKETPLACE
        </span>
      </Link>

      <nav style={{ display: 'flex', alignItems: 'center', gap: 24 }}>
        <Link href="/" style={{
          fontSize: 13, color: '#374151', textDecoration: 'none', letterSpacing: '0.02em',
        }}>
          Browse
        </Link>

        {/* Search icon — placeholder */}
        <svg width="17" height="17" viewBox="0 0 24 24" fill="none"
          stroke="#9ca3af" strokeWidth="1.75" strokeLinecap="round" strokeLinejoin="round">
          <circle cx="11" cy="11" r="7" />
          <line x1="21" y1="21" x2="16.65" y2="16.65" />
        </svg>

        {/* ── Auth state ───────────────────────────────────────────────────── */}
        {user ? (
          <div style={{ display: 'flex', alignItems: 'center', gap: 16, marginLeft: 4 }}>
            <span style={{
              fontSize: 12, color: '#374151', fontWeight: 500, letterSpacing: '0.01em',
              maxWidth: 160, overflow: 'hidden', textOverflow: 'ellipsis', whiteSpace: 'nowrap',
            }}>
              {displayName}
            </span>
            <form action={signOut} style={{ display: 'inline' }}>
              <button type="submit" style={{
                fontSize: 12, color: '#6b7280', background: 'none', border: 'none',
                cursor: 'pointer', padding: 0, letterSpacing: '0.02em',
              }}>
                Log out
              </button>
            </form>
          </div>
        ) : (
          <div style={{ display: 'flex', alignItems: 'center', gap: 16, marginLeft: 4 }}>
            <Link href="/auth/login" style={{
              fontSize: 13, color: '#374151', textDecoration: 'none', letterSpacing: '0.02em',
            }}>
              Log in
            </Link>
            <Link href="/auth/signup" style={{
              fontSize: 12, fontWeight: 600, color: '#fff',
              background: '#111', padding: '6px 14px', borderRadius: 5,
              textDecoration: 'none', letterSpacing: '0.02em',
            }}>
              Sign up
            </Link>
          </div>
        )}
      </nav>
    </header>
  )
}
