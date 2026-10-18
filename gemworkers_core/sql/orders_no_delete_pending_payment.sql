-- Already applied to live DB 2026-10-18.
-- Guard: orders awaiting payment cannot be deleted by anyone; they are
-- released automatically by the sweep when their payment deadline passes.
-- NOTE: a future test-data wipe must cancel such orders first (or temporarily
-- disable this trigger) before deleting them.
BEGIN;

CREATE OR REPLACE FUNCTION public.prevent_delete_pending_payment_order()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
BEGIN
  IF OLD.status = 'pending_payment' THEN
    RAISE EXCEPTION 'Order % is awaiting payment and cannot be deleted. It is released automatically when its payment deadline passes.', OLD.id;
  END IF;
  RETURN OLD;
END;
$function$;

DROP TRIGGER IF EXISTS orders_no_delete_pending_payment ON public.orders;

CREATE TRIGGER orders_no_delete_pending_payment
BEFORE DELETE ON public.orders
FOR EACH ROW
EXECUTE FUNCTION public.prevent_delete_pending_payment_order();

COMMIT;
