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

DROP POLICY IF EXISTS user_profiles_all ON user_profiles;

-- DEV: open policy — replace with authenticated policies before production.
CREATE POLICY user_profiles_all ON user_profiles
  FOR ALL TO public USING (true) WITH CHECK (true);

-- ── How to add users ──────────────────────────────────────────────────────────
--
-- Step 1: Create the auth user via Supabase Dashboard → Authentication → Users
--         → "Add user" (enter email + password).
--
-- Step 2: After the auth user exists, insert their profile row below.
--
-- ── Template: owner profile ───────────────────────────────────────────────────
--
-- INSERT INTO user_profiles (id, role, display_name)
-- VALUES (
--   (SELECT id FROM auth.users WHERE email = 'zakariauz@hotmail.com'),
--   'owner',
--   'Zakaria'
-- )
-- ON CONFLICT (id) DO NOTHING;
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
