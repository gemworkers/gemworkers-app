-- =============================================================================
-- GemWorkers — Auto-Generated SKUs
-- =============================================================================
-- Purpose: assign every inventory_items row a collision-proof SKU, generated
-- DB-side, so two sellers inserting concurrently can never produce the same
-- value (a client-side/Dart-generated SKU cannot guarantee that under
-- concurrent writes — only a DB sequence can).
--
-- Format:  GW-{TYPE}-{CODE}-{SEQ5}
--   TYPE  = single-letter product type code:
--             L = loose_stone, S = specimen, J = jewelry
--             (X = unexpected/unmapped product_type; should not occur in
--              normal use, kept as a visible sentinel rather than failing)
--   CODE  = 4-letter gem code, looked up from public.sku_codes by exact
--           gem_type match. All three product types share this same gem
--           vocabulary (jewelry and specimen reuse the loose-stone list).
--           Unmapped / 'Other' / null / empty gem_type → 'OTHR'.
--   SEQ5  = global 5-digit zero-padded sequence (public.sku_seq), shared
--           across ALL product types and gem types — it never resets per
--           type, it only counts up. Starts at 1000 (not 1) so early SKUs
--           read as intentional and don't look like a typo/placeholder.
--
-- Example: GW-L-SAPP-01000, GW-J-RUBY-01001, GW-S-OTHR-01002
--
-- Generation happens in a BEFORE INSERT trigger (trg_set_sku / set_sku()):
-- if the row already carries a non-empty sku (manual entry, import, etc.)
-- it is left untouched; only a null/blank sku gets auto-assigned. This
-- covers the Add Inventory form, lot rows, and lot-children sorted out of
-- a lot identically, since they all insert through the same table.
--
-- No views are touched by this file, so the append-only view-migration
-- convention used elsewhere in sql/ does not apply here.
--
-- Idempotent: safe to run repeatedly (IF NOT EXISTS / ON CONFLICT DO
-- NOTHING / CREATE OR REPLACE / DROP+CREATE TRIGGER guards throughout).
-- =============================================================================


-- =============================================================================
-- 1. Gem code lookup table
-- =============================================================================

CREATE TABLE IF NOT EXISTS public.sku_codes (
    gem_type text PRIMARY KEY,
    code     text NOT NULL CHECK (char_length(code) = 4)
);

INSERT INTO public.sku_codes (gem_type, code) VALUES
    ('Diamond',     'DIAM'),
    ('Ruby',        'RUBY'),
    ('Sapphire',    'SAPP'),
    ('Emerald',     'EMRL'),
    ('Alexandrite', 'ALEX'),
    ('Aquamarine',  'AQUA'),
    ('Amethyst',    'AMTH'),
    ('Citrine',     'CITR'),
    ('Garnet',      'GARN'),
    ('Morganite',   'MORG'),
    ('Opal',        'OPAL'),
    ('Pearl',       'PERL'),
    ('Peridot',     'PERI'),
    ('Spinel',      'SPIN'),
    ('Tanzanite',   'TANZ'),
    ('Topaz',       'TOPZ'),
    ('Tourmaline',  'TOUR'),
    ('Turquoise',   'TURQ'),
    ('Zircon',      'ZIRC'),
    ('Quartz',      'QRTZ'),
    ('Jade',        'JADE'),
    ('Onyx',        'ONYX'),
    ('Moonstone',   'MOON'),
    ('Labradorite', 'LABR'),
    ('Sunstone',    'SUNS'),
    ('Apatite',     'APAT'),
    ('Iolite',      'IOLT'),
    ('Kunzite',     'KUNZ'),
    ('Zoisite',     'ZOIS'),
    ('Chrysoberyl', 'CHRY'),
    ('Obsidian',    'OBSD'),
    ('Amber',       'AMBR'),
    ('Coral',       'CORL'),
    ('Other',       'OTHR')
ON CONFLICT (gem_type) DO NOTHING;


-- =============================================================================
-- 2. Global SKU sequence
-- =============================================================================
-- Shared across every product type and gem type — always counts up, never
-- resets. Starting point of 1000 is deliberate (see header).

CREATE SEQUENCE IF NOT EXISTS public.sku_seq START WITH 1000;


-- =============================================================================
-- 3. generate_sku(product_type, gem_type) — builds one SKU string
-- =============================================================================

CREATE OR REPLACE FUNCTION public.generate_sku(
    p_product_type text,
    p_gem_type     text
)
RETURNS text
LANGUAGE plpgsql
AS $$
DECLARE
    v_type_code text;
    v_gem_code  text;
    v_seq       bigint;
BEGIN
    -- product_type → single-letter type code. Anything unrecognized maps to
    -- 'X' rather than erroring, so a bad/legacy product_type never blocks
    -- an insert — it just produces a visibly-off SKU worth investigating.
    v_type_code := CASE p_product_type
        WHEN 'loose_stone' THEN 'L'
        WHEN 'specimen'    THEN 'S'
        WHEN 'jewelry'     THEN 'J'
        ELSE 'X'
    END;

    -- Exact gem_type match against the shared lookup table.
    SELECT code INTO v_gem_code
    FROM public.sku_codes
    WHERE gem_type = p_gem_type;

    IF v_gem_code IS NULL OR p_gem_type IS NULL OR trim(p_gem_type) = '' THEN
        v_gem_code := 'OTHR';
    END IF;

    v_seq := nextval('public.sku_seq');

    RETURN 'GW-' || v_type_code || '-' || v_gem_code || '-' || lpad(v_seq::text, 5, '0');
END;
$$;


-- =============================================================================
-- 4. set_sku() — BEFORE INSERT trigger function on inventory_items
-- =============================================================================
-- Only fills in sku when the incoming row didn't already provide one, so
-- manual entry / imports / overrides that set sku explicitly are preserved
-- untouched.

CREATE OR REPLACE FUNCTION public.set_sku()
RETURNS trigger
LANGUAGE plpgsql
AS $$
BEGIN
    IF NEW.sku IS NULL OR trim(NEW.sku) = '' THEN
        NEW.sku := public.generate_sku(NEW.product_type, NEW.gem_type);
    END IF;
    RETURN NEW;
END;
$$;


-- =============================================================================
-- 5. Trigger wiring
-- =============================================================================

DROP TRIGGER IF EXISTS trg_set_sku ON public.inventory_items;

CREATE TRIGGER trg_set_sku
    BEFORE INSERT ON public.inventory_items
    FOR EACH ROW
    EXECUTE FUNCTION public.set_sku();


-- =============================================================================
-- 6. Uniqueness guarantee on inventory_items.sku
-- =============================================================================
-- sku is currently NOT NULL with no default and the table holds no rows
-- (wiped via test_data_wipe.sql), so adding this now is clean — no backfill
-- or conflict resolution needed.

CREATE UNIQUE INDEX IF NOT EXISTS inventory_items_sku_unique_idx
    ON public.inventory_items (sku);
