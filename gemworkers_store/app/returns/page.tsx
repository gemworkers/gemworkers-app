import Link from 'next/link'
import { ContentPage } from '@/app/components/ContentPage'

export const metadata = { title: 'Returns & Refunds · GemWorkers' }

// Facts here must match sql/returns_setup.sql: 30 days from delivery (60 from
// shipping if delivery isn't confirmed), private and business buyers alike,
// one NL return address (shown when the return is approved), refund = what was
// paid incl. original shipping and VAT, minus a deduction only for damage.
export default function ReturnsPage() {
  return (
    <ContentPage eyebrow="Customer Care" title="Returns & Refunds" lastUpdated="23 October 2026">
      {/* ACCOUNTANT / LEGAL REVIEW before payments go live. */}
      <p>
        We want you to love what you buy. If a stone isn&apos;t right for you, you can return
        it — no reason needed.
      </p>

      <h2>30-day returns</h2>
      <p>
        You have <strong>30 days from delivery</strong> to tell us you&apos;d like to return an
        item. This applies to private and business buyers. It is longer than the 14 days EU
        law requires.
      </p>

      <h2>How to return</h2>
      <ol>
        <li>
          Go to <Link href="/orders">My orders</Link> and click <strong>Return this stone</strong>.
          A reason is optional. (Or email{' '}
          <a href="mailto:hello@gemworkers.com">hello@gemworkers.com</a>, or use the form below.)
        </li>
        <li>We reply within 2 business days with the return address in the Netherlands.</li>
        <li>
          Send the stone back within 14 days, well packed, with its certificate and original
          packaging. Add your tracking number in My orders.
        </li>
        <li>Once it arrives and we&apos;ve checked it, we refund you.</li>
      </ol>
      <p>Please don&apos;t send items back before your return has been approved.</p>

      <h2>Your refund</h2>
      <p>
        We refund what you paid — the stone, the original standard shipping and any VAT — to
        your original payment method, within 14 days of receiving the stone back. If an item
        comes back damaged or worn, we may deduct the loss in value and will explain why.
      </p>

      <h2>Return shipping</h2>
      <p>
        Return shipping is paid by you. We strongly recommend a tracked and insured service, as
        the item remains your responsibility until it reaches us. Sending from outside the EU?
        Mark the customs form &ldquo;Returned goods&rdquo; and add your order number, so no
        import tax is charged on the return.
      </p>

      <h2>Faulty or not as described</h2>
      <p>
        If an item arrives faulty, damaged, or not as described, tick that box when you request
        the return. We then refund your return shipping as well, or offer a replacement. Please
        send photos to <a href="mailto:hello@gemworkers.com">hello@gemworkers.com</a> as soon
        as possible.
      </p>

      <h2>Items that can&apos;t be returned</h2>
      <ul>
        <li>Custom orders (stones sourced or cut especially for you)</li>
        <li>Jewellery that has been resized or altered at your request</li>
        <li>Engraved or personalised items</li>
      </ul>

      <h2>Withdrawal form</h2>
      <p>
        You may also use this form (EU model form) — copy it into an email to{' '}
        <a href="mailto:hello@gemworkers.com">hello@gemworkers.com</a>:
      </p>
      <blockquote style={{ borderLeft: '3px solid #ECE5D8', margin: '12px 0', padding: '4px 16px', color: '#5A5045' }}>
        To GemWorkers, hello@gemworkers.com:<br />
        I hereby give notice that I withdraw from my contract for the sale of the following
        goods: [stone / order number]<br />
        Ordered on / received on: [date]<br />
        Name: [your name]<br />
        Address: [your address]<br />
        Date: [date]
      </blockquote>

      <h2>Your legal rights</h2>
      <p>
        This policy is in addition to, and does not affect, your statutory rights as a consumer.
      </p>
    </ContentPage>
  )
}
