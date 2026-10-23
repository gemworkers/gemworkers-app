import { NextRequest, NextResponse } from 'next/server'
import { stripe } from '@/lib/stripe/server'
import { createAdminClient } from '@/lib/supabase/admin'

// Refund a returned stone (sql/returns_setup.sql). Called by the admin app
// (sell.gemworkers.com) with the owner's Supabase access token:
//   POST { return_id, deduction, deduction_reason }
// 1. owner check  2. amount from return_refund_amount (paid − deduction)
// 3. Stripe refund on the order's payment (once per return — a retry reuses
//    the existing refund)  4. complete_return_refund records it, sets the
// order 'refunded' and puts the stone back in stock (unlisted).

const ADMIN_ORIGIN = 'https://sell.gemworkers.com'

function cors(res: NextResponse, req: NextRequest) {
  const origin = req.headers.get('origin')
  if (origin === ADMIN_ORIGIN || origin?.startsWith('http://localhost:')) {
    res.headers.set('Access-Control-Allow-Origin', origin)
    res.headers.set('Vary', 'Origin')
  }
  res.headers.set('Access-Control-Allow-Methods', 'POST, OPTIONS')
  res.headers.set('Access-Control-Allow-Headers', 'Authorization, Content-Type')
  return res
}

function reply(req: NextRequest, body: unknown, status = 200) {
  return cors(NextResponse.json(body, { status }), req)
}

export async function OPTIONS(req: NextRequest) {
  return cors(new NextResponse(null, { status: 204 }), req)
}

export async function POST(req: NextRequest) {
  const admin = createAdminClient()

  // ── 1. Owner only ───────────────────────────────────────────────────────────
  const token = req.headers.get('authorization')?.replace(/^Bearer\s+/i, '')
  if (!token) return reply(req, { error: 'Not signed in' }, 401)
  const { data: { user } } = await admin.auth.getUser(token)
  if (!user) return reply(req, { error: 'Not signed in' }, 401)
  const { data: profile } = await admin.from('user_profiles').select('role').eq('id', user.id).maybeSingle()
  if ((profile as { role: string } | null)?.role !== 'owner') return reply(req, { error: 'Owner only' }, 403)

  const body = await req.json().catch(() => null) as
    { return_id?: string; deduction?: number | string; deduction_reason?: string } | null
  const returnId = body?.return_id
  const deduction = Number(body?.deduction ?? 0)
  if (!returnId || !Number.isFinite(deduction)) return reply(req, { error: 'Bad request' }, 400)

  // ── 2. Amount (validates status 'received' and the deduction) ──────────────
  const { data: amountData, error: amountErr } = await admin.rpc('return_refund_amount', {
    p_return_id: returnId, p_deduction: deduction,
  })
  if (amountErr) return reply(req, { error: amountErr.message }, 400)
  const cents = Math.round(Number(amountData) * 100)
  if (!Number.isInteger(cents) || cents <= 0) return reply(req, { error: 'Invalid refund amount' }, 400)

  const { data: retData } = await admin
    .from('returns')
    .select('order_id, orders ( id, order_number, checkout_group_id, stripe_payment_intent, stripe_checkout_session_id )')
    .eq('id', returnId)
    .single()
  const order = (retData as unknown as {
    orders: { id: string; order_number: string; checkout_group_id: string | null
              stripe_payment_intent: string | null; stripe_checkout_session_id: string | null }
  } | null)?.orders
  if (!order) return reply(req, { error: 'Order not found' }, 404)

  // ── 3. Find the payment ────────────────────────────────────────────────────
  let pi = order.stripe_payment_intent
  try {
    if (!pi && order.stripe_checkout_session_id) {
      const s = await stripe.checkout.sessions.retrieve(order.stripe_checkout_session_id)
      pi = typeof s.payment_intent === 'string' ? s.payment_intent : s.payment_intent?.id ?? null
    }
    if (!pi) {
      // Older orders: the payment carries the order (or cart group) id.
      const query = order.checkout_group_id
        ? `metadata['checkout_group_id']:'${order.checkout_group_id}'`
        : `metadata['order_id']:'${order.id}'`
      const found = await stripe.paymentIntents.search({ query, limit: 5 })
      pi = found.data.find(p => p.status === 'succeeded')?.id ?? null
    }
  } catch (err) {
    console.error('[refund] payment lookup failed:', err instanceof Error ? err.message : String(err))
  }
  if (!pi) return reply(req, { error: 'Could not find the Stripe payment for this order — refund it in the Stripe dashboard.' }, 409)

  // ── 4. Stripe refund (reuse one already made for this return) ──────────────
  let refundId: string
  try {
    const existing = await stripe.refunds.list({ payment_intent: pi, limit: 100 })
    const prior = existing.data.find(r => r.metadata?.return_id === returnId && r.status !== 'failed' && r.status !== 'canceled')
    if (prior) {
      refundId = prior.id
    } else {
      const refund = await stripe.refunds.create(
        {
          payment_intent: pi,
          amount: cents,
          metadata: { order_id: order.id, order_number: order.order_number, return_id: returnId, reason: 'return' },
        },
        { idempotencyKey: `return-${returnId}-${cents}` },
      )
      refundId = refund.id
    }
  } catch (err) {
    const message = err instanceof Error ? err.message : 'Stripe refund failed'
    console.error('[refund] Stripe refund failed for return', returnId, ':', message)
    return reply(req, { error: `Stripe refund failed: ${message}` }, 502)
  }

  // ── 5. Record it ───────────────────────────────────────────────────────────
  const { error: doneErr } = await admin.rpc('complete_return_refund', {
    p_return_id: returnId,
    p_deduction: deduction,
    p_deduction_reason: body?.deduction_reason ?? null,
    p_stripe_refund_id: refundId,
  })
  if (doneErr) {
    console.error('[refund] recording failed for return', returnId, ':', doneErr.message)
    return reply(req, { error: `The money was refunded in Stripe (${refundId}) but saving failed — press Refund again to finish.` }, 500)
  }

  return reply(req, { ok: true, refund_id: refundId, amount: cents / 100 })
}
