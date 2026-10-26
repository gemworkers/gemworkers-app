// SERVER ONLY — "Please confirm your subscription" (double opt-in).
import { Resend } from 'resend'

const FROM = 'GemWorkers <hello@gemworkers.com>'

export async function sendNewsletterConfirmEmail(to: string, confirmUrl: string): Promise<void> {
  const html = `<!DOCTYPE html>
<html><head><meta charset="utf-8"></head>
<body style="margin:0;padding:40px 24px;background:#fafaf9;font-family:-apple-system,BlinkMacSystemFont,'Segoe UI',Helvetica,Arial,sans-serif;color:#111">
  <div style="max-width:520px;margin:0 auto">
    <p style="font-size:11px;font-weight:700;letter-spacing:0.12em;text-transform:uppercase;color:#9ca3af;margin:0 0 10px">GemWorkers</p>
    <h1 style="font-family:Georgia,'Times New Roman',serif;font-size:22px;margin:0 0 12px">Please confirm your subscription</h1>
    <p style="font-size:14px;color:#374151;line-height:1.6;margin:0 0 20px">You (or someone using your email) asked to hear about new stones from GemWorkers. Click below to confirm — until then you won't get any emails from us.</p>
    <a href="${confirmUrl}" style="display:inline-block;background:#111;color:#fff;text-decoration:none;padding:12px 20px;border-radius:999px;font-size:14px">Yes, keep me posted</a>
    <p style="font-size:12px;color:#9ca3af;margin:24px 0 0;line-height:1.5">Didn't sign up? Just ignore this email — you won't hear from us.</p>
  </div>
</body></html>`
  const text = `Please confirm your subscription to GemWorkers news about new stones:\n${confirmUrl}\n\nDidn't sign up? Just ignore this email.`
  const { error } = await new Resend(process.env.RESEND_API_KEY).emails.send({
    from: FROM, to: [to], subject: 'Please confirm: new stones from GemWorkers', html, text,
  })
  if (error) throw new Error(error.message)
}
