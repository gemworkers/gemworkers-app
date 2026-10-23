// Supabase Edge Function — offer-notify
// Triggered by a Database Webhook on public.storefront_offers INSERT + UPDATE.
// Sends offer emails via Resend, one email per recipient:
//   INSERT pending          → seller + owner         ("New offer on {SKU}")
//   pending  → accepted     → buyer (pay within 48 h) + the staff side that didn't act
//   pending  → declined     → buyer (or "reserved by another buyer" when system-declined)
//   accepted → expired      → buyer + seller + owner (payment window ended;
//                             amount = counter price when it was a counter)
//   pending   → countered   → buyer (counter-offer, 48 h) + the staff side that didn't act
//   countered → accepted    → buyer (pay within 48 h) + seller + owner
//   countered → declined    → seller + owner (buyer declined), or buyer
//                             ("reserved by another buyer") when system-declined
//   countered → expired     → buyer + seller + owner (counter not answered in 48 h)
//   anything else (withdrawn, claim stamps, …) → no email
// Each event is sent at most once: public.claim_offer_notification stamps
// <kind>_notified_at atomically before anything is sent.
//
// Also called by pg_cron (public.send_offer_payment_reminders) with
// x-reminder-secret and {"type":"PAYMENT_REMINDER","order_id":…}:
//   ~12 h before payment_due_at → buyer only ("Reminder: complete your payment …")
// That job stamps orders.payment_reminder_sent_at before calling, so no claim here.
// Same secret, {"type":"REVIEW_INVITE","order_ids":[…]} from send_review_invites:
//   order received / shipped ≥ 14 days → buyer only ("How is your {stone}?")
// That job stamps orders.review_invited_at before calling.
// Same secret, {"type":"LISTING_EVENT","item_id","event"} from the listing
// approval trigger: requested → owner; approved / rejected → seller.
// SERVER ONLY. Never reads seller_note. Never reveals the seller to the buyer.

import { createClient, type SupabaseClient } from "@supabase/supabase-js"

// ── Payload types ──────────────────────────────────────────────────────────────

// Deliberately no seller_note / buyer_note — this function must never read them.
interface OfferRecord {
  id:                string
  buyer_id:          string
  inventory_item_id: string
  seller_id:         string
  offered_price:     number | string
  status:            string
  responded_by_role: string | null
  counter_price?:      number | string | null
  counter_expires_at?: string | null
  countered_by_role?:  string | null
}

interface WebhookPayload {
  type:       string
  table:      string
  schema:     string
  record:     OfferRecord | null
  old_record: { status?: string } | null
}

interface OrderRow {
  order_total:    number | string | null
  shipping_cost:  number | string | null
  payment_due_at: string | null
}

interface ReminderPayload {
  type:     string
  order_id: string
}

interface ReminderOrderRow extends OrderRow {
  id:       string
  status:   string
  buyer_id: string
  offer_id: string | null
}

// One event per webhook. Later parts add their own variants here
// (e.g. "payment_reminder", "countered") plus a case in classify() and the handler switch.
type OfferEvent =
  | "new_offer" | "accepted" | "declined" | "expired"
  | "countered" | "counter_accepted" | "counter_declined" | "counter_expired"

// Must match the kinds accepted by public.claim_offer_notification.
type ClaimKind = "new_offer" | "countered" | "response" | "expired"

// A countered offer never used 'response' / 'expired' before, so the
// counter outcomes reuse those stamps.
const CLAIM_KIND: Record<OfferEvent, ClaimKind> = {
  new_offer:        "new_offer",
  accepted:         "response",
  declined:         "response",
  expired:          "expired",
  countered:        "countered",
  counter_accepted: "response",
  counter_declined: "response",
  counter_expired:  "expired",
}

// ── Constants ──────────────────────────────────────────────────────────────────

const FROM       = "GemWorkers <orders@gemworkers.com>"
const ADMIN_URL  = "https://sell.gemworkers.com"
const STORE_URL  = "https://www.gemworkers.com"
const ORDERS_URL = `${STORE_URL}/orders`

const stoneUrl = (itemId: string) => `${STORE_URL}/stones/${encodeURIComponent(itemId)}`

// ── Formatting ─────────────────────────────────────────────────────────────────

const eurWhole = new Intl.NumberFormat("en-IE", { style: "currency", currency: "EUR", maximumFractionDigits: 0 })
const eurCents = new Intl.NumberFormat("en-IE", { style: "currency", currency: "EUR", minimumFractionDigits: 2 })

function eur(n: number): string {
  return Number.isInteger(n) ? eurWhole.format(n) : eurCents.format(n)
}

const utcDate = new Intl.DateTimeFormat("en-GB", {
  timeZone: "UTC",
  day: "numeric", month: "short", year: "numeric",
  hour: "2-digit", minute: "2-digit", hour12: false,
})

// ── HTML builder ───────────────────────────────────────────────────────────────

