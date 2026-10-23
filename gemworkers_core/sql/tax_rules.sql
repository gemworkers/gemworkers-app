-- =============================================================================
-- GemWorkers — Tax & duties rules (tax plan, step 2: data + admin only)
-- =============================================================================
-- Applied to live DB 2026-10-23
--
-- Nothing here charges anyone yet: step 3 (checkout) reads these tables.
-- All starting values are Claude's best knowledge (2025) and are marked
-- verified = false. Unknown values are left NULL = "buyer pays on delivery,
-- no estimate shown" rather than guessed. The owner edits everything in the
-- admin (Taxes & duties); the accountant reviews before live payments.
--
-- 1. tax_rules — one row per destination country (FK shipping_countries).
--      mode             collect    = we charge tax + duty at checkout, ship DDP
--                       buyer_pays = estimate shown, courier collects on delivery
--                       none       = no import tax/duty expected (e.g. HK)
--      tax_name/rate    VAT / GST / sales tax on the goods (0.2100 = 21%)
--      duty_loose / duty_jewelry / duty_specimen  base import duty by type
--      free_below_eur   consignments under this value: no import tax/duty
--      customs_union    e.g. 'EU': origin and destination in the same union
--                       → no import (no duty), VAT of the destination only
--      verified         ticked once the owner / accountant confirmed the row
--    Countries without a row: treated as buyer_pays, no estimate.
-- 2. origin_duties — extra duty for (destination, origin), e.g. US tariffs
--    on goods from Thailand / Pakistan / the EU. Added on top of the base duty.
-- 3. shipping_routes — price + delivery days per (origin country, destination
--    region or country). Empty at first; checkout keeps the stone's own
--    shipping_cost until a route exists. A country row beats a region row.
--
-- RLS: everyone may read (store shows estimates); only the owner writes.
-- =============================================================================

BEGIN;

-- Qatar was missing from shipping_countries (the generator skipped all Q*
-- codes as private-use; QA is the one real country). Add it first.
INSERT INTO public.shipping_countries (code, name, region, enabled, sort_order)
VALUES ('QA', 'Qatar', 'Middle East', true, 30)
ON CONFLICT (code) DO NOTHING;

-- ── 1. tax_rules ────────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS public.tax_rules (
  country_code   text         PRIMARY KEY REFERENCES public.shipping_countries(code) ON DELETE CASCADE,
  mode           text         NOT NULL DEFAULT 'buyer_pays'
                              CHECK (mode IN ('collect', 'buyer_pays', 'none')),
  tax_name       text,
  tax_rate       numeric(6,4) CHECK (tax_rate IS NULL OR tax_rate BETWEEN 0 AND 1),
  duty_loose     numeric(6,4) CHECK (duty_loose    IS NULL OR duty_loose    BETWEEN 0 AND 1),
  duty_jewelry   numeric(6,4) CHECK (duty_jewelry  IS NULL OR duty_jewelry  BETWEEN 0 AND 1),
  duty_specimen  numeric(6,4) CHECK (duty_specimen IS NULL OR duty_specimen BETWEEN 0 AND 1),
  free_below_eur numeric(12,2) CHECK (free_below_eur IS NULL OR free_below_eur >= 0),
  customs_union  text,
  notes          text,
  verified       boolean      NOT NULL DEFAULT false,
  updated_at     timestamptz  NOT NULL DEFAULT now()
);

-- ── 2. origin_duties ────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS public.origin_duties (
  dest_code   text         NOT NULL REFERENCES public.shipping_countries(code) ON DELETE CASCADE,
  origin_code text         NOT NULL CHECK (origin_code ~ '^[A-Z]{2}$'),
  extra_duty  numeric(6,4) NOT NULL CHECK (extra_duty BETWEEN 0 AND 1),
  notes       text,
  verified    boolean      NOT NULL DEFAULT false,
  updated_at  timestamptz  NOT NULL DEFAULT now(),
  PRIMARY KEY (dest_code, origin_code)
);

-- ── 3. shipping_routes ──────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS public.shipping_routes (
  id           uuid          PRIMARY KEY DEFAULT gen_random_uuid(),
  origin_code  text          NOT NULL CHECK (origin_code ~ '^[A-Z]{2}$'),
  dest_region  text,
  dest_code    text          REFERENCES public.shipping_countries(code) ON DELETE CASCADE,
  price_eur    numeric(10,2) NOT NULL CHECK (price_eur >= 0),
  days_min     integer       CHECK (days_min IS NULL OR days_min >= 0),
  days_max     integer       CHECK (days_max IS NULL OR days_max >= 0),
  courier      text,
  updated_at   timestamptz   NOT NULL DEFAULT now(),
  CHECK ((dest_region IS NULL) <> (dest_code IS NULL))
);

