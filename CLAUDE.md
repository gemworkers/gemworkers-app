# GemWorkers — rules for every Claude session

Owner: Zakaria (non-technical founder). Explain in plain English, one small step at a time. Tell him exactly what to click/test; never assume he reads code.

## What GemWorkers is
- ONE brand (house brand), not a marketplace. Buyers buy from GemWorkers (merchant of record).
- Sellers (Zakaria's brothers in Thailand/Pakistan + NL) are suppliers behind the brand. Buyers NEVER see seller names, emails or identity. Origin shows only as "Ships from {country}". Staff replies always show as "GemWorkers".
- Chosen model: "option 3" = one brand + curated maker stories (planned) + buyer questions routed directly to that stone's seller inbox (owner sees all).
- Money: Stripe (regular, not Connect) → GemWorkers; sellers paid manually (Wise / Payoneer). Per-seller commission rate, NULL = 0%. payout = price − round(price × rate, 2).
- One row = one physical item (inventory_items). Don't break it.
- No live payments before the accountant has reviewed VAT/customs/merchant-of-record. This gate does not move.

## Repo layout (C:\Users\Zakaria\Desktop\gemworkers_app)
- gemworkers_store — Next.js 15 storefront, www.gemworkers.com (Vercel, auto-deploys on push to main). Callbacks/webhooks must use www.
- gemworkers_core — Flutter web admin, sell.gemworkers.com. Manual deploy: flutter build web → cd build\web → npx vercel --prod. Flutter is NOT on PATH: C:\Users\Zakaria\Desktop\Flutter\flutter\bin\flutter.bat
- gemworkers_core/sql/ — SQL source of truth. supabase/functions/ — Edge Functions (deploy via CLI from gemworkers_app).
- Supabase project ref: cvqzidqnwthzfodhzepz.

## How we work
- Inspect before building. One verified change per commit. Report what changed and what is untested.
- SQL-first: write SQL file → Zakaria runs it in the Supabase SQL Editor → verify the live change (prosrc / information_schema) → then app code. Mark the file header "Applied to live DB <date>".
- Money / payment SQL (respond_to_offer, submit_storefront_offer, sweeps, checkout): copy the LIVE definition exactly and change only what's needed; show a diff. (Example trap: respond_to_offer_owner_override.sql is NOT live — commission_default_zero.sql + offer_notify.sql stamps are.)
- Views: columns only appended; DROP + CREATE when structure changes.
- Supabase returns numerics as strings → parse before math. Money is stored to the cent; never round silently. Display rule: whole euros if integer (€55), else 2 decimals (€49.80) — lib/money.ts / lib/core/utils/money.dart.
- Never run `npm run build` while `npm run dev` is running (corrupts .next; fix: delete .next).
- Secrets: never print, never commit, never put in chat. Webhook secrets: generate → `npx supabase secrets set` → put trigger SQL only on the clipboard. Turnstile site key is public; secret key lives only in Supabase.
- Buyer-facing emails and pages never include seller identity or seller_note.

## Live systems (built)
- Auth: Cloudflare Turnstile on store login/signup + admin login; Supabase CAPTCHA ON.
- Message portal: conversations + messages (RLS; buyer reads via buyer_conversations / buyer_messages views; all writes via functions). Contact info (emails, phone numbers starting +/0/00, non-gemworkers links) blocked for buyers/sellers. message-notify Edge Function + webhook (throttled nudges, never message text).
- Offers: offer-notify Edge Function + webhook (new / accepted / declined / expired), payment reminder via cron + Vault secret. Offer input is text (no scroll drift), exact cents enforced in SQL.
- Checkout collects shipping address + phone (required); shown to seller on order detail.
- Offers in the conversation + counter-offer (done 2026-10-22): trigger _offer_message_card writes 'system' cards (messages.kind ≠ 'text'; message-notify skips them). One counter per offer (counter_offer → respond_to_counter; > buyer's offer, < listed price, 48h, expired by the pending-payment sweep). Blocked buyer (per stone) can't offer/accept. Buyers read offers only via buyer_offers view; writes via submit_storefront_offer / respond_to_counter / withdraw_offer (no buyer table policies). Stone → 'sold' declines its open offers ('system').

- Maker credit (done 2026-10-22): owner-only makers list (public read), inventory_items.maker_id set only by owner (trigger + setItemMaker, not in toMap). Store: "Cut by / Made by / Collected by X in Place" + /makers profiles.
- Listing approval (done 2026-10-22): a seller's is_listed false→true becomes listing_requested_at (invoker trigger, current_user = 'authenticated'); owner approves in Listings → Awaiting approval. Definer functions relisting a stone are unaffected.
- Stone media (Etsy-style): store PhotoGallery = side thumbs (desktop) / edge-to-edge + dots (phone) / portal lightbox with zoom. Uploaded video (bucket inventory-videos, ≤50 MB, stored in inventory_items.video_url) = 2nd gallery item, muted loop; YouTube/Vimeo URLs still use VideoPlayer.
- Storage inventory-images: upload/delete staff only (owner anywhere, seller own stone folders), images ≤10 MB.
- Reviews (built 2026-10-22): reviews table, submit_review (buyer's own platform order, shipped/received/paid, once), public_reviews view (approved only), review-photos bucket (buyer's own folder). Invite: send_review_invites cron (15 min) → offer-notify REVIEW_INVITE (Vault offer_reminder_secret). Owner moderates in admin Reviews.
- Emails: new-order email one per recipient; late-payment refunds also email each seller ("do not ship").

## Current plan: tax & duties system (started 2026-10-23; accountant reviews before live payments)
Routes: ships from NL / TH / PK; buyers mainly US, then EU, UK, AU, CA, SG, HK, CN, IL, Gulf, Central Asia.
Decisions: (1) US (and where possible) = collect duties+taxes at checkout, ship DDP; (2) store shows base price, checkout adds shipping + country taxes/duties as separate lines; (3) ship only to the listed countries at launch, others "contact us".
Design: admin-editable rules table per destination (tax name/rate, thresholds, collect vs buyer-pays, duty % per product type, origin-specific tariffs e.g. US by origin) → checkout calculation stored per order (scheme, tax, duty) → reports (OSS/IOSS), invoices, customs data (HS: 7103 gems, 7113 jewelry, specimens TBD). Rates are starting values to verify — never claim them as authoritative. A paid rates service (Zonos/Avalara) can feed the same table later.
Steps: 1 ship-to country on stone page/cart + shippable-countries list (worldwide minus sanctions: RU BY IR KP SY CU off) · 2 rules table + admin page + starting values · 3 checkout calculation (money code: copy live, diff) · 3b payment methods: replace payment_method_types ['card'] with Stripe dynamic methods (PayPal via Stripe — Zakaria has PayPal Business — Apple/Google Pay, iDEAL, Bancontact, Klarna) · 4 reports/invoices/customs data · later: "Pay by bank transfer" for high-value stones (Wise business account, manual confirm); seller payouts via Wise / Payoneer (Payoneer for PK).

## Backlog (do everything, in order, nothing parked)
- Admin polish: other small fixes (decimal keyboards, Etsy-style photos + video done). Ask Zakaria for his list.
- Before launch: hide the approved test review (admin Reviews); optionally rotate the offer/message webhook secrets (they appeared in a tool log 2026-10-22).
- Trap: Edit stone does a full-row update from InventoryItem.toMap() — any field not passed into the new InventoryItem is reset (this wiped seller_id 2026-10-23). updateItem now drops a NULL seller_id; keep passing every field.
- Social links: ONE GemWorkers account per platform, never seller accounts — waiting for Zakaria's account URLs.
- Payment page (/payment) built 2026-10-22 — has ACCOUNTANT REVIEW marker (VAT wording, methods).
- Store: Reviews in top menu; ReviewSummary star line on homepage + stone pages; homepage band of 3 newest reviews.
- Listing emails (done 2026-10-23): trigger inventory_listing_decision_notify → offer-notify LISTING_EVENT (requested → owner; approved/rejected → seller, with listing_review_note).
- Seller invite (fixed 2026-10-23): seller-invite uses generateLink + Resend (not Supabase mailer); re-adding a seller with an existing login relinks it and sends a recovery link. Testseller (printforzakaria@gmail.com) exists for testing — deactivate before launch.
- Auth emails (done 2026-10-23): Supabase SMTP → Resend (noreply@gemworkers.com). Templates "Reset Password" and "Confirm signup" link to www.gemworkers.com/auth/confirm?token_hash=…&type=recovery|email (server verifyOtp, any device). Store has /auth/forgot-password + /auth/reset-password (?expired=1 → "Link expired"). Redirect URLs list both gemworkers.com/** and www.gemworkers.com/**.
- Pre-launch test-data wipe (orders_no_delete_pending_payment trigger blocks deletes — cancel first).
- Zakaria's own: change admin password, accountant, virtual office address, load real inventory.
