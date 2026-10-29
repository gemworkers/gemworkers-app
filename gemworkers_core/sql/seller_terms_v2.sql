-- =============================================================================
-- GemWorkers — Seller terms version 2 (with the GemWorkers Standards / SOPs)
-- =============================================================================
-- NOT YET APPLIED
--
-- Text: docs/seller-terms-v2.md (approved by Zakaria before running). v1 stays
-- stored unchanged (agreed versions are never edited); v2 becomes current, so
-- every seller is asked to agree again at the next login (SellerTermsGate).
-- Changes vs v1: same price everywhere / no fake discounts (3.2), shipping rules
-- 3–5 working days, signature + insurance from €300, customs + agent slip rules
-- (5), only GemWorkers refunds (7.5), packing video as evidence (8.3), no
-- contact/links/outside payment (9.2), new section 14 GemWorkers Standards.
-- =============================================================================

BEGIN;

UPDATE public.seller_terms SET is_current = false WHERE is_current;

INSERT INTO public.seller_terms (version, title, body, is_current)
VALUES ('v2-2026-10-29', 'GemWorkers Seller Terms', $terms$These terms are an agreement between **GemWorkers** (the shop at www.gemworkers.com,
company details at the bottom of this page) and **you, the seller**. By clicking
"I agree" you accept them, including the **GemWorkers Standards** in section 14. You can
read and print them at any time in the admin.

## 1. How it works
1. You keep ownership of your stones until they are sold.
2. GemWorkers sells your stones **in its own name, on your behalf**, for a service fee
   (a "commission agent" arrangement). The buyer buys from GemWorkers.
3. Buyers never see your name, email or contact details. Stones show only "Ships from
   {your country}". Replies to buyers are shown as "GemWorkers".
4. Every listing is checked by GemWorkers before it goes online. GemWorkers may refuse,
   change the presentation of, or remove a listing.

## 2. Your stones and descriptions
1. You only list stones that you own and are allowed to sell and export.
2. Descriptions must be true: gem type, weight, measurements, origin (if known), and
   **every known treatment** (heating, filling, dyeing, coating, etc.).
3. Photos and videos must show **the actual stone** being sold, without filters that change
   its colour or clarity.
4. Certificates must be genuine and belong to that stone.
5. Not allowed: synthetic or imitation stones sold as natural, stolen goods, conflict
   diamonds, protected materials (such as ivory, coral or tortoiseshell) without the
   required permits, and anything from sanctioned countries.

## 3. Prices and offers
1. You set the price of each stone in euros. Buyers may see it in their own currency or
   including VAT; this does not change what you receive.
2. Use the **same price** as anywhere else you sell the stone, and no fake discounts
   (no "was €X, now 60% off" unless the stone really sold for €X recently).
3. You may accept, decline or counter buyer offers. An accepted offer is a sale at that price.
4. If you sell a stone somewhere else, mark it as sold or unlist it **immediately**. If a
   GemWorkers order cannot be delivered because the stone is gone, the costs of
   cancelling (refund fees) are charged to you.

## 4. GemWorkers service fee
1. GemWorkers charges a service fee of **{fee}%** of the final sale price of the stone
   (the price after any offer, without shipping and without VAT), with a **minimum of €3
   per sale**.
2. The fee covers everything on our side: card, PayPal and Klarna fees, currency
   exchange, VAT and customs paperwork, customer service, returns handling and
   marketing. **There are no other fees.**
3. GemWorkers may change the fee with at least **30 days' notice**. A change never
   applies to stones already sold.

## 5. Shipping
1. You ship the stone within **3–5 working days** after payment, with **tracking**, well
   packed. From **€300**, with **signature and insurance for the full value**.
2. The sender name on the parcel is **"GemWorkers"**. You print the GemWorkers invoice and
   put it in the parcel.
3. Customs form: always **"Sale of goods / commercial"** (never "gift" or "sample"), the
   **real value** from the invoice (never lower) and the real country of origin of the
   stone, also when the parcel leaves from another country (for example Dubai).
4. If you ship through an agent (DHL, USPS, …), you check that the agent's slip shows the
   **same value as the invoice**, you keep a photo of the slip, and you enter the
   **carrier's** tracking number (not the agent's reference).
