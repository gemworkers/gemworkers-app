// SERVER ONLY — never import from client components.
import { Resend } from 'resend'

const FROM = 'GemWorkers <no-reply@gemworkers.com>'
const TO   = 'hello@gemworkers.com'

let _resend: Resend | null = null
function getResend(): Resend {
  if (!_resend) _resend = new Resend(process.env.RESEND_API_KEY)
  return _resend
}

function esc(s: string): string {
  return s.replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;')
}

function buildHtml(name: string, email: string, topic: string, message: string): string {
  return `<!DOCTYPE html>
<html><head><meta charset="utf-8"></head>
<body style="margin:0;padding:40px 24px;background:#fafaf9;font-family:-apple-system,BlinkMacSystemFont,'Segoe UI',Helvetica,Arial,sans-serif;color:#111">
  <div style="max-width:520px;margin:0 auto">
    <p style="font-size:11px;font-weight:700;letter-spacing:0.12em;text-transform:uppercase;color:#9ca3af;margin:0 0 10px">GemWorkers — Contact Form</p>
    <table style="width:100%;border-collapse:collapse;margin-bottom:24px">
      <tr>
        <td style="padding:8px 0;font-size:12px;color:#9ca3af;width:72px;vertical-align:top">Name</td>
        <td style="padding:8px 0;font-size:14px;color:#111">${esc(name)}</td>
      </tr>
      <tr>
        <td style="padding:8px 0;font-size:12px;color:#9ca3af;vertical-align:top">Email</td>
        <td style="padding:8px 0;font-size:14px;color:#111">${esc(email)}</td>
      </tr>
      <tr>
        <td style="padding:8px 0;font-size:12px;color:#9ca3af;vertical-align:top">Topic</td>
        <td style="padding:8px 0;font-size:14px;color:#111">${esc(topic)}</td>
      </tr>
    </table>
    <div style="background:#fff;border:1px solid #e5e7eb;border-radius:8px;padding:20px 24px">
      <p style="font-size:11px;font-weight:700;letter-spacing:0.1em;text-transform:uppercase;color:#9ca3af;margin:0 0 12px">Message</p>
      <p style="font-size:14px;line-height:1.75;color:#374151;margin:0;white-space:pre-wrap">${esc(message)}</p>
    </div>
  </div>
</body></html>`
}

export async function sendContactEmail(opts: {
  name:    string
  email:   string
  topic:   string
  message: string
}): Promise<void> {
  const { data, error } = await getResend().emails.send({
    from:    FROM,
    to:      TO,
    replyTo: opts.email,
    subject: `[Contact] ${opts.topic}: ${opts.name}`,
    html:    buildHtml(opts.name, opts.email, opts.topic, opts.message),
  })
  if (error) {
    console.error('[sendContactEmail] Resend API error:', error)
    throw new Error(error.message)
  }
  console.log('[sendContactEmail] sent, id:', data?.id)
}
