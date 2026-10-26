-- =============================================================================
-- GemWorkers — Email sign-up ("New stones, first") with proof of consent
-- =============================================================================
-- Applied to live DB 2026-10-26
--
-- Zakaria 2026-10-26. EU rules (GDPR / e-privacy): marketing email only to people
-- who clearly opted in, provable. Double opt-in:
--   sign-up box (store, Turnstile) → status 'pending' + confirmation email →
--   click → 'confirmed' (confirmed_at = the proof, with the exact consent text)
--   → every email has an unsubscribe link → 'unsubscribed'.
-- Written ONLY by the store server (service role): no anon/authenticated
-- policies. The owner reads the list in the admin (Subscribers).
-- =============================================================================

BEGIN;

CREATE TABLE IF NOT EXISTS public.newsletter_subscribers (
  id                uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  email             text NOT NULL UNIQUE CHECK (email = lower(email)),
  status            text NOT NULL DEFAULT 'pending'
                    CHECK (status IN ('pending', 'confirmed', 'unsubscribed')),
  confirm_token     uuid NOT NULL DEFAULT gen_random_uuid(),
  unsubscribe_token uuid NOT NULL DEFAULT gen_random_uuid(),
  consent_text      text NOT NULL,          -- exactly what the person agreed to
  source            text,                   -- e.g. 'footer'
  signed_up_at      timestamptz NOT NULL DEFAULT now(),
  confirmed_at      timestamptz,
  unsubscribed_at   timestamptz
);
CREATE UNIQUE INDEX IF NOT EXISTS newsletter_confirm_token ON public.newsletter_subscribers (confirm_token);
CREATE UNIQUE INDEX IF NOT EXISTS newsletter_unsubscribe_token ON public.newsletter_subscribers (unsubscribe_token);

ALTER TABLE public.newsletter_subscribers ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS newsletter_owner_read ON public.newsletter_subscribers;
CREATE POLICY newsletter_owner_read ON public.newsletter_subscribers FOR SELECT TO authenticated
  USING (public.is_owner());
REVOKE ALL ON public.newsletter_subscribers FROM anon, authenticated;
GRANT SELECT ON public.newsletter_subscribers TO authenticated;

COMMIT;
