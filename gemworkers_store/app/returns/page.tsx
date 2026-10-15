import { ContentPage } from '@/app/components/ContentPage'

export default function ReturnsPage() {
  return (
    <ContentPage eyebrow="Customer Care" title="Returns & Refunds" lastUpdated="15 October 2026">
      <p>
        We want you to love what you buy. If a piece isn't right for you, you can return it.
      </p>

      <h2>30-day returns</h2>
      <p>
        You have 30 days from delivery to let us know you'd like to return an item. Email{' '}
        <a href="mailto:hello@gemworkers.com">hello@gemworkers.com</a> with your order number
        and we'll send you the return address and instructions. Please don't send items back
        without contacting us first.
      </p>

      <h2>Condition</h2>
      <p>
        Items must be returned in their original condition, unworn and unaltered, with their
        original packaging and any certificate or documents that came with them.
      </p>

      <h2>Items that can't be returned</h2>
      <ul>
        <li>Custom orders (stones sourced or cut especially for you)</li>
        <li>Jewelry that has been resized or altered at your request</li>
        <li>Engraved or personalised items</li>
      </ul>

      <h2>Return shipping</h2>
      <p>
        Return shipping costs are paid by the buyer. We strongly recommend a tracked and
        insured service, as the item remains your responsibility until it reaches us.
      </p>

      <h2>Refunds</h2>
      <p>
        Once we've received and checked your return, we'll refund you within 14 days, to
        your original payment method. Your refund includes the original standard shipping cost.
      </p>

      <h2>Faulty or not as described</h2>
      <p>
        If an item arrives faulty, damaged, or not as described, we'll cover the return
        shipping and give you a full refund or replacement. Please email us with photos as
        soon as possible.
      </p>

      <h2>Your legal rights</h2>
      <p>
        This policy is in addition to, and does not affect, your statutory rights as a consumer.
      </p>
    </ContentPage>
  )
}
