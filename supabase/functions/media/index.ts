// Supabase Edge Function — media
// Photos and videos of stones live on Bunny (sql/media_bunny.sql):
//   photos → Bunny Storage zone gemworkers-media, served from media.gemworkers.com
//   videos → Bunny Stream library 794698 (encoded there, MP4 played by the store)
// The Bunny keys (BUNNY_STORAGE_PASSWORD, BUNNY_STREAM_API_KEY) never leave this
// function. Every call is checked: the owner may touch any stone, a seller only
// their own (user_profiles.seller_id = inventory_items.seller_id).
//
// Actions (POST):
//   multipart  action=photo, item_id, file (full JPEG), card (small JPEG)  → { url }
//   json       { action: 'photo_delete', item_id, url }
//   json       { action: 'video_create', item_id }  → TUS upload pass for the admin
//   json       { action: 'video_check',  item_id }  → finishes a pending video if Bunny is done
//   json       { action: 'video_delete', item_id, url? }
//   ?webhook=<MEDIA_WEBHOOK_SECRET>  Bunny Stream status callback → same as video_check
//   X-Migrate-Token: <MEDIA_MIGRATE_TOKEN>  one-off move of existing files
//                    (import_photo multipart, import_video json { item_id, source_url })

import { createClient, type SupabaseClient } from "@supabase/supabase-js"

const corsHeaders = {
  "Access-Control-Allow-Origin":  "*",
  "Access-Control-Allow-Methods": "POST, OPTIONS",
  "Access-Control-Allow-Headers": "authorization, x-client-info, apikey, content-type, x-migrate-token",
}

const json = (body: unknown, status = 200) =>
  new Response(JSON.stringify(body), {
    status,
    headers: { "Content-Type": "application/json", ...corsHeaders },
  })

const STORAGE_ZONE = "gemworkers-media"
const STORAGE_HOST = "https://storage.bunnycdn.com"   // main region Frankfurt
const MEDIA_HOST   = "https://media.gemworkers.com"
const LIBRARY_ID   = "794698"
const STREAM_HOST  = "https://vz-192edce1-fc4.b-cdn.net"
const STREAM_API   = `https://video.bunnycdn.com/library/${LIBRARY_ID}/videos`

const MAX_PHOTO_BYTES = 10 * 1024 * 1024
const UUID = /^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$/i

const storageKey = () => Deno.env.get("BUNNY_STORAGE_PASSWORD") ?? ""
const streamKey  = () => Deno.env.get("BUNNY_STREAM_API_KEY") ?? ""

// Constant-time compare for the webhook / migration tokens.
function sameSecret(a: string | null, b: string | undefined): boolean {
  if (!a || !b || a.length !== b.length) return false
  let d = 0
  for (let i = 0; i < a.length; i++) d |= a.charCodeAt(i) ^ b.charCodeAt(i)
  return d === 0
}

async function sha256Hex(s: string): Promise<string> {
  const buf = await crypto.subtle.digest("SHA-256", new TextEncoder().encode(s))
  return [...new Uint8Array(buf)].map(b => b.toString(16).padStart(2, "0")).join("")
}

// ── Who may touch this stone ─────────────────────────────────────────────────

async function mayEdit(admin: SupabaseClient, req: Request, itemId: string): Promise<string | null> {
  if (!UUID.test(itemId)) return "Bad item_id"
  const jwt = (req.headers.get("Authorization") ?? "").replace("Bearer ", "").trim()
  if (!jwt) return "Unauthorized"
  const { data: { user }, error } = await admin.auth.getUser(jwt)
  if (error || !user) return "Unauthorized"
  const [{ data: profile }, { data: item }] = await Promise.all([
    admin.from("user_profiles").select("role, seller_id").eq("id", user.id).maybeSingle(),
    admin.from("inventory_items").select("seller_id").eq("id", itemId).maybeSingle(),
  ])
  if (!profile || !item) return "Forbidden"
  if (profile.role === "owner") return null
  if (profile.seller_id && profile.seller_id === item.seller_id) return null
  return "Forbidden"
}

// ── Photos (Bunny Storage) ───────────────────────────────────────────────────

async function putFile(path: string, body: BodyInit, type = "application/octet-stream"): Promise<void> {
  const res = await fetch(`${STORAGE_HOST}/${STORAGE_ZONE}/${path}`, {
    method: "PUT",
    headers: { AccessKey: storageKey(), "Content-Type": type },
    body,
  })
  if (!res.ok) throw new Error(`Bunny storage ${res.status}: ${await res.text()}`)
}

async function deleteFile(path: string): Promise<void> {
  const res = await fetch(`${STORAGE_HOST}/${STORAGE_ZONE}/${path}`, {
    method: "DELETE",
    headers: { AccessKey: storageKey() },
  })
  if (!res.ok && res.status !== 404) throw new Error(`Bunny delete ${res.status}`)
}