function esc(s: string): string {
  return s
    .replace(/&/g, "&amp;")
    .replace(/</g, "&lt;")
    .replace(/>/g, "&gt;")
    .replace(/"/g, "&quot;")
}

const strong = (s: string) => `<strong style="color:#111">${esc(s)}</strong>`

// paragraphsHtml are already-escaped HTML fragments.
function buildHtml(heading: string, paragraphsHtml: string[], linkUrl: string, linkLabel: string): string {
  const paragraphs = paragraphsHtml
    .map(p => `<p style="font-size:14px;color:#6b7280;margin:0 0 14px;line-height:1.6">${p}</p>`)
    .join("\n    ")
  return `<!DOCTYPE html>
<html><head><meta charset="utf-8"></head>
<body style="margin:0;padding:40px 24px;background:#fafaf9;font-family:-apple-system,BlinkMacSystemFont,'Segoe UI',Helvetica,Arial,sans-serif;color:#111">
  <div style="max-width:520px;margin:0 auto">
    <p style="font-size:11px;font-weight:700;letter-spacing:0.12em;text-transform:uppercase;color:#9ca3af;margin:0 0 10px">GemWorkers</p>
    <h1 style="font-family:Georgia,'Times New Roman',serif;font-size:22px;font-weight:700;margin:0 0 8px;color:#111;line-height:1.2">${esc(heading)}</h1>
    ${paragraphs}

    <p style="margin:14px 0 32px">
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

// ── Staff emails ───────────────────────────────────────────────────────────────

function staffNewOfferEmail(sku: string, amount: string): Email {
  const subject = `New offer on ${sku}: ${amount}`
  return {
    subject,
    html: buildHtml(
      subject,
      [`A customer offered ${strong(amount)} for ${strong(sku)}. Accept or decline it in GemWorkers admin.`],
      ADMIN_URL,
      "Open GemWorkers admin",
    ),
    text: `A customer offered ${amount} for ${sku}. Accept or decline it in GemWorkers admin: ${ADMIN_URL}\n`,
  }
}

function staffAcceptedEmail(sku: string, amount: string, actedBy: "seller" | "owner"): Email {
  const who     = actedBy === "seller" ? "the seller" : "GemWorkers admin"
  const subject = `Offer accepted on ${sku}: ${amount}`
  return {
    subject,
    html: buildHtml(
      subject,
      [
        `The offer of ${strong(amount)} for ${strong(sku)} was accepted by ${esc(who)}.`,
        "The stone is reserved and the buyer has 48 hours to pay.",
      ],
      ADMIN_URL,
      "Open GemWorkers admin",
    ),
    text: `The offer of ${amount} for ${sku} was accepted by ${who}. The stone is reserved and the buyer has 48 hours to pay.\n${ADMIN_URL}\n`,
  }
}

function staffExpiredEmail(sku: string, amount: string): Email {
  const subject = `Offer payment window ended on ${sku}`
  return {
    subject,
    html: buildHtml(
      subject,
      [
        `The buyer did not pay for the accepted offer of ${strong(amount)} on ${strong(sku)} within 48 hours.`,
        "The order was cancelled and the stone is available again.",
      ],
      ADMIN_URL,
      "Open GemWorkers admin",
    ),
    text: `The buyer did not pay for the accepted offer of ${amount} on ${sku} within 48 hours. The order was cancelled and the stone is available again.\n${ADMIN_URL}\n`,
  }
}

function staffCounterSentEmail(sku: string, offered: string, counter: string, actedBy: "seller" | "owner"): Email {
  const who     = actedBy === "seller" ? "The seller" : "GemWorkers admin"
  const subject = `Counter-offer sent on ${sku}: ${counter}`
  return {
    subject,
    html: buildHtml(
      subject,
      [
        `${esc(who)} answered the offer of ${strong(offered)} for ${strong(sku)} with a counter-offer of ${strong(counter)}.`,
        "The buyer has 48 hours to accept or decline it.",
      ],
      ADMIN_URL,
      "Open GemWorkers admin",
    ),
    text: `${who} answered the offer of ${offered} for ${sku} with a counter-offer of ${counter}. The buyer has 48 hours to accept or decline it.\n${ADMIN_URL}\n`,
  }
}

function staffCounterAcceptedEmail(sku: string, counter: string): Email {
  const subject = `Counter-offer accepted on ${sku}: ${counter}`
  return {
    subject,
    html: buildHtml(
      subject,
      [
        `The buyer accepted the counter-offer of ${strong(counter)} for ${strong(sku)}.`,
        "The stone is reserved and the buyer has 48 hours to pay.",
      ],
      ADMIN_URL,
      "Open GemWorkers admin",
    ),
    text: `The buyer accepted the counter-offer of ${counter} for ${sku}. The stone is reserved and the buyer has 48 hours to pay.\n${ADMIN_URL}\n`,
  }
}

function staffCounterDeclinedEmail(sku: string, counter: string): Email {
  const subject = `Counter-offer declined on ${sku}`
  return {
    subject,
    html: buildHtml(
      subject,
      [
        `The buyer declined the counter-offer of ${strong(counter)} for ${strong(sku)}.`,
        "The stone stays available.",
      ],
      ADMIN_URL,
      "Open GemWorkers admin",
    ),
    text: `The buyer declined the counter-offer of ${counter} for ${sku}. The stone stays available.\n${ADMIN_URL}\n`,
  }
}

function staffCounterExpiredEmail(sku: string, counter: string): Email {
  const subject = `Counter-offer expired on ${sku}`
  return {
    subject,
    html: buildHtml(
      subject,
      [
        `The buyer didn't answer the counter-offer of ${strong(counter)} for ${strong(sku)} within 48 hours, so it has expired.`,
        "The stone stays available.",
      ],
      ADMIN_URL,
      "Open GemWorkers admin",
    ),
    text: `The buyer didn't answer the counter-offer of ${counter} for ${sku} within 48 hours, so it has expired. The stone stays available.\n${ADMIN_URL}\n`,
  }
}

// ── Buyer emails (never mention the seller) ────────────────────────────────────

function buyerCounterEmail(stoneTitle: string, offered: string, counter: string, expiresAt: string, itemId: string): Email {
  const url     = stoneUrl(itemId)
  const subject = "We've sent you a counter-offer"
  return {
    subject,
    html: buildHtml(
      subject,
      [
        `Thank you for your offer of ${strong(offered)} for ${strong(stoneTitle)}. We can offer it to you for ${strong(counter)}.`,
        `This counter-offer is open until ${strong(`${expiresAt} UTC`)}. You can accept or decline it on the stone page.`,
      ],
      url,
      "View the counter-offer",
    ),
    text:
      `Thank you for your offer of ${offered} for ${stoneTitle}. We can offer it to you for ${counter}.\n\n` +
      `This counter-offer is open until ${expiresAt} UTC. You can accept or decline it on the stone page: ${url}\n`,
  }
}

function buyerCounterAcceptedEmail(stoneTitle: string, counter: string, total: string, shipping: number, dueAt: string): Email {
  const totalLine = shipping > 0 ? `${total} (including ${eur(shipping)} shipping)` : total
  const subject   = "Your stone is reserved"
  return {
    subject,
    html: buildHtml(
      subject,
      [
        `You accepted our counter-offer of ${strong(counter)} for ${strong(stoneTitle)}. The stone is reserved for you.`,
        `Total to pay: ${strong(totalLine)}`,
        `Please pay within 48 hours (by ${strong(`${dueAt} UTC`)}). After that the reservation ends and the stone goes back on sale.`,
      ],
      ORDERS_URL,
      "Pay now",
    ),
    text:
      `You accepted our counter-offer of ${counter} for ${stoneTitle}. The stone is reserved for you.\n\n` +
      `Total to pay: ${totalLine}\n\n` +
      `Please pay within 48 hours (by ${dueAt} UTC). After that the reservation ends and the stone goes back on sale.\n\n` +
      `Pay here: ${ORDERS_URL}\n`,
  }
}

function buyerCounterExpiredEmail(stoneTitle: string, counter: string, itemId: string): Email {
  const url     = stoneUrl(itemId)
  const subject = "Your counter-offer has expired"
  return {
    subject,
    html: buildHtml(
      subject,
      [
        `Our counter-offer of ${strong(counter)} for ${strong(stoneTitle)} was open for 48 hours and has now expired.`,
        "If you're still interested, you can view the stone here.",
      ],
      url,
      "View the stone",
    ),
    text: `Our counter-offer of ${counter} for ${stoneTitle} was open for 48 hours and has now expired.\n\nView the stone here: ${url}\n`,
  }
}

