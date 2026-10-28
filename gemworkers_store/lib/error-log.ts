// SERVER ONLY — writes server errors to public.app_errors (sql/error_log.sql);
// the nightly check emails the owner a summary. Fire-and-forget: never
// throws, never logs its own failures through console.error (no loops),
// at most MAX_PER_HOUR writes per server instance.

const MAX_PER_HOUR = 60
// Messages that are expected and harmless — not errors for the owner.
const IGNORE = [
  /dup delivery/i, /already confirmed/i, /already refunded/i, /refunded in full/i,
  /not available yet/i, /\[views\] not counted/i, /NEXT_REDIRECT/, /NEXT_NOT_FOUND/,
]

let windowStart = 0
let written = 0

export function logError(source: string, message: string): Promise<void> {
  try {
    if (!message || IGNORE.some(r => r.test(message))) return Promise.resolve()
    const now = Date.now()
    if (now - windowStart > 3600_000) { windowStart = now; written = 0 }
    if (written >= MAX_PER_HOUR) return Promise.resolve()
    written++
    const url = process.env.NEXT_PUBLIC_SUPABASE_URL
    const key = process.env.SUPABASE_SERVICE_ROLE_KEY
    if (!url || !key) return Promise.resolve()
    return fetch(`${url}/rest/v1/app_errors`, {
      method: 'POST',
      headers: { apikey: key, Authorization: `Bearer ${key}`, 'Content-Type': 'application/json', Prefer: 'return=minimal' },
      body: JSON.stringify({ source: source.slice(0, 40), message: message.slice(0, 2000) }),
    }).then(() => {}, () => {})
  } catch {
    return Promise.resolve()   // never break the caller
  }
}

/** console.error arguments → one line. */
export function errorText(args: unknown[]): string {
  return args.map(a => (a instanceof Error ? a.message : typeof a === 'string' ? a : (() => {
    try { return JSON.stringify(a) } catch { return String(a) }
  })())).join(' ')
}
