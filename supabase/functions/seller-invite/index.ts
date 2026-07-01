// Supabase Edge Function — seller-invite
// Called by the Flutter admin app (owner only) to send a Supabase auth invite
// to a seller's email address. On success the seller receives a link to set
// their password; after doing so they can log in to the Flutter admin app.
// The function also creates the user_profiles row linking the auth user to the
// seller record so current_seller_id() RLS works immediately on first sign-in.

import { createClient } from "@supabase/supabase-js"

// ── Response helper ────────────────────────────────────────────────────────────

const json = (body: unknown, status = 200) =>
  new Response(JSON.stringify(body), {
    status,
    headers: { "Content-Type": "application/json" },
  })

// ── Handler ────────────────────────────────────────────────────────────────────

Deno.serve(async (req: Request) => {
  // ── CORS preflight ─────────────────────────────────────────────────────────
  // The Supabase Flutter client sends an OPTIONS preflight before POST.
  if (req.method === "OPTIONS") {
    return new Response(null, {
      status: 204,
      headers: {
        "Access-Control-Allow-Origin":  "*",
        "Access-Control-Allow-Methods": "POST, OPTIONS",
        "Access-Control-Allow-Headers": "Content-Type, Authorization",
      },
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

  const { data: invited, error: inviteErr } =
    await admin.auth.admin.inviteUserByEmail(sellerEmail, { redirectTo })

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
      console.log("[seller-invite] seller already invited:", sellerEmail)
      return json({ ok: true, alreadyInvited: true, message: "This seller was already invited." })
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

  console.log(
    "[seller-invite] invite sent to", sellerEmail,
    "| seller:", seller_id,
    "| new auth uid:", newUserId,
  )

  return json({ ok: true, invited: true, email: sellerEmail })
})
