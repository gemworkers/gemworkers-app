import { ContentPage } from '@/app/components/ContentPage'

export const metadata = { title: 'Shipping · GemWorkers' }

export default function ShippingPage() {
  return (
    <ContentPage eyebrow="Customer Care" title="Shipping" lastUpdated="25 October 2026">
      <p>
        Every GemWorkers piece is packed by hand and shipped with care, wherever you are in
        the world.
      </p>

      <h2>Dispatch</h2>
      <p>
        Orders are dispatched within 1–5 business days. You'll receive a tracking number by
        email as soon as your parcel is on its way.
      </p>

      <h2>Delivery times</h2>
      <p>
        Our stones ship from our partners in the Netherlands, Thailand and Pakistan. The
        product page shows where each piece ships from.
      </p>
      <ul>
        <li>Ships from the Netherlands → Europe: 2–5 business days</li>
        <li>Ships from the Netherlands → rest of world: 5–15 business days</li>
        <li>Ships from Thailand or Pakistan → worldwide: 8–30 business days</li>
      </ul>
      <p>These are estimates; customs checks can occasionally add time.</p>

      <h2>Carriers</h2>
      <p>
        We use trusted, tracked couriers, chosen for each route to give your parcel the
        safest and most reliable journey. High-value orders require a signature on delivery.
      </p>

      <h2>Lost or damaged parcels</h2>
      <p>Every parcel is tracked, and high-value orders require a signature.</p>
      <p>
        <strong>Lost parcels:</strong> if tracking shows your parcel hasn't arrived within
        10 business days after the latest estimated delivery date, contact us. We'll open an
        investigation with the courier. If the parcel is confirmed lost, we'll refund you in
        full or, if you prefer, offer a comparable piece.
      </p>
      <p>
        <strong>Marked as delivered:</strong> if tracking shows your parcel as delivered but
        you haven't received it, please check with neighbours and your building first, then
        contact us within 7 days. We'll investigate with the courier and help however we can.
      </p>
      <p>
        <strong>Damaged on arrival:</strong> email{' '}
        <a href="mailto:hello@gemworkers.com">hello@gemworkers.com</a> within 7 days of
        delivery with photos of the item and packaging, and keep both. We may ask you to
        return the item. Once we've confirmed the damage, we'll repair, replace, or refund
        it in full.
      </p>

      <h2>Customs, duties and taxes</h2>
      {/* ACCOUNTANT REVIEW: duties/VAT wording (no IOSS: import VAT is paid on delivery). */}
      <p>
        <strong>Shipped from the Netherlands to the EU:</strong> no customs. The VAT of your
        country is included in the price and charged at checkout.
      </p>
      <p>
        <strong>All other orders</strong>, meaning pieces shipped from Thailand or Pakistan
        (also to EU countries) and orders to countries outside the EU, may be subject to import
        VAT, duties or customs fees in your country. We don&apos;t charge these at checkout: the
        courier usually collects them before delivery, and they are paid by you. Where we can,
        the product page shows an estimate. Some countries charge nothing below a certain value.
      </p>
      <p>
        Every parcel travels with our invoice showing the real price paid, as customs
        require. We never mark parcels as gifts. If you&apos;re unsure what applies in your
        country, please contact your local customs office.
      </p>
      <p>
        <strong>United Kingdom:</strong> orders must be at least €160, so UK VAT is paid at the
        border like other imports.
      </p>

      <h2>Questions</h2>
      <p>
        Email us at{' '}
        <a href="mailto:hello@gemworkers.com">hello@gemworkers.com</a> — we're happy to help.
      </p>
    </ContentPage>
  )
}