function buyerAcceptedEmail(stoneTitle: string, amount: string, total: string, shipping: number, dueAt: string): Email {
  const totalLine = shipping > 0 ? `${total} (including ${eur(shipping)} shipping)` : total
  const subject   = "Your offer was accepted"
  return {
    subject,
    html: buildHtml(
      subject,
      [
        `Good news &mdash; your offer of ${strong(amount)} for ${strong(stoneTitle)} was accepted. The stone is reserved for you.`,
        `Total to pay: ${strong(totalLine)}`,
        `Please pay within 48 hours (by ${strong(`${dueAt} UTC`)}). After that the reservation ends and the stone goes back on sale.`,
      ],
      ORDERS_URL,
      "Pay now",
    ),
    text:
      `Good news - your offer of ${amount} for ${stoneTitle} was accepted. The stone is reserved for you.\n\n` +
      `Total to pay: ${totalLine}\n\n` +
      `Please pay within 48 hours (by ${dueAt} UTC). After that the reservation ends and the stone goes back on sale.\n\n` +
      `Pay here: ${ORDERS_URL}\n`,
  }
}

function buyerPaymentReminderEmail(stoneTitle: string, total: string, shipping: number, dueAt: string): Email {
  const totalLine = shipping > 0 ? `${total} (including ${eur(shipping)} shipping)` : total
  const subject   = `Reminder: complete your payment for ${stoneTitle}`
  return {
    subject,
    html: buildHtml(
      subject,
      [
        `Total to pay: ${strong(totalLine)}`,
        `Your reserved stone is held until ${strong(`${dueAt} UTC`)} &mdash; please pay a little before then.`,
      ],
      ORDERS_URL,
      "Pay now",
    ),
    text:
      `Total to pay: ${totalLine}\n\n` +
      `Your reserved stone is held until ${dueAt} UTC - please pay a little before then.\n\n` +
      `Pay here: ${ORDERS_URL}\n`,
  }
}

function buyerDeclinedEmail(stoneTitle: string, amount: string, itemId: string, reservedByOther: boolean): Email {
  const url     = stoneUrl(itemId)
  const subject = "Your offer wasn't accepted this time"
  const reason  = reservedByOther
    ? "This stone has just been reserved by another buyer."
    : "We weren't able to accept it this time."
  return {
    subject,
    html: buildHtml(
      subject,
      [
        `Thank you for your offer of ${strong(amount)} for ${strong(stoneTitle)}. ${esc(reason)}`,
        "You're welcome to take another look at the stone.",
      ],
      url,
      "View the stone",
    ),
    text: `Thank you for your offer of ${amount} for ${stoneTitle}. ${reason}\n\nYou're welcome to take another look at the stone: ${url}\n`,
  }
}

function buyerExpiredEmail(stoneTitle: string, itemId: string): Email {
  const url     = stoneUrl(itemId)
  const subject = "Your payment window has ended"
  return {
    subject,
    html: buildHtml(
      subject,
      [
        `The 48-hour payment window for ${strong(stoneTitle)} has ended, so your reservation was released and the stone is available again.`,
        "If you're still interested, you can view it here.",
      ],
      url,
      "View the stone",
    ),
    text: `The 48-hour payment window for ${stoneTitle} has ended, so your reservation was released and the stone is available again.\n\nView it here: ${url}\n`,
  }
}

// ── Helpers ────────────────────────────────────────────────────────────────────

const json = (body: unknown, status = 200) =>
  new Response(JSON.stringify(body), {
    status,
    headers: { "Content-Type": "application/json" },
  })

// Only status transitions matter; the claim stamps' own UPDATEs fall through to null.
function classify(payload: WebhookPayload): OfferEvent | null {
  const now    = payload.record?.status
  const before = payload.old_record?.status
  if (payload.type === "INSERT") {
    return now === "pending" ? "new_offer" : null
  }
  if (payload.type === "UPDATE" && before !== now) {
    if (before === "pending"  && now === "accepted") return "accepted"
    if (before === "pending"  && now === "declined") return "declined"
    if (before === "accepted" && now === "expired")  return "expired"
    if (before === "pending"   && now === "countered") return "countered"
    if (before === "countered" && now === "accepted")  return "counter_accepted"
    if (before === "countered" && now === "declined")  return "counter_declined"
    if (before === "countered" && now === "expired")   return "counter_expired"
  }
  return null
}

async function claim(supabase: SupabaseClient, offerId: string, kind: ClaimKind): Promise<boolean> {
  const { data, error } = await supabase.rpc("claim_offer_notification", {
    p_offer_id: offerId,
    p_kind:     kind,
  })
  if (error) {
    console.error("[offer-notify] claim", kind, "failed for offer", offerId, "—", error.message)
    return false
  }
  return data === true
}

// One recipient per call — seller, owner and buyer never share a To: line.
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
      console.error("[offer-notify] Resend returned", res.status, "for", context, "—", await res.text())
      return false
    }
    return true
  } catch (e) {
    console.error("[offer-notify] fetch to Resend threw for", context, ":", e instanceof Error ? e.message : String(e))
    return false
  }
}

const sameAddress = (a: string, b: string) => a !== "" && b !== "" && a.toLowerCase() === b.toLowerCase()

// ── Payment reminder (pg_cron) ─────────────────────────────────────────────────

