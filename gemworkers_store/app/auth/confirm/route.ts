import { createServerClient, type CookieOptions } from '@supabase/ssr'
import type { EmailOtpType } from '@supabase/supabase-js'
import { cookies } from 'next/headers'
import { NextResponse, type NextRequest } from 'next/server'
import { safeNext } from '@/lib/safe-next'
import { createAdminClient } from '@/lib/supabase/admin'

// Email links that work on any device: the Supabase email templates point
// here — Reset password: ?token_hash=…&type=recovery&next=/auth/reset-password,
// Confirm signup: ?token_hash=…&type=email&next=/ — and the
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
      // A recovery link proves the mailbox is theirs: log out every other
      // device (old sessions, or one opened at guest checkout by whoever
      // typed this email). This device stays logged in.
      if (type === 'recovery') {
        const { error: outErr } = await supabase.auth.signOut({ scope: 'others' })
        if (outErr) console.error('[auth/confirm] sign out others failed:', outErr.message)
        // Guest-checkout account: the email is now proven theirs — a normal
        // account from here on (no more "choose my password" links).
        const { data: { user } } = await supabase.auth.getUser()
        if (user?.user_metadata?.guest === true) {
          const { error: metaErr } = await createAdminClient().auth.admin.updateUserById(user.id, {
            user_metadata: { ...user.user_metadata, guest: false },
          })
          if (metaErr) console.error('[auth/confirm] guest flag not cleared:', metaErr.message)
        }
      }
      return NextResponse.redirect(`${origin}${next}`)
    }
    console.error('[auth/confirm] verifyOtp failed:', error.message)
  }

  // Expired or already-used link → the reset page shows "Link expired" (even
  // when the browser is still signed in from the first click).
  const fallback = type === 'recovery' ? '/auth/reset-password?expired=1' : '/auth/login?error=confirmation_failed'
  return NextResponse.redirect(`${origin}${fallback}`)
}
