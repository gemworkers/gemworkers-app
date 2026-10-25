-- =============================================================================
-- GemWorkers — Sellers can read the invoices of their own orders
-- =============================================================================
-- NOT YET APPLIED
--
-- A brother shipping from Thailand / Pakistan puts the GemWorkers invoice in
-- the parcel (customs: CN23 needs a commercial invoice). The invoice already
-- shows only what the seller sees on the order (buyer name + shipping
-- address) and GemWorkers as the seller — never the seller's identity.
-- Read only; writing stays impossible (invoices are immutable).
-- =============================================================================

BEGIN;

DROP POLICY IF EXISTS invoices_seller_select ON public.invoices;
CREATE POLICY invoices_seller_select ON public.invoices
  FOR SELECT TO authenticated
  USING (EXISTS (
    SELECT 1 FROM public.orders o
    WHERE  o.id = invoices.order_id
      AND  o.seller_id = public.current_seller_id()
  ));

COMMIT;
