import { NextRequest, NextResponse } from 'next/server'
import { createAdminClient } from '@/lib/supabase/admin'
import { runMoneyCheck } from '@/lib/money-check'
import { sendMoneyCheckEmail } from '@/lib/email/sendMoneyCheckEmail'
import { preflight, reply, requireOwner } from '@/lib/admin-api'

// Daily money check (lib/money-check.ts).
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
    const result = await runMoneyCheck(createAdminClient())
    if (result.problems.length > 0 && owner) await sendMoneyCheckEmail({ to: owner, problems: result.problems })
    if (result.problems.length > 0) console.error('[money-check]', result.problems.length, 'problem(s):', result.problems.join(' | '))
    return NextResponse.json(result)
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
    return reply(req, await runMoneyCheck(auth.admin))
  } catch (e) {
    return reply(req, { error: e instanceof Error ? e.message : String(e) }, 500)
  }
}
