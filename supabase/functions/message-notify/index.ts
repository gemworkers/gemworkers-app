// Supabase Edge Function — message-notify
// Triggered by a Database Webhook on public.messages INSERT.
// Sends short "you have a new message" nudges via Resend:
//   buyer sent        → the conversation's seller + the owner (separate emails)
//   seller/owner sent → the buyer
// Throttled per side by public.claim_message_notification (30 min, or sooner
// once that side has read the thread).
// SERVER ONLY. Never reads or sends the message body. Never reveals the seller
// to the buyer.

import { createClient, type SupabaseClient } from "@supabase/supabase-js"

// ── Payload types ──────────────────────────────────────────────────────────────

// Deliberately no `body` field — this function must never read message text.
interface MessageRecord {
  id:              string
  conversation_id: string
  sender_role:     string
}

interface WebhookPayload {
  type:       string
  table:      string
  schema:     string
  record:     MessageRecord | null
  old_record: unknown
}

interface ConversationRow {
  id:                string
  buyer_id:          string
  seller_id:         string
  inventory_item_id: string | null
}

type Role = "buyer" | "seller" | "owner"

// ── Constants ──────────────────────────────────────────────────────────────────

const FROM          = "GemWorkers <orders@gemworkers.com>"
const ADMIN_URL     = "https://sell.gemworkers.com"
const STORE_MSG_URL = "https://www.gemworkers.com/messages/"

// ── HTML builder ───────────────────────────────────────────────────────────────

