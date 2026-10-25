import Link from 'next/link'
import { ContentPage } from '@/app/components/ContentPage'
import { companyInfo } from '@/lib/company'

export const metadata = { title: 'Terms & Conditions · GemWorkers' }

export default async function TermsPage() {
  const c = await companyInfo()
  return (
    <ContentPage eyebrow="Legal" title="Terms & Conditions" lastUpdated="25 October 2026">
      {/* LEGAL REVIEW before payments go live. Company details come from admin → Company details. */}

      <h2>Who we are</h2>
      <p>
        GemWorkers is the trading name of {c.name}, registered in the Netherlands.
      </p>
      <ul>
        {c.address && <li style={{ whiteSpace: 'pre-line' }}>Address: {c.address}</li>}
        {c.kvk && <li>Chamber of Commerce (KvK): {c.kvk}</li>}
        {c.vat && <li>VAT number: {c.vat}</li>}
        <li>Email: <a href={`mailto:${c.email}`}>{c.email}</a></li>
      </ul>
      <p>
        When you buy from GemWorkers, your contract is with {c.name}. GemWorkers sells
        every piece in its own name, including pieces it sells on behalf of partners. Some
        pieces are shipped directly from our partners in Thailand and Pakistan; the product
        page shows where each piece ships from.
      </p>

      <h2>These terms</h2>
      <p>
        These terms apply to all purchases on gemworkers.com. By placing an order, you
        agree to them.
      </p>

      <h2>Our products</h2>
      <p>
        Most of our pieces are one of a kind. We describe and photograph each piece as
        accurately as we can; colours may appear slightly different on different screens.
        Treatments are disclosed as described in{' '}
        <Link href="/guarantee">Our Guarantee</Link>.
      </p>

      <h2>Prices</h2>
      {/* ACCOUNTANT REVIEW: VAT/duties wording */}
      <p>
        All prices are in euros. Choose your country under &ldquo;Ship to&rdquo; at the top of
        the page; prices, shipping and taxes are then shown for that country.
      </p>
      <ul>
        <li>
          <strong>Pieces shipped from the Netherlands to the EU:</strong> prices shown include
          the VAT of your country. The VAT is also shown separately at checkout and on your
          invoice.
        </li>
        <li>
          <strong>All other orders</strong> (pieces shipped from Thailand or Pakistan, and
          orders to countries outside the EU): no VAT is charged by us. Import VAT, duties or
          customs fees may be charged by your country on delivery and are paid by you; we show
          an estimate where we can. See <Link href="/shipping">Shipping</Link>.
        </li>
        <li>
          <strong>Business buyers in the EU</strong> outside the Netherlands with a verified VAT
          number buy at 0% VAT (reverse charge). See{' '}
          <Link href="/business">Buying for a business</Link>.
        </li>
      </ul>
      <p>The total you pay, including shipping and any VAT, is always shown before you pay.</p>

      <h2>Orders</h2>
      <p>
        Your order is confirmed when you receive our order confirmation by email. If a
        piece turns out to be unavailable, or a price or description contains an obvious
        error, we may cancel the order and refund you in full.
      </p>

      <h2>Payment</h2>
      <p>
        Payments are processed securely by Stripe. Depending on your country you can pay by
        card, Apple Pay, Google Pay, PayPal, iDEAL, Bancontact or Klarna. We never see or
        store your full card details. How and when you pay is explained on our{' '}
        <Link href="/payment">Payment</Link> page.
      </p>

      <h2>Delivery</h2>
      <p>
        Delivery times, tracking and lost or damaged parcels are covered on our{' '}
        <Link href="/shipping">Shipping</Link> page.
      </p>

      <h2>Returns and right of withdrawal</h2>
      <p>
        You may return most items within 30 days of delivery, which is longer than the
        14-day withdrawal period required by EU law. Custom, resized and engraved items
        are excluded. Full details are on our{' '}
        <Link href="/returns">Returns & Refunds</Link> page.
      </p>

      <h2>Legal guarantee</h2>
      <p>
        Your products are covered by the legal guarantee of conformity that applies in
        your country. Our own promises, described in{' '}
        <Link href="/guarantee">Our Guarantee</Link>, are in addition to this.
      </p>

      <h2>Liability</h2>
      <p>
        We are not liable for indirect or consequential loss, to the extent permitted by
        law. Nothing in these terms limits liability that cannot be limited by law, or
        your statutory rights as a consumer.
      </p>

      <h2>Website content</h2>
      <p>
        All photos, texts and designs on this website belong to GemWorkers and may not
        be used without our permission.
      </p>

      <h2>Governing law</h2>
      <p>
        These terms are governed by Dutch law. If you are a consumer, you also keep the
        protection of the mandatory laws of the country where you live.
      </p>

      <h2>Changes</h2>
      <p>
        We may update these terms from time to time. The version on this page at the time
        of your order applies to that order.
      </p>

      <h2>Contact</h2>
      <p>
        Questions about these terms? Email{' '}
        <a href={`mailto:${c.email}`}>{c.email}</a>.
      </p>
    </ContentPage>
  )
}