function isJpeg(b: Uint8Array): boolean {
  return b.length > 3 && b[0] === 0xff && b[1] === 0xd8 && b[2] === 0xff
}

// Full photo + its small card version, stored side by side:
//   items/<item>/<name>.jpg  and  items/<item>/<name>_card.jpg
async function savePhoto(itemId: string, form: FormData, name?: string): Promise<string> {
  const file = form.get("file"), card = form.get("card")
  if (!(file instanceof File) || !(card instanceof File)) throw new Error("file and card are required")
  if (file.size > MAX_PHOTO_BYTES || card.size > MAX_PHOTO_BYTES) throw new Error("Photo too large (max 10 MB)")
  const full = new Uint8Array(await file.arrayBuffer())
  const small = new Uint8Array(await card.arrayBuffer())
  if (!isJpeg(full) || !isJpeg(small)) throw new Error("Photos must be JPEG")
  const base = name ?? `${Date.now()}-${crypto.randomUUID().slice(0, 8)}`
  if (!/^[A-Za-z0-9._-]{1,80}$/.test(base)) throw new Error("Bad name")
  await putFile(`items/${itemId}/${base}.jpg`, full, "image/jpeg")
  await putFile(`items/${itemId}/${base}_card.jpg`, small, "image/jpeg")
  return `${MEDIA_HOST}/items/${itemId}/${base}.jpg`
}

async function removePhoto(itemId: string, url: string): Promise<void> {
  const prefix = `${MEDIA_HOST}/items/${itemId}/`
  if (!url.startsWith(prefix)) return            // not ours (or another stone's) → leave it
  const file = url.slice(prefix.length)
  if (!/^[A-Za-z0-9._-]+\.jpg$/.test(file)) return
  await deleteFile(`items/${itemId}/${file}`)
  await deleteFile(`items/${itemId}/${file.replace(/\.jpg$/, "_card.jpg")}`)
}

// ── Videos (Bunny Stream) ────────────────────────────────────────────────────

async function stream(path: string, init: RequestInit = {}): Promise<Response> {
  return fetch(`${STREAM_API}${path}`, {
    ...init,
    headers: { AccessKey: streamKey(), accept: "application/json", "content-type": "application/json", ...(init.headers ?? {}) },
  })
}

const guidOfUrl = (url: string | null | undefined): string | null => {
  if (!url || !url.startsWith(`${STREAM_HOST}/`)) return null
  const g = url.slice(STREAM_HOST.length + 1).split("/")[0]
  return UUID.test(g) ? g : null
}

async function deleteVideo(guid: string | null): Promise<void> {
  if (!guid) return
  const res = await stream(`/${guid}`, { method: "DELETE" })
  if (!res.ok && res.status !== 404) console.error("[media] video delete failed", guid, res.status)
}

// New Bunny video for this stone; the admin then uploads straight to Bunny
// (TUS) with a pass that expires in 2 hours.
async function createVideo(admin: SupabaseClient, itemId: string) {
  const res = await stream("", { method: "POST", body: JSON.stringify({ title: itemId }) })
  if (!res.ok) throw new Error(`Bunny create video ${res.status}`)
  const { guid } = await res.json()
  const { data: old } = await admin.from("inventory_items").select("video_pending").eq("id", itemId).maybeSingle()
  await deleteVideo(old?.video_pending ?? null)          // an earlier upload that never finished
  await admin.from("inventory_items").update({ video_pending: guid }).eq("id", itemId)
  const expire = Math.floor(Date.now() / 1000) + 2 * 3600
  const signature = await sha256Hex(`${LIBRARY_ID}${streamKey()}${expire}${guid}`)
  return { video_id: guid, library_id: LIBRARY_ID, expire, signature }
}

// If Bunny has finished encoding the pending video: play its MP4 (720p, or the
// best size below that), remove the stone's previous Bunny video.
async function finishVideo(admin: SupabaseClient, itemId: string) {
  const { data: item } = await admin.from("inventory_items").select("video_url, video_pending").eq("id", itemId).maybeSingle()
  if (!item?.video_pending) return { status: "none", video_url: item?.video_url ?? null }
  const guid = item.video_pending as string
  const res = await stream(`/${guid}`)
  if (res.status === 404) {
    await admin.from("inventory_items").update({ video_pending: null }).eq("id", itemId).eq("video_pending", guid)
    return { status: "failed", video_url: item.video_url }
  }
  if (!res.ok) throw new Error(`Bunny get video ${res.status}`)
  const v = await res.json()
  if (v.status === 5 || v.status === 6) {                // encoding / upload failed
    await admin.from("inventory_items").update({ video_pending: null }).eq("id", itemId).eq("video_pending", guid)
    return { status: "failed", video_url: item.video_url }
  }
  const sizes = String(v.availableResolutions ?? "").split(",").map(s => parseInt(s)).filter(n => n > 0 && n <= 720)
  if (v.status !== 4 || !v.hasMP4Fallback || sizes.length === 0) return { status: "processing", video_url: item.video_url }
  const url = `${STREAM_HOST}/${guid}/play_${Math.max(...sizes)}p.mp4`
  const { data: done } = await admin.from("inventory_items")
    .update({ video_url: url, video_pending: null }).eq("id", itemId).eq("video_pending", guid).select("id")
  if (done?.length) {
    const oldGuid = guidOfUrl(item.video_url)
    if (oldGuid && oldGuid !== guid) await deleteVideo(oldGuid)
  }
  return { status: "ready", video_url: url }
}

