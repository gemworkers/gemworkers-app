-- =============================================================================
-- GemWorkers — Social media links (edited by the owner in the admin)
-- =============================================================================
-- NOT YET APPLIED
--
-- Zakaria 2026-10-26: GemWorkers' own accounts (one per platform, never seller
-- accounts) shown as icons in the store footer and the admin. Stored in
-- store_settings (social_<platform>), edited in Admin → Taxes & duties →
-- Company details → Social media. public_social_links shows only https links
-- on that platform's own domain, so a typo can never put a strange link on the shop.
-- Starting values = the links Zakaria sent (Facebook: the page's permanent address).
-- =============================================================================

BEGIN;

INSERT INTO public.store_settings (key, value) VALUES
  ('social_instagram', 'https://www.instagram.com/gemworkersnl'),
  ('social_facebook',  'https://www.facebook.com/profile.php?id=100077691091750'),
  ('social_tiktok',    'https://www.tiktok.com/@gemworkers'),
  ('social_pinterest', 'https://www.pinterest.com/gemworkers'),
  ('social_youtube',   'https://www.youtube.com/@GemWorkers-l2j'),
  ('social_x',         'https://x.com/gemworkers')
ON CONFLICT (key) DO NOTHING;

CREATE OR REPLACE VIEW public.public_social_links AS
SELECT
  max(value) FILTER (WHERE key = 'social_instagram' AND value ~ '^https://(www\.)?instagram\.com/') AS instagram,
  max(value) FILTER (WHERE key = 'social_facebook'  AND value ~ '^https://(www\.|m\.)?facebook\.com/') AS facebook,
  max(value) FILTER (WHERE key = 'social_tiktok'    AND value ~ '^https://(www\.)?tiktok\.com/') AS tiktok,
  max(value) FILTER (WHERE key = 'social_pinterest' AND value ~ '^https://([a-z]{2}\.|www\.)?pinterest\.[a-z.]+/') AS pinterest,
  max(value) FILTER (WHERE key = 'social_youtube'   AND value ~ '^https://(www\.)?youtube\.com/') AS youtube,
  max(value) FILTER (WHERE key = 'social_x'         AND value ~ '^https://(www\.)?(x|twitter)\.com/') AS x
FROM public.store_settings
WHERE key LIKE 'social\_%';

GRANT SELECT ON public.public_social_links TO anon, authenticated;

COMMIT;
