import { NextRequest, NextResponse } from 'next/server'
import { createAdminClient } from '@/lib/supabase/admin'
import { runMoneyCheck } from '@/lib/money-check'
import { runHealthCheck } from '@/lib/health-check'
import { sendMoneyCheckEmail } from '@/lib/email/sendMoneyCheckEmail'
import { preflight, reply, requireOwner } from '@/lib/admin-api'

// Daily check: money (lib/money-check.ts) + errors and failed jobs (lib/health-check.ts).
// GET  — Vercel cron (vercel.json), Authorization: Bearer CRON_SECRET. Emails
//        the owner only when something doesn't match or the check failed.
// POST — the owner from the admin ("Run money check now"): returns the result,
//        no email.

export async function GET(req: NextRequest) {
  const secret = process.env.CRON_SECRET
  if (!secret || req.headers.get('authorization') !== `Bearer ${secret}`) {
    return NextResponse.json({ error: 'Unauthorized' }, { status: 401 })
  }
  const owner = process.env.OWNER_EMAIL?.trim()
  try {
    const admin = createAdminClient()
    const result = await runMoneyCheck(admin)
    const health = await runHealthCheck(admin)
    if ((result.problems.length > 0 || health.length > 0) && owner) {
      await sendMoneyCheckEmail({ to: owner, problems: result.problems, health })
    }
    // console.log, not .error: these lines must not land in the error log again.
    if (result.problems.length > 0) console.log('[money-check]', result.problems.length, 'problem(s):', result.problems.join(' | '))
    return NextResponse.json({ ...result, health })
  } catch (e) {
    const msg = e instanceof Error ? e.message : String(e)
    console.error('[money-check] failed:', msg)
    if (owner) await sendMoneyCheckEmail({ to: owner, problems: [], failed: msg }).catch(() => {})
    return NextResponse.json({ error: msg }, { status: 500 })
  }
}

export async function OPTIONS(req: NextRequest) {
  return preflight(req)
}

export async function POST(req: NextRequest) {
  const auth = await requireOwner(req)
  if ('error' in auth) return auth.error
  try {
    const result = await runMoneyCheck(auth.admin)
    return reply(req, { ...result, health: await runHealthCheck(auth.admin) })
  } catch (e) {
    return reply(req, { error: e instanceof Error ? e.message : String(e) }, 500)
  }
}
