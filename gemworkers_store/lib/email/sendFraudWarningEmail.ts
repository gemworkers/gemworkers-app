// SERVER ONLY — never import from client components.
// Owner alert for a Stripe early fraud warning: the card's bank reports the
// payment as probably made with a stolen card. A chargeback usually follows
// within weeks; refunding before shipping avoids losing the stone, the money
// and the €15 dispute fee.
import { Resend } from 'resend'
import { formatMoney } from '@/lib/money'

const FROM = 'GemWorkers <orders@gemworkers.com>'

function esc(s: string): string {
  return s.replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;')
}

export async function sendFraudWarningEmail(opts: {
  to: string
  chargeId: string
  amount: number            // in [currency]
  currency: string
  fraudType: string         // Stripe fraud_type, e.g. "made_with_stolen_card"
  orders: { orderNumber: string; title: string; status: string }[]
}): Promise<void> {
  const kind = opts.fraudType.replace(/_/g, ' ')
  const link = `https://dashboard.stripe.com/payments/${encodeURIComponent(opts.chargeId)}`
  const rows = opts.orders.map(o =>
    `<li style="margin:0 0 6px"><strong>${esc(o.orderNumber)}</strong> — ${esc(o.title)} <span style="color:#6b7280">(${esc(o.status)})</span></li>`).join('')
  const amount = formatMoney(opts.amount, opts.currency)

  const html = `<!DOCTYPE html>
<html><head><meta charset="utf-8"></head>
<body style="margin:0;padding:40px 24px;background:#fafaf9;font-family:-apple-system,BlinkMacSystemFont,'Segoe UI',Helvetica,Arial,sans-serif;color:#111">
  <div style="max-width:520px;margin:0 auto">
    <p style="font-size:11px;font-weight:700;letter-spacing:0.12em;text-transform:uppercase;color:#b42318;margin:0 0 10px">Fraud warning — act today</p>
    <h1 style="font-size:20px;margin:0 0 14px">A payment of ${esc(amount)} is probably fraud</h1>
    <p style="font-size:14px;color:#374151;line-height:1.6;margin:0 0 12px">
      The card's bank reports: <strong>${esc(kind)}</strong>. A chargeback usually follows.
    </p>
    <ul style="font-size:14px;color:#374151;padding-left:18px;margin:0 0 16px">${rows}</ul>
    <p style="font-size:14px;color:#374151;line-height:1.6;margin:0 0 16px">
      <strong>Not shipped yet?</strong> Don't ship. Refund the order in full in the admin (Refund order) —
      that avoids the chargeback and its fee.<br>
      <strong>Already shipped?</strong> Ask the courier to stop or return the parcel, then refund.
    </p>
    <a href="${link}" style="display:inline-block;background:#111;color:#fff;text-decoration:none;padding:12px 20px;border-radius:999px;font-size:14px">Open the payment in Stripe</a>
  </div>
</body></html>`

  const text =
    `A payment of ${amount} is probably fraud (bank reports: ${kind}).\n\n` +
    opts.orders.map(o => `- ${o.orderNumber} — ${o.title} (${o.status})`).join('\n') +
    `\n\nNot shipped yet? Don't ship — refund the order in full in the admin (Refund order).\n` +
    `Already shipped? Ask the courier to stop or return the parcel, then refund.\n\n` +
    `Open the payment in Stripe: ${link}\n`

  await new Resend(process.env.RESEND_API_KEY).emails.send({
    from: FROM,
    to: [opts.to],
    subject: `Fraud warning: ${amount} — don't ship before checking`,
    html,
    text,
  })
}
