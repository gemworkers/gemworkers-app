// Next.js server start hook. Every server console.error and every uncaught
// request error also goes to the error log (lib/error-log.ts → app_errors),
// so the nightly check can email the owner what broke.

export async function register() {
  if (process.env.NEXT_RUNTIME !== 'nodejs') return
  const { logError, errorText } = await import('./lib/error-log')
  const original = console.error.bind(console)
  console.error = (...args: unknown[]) => {
    original(...args)
    void logError('store', errorText(args))
  }
}

export async function onRequestError(
  err: unknown,
  request: { path: string; method: string },
) {
  if (process.env.NEXT_RUNTIME !== 'nodejs') return
  const { logError } = await import('./lib/error-log')
  const msg = err instanceof Error ? err.message : String(err)
  await logError('crash', `${request.method} ${request.path}: ${msg}`)
}