5. You enter the tracking number in the admin **the same day** the parcel is sent.
6. You pay the postage. The shipping charge the buyer paid is added to your payout.
7. You follow the export rules of your own country and keep the export / post receipts.

## 6. Payouts
1. Your payout for a sale = the sale price + the buyer's shipping charge − the service fee.
2. A sale is paid out after the **30-day return period** has ended and there is no open
   return or payment dispute.
3. GemWorkers pays by Wise or Payoneer (or another method you agree on), in euros or in
   your own currency, normally within **7 days** after the sale is ready for payout.
4. Each payout comes with a statement (sales, fees, refunds, payout).
5. **Self-billing:** you agree that GemWorkers makes these payout statements for you, as
   your invoice for the sale. You will not send your own invoice for the same sale, and
   you tell us if you become VAT-registered or your details change.

## 7. Returns and refunds
1. Buyers may return a stone within 30 days. Returned stones are sent to GemWorkers in
   the Netherlands.
2. If a buyer is refunded, the refunded stone price and shipping are not paid out to you
   (or, if already paid out, are deducted from your next payout).
3. A returned stone stays yours. GemWorkers keeps it in the Netherlands and can sell it
   again for you, or send it back to you **at your cost**, as you prefer.
4. If a stone is not as described (for example an undisclosed treatment), the return
   costs are charged to you.
5. Only GemWorkers decides on refunds. You never promise a buyer a refund yourself.

## 8. Payment disputes (chargebacks)
1. If a buyer's bank reverses a payment, the bank's dispute fee for that sale is charged
   to you. If the dispute is won, the fee is credited back.
2. If the dispute is lost, it is handled like a full refund (section 7).
3. You help GemWorkers with evidence (tracking, packing video, photos, proof of delivery)
   when asked.

## 9. Buyer data and contact
1. You only use buyer details (name, address, phone) to ship the order, and keep them
   confidential. You delete them when they are no longer needed for that order.
2. You never contact buyers outside GemWorkers Messages, never share your phone, email,
   WhatsApp or other links, never accept payment outside GemWorkers and never ask
   buyers to buy from you directly.

## 10. Taxes
1. GemWorkers handles VAT towards buyers where it has to.
2. You are responsible for your own income tax and any taxes, export duties and permits
   in your own country.

## 11. Ending the agreement
1. You or GemWorkers can end this agreement at any time with **30 days' notice** by email.
2. GemWorkers may end it immediately in case of fraud, false descriptions or a serious
   breach of these terms.
3. Orders already placed are still completed. Unsold stones remain yours.

## 12. Changes to these terms
1. GemWorkers may update these terms. You will be asked to agree to the new version the
   next time you log in; you cannot list new stones until you do.

## 13. Law
1. Dutch law applies. Disputes go to the competent court in the Netherlands, unless we
   agree otherwise.

## 14. GemWorkers Standards (how we work every day)
1. **Listing:** weigh and measure every stone (never estimate). Daylight photos on the
   same background, plus one short video. Show inclusions honestly. Never put your name,
   phone, shop name or other links in a title, description or photo.
2. **Storage:** every stone has a location in the admin (for example "Drawer A3") and its
   SKU label on the bag. If you take a stone out, move it in the admin and put it back in
   the same place. Once a month, compare your drawers with the admin's list.
3. **Packing:** film the packing of every parcel (the stone, sealing the bag, closing the
   parcel, the label) and keep the video until the order is complete.
4. **Messages:** answer every buyer message within **24 hours** (also "I'll check and reply
   tomorrow"). Answer offers within **48 hours** (accept, counter or decline).
5. **Problems:** if a buyer is unhappy or a parcel is lost, tell GemWorkers right away.
   If GemWorkers warns you about possible fraud, or a buyer asks for another address or
   for payment outside the shop, **do not ship** and ask GemWorkers.
6. **Away:** if you are away for more than **3 days**, switch on Vacation mode in the admin.
7. **Security:** use only your own login, never share your password, and keep a screen
   lock on your phone.$terms$, true);

COMMIT;