function esc(s: string): string {
  return s
    .replace(/&/g, "&amp;")
    .replace(/</g, "&lt;")
    .replace(/>/g, "&gt;")
    .replace(/"/g, "&quot;")
}

function buildHtml(heading: string, introHtml: string, linkUrl: string, linkLabel: string): string {
  return `<!DOCTYPE html>
<html><head><meta charset="utf-8"></head>
<body style="margin:0;padding:40px 24px;background:#fafaf9;font-family:-apple-system,BlinkMacSystemFont,'Segoe UI',Helvetica,Arial,sans-serif;color:#111">
  <div style="max-width:520px;margin:0 auto">
    <p style="font-size:11px;font-weight:700;letter-spacing:0.12em;text-transform:uppercase;color:#9ca3af;margin:0 0 10px">GemWorkers</p>
    <h1 style="font-family:Georgia,'Times New Roman',serif;font-size:22px;font-weight:700;margin:0 0 8px;color:#111;line-height:1.2">${esc(heading)}</h1>
    <p style="font-size:14px;color:#6b7280;margin:0 0 28px;line-height:1.6">${introHtml}</p>

    <p style="margin:0 0 32px">
      <a href="${esc(linkUrl)}" style="display:inline-block;padding:12px 20px;background:#111;color:#fff;font-size:14px;font-weight:600;text-decoration:none;border-radius:6px">${esc(linkLabel)}</a>
    </p>
    <p style="font-size:13px;color:#6b7280;margin:0 0 32px;line-height:1.6;word-break:break-all">Or open: <a href="${esc(linkUrl)}" style="color:#374151">${esc(linkUrl)}</a></p>

    <p style="font-size:12px;color:#9ca3af;margin:0">This is an automated message &mdash; please do not reply. Questions? Email us at hello@gemworkers.com</p>
  </div>
</body></html>`
}

interface Email {
  subject: string
  html:    string
  text:    string
}

function staffEmail(sku: string): Email {
  return {
    subject: `New question about ${sku}`,
    html: buildHtml(
      `New question about ${sku}`,
      `A customer asked about <strong style="color:#111">${esc(sku)}</strong>. View and reply in GemWorkers admin.`,
      ADMIN_URL,
      "Open GemWorkers admin",
    ),
    text: `A customer asked about ${sku}. View and reply in GemWorkers admin: ${ADMIN_URL}\n`,
  }
}

function buyerEmail(stoneTitle: string, conversationId: string): Email {
  const url = STORE_MSG_URL + encodeURIComponent(conversationId)
  return {
    subject: "You have a reply from GemWorkers",
    html: buildHtml(
      "You have a reply from GemWorkers",
      `We've replied to your question about <strong style="color:#111">${esc(stoneTitle)}</strong>.`,
      url,
      "View message",
    ),
    text: `We've replied to your question about ${stoneTitle}. View it here: ${url}\n`,
  }
}

// ── Helpers ────────────────────────────────────────────────────────────────────

const json = (body: unknown, status = 200) =>
  new Response(JSON.stringify(body), {
    status,
    headers: { "Content-Type": "application/json" },
  })

async function claim(supabase: SupabaseClient, conversationId: string, role: Role): Promise<boolean> {
  const { data, error } = await supabase.rpc("claim_message_notification", {
    p_conversation_id: conversationId,
    p_role:            role,
  })
  if (error) {
    console.error("[message-notify] claim", role, "failed for conversation", conversationId, "—", error.message)
    return false
  }
  return data === true
}

// One recipient per call — seller and owner never share a To: line.
async function sendEmail(apiKey: string, to: string, email: Email, context: string): Promise<boolean> {
  try {
    const res = await fetch("https://api.resend.com/emails", {
      method:  "POST",
      headers: {
        "Authorization": `Bearer ${apiKey}`,
        "Content-Type":  "application/json",
      },
      body: JSON.stringify({
        from:    FROM,
        to:      [to],
        subject: email.subject,
        html:    email.html,
        text:    email.text,
      }),
    })
    if (!res.ok) {
      console.error("[message-notify] Resend returned", res.status, "for", context, "—", await res.text())
      return false
    }
    return true
  } catch (e) {
    console.error("[message-notify] fetch to Resend threw for", context, ":", e instanceof Error ? e.message : String(e))
    return false
  }
}

// ── Handler ────────────────────────────────────────────────────────────────────

Deno.serve(async (req: Request) => {
  // ── 1. Secret verification ─────────────────────────────────────────────────
  // Supabase webhook must send the header: x-webhook-secret: <MESSAGE_WEBHOOK_SECRET>
  const expectedSecret = Deno.env.get("MESSAGE_WEBHOOK_SECRET")
  const incomingSecret = req.headers.get("x-webhook-secret")
  if (!expectedSecret || incomingSecret !== expectedSecret) {
    console.error("[message-notify] Unauthorized request — secret mismatch or missing")
    return json({ error: "Unauthorized" }, 401)
  }

  // From here on, always 200 so Supabase doesn't retry and double-send.

  // ── 2. Parse payload ───────────────────────────────────────────────────────
  let payload: WebhookPayload
  try {
    payload = await req.json()
  } catch {
    console.error("[message-notify] invalid JSON payload")
    return json({ skipped: true, reason: "invalid JSON" })
  }

  if (payload.type !== "INSERT" || payload.table !== "messages") {
    return json({ skipped: true, reason: "not a messages INSERT" })
  }

  const record = payload.record
  const conversationId = record?.conversation_id
  const senderRole     = record?.sender_role
  if (!conversationId || !senderRole) {
    console.error("[message-notify] malformed record — missing conversation_id or sender_role")
    return json({ skipped: true, reason: "malformed record" })
  }

  // ── 3. Env ─────────────────────────────────────────────────────────────────
  const supabaseUrl        = Deno.env.get("SUPABASE_URL")
  const supabaseServiceKey = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")
  if (!supabaseUrl || !supabaseServiceKey) {
    console.error("[message-notify] SUPABASE_URL or SUPABASE_SERVICE_ROLE_KEY not available")
    return json({ ok: true, emailsSent: 0, reason: "supabase env missing" })
  }

  const resendApiKey = Deno.env.get("RESEND_API_KEY")
  if (!resendApiKey) {
    // Checked before claiming so a missing key doesn't burn the throttle window.
    console.error("[message-notify] RESEND_API_KEY not set — no emails sent")
    return json({ ok: true, emailsSent: 0, reason: "RESEND_API_KEY missing" })
  }

  const supabase = createClient(supabaseUrl, supabaseServiceKey, {
    auth: { autoRefreshToken: false, persistSession: false },
  })

  // ── 4. Conversation + stone ────────────────────────────────────────────────
  const { data: convData, error: convErr } = await supabase
    .from("conversations")
    .select("id, buyer_id, seller_id, inventory_item_id")
    .eq("id", conversationId)
    .single()

  const conv = convData as ConversationRow | null
  if (convErr || !conv) {
    console.error("[message-notify] conversation not found:", conversationId, convErr?.message)
    return json({ skipped: true, reason: "conversation not found" })
  }

  let sku        = ""
  let stoneTitle = ""
  if (conv.inventory_item_id) {
    const { data: inv, error: invErr } = await supabase
      .from("inventory_items")
      .select("sku, title")
      .eq("id", conv.inventory_item_id)
      .single()
    if (invErr) {
      console.error("[message-notify] could not load stone", conv.inventory_item_id, "—", invErr.message)
    }
    const row = inv as { sku: string | null; title: string | null } | null
    sku        = row?.sku?.trim()   ?? ""
    stoneTitle = row?.title?.trim() ?? ""
  }

  let sent = 0

  // ── 5a. Buyer sent → nudge seller + owner ──────────────────────────────────
  if (senderRole === "buyer") {
    const email = staffEmail(sku || "a stone")

    const { data: sellerRow, error: sellerErr } = await supabase
      .from("sellers")
      .select("email")
      .eq("id", conv.seller_id)
      .single()
    if (sellerErr) {
      console.error("[message-notify] could not load seller", conv.seller_id, "—", sellerErr.message)
    }
    const sellerEmail = (sellerRow as { email: string | null } | null)?.email?.trim() ?? ""
    const ownerEmail  = Deno.env.get("OWNER_EMAIL")?.trim() ?? ""

    if (!ownerEmail) {
      console.error("[message-notify] OWNER_EMAIL not set — owner not emailed")
    }
    if (!sellerEmail) {
      console.log("[message-notify] seller", conv.seller_id, "has no email — seller not emailed")
    }

    const sameInbox = sellerEmail !== "" && ownerEmail !== "" &&
      sellerEmail.toLowerCase() === ownerEmail.toLowerCase()

    if (sameInbox) {
      // Owner is also this stone's seller: claim both sides, send one email.
      const sellerClaimed = await claim(supabase, conv.id, "seller")
      const ownerClaimed  = await claim(supabase, conv.id, "owner")
      if (sellerClaimed || ownerClaimed) {
        if (await sendEmail(resendApiKey, ownerEmail, email, `conversation ${conv.id} (seller+owner)`)) sent++
      }
    } else {
      if (sellerEmail && await claim(supabase, conv.id, "seller")) {
        if (await sendEmail(resendApiKey, sellerEmail, email, `conversation ${conv.id} (seller)`)) sent++
      }
      if (ownerEmail && await claim(supabase, conv.id, "owner")) {
        if (await sendEmail(resendApiKey, ownerEmail, email, `conversation ${conv.id} (owner)`)) sent++
      }
    }

  // ── 5b. Staff sent → nudge buyer ───────────────────────────────────────────
  } else if (senderRole === "seller" || senderRole === "owner") {
    const { data: userData, error: userErr } = await supabase.auth.admin.getUserById(conv.buyer_id)
    const buyerAddr = userData?.user?.email?.trim() ?? ""
    if (userErr || !buyerAddr) {
      console.error("[message-notify] could not resolve buyer email for conversation", conv.id, userErr?.message)
      return json({ skipped: true, reason: "no buyer email" })
    }

    if (await claim(supabase, conv.id, "buyer")) {
      const email = buyerEmail(stoneTitle || "your stone", conv.id)
      if (await sendEmail(resendApiKey, buyerAddr, email, `conversation ${conv.id} (buyer)`)) sent++
    }

  } else {
    console.error("[message-notify] unknown sender_role", senderRole, "for conversation", conv.id)
    return json({ skipped: true, reason: "unknown sender_role" })
  }

  console.log("[message-notify] conversation", conv.id, "sender", senderRole, "— emails sent:", sent)
  return json({ ok: true, emailsSent: sent })
})
