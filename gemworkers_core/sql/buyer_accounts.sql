-- =============================================================================
-- GemWorkers — Buyer Accounts
-- =============================================================================
-- Creates public.buyers for marketplace customers who sign up via the
-- storefront. Completely separate from user_profiles (owner/seller roles).
-- No existing tables, policies, or functions are modified.
--
-- Why a separate table (not a role in user_profiles):
--   • user_profiles.role has CHECK (role IN ('owner','seller')) — extending it
--     risks breaking the is_owner() / current_seller_id() helper functions.
--   • user_profiles.seller_id is meaningless for buyers.
--   • A separate table keeps buyer PII isolated and is the clean home for
--     future buyer-specific columns (shipping addresses, saved searches, etc.).
--
-- Row creation — trigger-based:
--   A SECURITY DEFINER trigger fires on every auth.users INSERT.
--   It creates a buyers row ONLY when raw_user_meta_data->>'source' = 'storefront'.
--   Owner/seller accounts are created via the Supabase Dashboard and never carry
--   this metadata, so they will never get a buyers row.
--   The storefront signup action sets: options.data = { source: 'storefront' }.
--
-- Idempotent: safe to run repeatedly.
-- =============================================================================


-- =============================================================================
-- 1. TABLE
-- =============================================================================

CREATE TABLE IF NOT EXISTS public.buyers (
  id           uuid        PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  email        text        NOT NULL,
  display_name text,
  created_at   timestamptz NOT NULL DEFAULT now()
);


-- =============================================================================
-- 2. ROW LEVEL SECURITY
-- =============================================================================

ALTER TABLE public.buyers ENABLE ROW LEVEL SECURITY;

-- Idempotent drops.
DROP POLICY IF EXISTS buyers_self_select ON public.buyers;
DROP POLICY IF EXISTS buyers_self_update ON public.buyers;
DROP POLICY IF EXISTS buyers_owner       ON public.buyers;

-- A buyer can read only their own row.
CREATE POLICY buyers_self_select
  ON public.buyers FOR SELECT
  TO authenticated
  USING (id = auth.uid());

-- A buyer can update only their own row (no INSERT/DELETE via policy).
CREATE POLICY buyers_self_update
  ON public.buyers FOR UPDATE
  TO authenticated
  USING      (id = auth.uid())
  WITH CHECK (id = auth.uid());

-- Owner has full access — mirrors the pattern in rls_policies.sql.
-- Requires public.is_owner() to exist (created by rls_policies.sql).
CREATE POLICY buyers_owner
  ON public.buyers FOR ALL
  TO authenticated
  USING      (public.is_owner())
  WITH CHECK (public.is_owner());


-- =============================================================================
-- 3. AUTO-CREATE TRIGGER
-- =============================================================================
-- Fires on every new auth.users row. Creates a buyers record only when the
-- signup came through the storefront (source metadata present). This prevents
-- owner/seller accounts — created via Supabase Dashboard with no source
-- metadata — from accidentally receiving a buyers row.

CREATE OR REPLACE FUNCTION public.handle_new_buyer()
RETURNS trigger
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
BEGIN
  IF (NEW.raw_user_meta_data->>'source') = 'storefront' THEN
    INSERT INTO public.buyers (id, email)
    VALUES (NEW.id, NEW.email)
    ON CONFLICT (id) DO NOTHING;
  END IF;
  RETURN NEW;
END;
$$;

DROP TRIGGER IF EXISTS on_auth_user_created_buyer ON auth.users;

CREATE TRIGGER on_auth_user_created_buyer
  AFTER INSERT ON auth.users
  FOR EACH ROW
  EXECUTE FUNCTION public.handle_new_buyer();
