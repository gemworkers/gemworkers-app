-- =============================================================================
-- GemWorkers — Counter-offers in the buyer's currency: neat amounts
-- =============================================================================
-- Applied to live DB 2026-10-26
--
-- Zakaria 2026-10-26: a counter of €90 showed the buyer $103 — looks
-- machine-made. Now rounded like listed prices (_local_price): $105.
-- Safety: never reaches the listed local price (falls back to the whole
-- number) and always stays above the buyer's own offer. The seller's basis
-- stays the euro counter they typed; the rounding extra stays with GemWorkers
-- (as with listed prices).
--
-- counter_offer copied from the LIVE definition (offers_local_currency.sql); diff:
--   -    v_local := greatest(ceil(p_counter_price * v_offer.offer_rate * 1.02), v_offer.local_offered + 1);
--   +    v_local := public._local_price(p_counter_price, v_offer.offer_rate);
--   +    IF v_local >= public._local_price(v_item.selling_price, v_offer.offer_rate) THEN
--   +      v_local := ceil(p_counter_price * v_offer.offer_rate * 1.02);
--   +    END IF;
--   +    v_local := greatest(v_local, v_offer.local_offered + 1);
-- =============================================================================

BEGIN;

CREATE OR REPLACE FUNCTION public.counter_offer(p_offer_id uuid, p_counter_price numeric)
 RETURNS json
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO 'public', 'pg_temp'
AS $function$
DECLARE
  v_offer   record;
  v_item    record;
  v_role    text;
  v_expires timestamptz := now() + interval '48 hours';
  v_local   numeric;
BEGIN
  IF p_counter_price IS NULL OR p_counter_price <= 0 THEN
    RAISE EXCEPTION 'Counter-offer must be greater than zero';
  END IF;
  IF p_counter_price <> round(p_counter_price, 2) THEN
    RAISE EXCEPTION 'Please enter the counter-offer in euros and cents (at most 2 decimals), e.g. 49.80';
  END IF;

  SELECT o.id, o.inventory_item_id, o.seller_id, o.offered_price, o.status,
         o.offer_currency, o.offer_rate, o.local_offered
  INTO   v_offer
  FROM   storefront_offers o
  WHERE  o.id = p_offer_id
  FOR UPDATE;

  IF NOT FOUND THEN
    RAISE EXCEPTION 'Offer not found';
  END IF;

  IF v_offer.seller_id IS DISTINCT FROM public.current_seller_id()
     AND NOT public.is_owner() THEN
    RAISE EXCEPTION 'This offer does not belong to your shop';
  END IF;

  IF v_offer.status = 'countered' THEN
    RAISE EXCEPTION 'A counter-offer has already been sent for this offer';
  END IF;
  IF v_offer.status <> 'pending' THEN
    RAISE EXCEPTION 'Offer is no longer pending (status: %)', v_offer.status;
  END IF;

  SELECT id, status, is_listed, selling_price
  INTO   v_item
  FROM   inventory_items
  WHERE  id = v_offer.inventory_item_id
  FOR UPDATE;

  IF NOT FOUND OR v_item.status <> 'available' OR v_item.is_listed IS NOT TRUE THEN
    RAISE EXCEPTION 'Item is no longer available (status: %)', COALESCE(v_item.status, 'missing');
  END IF;

  IF p_counter_price <= v_offer.offered_price THEN
    RAISE EXCEPTION 'Counter-offer must be higher than the buyer''s offer (%)',
      public._offer_card_label(v_offer.offered_price);
  END IF;
  IF v_item.selling_price IS NULL OR p_counter_price >= v_item.selling_price THEN
    RAISE EXCEPTION 'Counter-offer must be lower than the listed price (%)',
      COALESCE(public._offer_card_label(v_item.selling_price), 'not set');
  END IF;

  -- Buyer's currency: rounded up, always above their own offer.
  IF v_offer.offer_currency <> 'EUR' THEN
    -- Neat like listed prices (_local_price: whole below 50, next 5/0 from 50),
    -- but never up to the listed price: then the whole number instead.
    v_local := public._local_price(p_counter_price, v_offer.offer_rate);
    IF v_local >= public._local_price(v_item.selling_price, v_offer.offer_rate) THEN
      v_local := ceil(p_counter_price * v_offer.offer_rate * 1.02);
    END IF;
    v_local := greatest(v_local, v_offer.local_offered + 1);
  END IF;

  v_role := CASE WHEN v_offer.seller_id IS NOT DISTINCT FROM public.current_seller_id()
                 THEN 'seller' ELSE 'owner' END;

  UPDATE storefront_offers
  SET    status             = 'countered',
         counter_price      = p_counter_price,
         countered_at       = now(),
         counter_expires_at = v_expires,
         countered_by_role  = v_role,
         local_counter      = v_local
  WHERE  id = p_offer_id;

  RETURN json_build_object(
    'offer_id',           p_offer_id,
    'counter_price',      p_counter_price,
    'counter_expires_at', v_expires
  );
END;
$function$;

COMMIT;
