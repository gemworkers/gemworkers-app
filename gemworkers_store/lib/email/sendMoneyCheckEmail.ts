// SERVER ONLY — never import from client components.
// Owner alert from the daily money check (lib/money-check.ts): sent only when
// something doesn't match, or when the check itself could not run.
import { Resend } from 'resend'

const FROM = 'GemWorkers <orders@gemworkers.com>'

function esc(s: string): string {
  return s.replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;')
}

export async function sendMoneyCheckEmail(opts: { to: string; problems: string[]; failed?: string }): Promise<void> {
  const title = opts.failed
    ? 'The daily money check could not run'
    : opts.problems.length === 1 ? '1 thing in the money doesn\'t match' : `${opts.problems.length} things in the money don't match`
  const items = opts.failed ? [opts.failed] : opts.problems
  const rows = items.map(p => `<li style="margin:0 0 8px">${esc(p)}</li>`).join('')

  const html = `<!DOCTYPE html>
<html><head><meta charset="utf-8"></head>
<body style="margin:0;padding:40px 24px;background:#fafaf9;font-family:-apple-system,BlinkMacSystemFont,'Segoe UI',Helvetica,Arial,sans-serif;color:#111">
  <div style="max-width:560px;margin:0 auto">
    <p style="font-size:11px;font-weight:700;letter-spacing:0.12em;text-transform:uppercase;color:#b42318;margin:0 0 10px">Daily money check</p>
    <h1 style="font-size:20px;margin:0 0 14px">${esc(title)}</h1>
    <ul style="font-size:14px;color:#374151;line-height:1.55;padding-left:18px;margin:0 0 16px">${rows}</ul>
    <p style="font-size:13px;color:#6b7280;line-height:1.6;margin:0">
      Nothing was changed. Check these in Stripe and in the admin (Orders, Returns, Payouts),
      or forward this email to Claude to look into it.
    </p>
  </div>
</body></html>`

  const text = `${title}\n\n${items.map(p => `- ${p}`).join('\n')}\n\nNothing was changed. Check these in Stripe and in the admin.\n`

  await new Resend(process.env.RESEND_API_KEY).emails.send({
    from: FROM,
    to: [opts.to],
    subject: `Money check: ${title}`,
    html,
    text,
  })
}
