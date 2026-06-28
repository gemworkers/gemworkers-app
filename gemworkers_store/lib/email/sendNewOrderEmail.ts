// SERVER ONLY — never import from client components.
import { Resend } from 'resend'

const FROM = 'GemWorkers <orders@gemworkers.com>'

// Lazy-initialized so the constructor doesn't throw at module-load time when
// RESEND_API_KEY is absent (e.g. during next build page-data collection).
let _resend: Resend | null = null
function getResend(): Resend {
  if (!_resend) _resend = new Resend(process.env.RESEND_API_KEY)
  return _resend
}

export type EmailOrderLine = {
  orderNumber: string
  itemTitle:   string
  orderTotal:  number   // authoritative total incl. shipping, read from DB
}

export type ShippingAddress = {
  name:       string | null
  line1:      string | null
  line2:      string | null
  city:       string | null
  state:      string | null
  postalCode: string | null
  country:    string | null
  phone:      string | null
}

// ── HTML helpers ───────────────────────────────────────────────────────────────

function esc(s: string): string {
  return s.replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;')
}

function buildAddrHtml(addr: ShippingAddress): string {
  const lines: string[] = [
    addr.name,
    addr.line1,
    addr.line2,
    [addr.city, addr.state, addr.postalCode].filter(Boolean).join(' '),
    addr.country,
  ].filter((l): l is string => !!l)
  return lines.map(esc).join('<br>')
}

function buildHtml(orders: EmailOrderLine[], addr: ShippingAddress): string {
  const fmt = (n: number) => `€${Number(n).toFixed(2)}`

  const rows = orders.map(o => `
      <tr>
        <td style="padding:12px 16px;border-bottom:1px solid #f3f4f6;font-size:14px;color:#111">
          <strong>${esc(o.itemTitle)}</strong><br>
          <span style="color:#9ca3af;font-size:12px">${esc(o.orderNumber)}</span>
        </td>
        <td style="padding:12px 16px;border-bottom:1px solid #f3f4f6;text-align:right;font-size:14px;font-weight:700;color:#111;white-space:nowrap">
          ${fmt(o.orderTotal)}
        </td>
      </tr>`).join('')

  const phoneRow = addr.phone
    ? `<p style="font-size:13px;color:#6b7280;margin:8px 0 0">Phone: ${esc(addr.phone)}</p>`
    : ''

  return `<!DOCTYPE html>
<html><head><meta charset="utf-8"></head>
<body style="margin:0;padding:40px 24px;background:#fafaf9;font-family:-apple-system,BlinkMacSystemFont,'Segoe UI',Helvetica,Arial,sans-serif;color:#111">
  <div style="max-width:520px;margin:0 auto">
    <p style="font-size:11px;font-weight:700;letter-spacing:0.12em;text-transform:uppercase;color:#9ca3af;margin:0 0 10px">GemWorkers</p>
    <h1 style="font-family:Georgia,'Times New Roman',serif;font-size:22px;font-weight:700;margin:0 0 28px;color:#111;line-height:1.2">New order</h1>

    <table style="width:100%;border-collapse:collapse;border:1px solid #e5e7eb;border-radius:8px;overflow:hidden;background:#fff;margin-bottom:24px">
      <thead>
        <tr style="background:#f9fafb">
          <th style="padding:10px 16px;font-size:11px;font-weight:700;letter-spacing:0.08em;text-transform:uppercase;color:#9ca3af;text-align:left">Stone</th>
          <th style="padding:10px 16px;font-size:11px;font-weight:700;letter-spacing:0.08em;text-transform:uppercase;color:#9ca3af;text-align:right">Total incl.&nbsp;shipping</th>
        </tr>
      </thead>
      <tbody>${rows}</tbody>
    </table>

    <div style="background:#fff;border:1px solid #e5e7eb;border-radius:8px;padding:20px 24px;margin-bottom:32px">
      <p style="font-size:11px;font-weight:700;letter-spacing:0.1em;text-transform:uppercase;color:#9ca3af;margin:0 0 12px">Ship to</p>
      <p style="font-size:14px;line-height:1.75;color:#374151;margin:0">${buildAddrHtml(addr)}</p>
      ${phoneRow}
    </div>

    <p style="font-size:12px;color:#9ca3af;margin:0">Automated notification — GemWorkers</p>
  </div>
</body></html>`
}

// ── Public API ─────────────────────────────────────────────────────────────────

export async function sendNewOrderEmail(opts: {
  to:       string[]
  subject:  string
  orders:   EmailOrderLine[]
  shipping: ShippingAddress
}): Promise<void> {
  if (opts.to.length === 0) return
  await getResend().emails.send({
    from:    FROM,
    to:      opts.to,
    subject: opts.subject,
    html:    buildHtml(opts.orders, opts.shipping),
  })
}
