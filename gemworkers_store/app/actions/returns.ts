'use server'

import { revalidatePath } from 'next/cache'
import { createClient } from '@/lib/supabase/server'

// Buyer side of returns (sql/returns_setup.sql). All checks (own order,
// 30-day window, one return per order) happen in the SQL functions; their
// messages are written for buyers.

type Result = { ok: true } | { error: string }

async function call(fn: string, args: Record<string, unknown>): Promise<Result> {
  const supabase = await createClient()
  const { data: { user } } = await supabase.auth.getUser()
  if (!user) return { error: 'Please log in first.' }
  const { error } = await supabase.rpc(fn, args)
  if (error) {
    console.error(`[returns] ${fn} failed:`, error.message)
    return { error: error.message || 'Something went wrong — please try again.' }
  }
  revalidatePath('/orders')
  return { ok: true }
}

export async function requestReturn(orderId: string, reason: string, faulty: boolean): Promise<Result> {
  return call('request_return', { p_order_id: orderId, p_reason: reason.slice(0, 1000), p_faulty: faulty })
}

export async function withdrawReturn(returnId: string): Promise<Result> {
  return call('withdraw_return', { p_return_id: returnId })
}

export async function addReturnTracking(returnId: string, tracking: string): Promise<Result> {
  return call('add_return_tracking', { p_return_id: returnId, p_tracking: tracking.slice(0, 100) })
}
