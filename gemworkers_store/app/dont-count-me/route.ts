// Open once on each of your own devices/browsers: from then on your visits to
// gemworkers.com are not counted in Views & Visits (cookie, 2 years).
// gemworkers.com/dont-count-me?undo=1 counts this device again.
import { NextResponse, type NextRequest } from 'next/server'

export function GET(req: NextRequest) {
  const undo = req.nextUrl.searchParams.has('undo')
  const res = new NextResponse(
    `<!doctype html><meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1">
<title>GemWorkers</title><body style="font-family:system-ui;padding:40px;max-width:520px;margin:auto;color:#1F1B16">
<h2>${undo ? 'This device is counted again.' : 'Done: this device is no longer counted.'}</h2>
<p>${undo ? '' : 'Your own visits on this phone or browser won’t appear in Views &amp; Visits. Repeat on your other devices and browsers.'}</p>
<p><a href="/" style="color:#7A5A22">Go to the shop →</a></p></body>`,
    { headers: { 'content-type': 'text/html; charset=utf-8', 'cache-control': 'no-store', 'x-robots-tag': 'noindex' } })
  res.cookies.set('gw_nocount', undo ? '' : '1', { maxAge: undo ? 0 : 60 * 60 * 24 * 730, path: '/', sameSite: 'lax', secure: true })
  return res
}
