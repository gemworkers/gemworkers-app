// Supabase Edge Function — seller-invite
// Called by the Flutter admin app (owner only) to invite a seller. It creates
// the auth user with a Supabase invite link (generateLink) and emails that
// link itself via Resend — not Supabase's rate-limited built-in mailer. The
// seller sets a password on /seller/accept-invite, then logs in to the admin.
// The function also creates the user_profiles row linking the auth user to the
// seller record so current_seller_id() RLS works immediately on first sign-in.

import { createClient, type SupabaseClient } from "@supabase/supabase-js"

// ── CORS headers — included on every response so browser clients don't block ──

const corsHeaders = {
  "Access-Control-Allow-Origin":  "*",
  "Access-Control-Allow-Methods": "POST, OPTIONS",
  "Access-Control-Allow-Headers": "authorization, x-client-info, apikey, content-type",
}

// ── Response helper ────────────────────────────────────────────────────────────

const json = (body: unknown, status = 200) =>
  new Response(JSON.stringify(body), {
    status,
    headers: { "Content-Type": "application/json", ...corsHeaders },
  })

// ── Existing login ─────────────────────────────────────────────────────────────
// The email already has an auth user. Link it to this seller unless it is the
// owner's login or still belongs to another existing seller, then email a
// recovery ("set your password") link through Resend. The accept-invite page
// accepts both invite and recovery links.

type AdminClient = SupabaseClient

// Invite / set-password email via Resend (same sender as the order emails).
// Returns null on success, or a short error.
async function sendSetPasswordEmail(to: string, link: string, subject: string): Promise<string | null> {
  const resendApiKey = Deno.env.get("RESEND_API_KEY")
  if (!resendApiKey) {
    console.error("[seller-invite] RESEND_API_KEY not set — email not sent")
    return "email not configured"
  }
  const res = await fetch("https://api.resend.com/emails", {
    method: "POST",
    headers: { "Authorization": `Bearer ${resendApiKey}`, "Content-Type": "application/json" },
    body: JSON.stringify({
      from: "GemWorkers <orders@gemworkers.com>",
      to: [to],
      subject,
      html:
        `<p style="font-family:Arial,sans-serif;font-size:15px">Your GemWorkers seller account is ready.</p>` +
        `<p style="font-family:Arial,sans-serif;font-size:15px">Click the button to choose your password, then log in at sell.gemworkers.com.</p>` +
        `<p><a href="${link}" style="display:inline-block;padding:12px 20px;background:#111;color:#fff;font-family:Arial,sans-serif;font-size:14px;text-decoration:none;border-radius:6px">Set my password</a></p>` +
        `<p style="font-family:Arial,sans-serif;font-size:12px;color:#6b7280">If you didn't expect this email, you can ignore it.</p>`,
      text: `Your GemWorkers seller account is ready.\n\nChoose your password here, then log in at sell.gemworkers.com:\n${link}\n`,
    }),
  })
  if (!res.ok) {
    console.error("[seller-invite] Resend returned", res.status, "for", to, "—", await res.text())
    return `Resend ${res.status}`
  }
  return null
}

async function findUserIdByEmail(admin: AdminClient, email: string): Promise<string | null> {
  const target = email.toLowerCase()
  for (let page = 1; page <= 20; page++) {
    const { data, error } = await admin.auth.admin.listUsers({ page, perPage: 200 })
    if (error) {
      console.error("[seller-invite] listUsers failed:", error.message)
      return null
    }
    const hit = data.users.find(u => u.email?.toLowerCase() === target)
    if (hit) return hit.id
    if (data.users.length < 200) return null
  }
  return null
}

