import { ContentPage } from '@/app/components/ContentPage'

export default function PrivacyPage() {
  return (
    <ContentPage eyebrow="Legal" title="Privacy Policy" lastUpdated="15 October 2026">
      {/* LEGAL REVIEW before launch. ADD business address to "Who we are" before launch. Check partner data transfers outside the EU (Thailand/Pakistan). Update cookie section if analytics are added. */}

      <h2>Who we are</h2>
      <p>
        Gem Workers (trading as GemWorkers), registered in the Netherlands (KvK 88333418),
        is responsible for your personal data. Contact:{' '}
        <a href="mailto:hello@gemworkers.com">hello@gemworkers.com</a>.
      </p>

      <h2>What we collect</h2>
      <ul>
        <li>Account details: your name and email address.</li>
        <li>
          Order details: your name, shipping address, phone number (if given), and what
          you ordered.
        </li>
        <li>Messages: anything you send us by email.</li>
        <li>
          Technical data needed to run the website, such as a cookie that keeps you
          logged in.
        </li>
      </ul>
      <p>
        We do not receive or store your full card details; payments are handled by our
        payment providers.
      </p>

      <h2>Why we use it</h2>
      <ul>
        <li>To process and deliver your orders (performance of our contract with you).</li>
        <li>To keep records required by tax law (legal obligation).</li>
        <li>To answer your questions and provide customer service.</li>
        <li>To keep the website secure and prevent fraud (legitimate interest).</li>
      </ul>

      <h2>Who we share it with</h2>
      <p>We share only what is needed:</p>
      <ul>
        <li>
          Our partners and couriers, who need your name, address and phone number to ship
          your order. Some partners are located outside the EU (Thailand and Pakistan).
        </li>
        <li>
          Service providers that run our website, payments and email (for example hosting,
          payment processing and email delivery). They may only use your data to provide
          their service to us.
        </li>
      </ul>
      <p>We never sell your data.</p>

      <h2>How long we keep it</h2>
      <p>
        Order and invoice records are kept for 7 years, as required by Dutch tax law.
        Account details are kept until you ask us to delete your account.
      </p>

      <h2>Your rights</h2>
      <p>
        You can ask us to see, correct, or delete your personal data, to limit or object
        to how we use it, or to receive a copy of it. Email{' '}
        <a href="mailto:hello@gemworkers.com">hello@gemworkers.com</a>. You can also file
        a complaint with the Dutch Data Protection Authority (Autoriteit Persoonsgegevens)
        or the authority in your own country.
      </p>

      <h2>Cookies</h2>
      <p>
        We use only the cookies needed for the website to work, such as keeping you logged
        in. We do not use analytics, advertising or tracking cookies.
      </p>

      <h2>Changes</h2>
      <p>
        We may update this policy from time to time. The latest version is always on this
        page.
      </p>
    </ContentPage>
  )
}
