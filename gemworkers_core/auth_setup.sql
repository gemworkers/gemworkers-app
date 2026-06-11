-- auth_setup.sql
-- Creates the user_profiles table that links Supabase auth users to roles.
-- Safe to re-run (IF NOT EXISTS, DROP POLICY IF EXISTS).
-- Does NOT touch RLS policies on other tables.

-- ── user_profiles ─────────────────────────────────────────────────────────────

CREATE TABLE IF NOT EXISTS user_profiles (
  id            uuid        PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  role          text        NOT NULL CHECK (role IN ('owner', 'seller')),
  seller_id     uuid        REFERENCES sellers(id) ON DELETE SET NULL,
  display_name  text,
  created_at    timestamptz NOT NULL DEFAULT now()
);

ALTER TABLE user_profiles ENABLE ROW LEVEL SECURITY;

-- Drop any prior open dev policy.
DROP POLICY IF EXISTS user_profiles_all ON user_profiles;

-- Idempotent drops so this file is safe to re-run.
DROP POLICY IF EXISTS user_profiles_owner       ON user_profiles;
DROP POLICY IF EXISTS user_profiles_self_select ON user_profiles;
DROP POLICY IF EXISTS user_profiles_self_update ON user_profiles;

-- owner: full access to all rows.
-- Requires rls_policies.sql to have been run first (defines public.is_owner()).
CREATE POLICY user_profiles_owner
  ON user_profiles FOR ALL
  TO authenticated
  USING      (public.is_owner())
  WITH CHECK (public.is_owner());

-- Any authenticated user can read and update their own row.
CREATE POLICY user_profiles_self_select
  ON user_profiles FOR SELECT
  TO authenticated
  USING (id = auth.uid());

CREATE POLICY user_profiles_self_update
  ON user_profiles FOR UPDATE
  TO authenticated
  USING      (id = auth.uid())
  WITH CHECK (id = auth.uid());

-- ── How to add users ──────────────────────────────────────────────────────────
--
-- Step 1: Create the auth user via Supabase Dashboard → Authentication → Users
--         → "Add user" (enter email + password).
--
-- Step 2: After the auth user exists, insert their profile row below.
--
-- ── Owner profile (zakariauz@hotmail.com) ────────────────────────────────────

INSERT INTO user_profiles (id, role, display_name)
VALUES ('feb102da-a9b4-4054-83e1-95985f8caf1e', 'owner', 'Zakaria')
ON CONFLICT (id) DO NOTHING;
--
-- ── Template: seller profile ──────────────────────────────────────────────────
--
-- INSERT INTO user_profiles (id, role, seller_id, display_name)
-- VALUES (
--   (SELECT id FROM auth.users WHERE email = 'seller@example.com'),
--   'seller',
--   (SELECT id FROM sellers WHERE name = 'My Shop'),  -- replace with seller name
--   'Seller Name'
-- )
-- ON CONFLICT (id) DO NOTHING;
--
-- ── Find seller UUIDs ─────────────────────────────────────────────────────────
--
-- SELECT id, name FROM sellers;
