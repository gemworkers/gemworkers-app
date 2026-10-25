import { NextRequest, NextResponse } from 'next/server'
import { createAdminClient } from '@/lib/supabase/admin'
import { recordFeeForPayment } from '@/lib/stripe/fees'

// Daily (vercel.json): fills in Stripe's fee + euros received for paid orders
// of the last 60 days that don't have them yet (lib/stripe/fees.ts). Vercel
// calls it with Authorization: Bearer CRON_SECRET.
export async function GET(req: NextRequest) {
  const secret = process.env.CRON_SECRET
  if (!secret || req.headers.get('authorization') !== `Bearer ${secret}`) {
    return NextResponse.json({ error: 'Unauthorized' }, { status: 401 })
  }
  const admin = createAdminClient()
  const since = new Date(Date.now() - 60 * 24 * 3600 * 1000).toISOString()
  const { data, error } = await admin
    .from('orders')
    .select('id, stripe_payment_intent')
    .is('stripe_fee', null)
    .not('stripe_payment_intent', 'is', null)
    .not('paid_at', 'is', null)
    .gte('paid_at', since)
  if (error) return NextResponse.json({ error: error.message }, { status: 500 })

  // One payment can cover several orders (cart): split over all of them.
  const byPayment = new Map<string, string[]>()
  for (const o of (data as { id: string; stripe_payment_intent: string }[] | null) ?? []) {
    byPayment.set(o.stripe_payment_intent, [...(byPayment.get(o.stripe_payment_intent) ?? []), o.id])
  }
  let filled = 0
  let waiting = 0
  for (const pi of byPayment.keys()) {
    const { data: all } = await admin.from('orders').select('id').eq('stripe_payment_intent', pi)
    const ids = ((all as { id: string }[] | null) ?? []).map(o => o.id)
    try {
      if (await recordFeeForPayment(admin, pi, ids)) filled += ids.length; else waiting++
    } catch (e) {
      waiting++
      console.error('[cron stripe-fees] failed for', pi, ':', e instanceof Error ? e.message : String(e))
    }
  }
  return NextResponse.json({ payments: byPayment.size, orders_filled: filled, still_waiting: waiting })
}
