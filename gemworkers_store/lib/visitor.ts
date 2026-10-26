// SERVER ONLY — the anonymous daily visitor code (sql/page_views.sql) and
// where that visitor came from today (sql/sales_by_source.sql). No cookies:
// HMAC(daily Amsterdam date + IP + browser); the IP is never stored and the
// code changes every day.
import { createHmac } from 'crypto'
import { headers } from 'next/headers'
import { createAdminClient } from '@/lib/supabase/admin'

export function amsterdamDay(d = new Date()): string {
  return new Intl.DateTimeFormat('en-CA', { timeZone: 'Europe/Amsterdam' }).format(d)
}

export function visitorCodeFrom(ip: string, ua: string): string | null {
  const secret = process.env.CRON_SECRET
  if (!secret || !ua) return null
  return createHmac('sha256', secret).update(`${amsterdamDay()}|${ip}|${ua}`).digest('hex').slice(0, 16)
}

/** The visitor code of the current request (server actions / route handlers). */
export async function currentVisitorCode(): Promise<string | null> {
  const h = await headers()
  const ip = (h.get('x-forwarded-for') ?? '').split(',')[0].trim()
  return visitorCodeFrom(ip, h.get('user-agent') ?? '')
}

/** Where this visitor came from today: the first source that isn't 'direct',
 *  else 'direct'; null when they weren't counted today. */
export async function todaysSource(): Promise<string | null> {
  try {
    const code = await currentVisitorCode()
    if (!code) return null
    const { data } = await createAdminClient()
      .from('page_views').select('source').eq('visitor', code).eq('day', amsterdamDay())
      .order('at', { ascending: true }).limit(50)
    const rows = (data as { source: string }[] | null) ?? []
    if (rows.length === 0) return null
    return rows.find(r => r.source !== 'direct')?.source ?? 'direct'
  } catch {
    return null
  }
}

/** Saves the source on new orders / an offer (never overwrites one already set). */
export async function noteSource(table: 'orders' | 'storefront_offers', ids: string[]): Promise<void> {
  if (ids.length === 0) return
  const source = await todaysSource()
  if (!source) return
  const { error } = await createAdminClient().from(table).update({ source }).in('id', ids).is('source', null)
  if (error) console.error('[sales source] not saved:', error.message)
}
