import Link from 'next/link'
import { ContentPage } from '@/app/components/ContentPage'

export default function GuaranteePage() {
  return (
    <ContentPage eyebrow="Customer Care" title="Our Guarantee" lastUpdated="15 October 2026">
      <p>
        Buying a gemstone online takes trust. Here is exactly what we promise.
      </p>

      <h2>Natural gemstones</h2>
      <p>
        Every gemstone we sell is natural, formed in the earth, never lab-grown or synthetic.
      </p>

      <h2>Honest treatment disclosure</h2>
      <p>
        Many gemstones are routinely treated to improve their colour or clarity; heating
        sapphires and oiling emeralds are long-standing, accepted practices. We always
        disclose every treatment we know of. Where a stone has no certificate and no
        treatment is listed, please assume it may have undergone common, industry-standard
        treatments.
      </p>

      <h2>Certificates</h2>
      <p>
        Some stones come with a certificate from an independent gemological laboratory;
        this is shown on the product page. For any other stone, you can request a
        certificate before or after purchase. The laboratory fee depends on the lab and
        report type, and is paid by the buyer; we'll quote it upfront.
      </p>

      <h2>Our certificate promise</h2>
      <p>
        If a recognised independent gemological laboratory finds that a stone is not what
        we described (a different gemstone, synthetic, or treated in a way we did not
        disclose), return it to us and we'll refund you in full, including the laboratory
        fee. This covers these factual points; it does not cover differences of opinion on
        quality grades or colour names.
      </p>

      <h2>Accurate photos</h2>
      <p>
        We photograph and describe every piece as accurately as we can. Colours can look
        slightly different between screens and lighting conditions; if you have any doubt,
        ask us for more photos or a video before you buy.
      </p>

      <h2>Secure delivery and easy returns</h2>
      <p>
        Every parcel is tracked and carefully packed. If a piece isn't right for you, you
        can return it within 30 days; see our{' '}
        <Link href="/shipping">Shipping</Link> and{' '}
        <Link href="/returns">Returns</Link> pages.
      </p>
    </ContentPage>
  )
}
