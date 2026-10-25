-- =============================================================================
-- GemWorkers — Buyers can delete their account (GDPR right to erasure)
-- =============================================================================
-- NOT YET APPLIED
--
-- What we must KEEP (tax law, 7 / 10 years): orders, invoices, credit notes,
-- returns, refunds — they hold the snapshot needed for the books. Everything
-- else is removed or anonymised:
--   • cart emptied, open offers withdrawn, buyer_business removed
--   • conversations closed, first name → "Deleted buyer"
--   • reviews stay (they are about the stone) but show "Former customer"
--   • the login itself is deleted by the store (service role) after this
--     function succeeds; buyers row + buyer_business go with it (cascade)
-- Refused while something is still running: unpaid / unshipped / in-transit
-- orders, an open return or an open chargeback.
--
-- returns.buyer_id kept the login alive (FK, no action) → now SET NULL, so
-- the return record stays for the books without the account.
-- =============================================================================

BEGIN;

ALTER TABLE public.returns ALTER COLUMN buyer_id DROP NOT NULL;
ALTER TABLE public.returns DROP CONSTRAINT IF EXISTS returns_buyer_id_fkey;
ALTER TABLE public.returns ADD CONSTRAINT returns_buyer_id_fkey
  FOREIGN KEY (buyer_id) REFERENCES auth.users(id) ON DELETE SET NULL;

-- Step 1 of deleting an account (the store then deletes the login).
-- Returns NULL when ready, or the reason it can't be deleted yet.
CREATE OR REPLACE FUNCTION public.prepare_account_deletion()
RETURNS text
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public, pg_temp
AS $$
DECLARE
  v_uid uuid := auth.uid();
BEGIN
  IF v_uid IS NULL THEN RAISE EXCEPTION 'Not signed in'; END IF;

  IF EXISTS (SELECT 1 FROM public.orders WHERE buyer_id = v_uid AND status IN ('pending_payment','confirmed','shipped')) THEN
    RETURN 'You have an order that is still being paid, prepared or shipped. You can delete your account once it has arrived.';
  END IF;
  IF EXISTS (SELECT 1 FROM public.returns WHERE buyer_id = v_uid AND status IN ('requested','approved','received')) THEN
    RETURN 'You have a return in progress. You can delete your account once it is finished.';
  END IF;
  IF EXISTS (SELECT 1 FROM public.orders WHERE buyer_id = v_uid AND dispute_status = 'open') THEN
    RETURN 'A payment dispute is still open. Please contact us.';
  END IF;

  DELETE FROM public.storefront_cart WHERE buyer_id = v_uid;

  UPDATE public.storefront_offers SET status = 'withdrawn', responded_at = now()
  WHERE  buyer_id = v_uid AND status IN ('pending','countered');

  UPDATE public.conversations
  SET    status = CASE WHEN status = 'blocked' THEN 'blocked' ELSE 'closed' END,
         buyer_first_name = 'Deleted buyer'
  WHERE  buyer_id = v_uid;

  UPDATE public.reviews SET reviewer_name = 'Former customer'
  WHERE  buyer_id = v_uid;

  DELETE FROM public.buyer_business WHERE buyer_id = v_uid;

  RETURN NULL;
END;
$$;

REVOKE ALL ON FUNCTION public.prepare_account_deletion() FROM PUBLIC, anon;
GRANT EXECUTE ON FUNCTION public.prepare_account_deletion() TO authenticated;

COMMIT;