// ── Handler ──────────────────────────────────────────────────────────────────

Deno.serve(async (req: Request) => {
  if (req.method === "OPTIONS") return new Response("ok", { headers: corsHeaders })
  if (req.method !== "POST") return json({ error: "Method not allowed" }, 405)

  const admin = createClient(Deno.env.get("SUPABASE_URL")!, Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!, {
    auth: { autoRefreshToken: false, persistSession: false },
  })

  try {
    // Bunny Stream webhook: only tells us "look at video X"; the facts come
    // from Bunny's API with our own key, so a fake call can't change anything.
    const hook = new URL(req.url).searchParams.get("webhook")
    if (hook !== null) {
      if (!sameSecret(hook, Deno.env.get("MEDIA_WEBHOOK_SECRET"))) return json({ error: "Forbidden" }, 403)
      const body = await req.json().catch(() => ({}))
      const guid = String(body.VideoGuid ?? "")
      if (!UUID.test(guid)) return json({ ok: true })
      const { data: item } = await admin.from("inventory_items").select("id").eq("video_pending", guid).maybeSingle()
      if (item) await finishVideo(admin, item.id)
      return json({ ok: true })
    }

    // One-off move of the existing Supabase files (owner runs it once).
    const migrating = req.headers.get("x-migrate-token")
    if (migrating !== null) {
      if (!sameSecret(migrating, Deno.env.get("MEDIA_MIGRATE_TOKEN"))) return json({ error: "Forbidden" }, 403)
      if ((req.headers.get("content-type") ?? "").includes("multipart/form-data")) {
        const form = await req.formData()
        const itemId = String(form.get("item_id") ?? "")
        if (!UUID.test(itemId)) return json({ error: "Bad item_id" }, 400)
        const name = String(form.get("name") ?? "") || undefined
        return json({ url: await savePhoto(itemId, form, name) })
      }
      const b = await req.json()
      if (b.action !== "import_video" || !UUID.test(String(b.item_id ?? ""))) return json({ error: "Bad request" }, 400)
      const src = String(b.source_url ?? "")
      if (!src.startsWith(`${Deno.env.get("SUPABASE_URL")}/storage/v1/object/public/inventory-videos/`)) {
        return json({ error: "Bad source_url" }, 400)
      }
      const pass = await createVideo(admin, b.item_id)
      const file = await fetch(src)
      if (!file.ok || !file.body) return json({ error: `source ${file.status}` }, 502)
      const up = await stream(`/${pass.video_id}`, { method: "PUT", body: file.body, headers: { "content-type": "application/octet-stream" } })
      if (!up.ok) return json({ error: `Bunny upload ${up.status}` }, 502)
      return json({ video_id: pass.video_id })
    }

    // Admin calls (signed-in owner or seller).
    if ((req.headers.get("content-type") ?? "").includes("multipart/form-data")) {
      const form = await req.formData()
      const itemId = String(form.get("item_id") ?? "")
      if (String(form.get("action")) !== "photo") return json({ error: "Bad request" }, 400)
      const denied = await mayEdit(admin, req, itemId)
      if (denied) return json({ error: denied }, denied === "Unauthorized" ? 401 : 403)
      return json({ url: await savePhoto(itemId, form) })
    }

    const b = await req.json().catch(() => ({}))
    const itemId = String(b.item_id ?? "")
    const denied = await mayEdit(admin, req, itemId)
    if (denied) return json({ error: denied }, denied === "Unauthorized" ? 401 : 403)

    switch (b.action) {
      case "photo_delete":
        await removePhoto(itemId, String(b.url ?? ""))
        return json({ ok: true })
      case "video_create":
        return json(await createVideo(admin, itemId))
      case "video_check":
        return json(await finishVideo(admin, itemId))
      case "video_delete": {
        const { data: item } = await admin.from("inventory_items").select("video_url, video_pending").eq("id", itemId).maybeSingle()
        const target = guidOfUrl(String(b.url ?? "")) ?? guidOfUrl(item?.video_url)
        if (target && target === guidOfUrl(item?.video_url)) await deleteVideo(target)
        if (item?.video_pending) {
          await deleteVideo(item.video_pending)
          await admin.from("inventory_items").update({ video_pending: null }).eq("id", itemId)
        }
        return json({ ok: true })
      }
      default:
        return json({ error: "Unknown action" }, 400)
    }
  } catch (e) {
    console.error("[media]", e instanceof Error ? e.message : e)
    return json({ error: "Media request failed" }, 500)
  }
})
