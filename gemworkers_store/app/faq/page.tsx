import Link from 'next/link'
import { ContentPage } from '@/app/components/ContentPage'

export default function FaqPage() {
  return (
    <ContentPage
      eyebrow="Customer Care"
      title="Frequently Asked Questions"
      lastUpdated="15 October 2026"
    >
      <h3>Are your gemstones natural?</h3>
      <p>
        Yes. Every gemstone we sell is natural, never lab-grown or synthetic. See{' '}
        <Link href="/guarantee">Our Guarantee</Link>.
      </p>

      <h3>Are your stones treated?</h3>
      <p>
        Some are, as is common in the gem trade. We always disclose every treatment we
        know of on the product page.
      </p>

      <h3>Do your stones come with a certificate?</h3>
      <p>
        Some do, as shown on the product page. For any other stone you can request one;
        the lab fee is paid by the buyer and quoted upfront.
      </p>

      <h3>Where do your stones come from?</h3>
      <p>
        From mines around the world, including Afghanistan, Pakistan, Africa and the Americas,
        often via trusted partners in Thailand. Each product page shows the stone&apos;s origin
        and where it ships from.
      </p>

      <h3>How long does shipping take?</h3>
      <p>
        Orders are dispatched within 1–5 business days. Delivery takes 2–30 business days
        depending on where the piece ships from and to. See{' '}
        <Link href="/shipping">Shipping</Link>.
      </p>

      <h3>Will I have to pay customs or import fees?</h3>
      <p>
        Possibly. Depending on your country, import duties or taxes may be charged on
        delivery. See <Link href="/shipping">Shipping</Link>.
      </p>

      <h3>Can I return an item?</h3>
      <p>
        Yes, within 30 days of delivery, except custom, resized or engraved items. See{' '}
        <Link href="/returns">Returns & Refunds</Link>.
      </p>

      <h3>Do the photos show the real stone?</h3>
      <p>
        Yes, every photo is of the actual piece you'll receive. Colours may vary slightly
        between screens; we're happy to send extra photos or a video.
      </p>

      <h3>Can you find a specific stone for me?</h3>
      <p>
        Often, yes. Our partners source directly in Thailand and Pakistan. Email{' '}
        <a href="mailto:hello@gemworkers.com">hello@gemworkers.com</a> with what you're
        looking for.
      </p>

      <h3>How can I contact you?</h3>
      <p>
        Email <a href="mailto:hello@gemworkers.com">hello@gemworkers.com</a>. We aim to
        reply within 1–2 business days.
      </p>
    </ContentPage>
  )
}
