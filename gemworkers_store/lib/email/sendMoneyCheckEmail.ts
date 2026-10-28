// SERVER ONLY — never import from client components.
// Owner alert from the nightly check: money (lib/money-check.ts) and errors /
// failed jobs (lib/health-check.ts). Sent only when something is listed, or
// when the check itself could not run.
import { Resend } from 'resend'

const FROM = 'GemWorkers <orders@gemworkers.com>'

function esc(s: string): string {
  return s.replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;')
}

const things = (n: number) => (n === 1 ? '1 thing' : `${n} things`)

export async function sendMoneyCheckEmail(opts: { to: string; problems: string[]; health?: string[]; failed?: string }): Promise<void> {
  const health = opts.health ?? []
  const title = opts.failed
    ? 'The nightly check could not run'
    : opts.problems.length > 0
      ? `${things(opts.problems.length)} in the money ${opts.problems.length === 1 ? "doesn't" : "don't"} match`
      : `${things(health.length)} went wrong in the last 24 hours`

  const section = (heading: string, items: string[]) => items.length === 0 ? '' : `
    <h2 style="font-size:15px;margin:20px 0 8px">${esc(heading)}</h2>
    <ul style="font-size:14px;color:#374151;line-height:1.55;padding-left:18px;margin:0">${items.map(p => `<li style="margin:0 0 8px">${esc(p)}</li>`).join('')}</ul>`

  const body = opts.failed
    ? section('Problem', [opts.failed])
    : section('Money', opts.problems) + section('Errors and failed jobs', health)

  const html = `<!DOCTYPE html>
<html><head><meta charset="utf-8"></head>
<body style="margin:0;padding:40px 24px;background:#fafaf9;font-family:-apple-system,BlinkMacSystemFont,'Segoe UI',Helvetica,Arial,sans-serif;color:#111">
  <div style="max-width:560px;margin:0 auto">
    <p style="font-size:11px;font-weight:700;letter-spacing:0.12em;text-transform:uppercase;color:#b42318;margin:0 0 10px">Nightly check</p>
    <h1 style="font-size:20px;margin:0 0 6px">${esc(title)}</h1>
    ${body}
    <p style="font-size:13px;color:#6b7280;line-height:1.6;margin:20px 0 0">
      Nothing was changed. Check these in Stripe and in the admin, or forward this email to
      Claude to look into it.
    </p>
  </div>
</body></html>`

  const text = opts.failed
    ? `${title}\n\n- ${opts.failed}\n`
    : `${title}\n` +
      (opts.problems.length ? `\nMoney:\n${opts.problems.map(p => `- ${p}`).join('\n')}\n` : '') +
      (health.length ? `\nErrors and failed jobs:\n${health.map(p => `- ${p}`).join('\n')}\n` : '') +
      `\nNothing was changed.\n`

  await new Resend(process.env.RESEND_API_KEY).emails.send({
    from: FROM,
    to: [opts.to],
    subject: `Nightly check: ${title}`,
    html,
    text,
  })
}
