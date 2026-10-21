// SERVER ONLY — never import from client components.
import { Resend } from 'resend'
import { formatEur } from '@/lib/money'
import type { EmailOrderLine } from './sendNewOrderEmail'

const FROM = 'GemWorkers <orders@gemworkers.com>'

let _resend: Resend | null = null
function getResend(): Resend {
  if (!_resend) _resend = new Resend(process.env.RESEND_API_KEY)
  return _resend
}

function esc(s: string): string {
  return s.replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;')
}

const fmt = formatEur

// One refunded order — orderId is always shown to the owner.
export type RefundedOrderLine = EmailOrderLine & { orderId: string }

function itemRows(orders: RefundedOrderLine[], showIds: boolean): string {
  return orders.map(o => `
      <tr>
        <td style="padding:12px 16px;border-bottom:1px solid #f3f4f6;font-size:14px;color:#111">
          <strong>${esc(o.itemTitle)}</strong><br>
          <span style="color:#9ca3af;font-size:12px">${esc(o.orderNumber)}${showIds ? ` &middot; ${esc(o.orderId)}` : ''}</span>
        </td>
        <td style="padding:12px 16px;border-bottom:1px solid #f3f4f6;text-align:right;font-size:14px;font-weight:700;color:#111;white-space:nowrap">
          ${fmt(o.orderTotal)}
        </td>
      </tr>`).join('')
}

function wrap(inner: string): string {
  return `<!DOCTYPE html>
<html><head><meta charset="utf-8"></head>
<body style="margin:0;padding:40px 24px;background:#fafaf9;font-family:-apple-system,BlinkMacSystemFont,'Segoe UI',Helvetica,Arial,sans-serif;color:#111">
  <div style="max-width:520px;margin:0 auto">
    <p style="font-size:11px;font-weight:700;letter-spacing:0.12em;text-transform:uppercase;color:#9ca3af;margin:0 0 10px">GemWorkers</p>
    ${inner}
  </div>
</body></html>`
}

function table(orders: RefundedOrderLine[], showIds: boolean): string {
  return `<table style="width:100%;border-collapse:collapse;border:1px solid #e5e7eb;border-radius:8px;overflow:hidden;background:#fff;margin-bottom:24px">
      <tbody>${itemRows(orders, showIds)}</tbody>
    </table>`
}

// Owner notice: automatic refund of a payment that arrived after the order
// was no longer pending_payment.
export async function sendLatePaymentOwnerEmail(opts: {
  to:            string
  orders:        RefundedOrderLine[]
  refundedTotal: number
  buyerEmail:    string | null
  sessionId:     string
  paymentIntent: string
}): Promise<void> {
  const ref = opts.orders.map(o => o.orderNumber || o.orderId).join(', ')
  const html = wrap(`
    <h1 style="font-family:Georgia,'Times New Roman',serif;font-size:22px;font-weight:700;margin:0 0 8px;color:#111;line-height:1.2">Late payment refunded</h1>
    <p style="font-size:14px;color:#6b7280;margin:0 0 24px;line-height:1.6">A payment arrived after the order${opts.orders.length !== 1 ? 's were' : ' was'} no longer awaiting payment (reservation expired / cancelled). It was refunded automatically &mdash; no action needed. No shipping address was saved and no order emails were sent for ${opts.orders.length !== 1 ? 'these orders' : 'this order'}.</p>
    ${table(opts.orders, true)}
    <table style="width:100%;border-collapse:collapse;font-size:13px;color:#374151">
      <tr><td style="padding:4px 0;color:#9ca3af;width:140px">Amount refunded</td><td style="padding:4px 0">${fmt(opts.refundedTotal)}</td></tr>
      <tr><td style="padding:4px 0;color:#9ca3af">Buyer email</td><td style="padding:4px 0">${esc(opts.buyerEmail ?? '(unknown)')}</td></tr>
      <tr><td style="padding:4px 0;color:#9ca3af">Checkout session</td><td style="padding:4px 0">${esc(opts.sessionId)}</td></tr>
      <tr><td style="padding:4px 0;color:#9ca3af">Payment intent</td><td style="padding:4px 0">${esc(opts.paymentIntent)}</td></tr>
    </table>`)

  const { error } = await getResend().emails.send({
    from:    FROM,
    to:      [opts.to],
    subject: `[GemWorkers] Late payment refunded — ${ref}`,
    html,
  })
  if (error) throw new Error(error.message)
}

// Buyer notice: kind, short explanation that the stone was released and the
// money is on its way back.
export async function sendLatePaymentBuyerEmail(opts: {
  to:            string
  orders:        RefundedOrderLine[]
  refundedTotal: number
}): Promise<void> {
  const plural = opts.orders.length !== 1
  const html = wrap(`
    <h1 style="font-family:Georgia,'Times New Roman',serif;font-size:22px;font-weight:700;margin:0 0 8px;color:#111;line-height:1.2">Your payment has been refunded</h1>
    <p style="font-size:14px;color:#374151;margin:0 0 16px;line-height:1.6">Thank you for your payment, and we&rsquo;re sorry for the inconvenience. Unfortunately it reached us after the reservation had expired, so the stone${plural ? 's below were' : ' below was'} released and ${plural ? 'are' : 'is'} no longer held for you.</p>
    ${table(opts.orders, false)}
    <p style="font-size:14px;color:#374151;margin:0 0 16px;line-height:1.6">We have refunded <strong>${fmt(opts.refundedTotal)}</strong> to your original payment method. It usually takes 5&ndash;10 business days to appear on your statement.</p>
    <p style="font-size:14px;color:#374151;margin:0 0 32px;line-height:1.6">If you have any questions, or would still like the stone, just email us at <a href="mailto:hello@gemworkers.com" style="color:#111">hello@gemworkers.com</a>.</p>
    <p style="font-size:12px;color:#9ca3af;margin:0">This is an automated message &mdash; please do not reply.</p>`)

  const { error } = await getResend().emails.send({
    from:    FROM,
    to:      [opts.to],
    subject: plural ? 'Your GemWorkers payment has been refunded' : `Your GemWorkers payment has been refunded — ${opts.orders[0]?.itemTitle ?? 'Stone'}`,
    html,
  })
  if (error) throw new Error(error.message)
}