async function relinkExistingLogin(
  admin: AdminClient,
  sellerId: string,
  sellerEmail: string,
  redirectTo: string,
): Promise<Response> {
  const userId = await findUserIdByEmail(admin, sellerEmail)
  if (!userId) {
    console.error("[seller-invite] login exists but could not be found for", sellerEmail)
    return json({ error: "This email already has a login, but it could not be found. Please try again." }, 500)
  }

  const { data: existing } = await admin
    .from("user_profiles")
    .select("role, seller_id")
    .eq("id", userId)
    .maybeSingle()
  const prof = existing as { role: string | null; seller_id: string | null } | null

  if (prof?.role === "owner") {
    return json({ error: "This email is the owner's own login. Please use a different email for the seller." }, 400)
  }

  if (prof?.seller_id && prof.seller_id !== sellerId) {
    const { data: other } = await admin.from("sellers").select("name").eq("id", prof.seller_id).maybeSingle()
    if (other) {
      const name = (other as { name: string | null }).name ?? "another seller"
      return json({ error: `This email is already the login for ${name}. Please use a different email.` }, 409)
    }
  }

  const { error: upsertErr } = await admin
    .from("user_profiles")
    .upsert({ id: userId, role: "seller", seller_id: sellerId }, { onConflict: "id" })
  if (upsertErr) {
    console.error("[seller-invite] relink failed for", userId, ":", upsertErr.message)
    return json({ error: `Could not reconnect the login: ${upsertErr.message}` }, 500)
  }

  const { data: link, error: linkErr } = await admin.auth.admin.generateLink({
    type: "recovery",
    email: sellerEmail,
    options: { redirectTo },
  })
  const actionLink = link?.properties?.action_link
  if (linkErr || !actionLink) {
    console.error("[seller-invite] recovery link failed for", sellerEmail, ":", linkErr?.message)
    return json({ error: "Login reconnected, but the set-password link could not be created." }, 500)
  }

  const sendErr = await sendSetPasswordEmail(sellerEmail, actionLink, "Set your GemWorkers seller password")
  if (sendErr) {
    return json({ error: `Login reconnected, but the email could not be sent: ${sendErr}. Please try again.` }, 502)
  }

  console.log("[seller-invite] relinked existing login", userId, "to seller", sellerId, "and emailed a set-password link")
  return json({
    ok: true,
    relinked: true,
    message: `This email already had a login. It is now connected to this seller and a set-password link was emailed to ${sellerEmail}.`,
  })
}

// ── Handler ────────────────────────────────────────────────────────────────────

