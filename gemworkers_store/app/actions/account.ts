'use server'

import { revalidatePath } from 'next/cache'
import { redirect } from 'next/navigation'
import { createClient } from '@/lib/supabase/server'
import { createAdminClient } from '@/lib/supabase/admin'

// Buyer "My account" (app/account). Each action works on the logged-in
// buyer only. Deleting: sql/account_deletion.sql prepares (keeps tax records,
// anonymises the rest), then the login is deleted here with the service role.

type Result = { ok: true; message: string } | { error: string }

const SITE = process.env.NEXT_PUBLIC_SITE_URL ?? 'https://www.gemworkers.com'

async function currentUser() {
  const supabase = await createClient()
  const { data: { user } } = await supabase.auth.getUser()
  return { supabase, user }
}

export async function updateDisplayName(name: string): Promise<Result> {
  const { supabase, user } = await currentUser()
  if (!user) return { error: 'Please log in again.' }
  const clean = name.trim().replace(/\s+/g, ' ')
  if (!clean || clean.length > 80) return { error: 'Please enter a name (up to 80 characters).' }
  const { error } = await supabase.from('buyers').update({ display_name: clean }).eq('id', user.id)
  if (error) return { error: 'Could not save — please try again.' }
  revalidatePath('/', 'layout')
  return { ok: true, message: 'Name saved.' }
}

export async function changeEmail(newEmail: string): Promise<Result> {
  const { supabase, user } = await currentUser()
  if (!user) return { error: 'Please log in again.' }
  const email = newEmail.trim().toLowerCase()
  if (!/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email)) return { error: 'Please enter a valid email address.' }
  if (email === user.email?.toLowerCase()) return { error: 'That is already your email address.' }
  const { error } = await supabase.auth.updateUser({ email }, { emailRedirectTo: `${SITE}/account?email=changed` })
  if (error) return { error: error.message }
  return { ok: true, message: `We sent a confirmation link to ${email}. Your email changes once you click it.` }
}

export async function changePassword(password: string, confirm: string): Promise<Result> {
  const { supabase, user } = await currentUser()
  if (!user) return { error: 'Please log in again.' }
  if (password.length < 8) return { error: 'Use at least 8 characters.' }
  if (password !== confirm) return { error: 'The two passwords are not the same.' }
  const { error } = await supabase.auth.updateUser({ password })
  if (error) return { error: error.message }
  return { ok: true, message: 'Password changed.' }
}

export async function deleteAccount(confirmText: string): Promise<{ error: string } | void> {
  const { supabase, user } = await currentUser()
  if (!user) return { error: 'Please log in again.' }
  if (confirmText.trim().toUpperCase() !== 'DELETE') return { error: 'Type DELETE to confirm.' }

  const { data: reason, error } = await supabase.rpc('prepare_account_deletion')
  if (error) {
    console.error('[deleteAccount] prepare failed:', error.message)
    return { error: 'Something went wrong — please try again or contact us.' }
  }
  if (reason) return { error: reason as string }

  const { error: delErr } = await createAdminClient().auth.admin.deleteUser(user.id)
  if (delErr) {
    console.error('[deleteAccount] delete failed:', delErr.message)
    return { error: 'Your data was cleaned up, but the login could not be deleted. Please contact us.' }
  }
  await supabase.auth.signOut()
  redirect('/?account=deleted')
}
