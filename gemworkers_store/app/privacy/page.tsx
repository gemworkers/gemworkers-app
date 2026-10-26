import { ContentPage } from '@/app/components/ContentPage'
import { companyInfo } from '@/lib/company'

export const metadata = { title: 'Privacy Policy · GemWorkers' }

export default async function PrivacyPage() {
  const c = await companyInfo()
  return (
    <ContentPage eyebrow="Legal" title="Privacy Policy" lastUpdated="26 October 2026">
      {/* LEGAL REVIEW before launch: partner data transfers outside the EU (Thailand/Pakistan, standard contractual clauses?). Update cookies if analytics are added. */}

      <h2>Who we are</h2>
      <p>
        {c.name} (trading as GemWorkers), registered in the Netherlands
        {c.kvk ? ` (KvK ${c.kvk})` : ''}, is responsible for your personal data.
        {c.address && <> Address: <span style={{ whiteSpace: 'pre-line' }}>{c.address}</span>.</>} Contact:{' '}
        <a href={`mailto:${c.email}`}>{c.email}</a>.
      </p>

      <h2>What we collect</h2>
      <ul>
        <li>
          Account details: your name and email address. If you buy without logging in, we
          create an account with the email you give, so you can follow your order, request a
          return and see your invoice; you can choose a password later or ask us to delete it.
        </li>
        <li>
          Order details: your name, shipping address, phone number (if given), and what
          you ordered.
        </li>
        <li>Messages: anything you send us by email or through Messages on our website.</li>
        <li>
          Business buyers: company name and VAT number, and the result of the check in the
          EU VAT register (VIES), which we must keep as proof for 0% VAT.
        </li>
        <li>Reviews you write, and returns or refunds you ask for.</li>
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
        <li>To keep records required by tax law, such as invoices (legal obligation).</li>
        <li>To answer your questions and provide customer service.</li>
        <li>To keep the website secure and prevent fraud (legitimate interest).</li>
      </ul>

      <h2>Who we share it with</h2>
      <p>We share only what is needed:</p>
      <ul>
        <li>
          Our partners and couriers, who need your name, address and phone number to ship
          your order. Some partners are located outside the EU (Thailand and Pakistan); they
          receive only what is needed to ship and answer questions about the piece you bought.
        </li>
        <li>
          Service providers that run our shop: our payment provider Stripe (including PayPal
          and Klarna through Stripe), and providers for website hosting, our database, email
          delivery and spam protection at login. They may only use your data to provide their
          service to us. Some of them are based outside the EU (for example in the United
          States); where that is the case, your data is protected by the European
          Commission&apos;s standard contractual clauses or an equivalent safeguard.
        </li>
      </ul>
      <p>We never sell your data.</p>

      <h2>How long we keep it</h2>
      <p>
        Order and invoice records are kept for 7 years (10 years for EU sales reported
        through the One-Stop-Shop), as required by tax law. Account details are kept until
        you ask us to delete your account.
      </p>

      <h2>Your rights</h2>
      <p>
        You can ask us to see, correct, or delete your personal data, to limit or object
        to how we use it, or to receive a copy of it. Email{' '}
        <a href={`mailto:${c.email}`}>{c.email}</a>. Records we must keep for tax law are
        kept even after your account is deleted. You can also file
        a complaint with the Dutch Data Protection Authority (Autoriteit Persoonsgegevens)
        or the authority in your own country.
      </p>

      <h2>Cookies</h2>
      <p>
        We use only the cookies needed for the website to work: keeping you logged in and
        remembering the country you ship to. We do not use analytics, advertising or tracking
        cookies.
      </p>

      <h2>Changes</h2>
      <p>
        We may update this policy from time to time. The latest version is always on this
        page.
      </p>
    </ContentPage>
  )
}
