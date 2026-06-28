// Supabase Edge Function — order-shipped-email
// Triggered by a Database Webhook on public.orders UPDATE.
// Sends a customer-facing "your order has shipped" email via Resend.
// SERVER ONLY. Never exposes seller, payout, or commission data.

import { createClient } from "@supabase/supabase-js"

// ── Payload types ──────────────────────────────────────────────────────────────

interface OrderRecord {
  id:                   string
  order_number:         string
  tracking_number:      string | null
  buyer_id:             string | null
  order_email:          string | null
  status:               string
  checkout_group_id:    string | null
  shipping_name:        string | null
  shipping_line1:       string | null
  shipping_line2:       string | null
  shipping_city:        string | null
  shipping_state:       string | null
  shipping_postal_code: string | null
  shipping_country:     string | null
  shipping_phone:       string | null
}

interface WebhookPayload {
  type:       string
  table:      string
  schema:     string
  record:     OrderRecord
  old_record: OrderRecord | null
}

// ── HTML builder ───────────────────────────────────────────────────────────────

function esc(s: string): string {
  return s.replace(/&/g, "&amp;").replace(/</g, "&lt;").replace(/>/g, "&gt;")
}

function buildAddrHtml(r: OrderRecord): string {
  const lines = [
    r.shipping_name,
    r.shipping_line1,
    r.shipping_line2,
    [r.shipping_city, r.shipping_state, r.shipping_postal_code].filter(Boolean).join(" "),
    r.shipping_country,
  ].filter((l): l is string => Boolean(l))
  return lines.length > 0 ? lines.map(esc).join("<br>") : "—"
}

function buildHtml(stoneTitle: string, order: OrderRecord): string {
  const trackingRow = order.tracking_number
    ? `<tr>
          <td style="padding:10px 16px;font-size:13px;color:#6b7280;border-bottom:1px solid #f3f4f6">Tracking</td>
          <td style="padding:10px 16px;font-size:13px;color:#111;font-weight:600;border-bottom:1px solid #f3f4f6">${esc(order.tracking_number)}</td>
        </tr>`
    : ""

  const phoneRow = order.shipping_phone
    ? `<p style="font-size:13px;color:#6b7280;margin:8px 0 0">Phone: ${esc(order.shipping_phone)}</p>`
    : ""

  return `<!DOCTYPE html>
<html><head><meta charset="utf-8"></head>
<body style="margin:0;padding:40px 24px;background:#fafaf9;font-family:-apple-system,BlinkMacSystemFont,'Segoe UI',Helvetica,Arial,sans-serif;color:#111">
  <div style="max-width:520px;margin:0 auto">
    <p style="font-size:11px;font-weight:700;letter-spacing:0.12em;text-transform:uppercase;color:#9ca3af;margin:0 0 10px">GemWorkers</p>
    <h1 style="font-family:Georgia,'Times New Roman',serif;font-size:22px;font-weight:700;margin:0 0 8px;color:#111;line-height:1.2">Your order has shipped</h1>
    <p style="font-size:14px;color:#6b7280;margin:0 0 28px;line-height:1.6">Good news &mdash; your order is on its way.</p>

    <table style="width:100%;border-collapse:collapse;border:1px solid #e5e7eb;border-radius:8px;overflow:hidden;background:#fff;margin-bottom:24px">
      <tbody>
        <tr>
          <td style="padding:10px 16px;font-size:13px;color:#6b7280;border-bottom:1px solid #f3f4f6">Order</td>
          <td style="padding:10px 16px;font-size:13px;color:#111;font-weight:600;border-bottom:1px solid #f3f4f6">${esc(order.order_number)}</td>
        </tr>
        <tr>
          <td style="padding:10px 16px;font-size:13px;color:#6b7280;${order.tracking_number ? "border-bottom:1px solid #f3f4f6;" : ""}">Stone</td>
          <td style="padding:10px 16px;font-size:13px;color:#111;font-weight:600;${order.tracking_number ? "border-bottom:1px solid #f3f4f6;" : ""}">${esc(stoneTitle)}</td>
        </tr>
        ${trackingRow}
      </tbody>
    </table>

    <div style="background:#fff;border:1px solid #e5e7eb;border-radius:8px;padding:20px 24px;margin-bottom:32px">
      <p style="font-size:11px;font-weight:700;letter-spacing:0.1em;text-transform:uppercase;color:#9ca3af;margin:0 0 12px">Ship to</p>
      <p style="font-size:14px;line-height:1.75;color:#374151;margin:0">${buildAddrHtml(order)}</p>
      ${phoneRow}
    </div>

    <p style="font-size:12px;color:#9ca3af;margin:0">This is an automated message &mdash; please do not reply. Questions? Email us at hello@gemworkers.com</p>
  </div>
</body></html>`
}

// ── Response helpers ───────────────────────────────────────────────────────────

const json = (body: unknown, status = 200) =>
  new Response(JSON.stringify(body), {
    status,
    headers: { "Content-Type": "application/json" },
  })

// ── Handler ────────────────────────────────────────────────────────────────────

