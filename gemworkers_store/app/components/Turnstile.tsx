'use client'

import { useEffect, useRef, useState } from 'react'

// Cloudflare Turnstile (managed mode). Renders the widget and hands the token
// back via onToken (null when it expires, errors or is reset).
//
// Supabase CAPTCHA may or may not be switched on: when it's off Supabase just
// ignores options.captchaToken, so callers can always pass it.

const SITE_KEY = process.env.NEXT_PUBLIC_TURNSTILE_SITE_KEY ?? ''

// No site key (e.g. local dev without .env.local) → no widget, don't block forms.
export const TURNSTILE_ENABLED = SITE_KEY !== ''

export const CAPTCHA_FAILED_MESSAGE = 'Please complete the check and try again.'

// Supabase reports a missing/invalid token as "captcha protection: request disallowed (…)".
export function isCaptchaError(message: string) {
  return /captcha/i.test(message)
}

type TurnstileApi = {
  render: (el: HTMLElement, opts: Record<string, unknown>) => string
  reset: (id: string) => void
  remove: (id: string) => void
}

declare global {
  interface Window { turnstile?: TurnstileApi }
}

const SCRIPT_SRC = 'https://challenges.cloudflare.com/turnstile/v0/api.js?render=explicit'
let scriptPromise: Promise<TurnstileApi> | null = null

// Load the script once per page, however many widgets mount.
function loadTurnstile(): Promise<TurnstileApi> {
  if (window.turnstile) return Promise.resolve(window.turnstile)
  if (scriptPromise) return scriptPromise
  scriptPromise = new Promise((resolve, reject) => {
    const script = document.createElement('script')
    script.src = SCRIPT_SRC
    script.async = true
    script.onload = () => window.turnstile ? resolve(window.turnstile) : reject(new Error('Turnstile missing'))
    script.onerror = () => { scriptPromise = null; reject(new Error('Turnstile failed to load')) }
    document.head.appendChild(script)
  })
  return scriptPromise
}

export function Turnstile({
  onToken,
  resetKey = 0,
}: {
  onToken: (token: string | null) => void
  // Bump after a failed submit — tokens are single-use, so the widget re-runs.
  resetKey?: number
}) {
  const containerRef = useRef<HTMLDivElement>(null)
  const widgetIdRef = useRef<string | null>(null)
  const onTokenRef = useRef(onToken)
  onTokenRef.current = onToken
  const [failed, setFailed] = useState(false)

  useEffect(() => {
    if (!TURNSTILE_ENABLED) return
    let cancelled = false

    loadTurnstile()
      .then(api => {
        if (cancelled || !containerRef.current) return
        widgetIdRef.current = api.render(containerRef.current, {
          sitekey: SITE_KEY,
          theme: 'light',
          appearance: 'always',
          callback: (token: string) => { setFailed(false); onTokenRef.current(token) },
          'expired-callback': () => onTokenRef.current(null),
          'error-callback': () => { setFailed(true); onTokenRef.current(null) },
        })
      })
      .catch(() => { if (!cancelled) setFailed(true) })

    return () => {
      cancelled = true
      if (widgetIdRef.current && window.turnstile) window.turnstile.remove(widgetIdRef.current)
      widgetIdRef.current = null
    }
  }, [])

  useEffect(() => {
    if (resetKey === 0 || !widgetIdRef.current || !window.turnstile) return
    onTokenRef.current(null)
    window.turnstile.reset(widgetIdRef.current)
  }, [resetKey])

  if (!TURNSTILE_ENABLED) return null

  return (
    <div style={{ marginBottom: 20, textAlign: 'center' }}>
      <div ref={containerRef} style={{ display: 'flex', justifyContent: 'center', minHeight: 65 }} />
      {failed && (
        <p style={{ fontSize: 13, color: '#6B6052', marginTop: 8, lineHeight: 1.5 }}>
          {CAPTCHA_FAILED_MESSAGE}
        </p>
      )}
    </div>
  )
}
