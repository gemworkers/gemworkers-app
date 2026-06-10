-- auth_setup.sql
-- Creates the user_profiles table that links Supabase auth users to roles.
-- Safe to re-run (IF NOT EXISTS, DROP POLICY IF EXISTS).
-- DO NOT touch RLS policies on other tables — run dev_open_policies.sql separately.

-- ── user_profiles table ───────────────────────────────────────────────────────

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
-- Step 1: Create the auth user.
--   Option A — Supabase Dashboard → Authentication → Users → "Add user"
--   Option B — Supabase SQL editor (requires service_role):
--     SELECT auth.uid();  -- confirm you are connected
--
-- Step 2: After creating the auth user, insert their profile row.
--
-- OWNER profile (full access, sees all sellers):
--   INSERT INTO user_profiles (id, role, display_name)
--   VALUES ('<auth-user-uuid>', 'owner', 'Your Name');
--
-- SELLER profile (scoped to one seller's data):
--   INSERT INTO user_profiles (id, role, seller_id, display_name)
--   VALUES ('<auth-user-uuid>', 'seller', '<seller-uuid>', 'Seller Name');
--
-- Look up seller UUIDs:
--   SELECT id, name FROM sellers;
--
-- ── Template: create owner for zakariauz@hotmail.com ─────────────────────────
-- Run this AFTER creating the auth user via the Supabase dashboard:
--
-- INSERT INTO user_profiles (id, role, display_name)
-- VALUES (
--   (SELECT id FROM auth.users WHERE email = 'zakariauz@hotmail.com'),
--   'owner',
--   'Zakaria'
-- )
-- ON CONFLICT (id) DO NOTHING;
