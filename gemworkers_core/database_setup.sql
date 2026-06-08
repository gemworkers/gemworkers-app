-- =============================================================================
-- GemWorkers — Complete Database Setup
-- =============================================================================
-- Run the whole file in the Supabase SQL Editor to build the database from
-- scratch. Tables are created in dependency order so foreign keys resolve
-- cleanly. Safe to re-run: all statements use IF NOT EXISTS / ON CONFLICT.
--
-- Sections
--   1. Tables        (suppliers → inventory_items)
--   2. Indexes
--   3. Row-Level Security
--   4. Storage bucket (inventory-images)
-- =============================================================================


-- =============================================================================
-- 1. TABLES
-- =============================================================================

-- -----------------------------------------------------------------------------
-- suppliers
-- -----------------------------------------------------------------------------
-- Referenced by inventory_items.supplier_id, so it must be created first.

CREATE TABLE IF NOT EXISTS suppliers (
    id                uuid          PRIMARY KEY DEFAULT gen_random_uuid(),
    name              text          NOT NULL,
    country           text          NOT NULL DEFAULT '',
    contact_name      text          NOT NULL DEFAULT '',
    email             text          NOT NULL DEFAULT '',
    phone             text          NOT NULL DEFAULT '',
    reliability_score numeric(3,1)  NOT NULL DEFAULT 0
                          CHECK (reliability_score >= 0 AND reliability_score <= 5),
    notes             text          NOT NULL DEFAULT '',
    created_at        timestamptz   NOT NULL DEFAULT now()
);

COMMENT ON TABLE  suppliers                    IS 'Gem suppliers / vendors.';
COMMENT ON COLUMN suppliers.reliability_score  IS '0–5 rating with 0.5 increments.';


-- -----------------------------------------------------------------------------
-- inventory_items
-- -----------------------------------------------------------------------------

CREATE TABLE IF NOT EXISTS inventory_items (
    id              uuid           PRIMARY KEY DEFAULT gen_random_uuid(),

    -- Identification
    sku             text           NOT NULL,
    title           text           NOT NULL,

    -- Gem details
    gem_type        text           NOT NULL DEFAULT '',
    variety         text           NOT NULL DEFAULT '',
    shape           text           NOT NULL DEFAULT '',
    cut_type        text           NOT NULL DEFAULT '',

    -- Origin
    origin_country  text           NOT NULL DEFAULT '',
    origin_region   text           NOT NULL DEFAULT '',

    -- Weight
    weight_value    numeric        NOT NULL DEFAULT 0,
    weight_unit     text           NOT NULL DEFAULT 'ct'
                        CHECK (weight_unit IN ('ct', 'g', 'kg')),

    -- Stock
    quantity        integer        NOT NULL DEFAULT 1,

    -- Pricing  (14 digits, 4 decimal places — handles gem-scale precision)
    cost_price      numeric(14,4)  NOT NULL DEFAULT 0,
    sale_price      numeric(14,4)  NOT NULL DEFAULT 0,

    -- Identifiers
    barcode         text           NOT NULL DEFAULT '',
    qr_code         text           NOT NULL DEFAULT '',

    -- Workflow status
    status          text           NOT NULL DEFAULT 'available'
                        CHECK (status IN ('available', 'reserved', 'sold', 'draft')),

    -- Notes and media
    notes           text           NOT NULL DEFAULT '',
    image_urls      jsonb          NOT NULL DEFAULT '[]'::jsonb,

    -- Supplier link (nullable — items can exist without a supplier)
    supplier_id     uuid           REFERENCES suppliers (id) ON DELETE SET NULL,

    created_at      timestamptz    NOT NULL DEFAULT now()
);

COMMENT ON TABLE  inventory_items              IS 'Gem inventory items.';
COMMENT ON COLUMN inventory_items.image_urls   IS 'JSON array of Supabase Storage public URLs.';
COMMENT ON COLUMN inventory_items.supplier_id  IS 'FK to suppliers. Cleared (SET NULL) when supplier is deleted.';


