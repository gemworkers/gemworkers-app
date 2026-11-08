// A visitor's open page was made by an older deployment; after we publish a
// new one, its buttons/forms (server actions) no longer match the server
// ("Failed to find Server Action … older or newer deployment"). The fix is a
// fresh page. Reload at most once a minute so a real bug can't loop.

const PATTERN = /failed to find server action|older or newer deployment|server action .* (was )?not found/i
const KEY = 'gw_stale_reload_at'

export function isStaleVersionError(e: unknown): boolean {
  const msg = e instanceof Error ? e.message : typeof e === 'string' ? e : ''
  return PATTERN.test(msg)
}

/** Reloads the page once (per minute). Returns false if it already did. */
export function reloadForNewVersion(): boolean {
  try {
    const last = Number(sessionStorage.getItem(KEY) || 0)
    if (Date.now() - last < 60_000) return false
    sessionStorage.setItem(KEY, String(Date.now()))
  } catch { /* storage blocked: still reload once */ }
  window.location.reload()
  return true
}
