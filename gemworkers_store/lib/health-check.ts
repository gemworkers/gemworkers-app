// SERVER ONLY — the "everything else" half of the nightly check: failed
// scheduled jobs (pg_cron) and logged errors (app_errors: store errors,
// crashes, failed webhook calls) of the last 24 hours (sql/error_log.sql).
// Returns plain lines for the owner email; empty = nothing went wrong.
import type { createAdminClient } from '@/lib/supabase/admin'

type Admin = ReturnType<typeof createAdminClient>

const SOURCE: Record<string, string> = { store: 'Shop', crash: 'Shop crash', webhook: 'Webhook / email call' }

export async function runHealthCheck(admin: Admin): Promise<string[]> {
  const { data, error } = await admin.rpc('health_report', { p_hours: 24 })
  if (error) return [`The error log could not be read: ${error.message}`]
  const r = data as {
    cron_failures: { job: string | null; runs: number; message: string | null }[]
    errors: { source: string; message: string; count: number }[]
  }
  const lines: string[] = []
  for (const c of r.cron_failures ?? []) {
    lines.push(`Scheduled job "${c.job ?? 'unknown'}" failed ${c.runs}× — ${c.message ?? 'no message'}`)
  }
  for (const e of r.errors ?? []) {
    lines.push(`${SOURCE[e.source] ?? e.source}: ${e.count}× "${e.message}"`)
  }
  return lines
}
