// Email sign-up ("New stones, first") — sql/newsletter.sql. The exact text
// people agree to is stored with each sign-up as proof of consent; change it
// here only together with the box text in app/components/NewsletterSignup.tsx.
export const NEWSLETTER_CONSENT =
  'I want to receive emails from GemWorkers about new stones and offers. I can unsubscribe at any time.'

export const SITE = process.env.NEXT_PUBLIC_SITE_URL ?? 'https://www.gemworkers.com'