Deno.serve(async (req: Request) => {
  // ── CORS preflight ─────────────────────────────────────────────────────────
  // The Supabase Flutter client sends an OPTIONS preflight before POST.
  if (req.method === "OPTIONS") {
    return new Response(null, {
      status: 204,
      headers: corsHeaders,
    })
  }

  if (req.method !== "POST") {
    return json({ error: "Method not allowed" }, 405)
  }

  // ── 1. Build the service-role admin client ─────────────────────────────────
  // SUPABASE_URL and SUPABASE_SERVICE_ROLE_KEY are auto-injected by the Edge
  // Runtime — no manual secrets set needed for these two.
  const supabaseUrl        = Deno.env.get("SUPABASE_URL")
  const supabaseServiceKey = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")
  if (!supabaseUrl || !supabaseServiceKey) {
    console.error("[seller-invite] SUPABASE_URL or SUPABASE_SERVICE_ROLE_KEY not available")
    return json({ error: "Server misconfigured" }, 500)
  }

  const admin = createClient(supabaseUrl, supabaseServiceKey, {
    auth: { autoRefreshToken: false, persistSession: false },
  })

  // ── 2. Verify the caller is the owner ──────────────────────────────────────
  // The Supabase Flutter client automatically sends the signed-in user's JWT as
  // "Authorization: Bearer <token>". We validate it and check user_profiles.
  const authHeader = req.headers.get("Authorization") ?? ""
  const jwt = authHeader.replace("Bearer ", "").trim()
  if (!jwt) {
    return json({ error: "Unauthorized" }, 401)
  }

  const { data: { user }, error: authErr } = await admin.auth.getUser(jwt)
  if (authErr || !user) {
    console.error("[seller-invite] JWT validation failed:", authErr?.message)
    return json({ error: "Unauthorized" }, 401)
  }

  const { data: profile, error: profileErr } = await admin
    .from("user_profiles")
    .select("role")
    .eq("id", user.id)
    .single()

  if (profileErr || !profile) {
    console.error("[seller-invite] user_profiles lookup failed for", user.id, profileErr?.message)
    return json({ error: "Unauthorized" }, 401)
  }

  if (profile.role !== "owner") {
    console.error("[seller-invite] caller is not owner — role:", profile.role, "uid:", user.id)
    return json({ error: "Forbidden" }, 403)
  }

  // ── 3. Parse request body ──────────────────────────────────────────────────
  let body: { seller_id?: string }
  try {
    body = await req.json()
  } catch {
    return json({ error: "Invalid JSON" }, 400)
  }

  const { seller_id } = body
  if (!seller_id) {
    return json({ error: "Missing seller_id" }, 400)
  }

  // ── 4. Look up the seller row ──────────────────────────────────────────────
  // Never trust an email from the request body — always read it from the DB.
  const { data: seller, error: sellerErr } = await admin
    .from("sellers")
    .select("id, email, name, contact_name, status")
    .eq("id", seller_id)
    .single()

  if (sellerErr || !seller) {
    console.error("[seller-invite] seller not found:", seller_id, sellerErr?.message)
    return json({ error: "Seller not found" }, 404)
  }

  const sellerEmail = (seller.email as string | null)?.trim() ?? ""
  if (!sellerEmail) {
    return json({ error: "Seller has no email address — add one before inviting" }, 400)
  }

  // ── 5. Send the invite ─────────────────────────────────────────────────────
  // redirectTo points to the Next.js storefront page that handles the
  // accept-invite flow (password-set form). After setting their password the
  // seller logs in via the Flutter admin app using email + password.
  const redirectTo = "https://gemworkers.com/seller/accept-invite"

  // generateLink creates the invited user and returns the link WITHOUT
  // Supabase's built-in mailer (heavily rate-limited); we send it via Resend.
  const { data: invited, error: inviteErr } =
    await admin.auth.admin.generateLink({ type: "invite", email: sellerEmail, options: { redirectTo } })

  if (inviteErr) {
    // Supabase returns a "User already registered" style error when the email
    // already exists in auth.users. Treat this as a safe, non-fatal case —
    // the seller was previously invited or signed up on their own.
    const msg = inviteErr.message?.toLowerCase() ?? ""
    if (
      msg.includes("already registered") ||
      msg.includes("already been invited") ||
      msg.includes("user already exists")
    ) {
      // The login exists (e.g. the seller was deleted and added again):
      // reconnect it to this seller and email a set-password link.
      return relinkExistingLogin(admin, seller_id, sellerEmail, redirectTo)
    }
    console.error("[seller-invite] inviteUserByEmail failed for", sellerEmail, ":", inviteErr.message)
    return json({ error: inviteErr.message }, 400)
  }

  // ── 6. Insert the user_profiles row ───────────────────────────────────────
  // Links the new auth user → seller record so current_seller_id() and
  // is_owner() RLS helpers work as soon as the seller first signs in.
  // ON CONFLICT DO NOTHING: if the profile already exists (e.g. re-invite of
  // an existing auth user who lost their profile row), skip silently.
  const newUserId = invited.user?.id
  if (!newUserId) {
    // Should never happen if inviteUserByEmail succeeded, but guard defensively.
    console.error("[seller-invite] inviteUserByEmail returned no user.id for", sellerEmail)
    return json({ error: "Invite sent but could not link seller profile — no user id returned" }, 500)
  }

  const displayName = (seller.contact_name as string | null)?.trim() ||
                      (seller.name as string | null)?.trim() ||
                      null

  const { error: profileInsertErr } = await admin
    .from("user_profiles")
    .insert({
      id:           newUserId,
      role:         "seller",
      seller_id:    seller_id,
      display_name: displayName,
    })

  if (profileInsertErr) {
    // Duplicate key (23505) means the profile row already exists — safe to ignore.
    if (profileInsertErr.code === "23505") {
      console.log("[seller-invite] user_profiles row already exists for", newUserId, "— skipping insert")
    } else {
      console.error(
        "[seller-invite] user_profiles insert failed for", newUserId,
        ":", profileInsertErr.message,
      )
      return json({
        error: `Invite sent but profile link failed: ${profileInsertErr.message}`,
      }, 500)
    }
  }

  const inviteLink = invited.properties?.action_link
  if (!inviteLink) {
    console.error("[seller-invite] generateLink returned no action_link for", sellerEmail)
    return json({ error: "Seller created, but the invite link could not be made. Press Invite again." }, 500)
  }
  const sendErr = await sendSetPasswordEmail(sellerEmail, inviteLink, "You're invited to GemWorkers")
  if (sendErr) {
    return json({ error: `Seller created, but the invite email failed: ${sendErr}. Press Invite again.` }, 502)
  }

  console.log(
    "[seller-invite] invite sent to", sellerEmail,
    "| seller:", seller_id,
    "| new auth uid:", newUserId,
  )

  return json({ ok: true, invited: true, email: sellerEmail })
})
