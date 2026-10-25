-- =============================================================================
-- GemWorkers — EORI number on invoices (exports from NL)
-- =============================================================================
-- NOT YET APPLIED
--
-- store_settings key 'company_eori' (set by the owner in admin → Taxes &
-- duties → Company details). Couriers ask for it on exports from NL to
-- outside the EU; the invoice is the commercial invoice in the parcel.
--
-- _company_snapshot copied from the live definition (invoices_setup.sql);
-- only change: + 'eori'.
-- =============================================================================

BEGIN;

CREATE OR REPLACE FUNCTION public._company_snapshot()
RETURNS jsonb
LANGUAGE sql
STABLE
SECURITY DEFINER
SET search_path = public, pg_temp
AS $$
  SELECT jsonb_build_object(
    'name',    coalesce((SELECT value FROM public.store_settings WHERE key = 'company_name'), 'GemWorkers'),
    'address', (SELECT value FROM public.store_settings WHERE key = 'company_address'),
    'kvk',     (SELECT value FROM public.store_settings WHERE key = 'company_kvk'),
    'vat',     (SELECT value FROM public.store_settings WHERE key = 'company_vat'),
    'eori',    (SELECT value FROM public.store_settings WHERE key = 'company_eori'),
    'email',   coalesce((SELECT value FROM public.store_settings WHERE key = 'company_email'), 'hello@gemworkers.com')
  );
$$;

REVOKE ALL ON FUNCTION public._company_snapshot() FROM PUBLIC, anon, authenticated;

COMMIT;