Deno.serve(async (req: Request) => {
  // CORS preflight — Supabase webhooks don't send OPTIONS, but handle it cleanly.
  if (req.method === "OPTIONS") {
    return new Response(null, {
      status: 204,
      headers: {
        "Access-Control-Allow-Origin": "*",
        "Access-Control-Allow-Methods": "POST",
        "Access-Control-Allow-Headers": "Content-Type, x-webhook-secret",
      },
    })
  }

  // ── 1. Secret verification ─────────────────────────────────────────────────
  // Supabase webhook must send the header: x-webhook-secret: <SHIPPED_WEBHOOK_SECRET>
  const expectedSecret = Deno.env.get("SHIPPED_WEBHOOK_SECRET")
  const incomingSecret = req.headers.get("x-webhook-secret")
  if (!expectedSecret || incomingSecret !== expectedSecret) {
    console.error("[order-shipped-email] Unauthorized request — secret mismatch or missing")
    return json({ error: "Unauthorized" }, 401)
  }

  // ── 2. Parse payload ───────────────────────────────────────────────────────
  let payload: WebhookPayload
  try {
    payload = await req.json()
  } catch {
    return json({ error: "Invalid JSON" }, 400)
  }

  const { record, old_record } = payload

  if (!record || typeof record.status !== "string") {
    return json({ error: "Malformed payload — missing record.status" }, 400)
  }

  // ── 3. Guard: only process pending_payment → shipped (or confirmed → shipped)
  //      i.e. new status is 'shipped' and old status was NOT already 'shipped'.
  if (record.status !== "shipped" || old_record?.status === "shipped") {
    return json({ skipped: true, reason: "not a shipped transition" })
  }

  if (!record.buyer_id) {
    // Manual (non-platform) orders have no buyer_id — no email to send.
    console.log("[order-shipped-email] order", record.id, "has no buyer_id — skipping (manual order)")
    return json({ skipped: true, reason: "no buyer_id" })
  }

  // ── 4. Init Supabase admin client ──────────────────────────────────────────
  // SUPABASE_URL and SUPABASE_SERVICE_ROLE_KEY are injected automatically by
  // the Supabase Edge Runtime — no secrets set needed for these two.
  const supabaseUrl        = Deno.env.get("SUPABASE_URL")
  const supabaseServiceKey = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")
  if (!supabaseUrl || !supabaseServiceKey) {
    console.error("[order-shipped-email] SUPABASE_URL or SUPABASE_SERVICE_ROLE_KEY not available")
    return json({ ok: true, emailSent: false, reason: "supabase env missing" })
  }

  const supabase = createClient(supabaseUrl, supabaseServiceKey, {
    auth: { autoRefreshToken: false, persistSession: false },
  })

  // ── 5. Resolve customer email: order_email (checkout) → buyers.email → skip
  let customerEmail = (record.order_email as string | null)?.trim() ?? ""

  if (!customerEmail) {
    const { data: buyerRow, error: buyerErr } = await supabase
      .from("buyers")
      .select("email")
      .eq("id", record.buyer_id)
      .single()

    customerEmail = (buyerRow as { email: string } | null)?.email?.trim() ?? ""
    if (buyerErr || !customerEmail) {
      console.error(
        "[order-shipped-email] could not resolve customer email for order",
        record.id,
        "buyer", record.buyer_id,
        buyerErr?.message,
      )
      return json({ skipped: true, reason: "no customer email resolved" })
    }
  }

  // ── 6. Fetch stone title ───────────────────────────────────────────────────
  let stoneTitle = "Stone"
  const { data: itemRows } = await supabase
    .from("order_items")
    .select("inventory_item_id")
    .eq("order_id", record.id)
    .limit(1)

  const itemId = (itemRows as { inventory_item_id: string }[] | null)?.[0]?.inventory_item_id
  if (itemId) {
    const { data: invRow } = await supabase
      .from("inventory_items")
      .select("title")
      .eq("id", itemId)
      .single()
    stoneTitle = (invRow as { title: string } | null)?.title ?? "Stone"
  }

  // ── 7. Send email via Resend REST API ──────────────────────────────────────
  const resendApiKey = Deno.env.get("RESEND_API_KEY")
  if (!resendApiKey) {
    console.error("[order-shipped-email] RESEND_API_KEY not set — email not sent")
    return json({ ok: true, emailSent: false, reason: "RESEND_API_KEY missing" })
  }

  try {
    const emailRes = await fetch("https://api.resend.com/emails", {
      method:  "POST",
      headers: {
        "Authorization": `Bearer ${resendApiKey}`,
        "Content-Type":  "application/json",
      },
      body: JSON.stringify({
        from:    "GemWorkers <orders@gemworkers.com>",
        to:      [customerEmail],
        subject: `Your GemWorkers order has shipped — ${stoneTitle}`,
        html:    buildHtml(stoneTitle, record),
      }),
    })

    if (!emailRes.ok) {
      const errText = await emailRes.text()
      console.error(
        "[order-shipped-email] Resend returned",
        emailRes.status,
        "for order",
        record.id,
        "—",
        errText,
      )
      // Still return 200 so Supabase doesn't keep retrying this webhook.
      return json({ ok: true, emailSent: false, reason: `Resend ${emailRes.status}` })
    }
  } catch (e) {
    console.error(
      "[order-shipped-email] fetch to Resend threw for order",
      record.id,
      ":",
      e instanceof Error ? e.message : String(e),
    )
    return json({ ok: true, emailSent: false, reason: "Resend fetch threw" })
  }

  console.log(
    "[order-shipped-email] shipped email sent for order",
    record.id,
    "(",
    record.order_number,
    ") to",
    customerEmail,
  )
  return json({ ok: true, emailSent: true })
})