async function handlePaymentReminder(req: Request): Promise<Response> {
  // pg_cron must send the header: x-reminder-secret: <OFFER_REMINDER_SECRET>
  const expectedSecret = Deno.env.get("OFFER_REMINDER_SECRET")
  const incomingSecret = req.headers.get("x-reminder-secret")
  if (!expectedSecret || incomingSecret !== expectedSecret) {
    console.error("[offer-notify] Unauthorized reminder request — secret mismatch or missing")
    return json({ error: "Unauthorized" }, 401)
  }

  let payload: ReminderPayload
  try {
    payload = await req.json()
  } catch {
    console.error("[offer-notify] invalid JSON reminder payload")
    return json({ skipped: true, reason: "invalid JSON" })
  }

  if (payload.type === "REVIEW_INVITE") {
    return handleReviewInvite(payload as unknown as ReviewInvitePayload)
  }
  if (payload.type === "LISTING_EVENT") {
    return handleListingEvent(payload as unknown as ListingEventPayload)
  }
  if (payload.type === "RETURN_EVENT") {
    return handleReturnEvent(payload as unknown as ReturnEventPayload)
  }

  if (payload.type !== "PAYMENT_REMINDER" || !payload.order_id) {
    console.error("[offer-notify] malformed reminder payload — type", payload.type)
    return json({ skipped: true, reason: "malformed reminder payload" })
  }
  const orderId = payload.order_id

  const supabaseUrl        = Deno.env.get("SUPABASE_URL")
  const supabaseServiceKey = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")
  if (!supabaseUrl || !supabaseServiceKey) {
    console.error("[offer-notify] SUPABASE_URL or SUPABASE_SERVICE_ROLE_KEY not available")
    return json({ ok: true, emailsSent: 0, reason: "supabase env missing" })
  }

  const resendApiKey = Deno.env.get("RESEND_API_KEY")
  if (!resendApiKey) {
    console.error("[offer-notify] RESEND_API_KEY not set — reminder not sent")
    return json({ ok: true, emailsSent: 0, reason: "RESEND_API_KEY missing" })
  }

  const supabase = createClient(supabaseUrl, supabaseServiceKey, {
    auth: { autoRefreshToken: false, persistSession: false },
  })

  const { data: orderData, error: orderErr } = await supabase
    .from("orders")
    .select("id, status, buyer_id, offer_id, order_total, shipping_cost, payment_due_at")
    .eq("id", orderId)
    .maybeSingle()
  const order = orderData as ReminderOrderRow | null
  if (orderErr || !order) {
    console.error("[offer-notify] could not load order", orderId, "for reminder —", orderErr?.message)
    return json({ skipped: true, reason: "order not found" })
  }

  // Paid or cancelled since the cron job picked it — nothing to remind about.
  if (order.status !== "pending_payment") {
    console.log("[offer-notify] order", orderId, "is", order.status, "— reminder skipped")
    return json({ skipped: true, reason: "order no longer pending_payment" })
  }
  if (!order.offer_id || order.order_total == null || !order.payment_due_at) {
    console.error("[offer-notify] order", orderId, "missing offer_id, total or payment_due_at — reminder skipped")
    return json({ skipped: true, reason: "order incomplete" })
  }

  const { data: offerData, error: offerErr } = await supabase
    .from("storefront_offers")
    .select("inventory_item_id")
    .eq("id", order.offer_id)
    .maybeSingle()
  const itemId = (offerData as { inventory_item_id: string | null } | null)?.inventory_item_id ?? null
  if (offerErr || !itemId) {
    console.error("[offer-notify] could not load offer", order.offer_id, "for reminder —", offerErr?.message)
  }

  let stoneTitle = "your stone"
  if (itemId) {
    const { data: inv, error: invErr } = await supabase
      .from("inventory_items")
      .select("title")
      .eq("id", itemId)
      .maybeSingle()
    if (invErr) {
      console.error("[offer-notify] could not load stone", itemId, "—", invErr.message)
    }
    stoneTitle = (inv as { title: string | null } | null)?.title?.trim() || stoneTitle
  }

  const { data: userData, error: userErr } = await supabase.auth.admin.getUserById(order.buyer_id)
  const buyerAddr = userData?.user?.email?.trim() ?? ""
  if (userErr || !buyerAddr) {
    console.error("[offer-notify] could not resolve buyer email for order", orderId, userErr?.message)
    return json({ ok: true, emailsSent: 0, reason: "no buyer email" })
  }

  const email = buyerPaymentReminderEmail(
    stoneTitle,
    eur(Number(order.order_total)),
    Number(order.shipping_cost ?? 0),
    utcDate.format(new Date(order.payment_due_at)),
  )
  const sent = await sendEmail(resendApiKey, buyerAddr, email, `order ${orderId} payment_reminder (buyer)`)

  console.log("[offer-notify] order", orderId, "payment_reminder — emails sent:", sent ? 1 : 0, "of 1")
  return json({ ok: true, emailsSent: sent ? 1 : 0 })
}

// ── Review invite (pg_cron) ────────────────────────────────────────────────────
// send_review_invites (sql/reviews_setup.sql) stamps orders.review_invited_at
// and POSTs one checkout's eligible orders. Already authenticated by the
// x-reminder-secret check in handlePaymentReminder.

interface ReviewInvitePayload {
  type:      string
  order_ids: string[]
}

function buyerReviewInviteEmail(titles: string[]): Email {
  const one     = titles.length === 1
  const subject = one ? `How is your ${titles[0]}?` : "How are your new stones?"
  const what    = one ? strong(titles[0]) : "your stones"
  const list    = one ? "" : `<br>${titles.map(t => `&bull; ${esc(t)}`).join("<br>")}`
  return {
    subject,
    html: buildHtml(
      subject,
      [
        `We hope you love ${what}.${list}`,
        "Would you tell other collectors what you think? A star rating takes a few seconds; a few words and a photo help even more.",
      ],
      ORDERS_URL,
      "Write a review",
    ),
    text:
      `We hope you love ${one ? titles[0] : "your stones"}.\n` +
      (one ? "" : titles.map(t => `- ${t}`).join("\n") + "\n") +
      `\nWould you tell other collectors what you think? Write a review here: ${ORDERS_URL}\n`,
  }
}

async function handleReviewInvite(payload: ReviewInvitePayload): Promise<Response> {
  const ids = Array.isArray(payload.order_ids) ? payload.order_ids.filter(x => typeof x === "string") : []
  if (ids.length === 0) {
    return json({ skipped: true, reason: "no order_ids" })
  }

  const supabaseUrl        = Deno.env.get("SUPABASE_URL")
  const supabaseServiceKey = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")
  const resendApiKey       = Deno.env.get("RESEND_API_KEY")
  if (!supabaseUrl || !supabaseServiceKey || !resendApiKey) {
    console.error("[offer-notify] review invite: env missing (supabase or RESEND_API_KEY)")
    return json({ ok: true, emailsSent: 0, reason: "env missing" })
  }
  const supabase = createClient(supabaseUrl, supabaseServiceKey, {
    auth: { autoRefreshToken: false, persistSession: false },
  })

  const { data: ordersData, error: ordersErr } = await supabase
    .from("orders")
    .select("id, buyer_id, order_email, status")
    .in("id", ids)
  const orders = (ordersData as { id: string; buyer_id: string | null; order_email: string | null; status: string }[] | null) ?? []
  if (ordersErr || orders.length === 0) {
    console.error("[offer-notify] review invite: orders not found", ids, ordersErr?.message)
    return json({ skipped: true, reason: "orders not found" })
  }

  // Skip orders reviewed since the cron picked them.
  const { data: reviewed } = await supabase.from("reviews").select("order_id").in("order_id", ids)
  const done = new Set(((reviewed as { order_id: string }[] | null) ?? []).map(r => r.order_id))
  const open = orders.filter(o => !done.has(o.id) && o.status !== "cancelled")
  if (open.length === 0) {
    return json({ skipped: true, reason: "already reviewed" })
  }

  const { data: itemsData } = await supabase
    .from("order_items").select("order_id, inventory_item_id").in("order_id", open.map(o => o.id))
  const items = (itemsData as { order_id: string; inventory_item_id: string }[] | null) ?? []
  const { data: invData } = await supabase
    .from("inventory_items").select("id, title").in("id", [...new Set(items.map(i => i.inventory_item_id))])
  const titleOf = new Map(((invData as { id: string; title: string | null }[] | null) ?? []).map(i => [i.id, i.title?.trim() || "your stone"]))
  const titles = open.map(o => {
    const it = items.find(i => i.order_id === o.id)
    return (it && titleOf.get(it.inventory_item_id)) || "your stone"
  })

  let to = open.find(o => o.order_email)?.order_email?.trim() ?? ""
  if (!to && open[0].buyer_id) {
    const { data: userData } = await supabase.auth.admin.getUserById(open[0].buyer_id)
    to = userData?.user?.email?.trim() ?? ""
  }
  if (!to) {
    console.error("[offer-notify] review invite: no buyer email for orders", ids)
    return json({ ok: true, emailsSent: 0, reason: "no buyer email" })
  }

  const sent = await sendEmail(resendApiKey, to, buyerReviewInviteEmail(titles), `review invite ${ids.join(",")} (buyer)`)
  console.log("[offer-notify] review invite for", ids.length, "order(s) — emails sent:", sent ? 1 : 0)
  return json({ ok: true, emailsSent: sent ? 1 : 0 })
}

