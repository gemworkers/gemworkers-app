-- =============================================================================
-- GemWorkers — Saved replies in Messages (like Etsy's saved replies)
-- =============================================================================
-- Applied to live DB 2026-10-26
--
-- Zakaria 2026-10-26: staff (owner and sellers) save answers they send often
-- and insert them into a reply with one tap. Each person sees only their own.
-- Sending still goes through the normal message functions, so the usual
-- checks (e.g. no contact details for buyers) apply to saved text too.
-- =============================================================================

BEGIN;

CREATE TABLE IF NOT EXISTS public.saved_replies (
  id         uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id    uuid NOT NULL DEFAULT auth.uid(),
  title      text NOT NULL CHECK (length(btrim(title)) BETWEEN 1 AND 80),
  body       text NOT NULL CHECK (length(btrim(body)) BETWEEN 1 AND 2000),
  created_at timestamptz NOT NULL DEFAULT now()
);
CREATE INDEX IF NOT EXISTS saved_replies_user ON public.saved_replies (user_id, created_at);

ALTER TABLE public.saved_replies ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS saved_replies_own ON public.saved_replies;
CREATE POLICY saved_replies_own ON public.saved_replies FOR ALL TO authenticated
  USING (user_id = auth.uid() AND (public.is_owner() OR public.current_seller_id() IS NOT NULL))
  WITH CHECK (user_id = auth.uid() AND (public.is_owner() OR public.current_seller_id() IS NOT NULL));
REVOKE ALL ON public.saved_replies FROM anon;
GRANT SELECT, INSERT, UPDATE, DELETE ON public.saved_replies TO authenticated;

COMMIT;
