// SERVER ONLY — shared by the admin endpoints (app/api/admin/*), which the
// admin app (sell.gemworkers.com) calls with the owner's Supabase token.

import { NextRequest, NextResponse } from 'next/server'
import { stripe } from '@/lib/stripe/server'
import { createAdminClient } from '@/lib/supabase/admin'

const ADMIN_ORIGIN = 'https://sell.gemworkers.com'

export function cors(res: NextResponse, req: NextRequest) {
  const origin = req.headers.get('origin')
  if (origin === ADMIN_ORIGIN || origin?.startsWith('http://localhost:')) {
    res.headers.set('Access-Control-Allow-Origin', origin)
    res.headers.set('Vary', 'Origin')
  }
  res.headers.set('Access-Control-Allow-Methods', 'POST, OPTIONS')
  res.headers.set('Access-Control-Allow-Headers', 'Authorization, Content-Type')
  return res
}

export function reply(req: NextRequest, body: unknown, status = 200) {
  return cors(NextResponse.json(body, { status }), req)
}

export function preflight(req: NextRequest) {
  return cors(new NextResponse(null, { status: 204 }), req)
}

type AdminClient = ReturnType<typeof createAdminClient>

/** The service-role client when the request carries the owner's token; else a ready error reply. */
export async function requireOwner(req: NextRequest): Promise<{ admin: AdminClient } | { error: NextResponse }> {
  const admin = createAdminClient()
  const token = req.headers.get('authorization')?.replace(/^Bearer\s+/i, '')
  if (!token) return { error: reply(req, { error: 'Not signed in' }, 401) }
  const { data: { user } } = await admin.auth.getUser(token)
  if (!user) return { error: reply(req, { error: 'Not signed in' }, 401) }
  const { data: profile } = await admin.from('user_profiles').select('role').eq('id', user.id).maybeSingle()
  if ((profile as { role: string } | null)?.role !== 'owner') return { error: reply(req, { error: 'Owner only' }, 403) }
  return { admin }
}

export type OrderPaymentRef = {
  id: string
  checkout_group_id: string | null
  stripe_payment_intent: string | null
  stripe_checkout_session_id: string | null
}

/** The Stripe payment behind an order (saved by the webhook; older orders are looked up). */
export async function findPaymentIntent(order: OrderPaymentRef): Promise<string | null> {
  let pi = order.stripe_payment_intent
  try {
    if (!pi && order.stripe_checkout_session_id) {
      const s = await stripe.checkout.sessions.retrieve(order.stripe_checkout_session_id)
      pi = typeof s.payment_intent === 'string' ? s.payment_intent : s.payment_intent?.id ?? null
    }
    if (!pi) {
      const query = order.checkout_group_id
        ? `metadata['checkout_group_id']:'${order.checkout_group_id}'`
        : `metadata['order_id']:'${order.id}'`
      const found = await stripe.paymentIntents.search({ query, limit: 5 })
      pi = found.data.find(p => p.status === 'succeeded')?.id ?? null
    }
  } catch (err) {
    console.error('[admin-api] payment lookup failed:', err instanceof Error ? err.message : String(err))
  }
  return pi
}