CREATE UNIQUE INDEX IF NOT EXISTS shipping_routes_origin_region_key
  ON public.shipping_routes (origin_code, dest_region) WHERE dest_region IS NOT NULL;
CREATE UNIQUE INDEX IF NOT EXISTS shipping_routes_origin_country_key
  ON public.shipping_routes (origin_code, dest_code) WHERE dest_code IS NOT NULL;

-- ── RLS + grants (same pattern as shipping_countries) ───────────────────────
DO $$
DECLARE t text;
BEGIN
  FOREACH t IN ARRAY ARRAY['tax_rules', 'origin_duties', 'shipping_routes'] LOOP
    EXECUTE format('ALTER TABLE public.%I ENABLE ROW LEVEL SECURITY', t);
    EXECUTE format('DROP POLICY IF EXISTS %I ON public.%I', t || '_public_read', t);
    EXECUTE format('DROP POLICY IF EXISTS %I ON public.%I', t || '_owner', t);
    EXECUTE format('CREATE POLICY %I ON public.%I FOR SELECT TO anon, authenticated USING (true)', t || '_public_read', t);
    EXECUTE format('CREATE POLICY %I ON public.%I FOR ALL TO authenticated USING (public.is_owner()) WITH CHECK (public.is_owner())', t || '_owner', t);
    EXECUTE format('REVOKE ALL ON public.%I FROM anon, authenticated', t);
    EXECUTE format('GRANT SELECT ON public.%I TO anon', t);
    EXECUTE format('GRANT SELECT, INSERT, UPDATE, DELETE ON public.%I TO authenticated', t);
  END LOOP;
END;
$$;

