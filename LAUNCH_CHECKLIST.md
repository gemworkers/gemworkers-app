# GemWorkers — launch checklist

Everything left before real customers can pay. Tick items off as they're done.
**Z** = Zakaria · **C** = Claude (code) · **Z+C** = together (Claude guides).

## 1. Legal & money — must be done first (the gate)
- [ ] **Z** Accountant review: VAT/OSS set-up, GemWorkers as merchant of record, the
      service-fee (commission) model for the brothers' stones, and which amount counts as
      turnover for foreign-currency orders (euro price or euros received). Also the
      "ACCOUNTANT REVIEW" wording on the Payment page.
- [ ] **Z** Register for the EU One-Stop-Shop (OSS / "Unieregeling") at the Belastingdienst.
- [ ] **Z** Send Claude the BTW-id → **C** puts it in the store (VAT-number checks for
      business buyers get an official consultation number).
- [ ] **Z** Company details complete in Admin → Taxes & duties → Company details
      (address / virtual office, KvK, BTW, EORI, return address).
- [x] **Z+C** Short written agreement with each brother (seller terms, "I agree" at login — done 2026-10-26; accountant/lawyer to check the text): 12% service fee, payout after the
      30-day return period, returns and chargebacks charged to the stone's owner.
      (Claude can draft it.)
- [ ] **Z** Admin → Sellers: set the service fee to **12%** for each brother.
- [ ] **Z** Insurance for stock and parcels (expensive stones by tracked + signed post).

## 2. Real stock
- [ ] **Z** Load 30–50 real stones: good photos (same background and light every time) +
      video, correct weight, treatment, certificate, shipping price per stone.
- [x] **C** Listing-form rule for protected materials (coral, ivory, shells, fossils) and
      the Kimberley statement for diamonds. (done 2026-10-26)
- [ ] **Z** Unlist or remove the test stones.

## 3. Stripe live mode (test settings do NOT carry over)
- [ ] **Z** Activate the Stripe account for live payments (business verification).
- [ ] **Z+C** Payment methods ON: cards, Apple Pay, Google Pay, PayPal (connect PayPal
      Business), Klarna, iDEAL, Bancontact. SEPA Direct Debit stays OFF.
- [ ] **Z** Adaptive Pricing ON (Checkout).
- [ ] **Z+C** Live webhook to `https://www.gemworkers.com/api/stripe/webhook` with events:
      checkout.session.completed, checkout.session.async_payment_succeeded,
      checkout.session.expired, charge.dispute.created, charge.dispute.closed,
      radar.early_fraud_warning.created.
- [ ] **Z+C** Live keys + live webhook secret into Vercel (never in chat).
- [ ] **Z** Radar rules: block on CVC fail and postal-code fail; email alerts for disputes
      and fraud warnings.

## 4. Clean-up & safety
- [ ] **C** Test-data wipe (keep the one real buyer): test orders, invoices (counter back to
      GW-YYYY-00001), payouts (PO-YYYY-0001), refunds, owner charges, test offers, messages, test newsletter subscribers.
- [ ] **Z** Admin → Reviews: hide the test review.
- [ ] **Z** Deactivate the test seller account.
- [ ] **Z+C** New webhook passwords for the offer, message and order-shipped emails.
- [ ] **Z** Supabase → Authentication → Email: "Email OTP expiration" to **86400** (24 hours),
      so password links in order emails still work the next day.
- [ ] **Z** Change the admin password.

## 5. Launch day
- [ ] **Z+C** One real purchase with your own card (small stone), then refund it.
- [ ] **Z** Social accounts (one GemWorkers account per platform) → send the links → **C** adds
      them to the site footer.
- [ ] **Z+C** Google Merchant Center (free Google Shopping listings) once real stones are online.

## 6. First weeks after launch
- [ ] Watch: Stripe fees per sale, buyers dropping out at the bank check (€300+),
      returns, fraud warnings.
- [ ] Answer every buyer message within a day — early reviews matter most.

## Later (not before launch)
- Bank transfer (Wise) for stones above ~€1,000
- Lower service fee above €1,000 (e.g. 10%)
- Wise US dollar account linked to Stripe (saves ~1.5% on US sales) once there's volume
- Spreadsheet import of stones; AI help with descriptions
- Weekly auction experiment, once there are regular buyers
