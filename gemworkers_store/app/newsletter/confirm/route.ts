import { NextResponse, type NextRequest } from 'next/server'
import { createAdminClient } from '@/lib/supabase/admin'

// Link in the confirmation email → subscription confirmed (sql/newsletter.sql).
export async function GET(request: NextRequest) {
  const { searchParams, origin } = new URL(request.url)
  const token = searchParams.get('token') ?? ''
  if (/^[0-9a-f-]{36}$/i.test(token)) {
    const { data } = await createAdminClient().from('newsletter_subscribers')
      .update({ status: 'confirmed', confirmed_at: new Date().toISOString() })
      .eq('confirm_token', token).eq('status', 'pending').select('id')
    if (data && data.length > 0) return NextResponse.redirect(`${origin}/newsletter?confirmed=1`)
    // Already confirmed (second click) is fine too.
    const { data: again } = await createAdminClient().from('newsletter_subscribers')
      .select('status').eq('confirm_token', token).maybeSingle()
    if ((again as { status: string } | null)?.status === 'confirmed') return NextResponse.redirect(`${origin}/newsletter?confirmed=1`)
  }
  return NextResponse.redirect(`${origin}/newsletter?invalid=1`)
}
