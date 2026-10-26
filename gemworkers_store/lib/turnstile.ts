// SERVER ONLY — checks a Cloudflare Turnstile token ourselves (for flows that
// don't go through a Supabase auth call, e.g. guest checkout). Needs
// TURNSTILE_SECRET_KEY in Vercel; without it the check fails closed.
export async function verifyTurnstile(token: string | null | undefined): Promise<boolean> {
  const secret = process.env.TURNSTILE_SECRET_KEY
  if (!secret) {
    console.error('[turnstile] TURNSTILE_SECRET_KEY not set — check refused')
    return false
  }
  if (!token) return false
  try {
    const res = await fetch('https://challenges.cloudflare.com/turnstile/v0/siteverify', {
      method: 'POST',
      body: new URLSearchParams({ secret, response: token }),
    })
    const data = (await res.json()) as { success?: boolean; 'error-codes'?: string[]; hostname?: string }
    // Cloudflare's reason codes only (never the secret), e.g. invalid-input-secret.
    if (data.success !== true) console.error('[turnstile] refused:', (data['error-codes'] ?? []).join(',') || 'no reason', 'host:', data.hostname ?? '-')
    return data.success === true
  } catch (e) {
    console.error('[turnstile] verify failed:', e instanceof Error ? e.message : String(e))
    return false
  }
}