// ── Listing approval (DB trigger) ──────────────────────────────────────────────
// inventory_listing_decision_notify (sql/listing_decision_emails.sql):
//   requested → owner ("New listing waiting for approval")
//   approved  → seller ("Your stone is live")
//   rejected  → seller ("Listing not approved" + the owner's optional reason)
// Staff-only emails: seller names are fine here; nothing goes to buyers.

interface ListingEventPayload {
  type:    string
  item_id: string
  event:   string
}

function ownerListingRequestEmail(sku: string, title: string, sellerName: string): Email {
  const subject = `New listing waiting for approval: ${sku}`
  return {
    subject,
    html: buildHtml(
      subject,
      [`${strong(sellerName)} sent ${strong(title)} (${esc(sku)}) for approval. Approve or reject it in Listings → Awaiting approval.`],
      ADMIN_URL,
      "Open GemWorkers admin",
    ),
    text: `${sellerName} sent ${title} (${sku}) for approval. Approve or reject it in Listings → Awaiting approval: ${ADMIN_URL}\n`,
  }
}

function sellerListingApprovedEmail(sku: string, title: string, itemId: string): Email {
  const url     = stoneUrl(itemId)
  const subject = `Your stone is live: ${title}`
  return {
    subject,
    html: buildHtml(
      subject,
      [`Good news — ${strong(title)} (${esc(sku)}) was approved and is now for sale on GemWorkers.`],
      url,
      "View it on the store",
    ),
    text: `Good news - ${title} (${sku}) was approved and is now for sale on GemWorkers.\n\nView it: ${url}\n`,
  }
}

function sellerListingRejectedEmail(sku: string, title: string, note: string): Email {
  const subject = `Listing not approved: ${title}`
  const reason  = note
    ? [`Reason: ${strong(note)}`]
    : []
  return {
    subject,
    html: buildHtml(
      subject,
      [
        `${strong(title)} (${esc(sku)}) was not approved for the store yet. It is back in your Drafts.`,
        ...reason,
        "Please update the stone and send it for approval again.",
      ],
      ADMIN_URL,
      "Open GemWorkers admin",
    ),
    text:
      `${title} (${sku}) was not approved for the store yet. It is back in your Drafts.\n` +
      (note ? `Reason: ${note}\n` : "") +
      `\nPlease update the stone and send it for approval again: ${ADMIN_URL}\n`,
  }
}

async function handleListingEvent(payload: ListingEventPayload): Promise<Response> {
  const event = payload.event
  if (!payload.item_id || !["requested", "approved", "rejected"].includes(event)) {
    return json({ skipped: true, reason: "malformed listing event" })
  }

  const supabaseUrl        = Deno.env.get("SUPABASE_URL")
  const supabaseServiceKey = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")
  const resendApiKey       = Deno.env.get("RESEND_API_KEY")
  if (!supabaseUrl || !supabaseServiceKey || !resendApiKey) {
    console.error("[offer-notify] listing event: env missing (supabase or RESEND_API_KEY)")
    return json({ ok: true, emailsSent: 0, reason: "env missing" })
  }
  const supabase = createClient(supabaseUrl, supabaseServiceKey, {
    auth: { autoRefreshToken: false, persistSession: false },
  })

  const { data: itemData, error: itemErr } = await supabase
    .from("inventory_items")
    .select("id, sku, title, seller_id, listing_review_note")
    .eq("id", payload.item_id)
    .maybeSingle()
  const item = itemData as { id: string; sku: string | null; title: string | null; seller_id: string | null; listing_review_note: string | null } | null
  if (itemErr || !item) {
    console.error("[offer-notify] listing event: stone not found", payload.item_id, itemErr?.message)
    return json({ skipped: true, reason: "stone not found" })
  }
  const sku   = item.sku?.trim()   || "a stone"
  const title = item.title?.trim() || "your stone"

  let seller: { name: string | null; email: string | null } | null = null
  if (item.seller_id) {
    const { data } = await supabase.from("sellers").select("name, email").eq("id", item.seller_id).maybeSingle()
    seller = data as { name: string | null; email: string | null } | null
  }
  const ownerEmail  = Deno.env.get("OWNER_EMAIL")?.trim() ?? ""
  const sellerEmail = seller?.email?.trim() ?? ""

  let to = ""
  let email: Email
  if (event === "requested") {
    to    = ownerEmail
    email = ownerListingRequestEmail(sku, title, seller?.name?.trim() || "A seller")
  } else {
    // The owner made the decision; skip when the seller's inbox is the owner's.
    if (sameAddress(sellerEmail, ownerEmail)) {
      return json({ skipped: true, reason: "seller is owner" })
    }
    to    = sellerEmail
    email = event === "approved"
      ? sellerListingApprovedEmail(sku, title, item.id)
      : sellerListingRejectedEmail(sku, title, item.listing_review_note?.trim() ?? "")
  }

  if (!to) {
    console.log("[offer-notify] listing", event, "for", item.id, "— no recipient email")
    return json({ ok: true, emailsSent: 0, reason: "no recipient" })
  }

  const sent = await sendEmail(resendApiKey, to, email, `listing ${event} ${item.id}`)
  console.log("[offer-notify] listing", event, "for", item.id, "— emails sent:", sent ? 1 : 0)
  return json({ ok: true, emailsSent: sent ? 1 : 0 })
}

