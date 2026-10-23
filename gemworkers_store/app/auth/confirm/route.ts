import { createServerClient, type CookieOptions } from '@supabase/ssr'
import type { EmailOtpType } from '@supabase/supabase-js'
import { cookies } from 'next/headers'
import { NextResponse, type NextRequest } from 'next/server'
import { safeNext } from '@/lib/safe-next'

// Email links that work on any device: the Supabase email template points
// here with ?token_hash=…&type=recovery&next=/auth/reset-password, and the
// token is verified on the server (no PKCE verifier needed from the browser
// that requested it — unlike /auth/callback?code=…).
export async function GET(request: NextRequest) {
  const { searchParams, origin } = new URL(request.url)
  const tokenHash = searchParams.get('token_hash')
  const type = searchParams.get('type') as EmailOtpType | null
  const next = safeNext(searchParams.get('next'))

  if (tokenHash && type) {
    const cookieStore = await cookies()
    const supabase = createServerClient(
      process.env.NEXT_PUBLIC_SUPABASE_URL!,
      process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY!,
      {
        cookies: {
          getAll() { return cookieStore.getAll() },
          setAll(cookiesToSet: { name: string; value: string; options: CookieOptions }[]) {
            cookiesToSet.forEach(({ name, value, options }) =>
              cookieStore.set(name, value, options)
            )
          },
        },
      }
    )

    const { error } = await supabase.auth.verifyOtp({ type, token_hash: tokenHash })
    if (!error) {
      return NextResponse.redirect(`${origin}${next}`)
    }
    console.error('[auth/confirm] verifyOtp failed:', error.message)
  }

  // Expired or already-used link → the reset page shows "Link expired" (even
  // when the browser is still signed in from the first click).
  const fallback = type === 'recovery' ? '/auth/reset-password?expired=1' : '/auth/login?error=confirmation_failed'
  return NextResponse.redirect(`${origin}${fallback}`)
}
