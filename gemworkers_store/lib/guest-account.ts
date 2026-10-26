// SERVER ONLY — guest checkout accounts (app/actions/commerce.ts guestBuyNow).
import { createAdminClient } from '@/lib/supabase/admin'

type AdminClient = ReturnType<typeof createAdminClient>

/** For a buyer whose account was made at guest checkout (no password yet):
 *  a one-time "choose my password" link for the order email, else null.
 *  Opening it proves the email is theirs; /auth/confirm then logs out every
 *  other device (e.g. a session opened by someone who typed their email). */
export async function guestAccountLink(admin: AdminClient, buyerId: string | null | undefined): Promise<string | null> {
  if (!buyerId) return null
  try {
    const { data } = await admin.auth.admin.getUserById(buyerId)
    const user = data?.user
    if (!user?.email || user.user_metadata?.guest !== true) return null
    const { data: link, error } = await admin.auth.admin.generateLink({ type: 'recovery', email: user.email })
    const hash = link?.properties?.hashed_token
    if (error || !hash) return null
    const base = process.env.NEXT_PUBLIC_SITE_URL ?? 'https://www.gemworkers.com'
    return `${base}/auth/confirm?token_hash=${encodeURIComponent(hash)}&type=recovery&next=${encodeURIComponent('/auth/reset-password?welcome=1')}`
  } catch (e) {
    console.error('[guest-account] link failed:', e instanceof Error ? e.message : String(e))
    return null
  }
}
