// SERVER ONLY — never import from client components.
// Owner alert for a Stripe chargeback (dispute). Stripe gives only a few days
// to send evidence, so this goes out the moment the dispute is opened.
import { Resend } from 'resend'
import { formatEur } from '@/lib/money'

const FROM = 'GemWorkers <orders@gemworkers.com>'

function esc(s: string): string {
  return s.replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;')
}

export async function sendDisputeAlertEmail(opts: {
  to: string
  disputeId: string
  amount: number            // disputed amount, euros
  reason: string            // Stripe reason code, e.g. "fraudulent"
  respondBy: Date | null    // evidence due by
  orders: { orderNumber: string; title: string; owner: string }[]
}): Promise<void> {
  const due = opts.respondBy
    ? opts.respondBy.toLocaleString('en-GB', { dateStyle: 'full', timeStyle: 'short', timeZone: 'Europe/Amsterdam' })
    : 'see Stripe'
  const reason = opts.reason.replace(/_/g, ' ')
  const link = `https://dashboard.stripe.com/disputes/${encodeURIComponent(opts.disputeId)}`
  const rows = opts.orders.map(o =>
    `<li style="margin:0 0 6px"><strong>${esc(o.orderNumber)}</strong> — ${esc(o.title)} <span style="color:#6b7280">(${esc(o.owner)})</span></li>`).join('')

  const html = `<!DOCTYPE html>
<html><head><meta charset="utf-8"></head>
<body style="margin:0;padding:40px 24px;background:#fafaf9;font-family:-apple-system,BlinkMacSystemFont,'Segoe UI',Helvetica,Arial,sans-serif;color:#111">
  <div style="max-width:520px;margin:0 auto">
    <p style="font-size:11px;font-weight:700;letter-spacing:0.12em;text-transform:uppercase;color:#b42318;margin:0 0 10px">Chargeback — action needed</p>
    <h1 style="font-size:20px;margin:0 0 14px">A buyer disputed a payment of ${esc(formatEur(opts.amount))}</h1>
    <p style="font-size:14px;color:#374151;line-height:1.6;margin:0 0 12px">
      Reason given by the bank: <strong>${esc(reason)}</strong><br>
      <strong>Send your evidence before: ${esc(due)}</strong> — if you don't respond, the buyer wins automatically.
    </p>
    <ul style="font-size:14px;color:#374151;padding-left:18px;margin:0 0 16px">${rows}</ul>
    <p style="font-size:14px;color:#374151;line-height:1.6;margin:0 0 16px">
      What helps: the tracking showing delivery (with signature for expensive stones), the invoice,
      the stone page / photos, and any messages with the buyer. The dispute fee is charged to the stone's
      owner; the sale can't be paid out until the dispute is closed.
    </p>
    <a href="${link}" style="display:inline-block;background:#111;color:#fff;text-decoration:none;padding:12px 20px;border-radius:999px;font-size:14px">Open the dispute in Stripe</a>
  </div>
</body></html>`

  const text =
    `A buyer disputed a payment of ${formatEur(opts.amount)} (reason: ${reason}).\n` +
    `Send your evidence before: ${due}. If you don't respond, the buyer wins automatically.\n\n` +
    opts.orders.map(o => `- ${o.orderNumber} — ${o.title} (${o.owner})`).join('\n') +
    `\n\nOpen the dispute in Stripe: ${link}\n`

  await new Resend(process.env.RESEND_API_KEY).emails.send({
    from: FROM,
    to: [opts.to],
    subject: `Chargeback: ${formatEur(opts.amount)} — respond by ${opts.respondBy ? opts.respondBy.toLocaleDateString('en-GB', { timeZone: 'Europe/Amsterdam' }) : 'soon'}`,
    html,
    text,
  })
}
