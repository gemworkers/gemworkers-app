import { createHmac } from 'crypto'
import { NextRequest, NextResponse } from 'next/server'
import { createAdminClient } from '@/lib/supabase/admin'
import { createClient } from '@/lib/supabase/server'

// Anonymous views & visits (sql/page_views.sql). Called by ViewCounter in the
// browser for every page opened. No cookies, nothing stored on the device;
// the visitor code is HMAC(daily date + IP + browser) and changes every day —
// the IP itself is never stored. Bots and logged-in staff are not counted.

const BOT = /bot|crawl|spider|slurp|preview|facebookexternalhit|whatsapp|telegram|discord|headless|lighthouse|pingdom|curl|wget|python|node-fetch/i
const STONE = /^\/stones\/([0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12})/i

function sourceOf(referrer: string, utm: string): string {
  const u = utm.trim().toLowerCase().replace(/[^a-z0-9_-]/g, '').slice(0, 30)
  if (u) return u
  let host = ''
  try { host = new URL(referrer).hostname.toLowerCase() } catch { return 'direct' }
  if (!host || host.endsWith('gemworkers.com')) return 'direct'
  const known: [RegExp, string][] = [
    [/(^|\.)google\./, 'google'], [/(^|\.)bing\.com$/, 'bing'], [/duckduckgo\.com$/, 'duckduckgo'],
    [/instagram\.com$/, 'instagram'], [/(facebook\.com|fb\.com|fb\.me)$/, 'facebook'],
    [/tiktok\.com$/, 'tiktok'], [/(pinterest\.|pin\.it$)/, 'pinterest'],
    [/(^|\.)(x\.com|twitter\.com|t\.co)$/, 'x'], [/(youtube\.com|youtu\.be)$/, 'youtube'],
    [/whatsapp\.com$/, 'whatsapp'], [/etsy\.com$/, 'etsy'],
  ]
  for (const [re, name] of known) if (re.test(host)) return name
  return host.replace(/^www\./, '').slice(0, 30)
}

export async function POST(req: NextRequest) {
  try {
    const ua = req.headers.get('user-agent') ?? ''
    if (!ua || BOT.test(ua)) return new NextResponse(null, { status: 204 })

    const body = await req.json().catch(() => null) as { p?: string; r?: string; u?: string } | null
    const path = typeof body?.p === 'string' ? body.p.split('?')[0].slice(0, 300) : ''
    if (!path.startsWith('/') || path.startsWith('/api')) return new NextResponse(null, { status: 204 })

    // Staff browsing their own shop don't count.
    const supabase = await createClient()
    const { data: { user } } = await supabase.auth.getUser()
    const admin = createAdminClient()
    if (user) {
      const { data: profile } = await admin.from('user_profiles').select('role').eq('id', user.id).maybeSingle()
      const role = (profile as { role: string } | null)?.role
      if (role === 'owner' || role === 'seller') return new NextResponse(null, { status: 204 })
    }

    const secret = process.env.CRON_SECRET
    if (!secret) return new NextResponse(null, { status: 204 })
    const day = new Intl.DateTimeFormat('en-CA', { timeZone: 'Europe/Amsterdam' }).format(new Date())
    const ip = (req.headers.get('x-forwarded-for') ?? '').split(',')[0].trim()
    const visitor = createHmac('sha256', secret).update(`${day}|${ip}|${ua}`).digest('hex').slice(0, 16)
    const country = (req.headers.get('x-vercel-ip-country') ?? '').toUpperCase()
    const stone = STONE.exec(path)?.[1] ?? null

    await admin.from('page_views').insert({
      path,
      inventory_item_id: stone,
      visitor,
      source: sourceOf(body?.r ?? '', body?.u ?? ''),
      country: /^[A-Z]{2}$/.test(country) ? country : null,
    })
  } catch (e) {
    console.error('[views] not counted:', e instanceof Error ? e.message : String(e))
  }
  return new NextResponse(null, { status: 204 })
}
