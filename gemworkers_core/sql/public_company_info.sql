-- =============================================================================
-- GemWorkers — Public company details for the store's legal pages
-- =============================================================================
-- NOT YET APPLIED
--
-- A webshop must show its name, address, KvK number, VAT number and email
-- (Dutch / EU law). They live in store_settings (owner only, admin → Taxes &
-- duties → Company details). This view exposes ONLY those public keys, so
-- Terms / Privacy read the same details as the invoices — one place to edit.
-- No other store setting (e.g. the return address) is exposed.
-- =============================================================================

BEGIN;

CREATE OR REPLACE VIEW public.public_company_info WITH (security_invoker = false) AS
SELECT
  coalesce(max(value) FILTER (WHERE key = 'company_name'), 'GemWorkers')            AS name,
  max(value) FILTER (WHERE key = 'company_address')                                 AS address,
  max(value) FILTER (WHERE key = 'company_kvk')                                     AS kvk,
  max(value) FILTER (WHERE key = 'company_vat')                                     AS vat,
  max(value) FILTER (WHERE key = 'company_eori')                                    AS eori,
  coalesce(max(value) FILTER (WHERE key = 'company_email'), 'hello@gemworkers.com') AS email
FROM public.store_settings
WHERE key IN ('company_name','company_address','company_kvk','company_vat','company_eori','company_email');

REVOKE ALL ON public.public_company_info FROM PUBLIC;
GRANT SELECT ON public.public_company_info TO anon, authenticated;

COMMIT;
