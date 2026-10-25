import Link from 'next/link'
import { ContentPage } from '@/app/components/ContentPage'

export const metadata = { title: 'Payment Information · GemWorkers' }

// Facts here must match the code: Stripe Checkout, methods in
// lib/stripe/checkout.ts (card fallback), currency EUR or the buyer's own
// (US/GB/AU/CA: lib/fx.ts + sql/local_currency.sql, offers stay EUR); VAT per lib/tax.ts +
// sql/order_tax.sql / order_tax_b2b.sql; Buy now / cart orders are
// released after 30 min unpaid (sweep_expired_pending_orders); accepted
// offers and counter-offers have 48 h with a reminder ~12 h before
// (respond_to_offer / respond_to_counter, send_offer_payment_reminders).
export default function PaymentPage() {
  return (
    <ContentPage eyebrow="Customer Care" title="Payment" lastUpdated="25 October 2026">
      {/* ACCOUNTANT REVIEW before payments go live: VAT wording + payment methods. */}
      <p>
        You buy directly from GemWorkers. Payments are handled by Stripe, one of the
        world&apos;s largest payment providers, so paying is quick and secure.
      </p>

      <h2>How you can pay</h2>
      <ul>
        <li>Credit and debit cards (such as Visa and Mastercard)</li>
        <li>Apple Pay and Google Pay</li>
        <li>PayPal</li>
        <li>iDEAL (Netherlands) and Bancontact (Belgium)</li>
        <li>Klarna (pay later or in instalments, where available)</li>
      </ul>
      <p>
        The payment page shows the methods most used in your country and on your device.
      </p>
      <p>
        <strong>Shipping to the United States, the United Kingdom, Australia or Canada?</strong>{' '}
        You see our prices in your own currency (US$, £, A$ or C$) and pay exactly that amount —
        no conversion by your bank. Prices in your currency are based on the day&apos;s exchange
        rate and can change slightly from day to day; the amount you pay is fixed when you go to
        payment, and refunds are made in the same currency.
      </p>
      <p>
        Everywhere else our prices are in euros (€); in many countries we also show an
        approximate price in your currency. If you pay in euros with a card in another
        currency, your bank converts it and may charge a small fee. Offers are always made
        and paid in euros.
      </p>

      <h2>Safe and secure</h2>
      <p>
        You pay on Stripe&apos;s secure checkout page. Your card details go straight to
        Stripe — GemWorkers never sees or stores your full card number. Your bank may ask you
        to confirm the payment in its app or with a code.
      </p>

      <h2>When you pay</h2>
      <p>
        <strong>Buy now and cart:</strong> you pay at checkout. The stone is held for you for
        30 minutes while you complete payment; if the payment isn&apos;t finished in time, the
        stone goes back on sale.
      </p>
      <p>
        <strong>Offers:</strong> making an offer costs nothing. If your offer (or our
        counter-offer) is accepted, the stone is reserved for you and you have 48 hours to
        pay from <Link href="/orders">My orders</Link>. We&apos;ll email you a reminder
        before the time runs out.
      </p>
      <p>
        The total you pay — the stone, shipping and any VAT — is always shown before you pay.
        You&apos;ll receive an order confirmation by email once your payment is complete.
      </p>

      <h2>VAT, customs and duties</h2>
      <p>
        <strong>Stones shipped from the Netherlands to the EU:</strong> VAT for your country
        is added at checkout and shown as a separate line.
      </p>
      <p>
        <strong>All other orders</strong> (stones shipped from Thailand or Pakistan, and
        orders to countries outside the EU): no VAT is charged at checkout. Import taxes or
        duties may be charged by the courier on delivery — we show an estimate on the stone
        page where we can. See <Link href="/shipping">Shipping</Link> for details.
      </p>
      <p>
        <strong>Buying for a business?</strong> Add your company and VAT number under{' '}
        <Link href="/business">Buying for a business</Link>. EU businesses outside the
        Netherlands with a verified VAT number pay 0% VAT (reverse charge).
      </p>

      <h2>Refunds</h2>
      <p>
        Refunds always go back to the payment method you used. They usually appear on your
        statement within 5–10 business days. If a payment reaches us after a reservation has
        already ended, we refund it automatically and let you know by email. Our{' '}
        <Link href="/returns">Returns &amp; Refunds</Link> page explains returns.
      </p>

      <h2>Problems paying?</h2>
      <p>
        If your payment doesn&apos;t go through, please check your details or try another
        payment method. Still stuck? Email us at{' '}
        <a href="mailto:hello@gemworkers.com">hello@gemworkers.com</a> — we&apos;re happy to help.
      </p>
    </ContentPage>
  )
}
