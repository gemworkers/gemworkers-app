import Link from 'next/link'
import { ContentPage } from '@/app/components/ContentPage'

export const metadata = { title: 'Payment Information · GemWorkers' }

// Facts here must match the code: Stripe Checkout, payment_method_types
// ['card'], currency EUR (app/actions/commerce.ts); Buy now / cart orders are
// released after 30 min unpaid (sweep_expired_pending_orders); accepted
// offers and counter-offers have 48 h with a reminder ~12 h before
// (respond_to_offer / respond_to_counter, send_offer_payment_reminders).
export default function PaymentPage() {
  return (
    <ContentPage eyebrow="Customer Care" title="Payment" lastUpdated="22 October 2026">
      {/* ACCOUNTANT REVIEW before payments go live: VAT wording + payment methods. */}
      <p>
        You buy directly from GemWorkers. Payments are handled by Stripe, one of the
        world&apos;s largest payment providers, so paying is quick and secure.
      </p>

      <h2>How you can pay</h2>
      <ul>
        <li>Credit and debit cards (such as Visa and Mastercard)</li>
      </ul>
      <p>
        All prices are in euros (€). If your card is in another currency, your bank converts
        the amount and may charge a small fee for this.
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
        The total you pay — the stone plus shipping — is always shown before you pay.
        You&apos;ll receive an order confirmation by email once your payment is complete.
      </p>

      <h2>Customs, duties and taxes</h2>
      <p>
        For orders shipped across borders, import duties or taxes may apply. See{' '}
        <Link href="/shipping">Shipping</Link> for details.
      </p>

      <h2>Refunds</h2>
      <p>
        Refunds always go back to the card you paid with. They usually appear on your
        statement within 5–10 business days. If a payment reaches us after a reservation has
        already ended, we refund it automatically and let you know by email. Our{' '}
        <Link href="/returns">Returns &amp; Refunds</Link> page explains returns.
      </p>

      <h2>Problems paying?</h2>
      <p>
        If your payment doesn&apos;t go through, please check your card details or try another
        card. Still stuck? Email us at{' '}
        <a href="mailto:hello@gemworkers.com">hello@gemworkers.com</a> — we&apos;re happy to help.
      </p>
    </ContentPage>
  )
}