// ── Returns (DB trigger) ───────────────────────────────────────────────────────
// returns_notify (sql/returns_setup.sql), once per status change:
//   requested → owner ("Return requested")
//   approved  → buyer (return address + packing / customs steps)
//   rejected  → buyer (with the owner's reason)
//   refunded  → buyer (amount refunded)
// Buyer emails name the stone only — never the seller.

interface ReturnEventPayload {
  type:      string
  return_id: string
  event:     string
}

function ownerReturnRequestedEmail(orderNumber: string, title: string, reason: string, faulty: boolean): Email {
  const subject = `Return requested: ${orderNumber}`
  const lines = [
    `A buyer wants to return ${strong(title)} (order ${esc(orderNumber)}).`,
    ...(faulty ? [strong("They say it is damaged or not as described.")] : []),
    ...(reason ? [`Reason: ${esc(reason)}`] : []),
    "Approve or reject it in the admin under Returns.",
  ]
  return {
    subject,
    html: buildHtml(subject, lines, ADMIN_URL, "Open GemWorkers admin"),
    text:
      `A buyer wants to return ${title} (order ${orderNumber}).\n` +
      (faulty ? "They say it is damaged or not as described.\n" : "") +
      (reason ? `Reason: ${reason}\n` : "") +
      `\nApprove or reject it in the admin under Returns: ${ADMIN_URL}\n`,
  }
}

function buyerReturnApprovedEmail(title: string, orderNumber: string, address: string, faulty: boolean, note: string): Email {
  const subject = `Your return is approved: ${title}`
  const steps = [
    "Pack the stone well, with its certificate and the original packaging.",
    `Use a tracked and insured service${faulty ? " — we refund your return shipping" : ""}.`,
    "Sending from outside the EU? Mark the customs form “Returned goods” and add your order number.",
    "Add your tracking number in My orders.",
  ]
  return {
    subject,
    html: buildHtml(
      subject,
      [
        `Please send ${strong(title)} (order ${esc(orderNumber)}) within 14 days to:`,
        esc(address).replace(/\n/g, "<br>"),
        ...steps.map(esc),
        ...(note ? [`Note from GemWorkers: ${esc(note)}`] : []),
        "We refund you once the stone has arrived and been checked.",
      ],
      ORDERS_URL,
      "Open My orders",
    ),
    text:
      `Please send ${title} (order ${orderNumber}) within 14 days to:\n\n${address}\n\n` +
      steps.map(s => `- ${s}`).join("\n") +
      (note ? `\n\nNote from GemWorkers: ${note}` : "") +
      `\n\nWe refund you once the stone has arrived and been checked.\nMy orders: ${ORDERS_URL}\n`,
  }
}

function buyerReturnRejectedEmail(title: string, orderNumber: string, note: string): Email {
  const subject = `About your return: ${title}`
  return {
    subject,
    html: buildHtml(
      subject,
      [
        `We can't accept the return of ${strong(title)} (order ${esc(orderNumber)}).`,
        ...(note ? [`Reason: ${esc(note)}`] : []),
        "Questions? Just reply to hello@gemworkers.com.",
      ],
      ORDERS_URL,
      "Open My orders",
    ),
    text:
      `We can't accept the return of ${title} (order ${orderNumber}).\n` +
      (note ? `Reason: ${note}\n` : "") +
      `\nQuestions? Email hello@gemworkers.com.\nMy orders: ${ORDERS_URL}\n`,
  }
}

function buyerReturnRefundedEmail(title: string, orderNumber: string, amount: string, deductionReason: string): Email {
  const subject = `Refund sent: ${title}`
  return {
    subject,
    html: buildHtml(
      subject,
      [
        `We've refunded ${strong(amount)} for ${strong(title)} (order ${esc(orderNumber)}) to your original payment method.`,
        ...(deductionReason ? [`A deduction was made: ${esc(deductionReason)}`] : []),
        "It usually appears on your statement within 5–10 business days.",
      ],
      ORDERS_URL,
      "Open My orders",
    ),
    text:
      `We've refunded ${amount} for ${title} (order ${orderNumber}) to your original payment method.\n` +
      (deductionReason ? `A deduction was made: ${deductionReason}\n` : "") +
      `It usually appears on your statement within 5-10 business days.\n\nMy orders: ${ORDERS_URL}\n`,
  }
}

async function handleReturnEvent(payload: ReturnEventPayload): Promise<Response> {
  const event = payload.event
  if (!payload.return_id || !["requested", "approved", "rejected", "refunded"].includes(event)) {
    return json({ skipped: true, reason: "malformed return event" })
  }

  const supabaseUrl        = Deno.env.get("SUPABASE_URL")
  const supabaseServiceKey = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")
  const resendApiKey       = Deno.env.get("RESEND_API_KEY")
  if (!supabaseUrl || !supabaseServiceKey || !resendApiKey) {
    console.error("[offer-notify] return event: env missing (supabase or RESEND_API_KEY)")
    return json({ ok: true, emailsSent: 0, reason: "env missing" })
  }
  const supabase = createClient(supabaseUrl, supabaseServiceKey, {
    auth: { autoRefreshToken: false, persistSession: false },
  })

  const { data: retData, error: retErr } = await supabase
    .from("returns")
    .select("id, order_id, buyer_id, status, reason, faulty, return_address, decision_note, refund_amount, deduction_reason")
    .eq("id", payload.return_id)
    .maybeSingle()
  const ret = retData as {
    id: string; order_id: string; buyer_id: string; status: string; reason: string | null; faulty: boolean
    return_address: string | null; decision_note: string | null
    refund_amount: number | string | null; deduction_reason: string | null
  } | null
  if (retErr || !ret) {
    console.error("[offer-notify] return event: return not found", payload.return_id, retErr?.message)
    return json({ skipped: true, reason: "return not found" })
  }
  // A late delivery after another change: only send for the current status.
  if (ret.status !== event) return json({ skipped: true, reason: "status changed" })

  const { data: ordData } = await supabase
    .from("orders").select("order_number, order_email").eq("id", ret.order_id).maybeSingle()
  const ord = ordData as { order_number: string | null; order_email: string | null } | null
  const orderNumber = ord?.order_number ?? "your order"

  const { data: itemRows } = await supabase
    .from("order_items").select("inventory_items ( title )").eq("order_id", ret.order_id).limit(1)
  const title = ((itemRows as unknown as { inventory_items: { title: string | null } | null }[] | null)?.[0]
    ?.inventory_items?.title ?? "").trim() || "your stone"

  let to = ""
  let email: Email
  if (event === "requested") {
    to    = Deno.env.get("OWNER_EMAIL")?.trim() ?? ""
    email = ownerReturnRequestedEmail(orderNumber, title, ret.reason?.trim() ?? "", ret.faulty)
  } else {
    to = ord?.order_email?.trim() ?? ""
    if (!to) {
      const { data } = await supabase.auth.admin.getUserById(ret.buyer_id)
      to = data?.user?.email?.trim() ?? ""
    }
    email =
      event === "approved" ? buyerReturnApprovedEmail(title, orderNumber, ret.return_address ?? "", ret.faulty, ret.decision_note?.trim() ?? "")
      : event === "rejected" ? buyerReturnRejectedEmail(title, orderNumber, ret.decision_note?.trim() ?? "")
      : buyerReturnRefundedEmail(title, orderNumber, eur(Number(ret.refund_amount ?? 0)), ret.deduction_reason?.trim() ?? "")
  }

  if (!to) {
    console.log("[offer-notify] return", event, "for", ret.id, "— no recipient email")
    return json({ ok: true, emailsSent: 0, reason: "no recipient" })
  }

  const sent = await sendEmail(resendApiKey, to, email, `return ${event} ${ret.id}`)
  console.log("[offer-notify] return", event, "for", ret.id, "— emails sent:", sent ? 1 : 0)
  return json({ ok: true, emailsSent: sent ? 1 : 0 })
}