-- ── Starting values (verified = false — Claude's 2025 knowledge, CHECK THEM) ─
-- EU-27: standard VAT; loose stones / specimens 0% duty, jewellery ~2.5%.
-- From NL to an EU buyer there is no import (customs_union 'EU'): VAT only,
-- via OSS. From TH / PK: import — IOSS up to €150, DDP above.
INSERT INTO public.tax_rules
  (country_code, mode, tax_name, tax_rate, duty_loose, duty_jewelry, duty_specimen, free_below_eur, customs_union, notes)
VALUES
  ('AT','collect','VAT',0.2000,0,0.025,0,NULL,'EU',NULL),
  ('BE','collect','VAT',0.2100,0,0.025,0,NULL,'EU',NULL),
  ('BG','collect','VAT',0.2000,0,0.025,0,NULL,'EU',NULL),
  ('HR','collect','VAT',0.2500,0,0.025,0,NULL,'EU',NULL),
  ('CY','collect','VAT',0.1900,0,0.025,0,NULL,'EU',NULL),
  ('CZ','collect','VAT',0.2100,0,0.025,0,NULL,'EU',NULL),
  ('DK','collect','VAT',0.2500,0,0.025,0,NULL,'EU',NULL),
  ('EE','collect','VAT',0.2400,0,0.025,0,NULL,'EU','Rate raised during 2025 — check.'),
  ('FI','collect','VAT',0.2550,0,0.025,0,NULL,'EU',NULL),
  ('FR','collect','VAT',0.2000,0,0.025,0,NULL,'EU',NULL),
  ('DE','collect','VAT',0.1900,0,0.025,0,NULL,'EU',NULL),
  ('GR','collect','VAT',0.2400,0,0.025,0,NULL,'EU',NULL),
  ('HU','collect','VAT',0.2700,0,0.025,0,NULL,'EU',NULL),
  ('IE','collect','VAT',0.2300,0,0.025,0,NULL,'EU',NULL),
  ('IT','collect','VAT',0.2200,0,0.025,0,NULL,'EU',NULL),
  ('LV','collect','VAT',0.2100,0,0.025,0,NULL,'EU',NULL),
  ('LT','collect','VAT',0.2100,0,0.025,0,NULL,'EU',NULL),
  ('LU','collect','VAT',0.1700,0,0.025,0,NULL,'EU',NULL),
  ('MT','collect','VAT',0.1800,0,0.025,0,NULL,'EU',NULL),
  ('NL','collect','VAT',0.2100,0,0.025,0,NULL,'EU','Home country.'),
  ('PL','collect','VAT',0.2300,0,0.025,0,NULL,'EU',NULL),
  ('PT','collect','VAT',0.2300,0,0.025,0,NULL,'EU',NULL),
  ('RO','collect','VAT',0.2100,0,0.025,0,NULL,'EU','Rate raised during 2025 — check.'),
  ('SK','collect','VAT',0.2300,0,0.025,0,NULL,'EU','Rate raised in 2025 — check.'),
  ('SI','collect','VAT',0.2200,0,0.025,0,NULL,'EU',NULL),
  ('ES','collect','VAT',0.2100,0,0.025,0,NULL,'EU',NULL),
  ('SE','collect','VAT',0.2500,0,0.025,0,NULL,'EU',NULL),
  -- United States: no federal VAT; state sales tax not collected for now
  -- (economic-nexus thresholds). Duty-free $800 de minimis suspended 2025 —
  -- every parcel is dutiable. Base duty (HTS 7103 gems ~0%, 7113 jewellery
  -- ~5.5%); origin tariffs in origin_duties.
  ('US','collect','Sales tax',NULL,0,0.055,0,0,NULL,'De minimis suspended 2025; tariffs change often — check before launch.'),
  -- United Kingdom: VAT 20%; up to £135 the seller collects (UK VAT registration).
  ('GB','collect','VAT',0.2000,0,0.025,0,NULL,NULL,'Up to £135 seller collects UK VAT (registration needed).'),
  -- Hong Kong: free port.
  ('HK','none',NULL,0,0,0,0,NULL,NULL,'Free port — no VAT or duty.'),
  -- Others: buyer pays on delivery until we register / confirm.
  ('CA','buyer_pays','GST/HST',0.0500,0,NULL,0,NULL,NULL,'GST 5% + provincial HST up to 15% depending on province.'),
  ('AU','buyer_pays','GST',0.1000,0,0.05,0,NULL,NULL,'Up to A$1,000 GST is collected by registered sellers.'),
  ('SG','buyer_pays','GST',0.0900,0,0,0,NULL,NULL,NULL),
  ('JP','buyer_pays','Consumption tax',0.1000,0,NULL,0,NULL,NULL,NULL),
  ('CH','buyer_pays','VAT',0.0810,0,NULL,0,NULL,NULL,NULL),
  ('NO','buyer_pays','VAT',0.2500,0,NULL,0,NULL,NULL,'Up to NOK 3,000 registered sellers collect (VOEC).'),
  ('IL','buyer_pays','VAT',0.1800,NULL,NULL,NULL,NULL,NULL,NULL),
  ('AE','buyer_pays','VAT',0.0500,0.05,0.05,0.05,NULL,NULL,'Customs duty generally 5%.'),
  ('SA','buyer_pays','VAT',0.1500,NULL,NULL,NULL,NULL,NULL,NULL),
  ('QA','buyer_pays',NULL,0,NULL,NULL,NULL,NULL,NULL,'No VAT; customs duty applies.'),
  ('KW','buyer_pays',NULL,0,NULL,NULL,NULL,NULL,NULL,'No VAT; customs duty applies.'),
  ('BH','buyer_pays','VAT',0.1000,NULL,NULL,NULL,NULL,NULL,NULL),
  ('OM','buyer_pays','VAT',0.0500,NULL,NULL,NULL,NULL,NULL,NULL),
  ('CN','buyer_pays',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'Personal-import (postal) tax on jewellery/gems can be high — check.'),
  ('KZ','buyer_pays','VAT',0.1200,NULL,NULL,NULL,NULL,NULL,'EAEU personal-import allowance applies.'),
  ('UZ','buyer_pays','VAT',0.1200,NULL,NULL,NULL,NULL,NULL,NULL)
ON CONFLICT (country_code) DO NOTHING;

-- US tariffs by origin (2025 reciprocal tariffs — volatile, CHECK THEM).
-- EU goods: 15% (deal rate). Thailand, Pakistan: 19%.
INSERT INTO public.origin_duties (dest_code, origin_code, extra_duty, notes) VALUES
  ('US','NL',0.1500,'EU goods — 2025 deal rate.'),
  ('US','TH',0.1900,'Thailand — 2025 reciprocal tariff.'),
  ('US','PK',0.1900,'Pakistan — 2025 reciprocal tariff.')
ON CONFLICT (dest_code, origin_code) DO NOTHING;

COMMIT;

-- VERIFICATION (read-only):
--   SELECT mode, count(*) FROM tax_rules GROUP BY mode;
--   SELECT * FROM origin_duties;
--   SELECT policyname FROM pg_policies WHERE tablename IN ('tax_rules','origin_duties','shipping_routes');
