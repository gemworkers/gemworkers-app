-- =============================================================================
-- GemWorkers — Restore the seller of stones orphaned by the Edit-stone bug
-- =============================================================================
-- Applied to live DB 2026-10-23 (3 rows)
--
-- Edit stone saved seller_id = NULL (fixed in the admin 2026-10-23), which hid
-- these stones from the store. Zakaria confirmed they are his own stones →
-- My Shop (kCurrentSellerId a0000000-0000-0000-0000-000000000001).
-- Only rows that are still orphaned are touched.
-- =============================================================================

UPDATE public.inventory_items
SET    seller_id = 'a0000000-0000-0000-0000-000000000001'
WHERE  seller_id IS NULL
  AND  id IN (
         '88b04d28-a858-4b80-bbd1-93a172307a45',  -- GW-S-AQUA-01016  Aquamarine crystal (new)
         'ab8f412e-0283-4d01-b5e8-79f49ef4accc',  -- GW-AQUA-CR-NL-0001 Aquamarine crystal (older)
         '87729631-c3c0-4c5c-8b6c-f2bc972f061f'   -- GW-L-TOUR-01013  Tourmaline (test)
       )
RETURNING sku, title;