-- =============================================================================
-- 2. INDEXES
-- =============================================================================

-- getItems() and getItemsBySupplier() both ORDER BY created_at DESC
CREATE INDEX IF NOT EXISTS idx_inventory_items_created_at
    ON inventory_items (created_at DESC);

-- getItemsBySupplier() filters with .eq('supplier_id', ...)
CREATE INDEX IF NOT EXISTS idx_inventory_items_supplier_id
    ON inventory_items (supplier_id);

-- getSuppliers() ORDER BY name ASC
CREATE INDEX IF NOT EXISTS idx_suppliers_name
    ON suppliers (name);


-- =============================================================================
-- 3. ROW-LEVEL SECURITY
-- =============================================================================
-- Authenticated users (anyone signed in via Supabase Auth) have full CRUD
-- access. Unauthenticated / anon-key requests are blocked.
--
-- NOTE: While the app includes a temporary "Skip login (dev)" bypass, that
-- bypass uses the anon key and will receive empty results or permission errors
-- once RLS is enabled. Remove the bypass and add a real Supabase Auth account
-- before enabling RLS in production.

ALTER TABLE suppliers       ENABLE ROW LEVEL SECURITY;
ALTER TABLE inventory_items ENABLE ROW LEVEL SECURITY;

-- suppliers: authenticated full access
DROP POLICY IF EXISTS "authenticated_full_access" ON suppliers;
CREATE POLICY "authenticated_full_access"
    ON suppliers
    FOR ALL
    TO authenticated
    USING      (true)
    WITH CHECK (true);

-- inventory_items: authenticated full access
DROP POLICY IF EXISTS "authenticated_full_access" ON inventory_items;
CREATE POLICY "authenticated_full_access"
    ON inventory_items
    FOR ALL
    TO authenticated
    USING      (true)
    WITH CHECK (true);


-- =============================================================================
-- 4. STORAGE BUCKET: inventory-images
-- =============================================================================
-- Images are loaded in the app via Image.network() using the bucket's public
-- URL, so the bucket must be public (read access is unrestricted). Write and
-- delete are restricted to authenticated users.

INSERT INTO storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
VALUES (
    'inventory-images',
    'inventory-images',
    true,       -- public: Image.network() loads without auth tokens
    10485760,   -- 10 MB per file
    ARRAY['image/jpeg', 'image/png', 'image/webp', 'image/heic', 'image/heif']
)
ON CONFLICT (id) DO NOTHING;

-- Anyone can read (required for public image URLs)
DROP POLICY IF EXISTS "public_read"          ON storage.objects;
CREATE POLICY "public_read"
    ON storage.objects FOR SELECT
    TO public
    USING (bucket_id = 'inventory-images');

-- Authenticated users can upload
DROP POLICY IF EXISTS "authenticated_upload" ON storage.objects;
CREATE POLICY "authenticated_upload"
    ON storage.objects FOR INSERT
    TO authenticated
    WITH CHECK (bucket_id = 'inventory-images');

-- Authenticated users can delete
DROP POLICY IF EXISTS "authenticated_delete" ON storage.objects;
CREATE POLICY "authenticated_delete"
    ON storage.objects FOR DELETE
    TO authenticated
    USING (bucket_id = 'inventory-images');


-- =============================================================================
-- MIGRATION NOTE (existing databases)
-- =============================================================================
-- If you already have an inventory_items table from an earlier session and
-- only need to add the supplier link, run this single statement instead of
-- the whole file:
--
--   ALTER TABLE inventory_items
--     ADD COLUMN IF NOT EXISTS supplier_id uuid
--       REFERENCES suppliers (id) ON DELETE SET NULL;
--
--   CREATE INDEX IF NOT EXISTS idx_inventory_items_supplier_id
--     ON inventory_items (supplier_id);
-- =============================================================================