// ── Handler ────────────────────────────────────────────────────────────────────

Deno.serve(async (req: Request) => {
  // Reminder calls come from pg_cron with their own secret, not from the webhook.
  if (req.headers.has("x-reminder-secret")) {
    return handlePaymentReminder(req)
  }

  // ── 1. Secret verification ─────────────────────────────────────────────────
  // Supabase webhook must send the header: x-webhook-secret: <OFFER_WEBHOOK_SECRET>
  const expectedSecret = Deno.env.get("OFFER_WEBHOOK_SECRET")
  const incomingSecret = req.headers.get("x-webhook-secret")
  if (!expectedSecret || incomingSecret !== expectedSecret) {
    console.error("[offer-notify] Unauthorized request — secret mismatch or missing")
    return json({ error: "Unauthorized" }, 401)
  }

  // From here on, always 200 so Supabase doesn't retry and double-send.

  // ── 2. Parse payload + classify ────────────────────────────────────────────
  let payload: WebhookPayload
  try {
    payload = await req.json()
  } catch {
    console.error("[offer-notify] invalid JSON payload")
    return json({ skipped: true, reason: "invalid JSON" })
  }

  if (payload.table !== "storefront_offers") {
    return json({ skipped: true, reason: "not storefront_offers" })
  }

  const offer = payload.record
  if (!offer?.id || !offer.buyer_id || !offer.seller_id || !offer.inventory_item_id) {
    console.error("[offer-notify] malformed record — missing id, buyer_id, seller_id or inventory_item_id")
    return json({ skipped: true, reason: "malformed record" })
  }

  const event = classify(payload)
  if (!event) {
    return json({ skipped: true, reason: "no email for this change" })
  }

  // ── 3. Env ─────────────────────────────────────────────────────────────────
  const supabaseUrl        = Deno.env.get("SUPABASE_URL")
  const supabaseServiceKey = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")
  if (!supabaseUrl || !supabaseServiceKey) {
    console.error("[offer-notify] SUPABASE_URL or SUPABASE_SERVICE_ROLE_KEY not available")
    return json({ ok: true, emailsSent: 0, reason: "supabase env missing" })
  }

  const resendApiKey = Deno.env.get("RESEND_API_KEY")
  if (!resendApiKey) {
    // Checked before claiming so a missing key doesn't burn the one-time claim.
    console.error("[offer-notify] RESEND_API_KEY not set — no emails sent")
    return json({ ok: true, emailsSent: 0, reason: "RESEND_API_KEY missing" })
  }

  const supabase = createClient(supabaseUrl, supabaseServiceKey, {
    auth: { autoRefreshToken: false, persistSession: false },
  })

  // ── 4. Shared lookups ──────────────────────────────────────────────────────
  const { data: inv, error: invErr } = await supabase
    .from("inventory_items")
    .select("sku, title")
    .eq("id", offer.inventory_item_id)
    .single()
  if (invErr) {
    console.error("[offer-notify] could not load stone", offer.inventory_item_id, "—", invErr.message)
  }
  const invRow     = inv as { sku: string | null; title: string | null } | null
  const sku        = invRow?.sku?.trim()   || "a stone"
  const stoneTitle = invRow?.title?.trim() || "your stone"
  const amount     = eur(Number(offer.offered_price))
  // Set once the offer was countered; an accepted offer with a counter price
  // was accepted at that price.
  const counterAmount = offer.counter_price != null ? eur(Number(offer.counter_price)) : null

  if (event.startsWith("counter") && !counterAmount) {
    console.error("[offer-notify] offer", offer.id, "event", event, "has no counter_price — no email")
    return json({ skipped: true, reason: "counter_price missing" })
  }

  const ownerEmail = Deno.env.get("OWNER_EMAIL")?.trim() ?? ""
  if (!ownerEmail && event !== "declined") {
    console.error("[offer-notify] OWNER_EMAIL not set — owner not emailed")
  }

  async function loadSellerEmail(): Promise<string> {
    const { data, error } = await supabase
      .from("sellers")
      .select("email")
      .eq("id", offer!.seller_id)
      .single()
    if (error) {
      console.error("[offer-notify] could not load seller", offer!.seller_id, "—", error.message)
    }
    const addr = (data as { email: string | null } | null)?.email?.trim() ?? ""
    if (!addr) {
      console.log("[offer-notify] seller", offer!.seller_id, "has no email — seller not emailed")
    }
    return addr
  }

  async function loadBuyerEmail(): Promise<string> {
    const { data, error } = await supabase.auth.admin.getUserById(offer!.buyer_id)
    const addr = data?.user?.email?.trim() ?? ""
    if (error || !addr) {
      console.error("[offer-notify] could not resolve buyer email for offer", offer!.id, error?.message)
    }
    return addr
  }

  // Each send is queued here, then sent only after the claim succeeds.
  const outbox: { to: string; email: Email; who: string }[] = []

  // Seller + owner as separate emails, or one email when they share an inbox.
  function queueStaff(sellerEmail: string, email: Email) {
    if (sameAddress(sellerEmail, ownerEmail)) {
      outbox.push({ to: ownerEmail, email, who: "seller+owner" })
      return
    }
    if (sellerEmail) outbox.push({ to: sellerEmail, email, who: "seller" })
    if (ownerEmail)  outbox.push({ to: ownerEmail,  email, who: "owner" })
  }

  // ── 5. Build emails per event ──────────────────────────────────────────────
  switch (event) {
    case "new_offer": {
      queueStaff(await loadSellerEmail(), staffNewOfferEmail(sku, amount))
      break
    }

    case "accepted": {
      const buyerAddr = await loadBuyerEmail()

      const { data: orderData, error: orderErr } = await supabase
        .from("orders")
        .select("order_total, shipping_cost, payment_due_at")
        .eq("offer_id", offer.id)
        .order("created_at", { ascending: false })
        .limit(1)
        .maybeSingle()
      const order = orderData as OrderRow | null
      if (orderErr || !order || order.order_total == null || !order.payment_due_at) {
        // Without the total and deadline the buyer email would be misleading — don't send it.
        console.error("[offer-notify] no order with total + payment_due_at for accepted offer", offer.id, orderErr?.message)
      } else if (buyerAddr) {
        outbox.push({
          to:  buyerAddr,
          who: "buyer",
          email: buyerAcceptedEmail(
            stoneTitle,
            amount,
            eur(Number(order.order_total)),
            Number(order.shipping_cost ?? 0),
            utcDate.format(new Date(order.payment_due_at)),
          ),
        })
      }

      // The staff side that didn't act; skipped when it's the same inbox as the actor.
      const actedBy = offer.responded_by_role
      if (actedBy === "seller" || actedBy === "owner") {
        const sellerEmail = await loadSellerEmail()
        const other       = actedBy === "seller" ? ownerEmail : sellerEmail
        const actor       = actedBy === "seller" ? sellerEmail : ownerEmail
        if (other && !sameAddress(other, actor)) {
          outbox.push({
            to:    other,
            who:   actedBy === "seller" ? "owner" : "seller",
            email: staffAcceptedEmail(sku, amount, actedBy),
          })
        }
      } else {
        console.log("[offer-notify] accepted offer", offer.id, "has responded_by_role", actedBy, "— no staff email")
      }
      break
    }

    case "declined": {
      const buyerAddr = await loadBuyerEmail()
      if (buyerAddr) {
        outbox.push({
          to:    buyerAddr,
          who:   "buyer",
          email: buyerDeclinedEmail(stoneTitle, amount, offer.inventory_item_id, offer.responded_by_role === "system"),
        })
      }
      break
    }

    case "expired": {
      const buyerAddr = await loadBuyerEmail()
      if (buyerAddr) {
        outbox.push({ to: buyerAddr, who: "buyer", email: buyerExpiredEmail(stoneTitle, offer.inventory_item_id) })
      }
      queueStaff(await loadSellerEmail(), staffExpiredEmail(sku, counterAmount ?? amount))
      break
    }

    case "countered": {
      const buyerAddr = await loadBuyerEmail()
      if (!offer.counter_expires_at) {
        console.error("[offer-notify] countered offer", offer.id, "has no counter_expires_at — buyer not emailed")
      } else if (buyerAddr) {
        outbox.push({
          to:  buyerAddr,
          who: "buyer",
          email: buyerCounterEmail(
            stoneTitle,
            amount,
            counterAmount!,
            utcDate.format(new Date(offer.counter_expires_at)),
            offer.inventory_item_id,
          ),
        })
      }

      // The staff side that didn't act; skipped when it's the same inbox as the actor.
      const actedBy = offer.countered_by_role
      if (actedBy === "seller" || actedBy === "owner") {
        const sellerEmail = await loadSellerEmail()
        const other       = actedBy === "seller" ? ownerEmail : sellerEmail
        const actor       = actedBy === "seller" ? sellerEmail : ownerEmail
        if (other && !sameAddress(other, actor)) {
          outbox.push({
            to:    other,
            who:   actedBy === "seller" ? "owner" : "seller",
            email: staffCounterSentEmail(sku, amount, counterAmount!, actedBy),
          })
        }
      }
      break
    }

    case "counter_accepted": {
      const buyerAddr = await loadBuyerEmail()

      const { data: orderData, error: orderErr } = await supabase
        .from("orders")
        .select("order_total, shipping_cost, payment_due_at")
        .eq("offer_id", offer.id)
        .order("created_at", { ascending: false })
        .limit(1)
        .maybeSingle()
      const order = orderData as OrderRow | null
      if (orderErr || !order || order.order_total == null || !order.payment_due_at) {
        // Without the total and deadline the buyer email would be misleading — don't send it.
        console.error("[offer-notify] no order with total + payment_due_at for accepted counter", offer.id, orderErr?.message)
      } else if (buyerAddr) {
        outbox.push({
          to:  buyerAddr,
          who: "buyer",
          email: buyerCounterAcceptedEmail(
            stoneTitle,
            counterAmount!,
            eur(Number(order.order_total)),
            Number(order.shipping_cost ?? 0),
            utcDate.format(new Date(order.payment_due_at)),
          ),
        })
      }

      queueStaff(await loadSellerEmail(), staffCounterAcceptedEmail(sku, counterAmount!))
      break
    }

    case "counter_declined": {
      if (offer.responded_by_role === "system") {
        // Another buyer's offer was accepted while this counter was open.
        const buyerAddr = await loadBuyerEmail()
        if (buyerAddr) {
          outbox.push({
            to:    buyerAddr,
            who:   "buyer",
            email: buyerDeclinedEmail(stoneTitle, amount, offer.inventory_item_id, true),
          })
        }
      } else {
        queueStaff(await loadSellerEmail(), staffCounterDeclinedEmail(sku, counterAmount!))
      }
      break
    }

    case "counter_expired": {
      const buyerAddr = await loadBuyerEmail()
      if (buyerAddr) {
        outbox.push({
          to:    buyerAddr,
          who:   "buyer",
          email: buyerCounterExpiredEmail(stoneTitle, counterAmount!, offer.inventory_item_id),
        })
      }
      queueStaff(await loadSellerEmail(), staffCounterExpiredEmail(sku, counterAmount!))
      break
    }
  }

  if (outbox.length === 0) {
    console.log("[offer-notify] offer", offer.id, "event", event, "— no recipients")
    return json({ ok: true, emailsSent: 0, reason: "no recipients" })
  }

  // ── 6. Claim once, then send ───────────────────────────────────────────────
  const kind = CLAIM_KIND[event]
  if (!await claim(supabase, offer.id, kind)) {
    console.log("[offer-notify] offer", offer.id, "event", event, "— already notified, skipping")
    return json({ skipped: true, reason: "already notified" })
  }

  let sent = 0
  for (const m of outbox) {
    if (await sendEmail(resendApiKey, m.to, m.email, `offer ${offer.id} ${event} (${m.who})`)) sent++
  }

  console.log("[offer-notify] offer", offer.id, "event", event, "— emails sent:", sent, "of", outbox.length)
  return json({ ok: true, emailsSent: sent })
})
