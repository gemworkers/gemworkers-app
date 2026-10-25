-- =============================================================================
-- GemWorkers — Offers in the buyer's own currency (USD, GBP, AUD, CAD)
-- =============================================================================
-- Applied to live DB 2026-10-25
--
-- Zakaria 2026-10-25 (agreed): buyers shipping to the US, UK, Australia or
-- Canada make offers in their own currency. The offer is stored in EUR as
-- always (offered_price = local ÷ (rate × 1.02), to the cent) — sellers decide,
-- counter, earn and are paid in euros; every rule stays checked in euros.
-- Next to it: offer_currency, offer_rate (the day's ECB rate, locked) and
-- local_offered / local_counter (what the buyer sees and pays).
-- • Counter-offers are typed in EUR; the buyer sees ceil(counter × rate × 1.02)
--   in their currency (whole units, always above their own offer).
-- • An accepted offer's order gets the agreed local amount + local shipping
--   (_local_price) at insert (trigger) — respond_to_offer / respond_to_counter
--   are NOT changed.
-- • At payment set_order_currency keeps it only if the buyer still ships to
--   that currency's country with no VAT; otherwise the order is paid in EUR.
-- • Rates come from fx_rates, written only by the store server (service role)
--   from the ECB rates it shows; buyers can't supply their own rate.
--
-- Changes vs live:
--   submit_storefront_offer: DROP + CREATE with 2 new optional params
--     (p_currency default 'EUR', p_local_amount default NULL); body = live +
--     the local-currency block + 3 insert columns (garbled comment cleaned).
--   counter_offer: live + local_counter (select offer_currency/offer_rate/
--     local_offered, compute, SET local_counter).
--   _offer_message_card: live + local label "$300 (€262.77)".
--   set_order_currency: own function from local_currency.sql + offer orders.
--   buyer_offers: 3 columns appended.
-- =============================================================================

BEGIN;

-- ── Daily rates the store shows (store server writes, nobody else) ─────────
CREATE TABLE IF NOT EXISTS public.fx_rates (
  currency   text PRIMARY KEY CHECK (currency IN ('USD', 'GBP', 'AUD', 'CAD')),
  rate       numeric NOT NULL,
  updated_at timestamptz NOT NULL DEFAULT now(),
  CONSTRAINT fx_rates_plausible CHECK (
    (currency = 'USD' AND rate BETWEEN 0.8 AND 1.6) OR
    (currency = 'GBP' AND rate BETWEEN 0.6 AND 1.1) OR
    (currency = 'AUD' AND rate BETWEEN 1.2 AND 2.3) OR
    (currency = 'CAD' AND rate BETWEEN 1.1 AND 2.0))
);
ALTER TABLE public.fx_rates ENABLE ROW LEVEL SECURITY;   -- no policies: service role only
REVOKE ALL ON public.fx_rates FROM anon, authenticated;

-- ── Offer currency columns ─────────────────────────────────────────────────
ALTER TABLE public.storefront_offers
  ADD COLUMN IF NOT EXISTS offer_currency text NOT NULL DEFAULT 'EUR',
  ADD COLUMN IF NOT EXISTS offer_rate     numeric,
  ADD COLUMN IF NOT EXISTS local_offered  numeric(12,2),
  ADD COLUMN IF NOT EXISTS local_counter  numeric(12,2);
ALTER TABLE public.storefront_offers DROP CONSTRAINT IF EXISTS storefront_offers_currency_check;
ALTER TABLE public.storefront_offers ADD CONSTRAINT storefront_offers_currency_check
  CHECK (offer_currency IN ('EUR', 'USD', 'GBP', 'AUD', 'CAD')
         AND (offer_currency = 'EUR' OR (offer_rate > 0 AND local_offered > 0)));

-- "$300", "£49.50", "A$120", "C$75"
CREATE OR REPLACE FUNCTION public._offer_local_label(p_amount numeric, p_currency text)
RETURNS text
LANGUAGE sql
IMMUTABLE
SET search_path TO 'public', 'pg_temp'
AS $$
  SELECT CASE p_currency WHEN 'USD' THEN '$' WHEN 'GBP' THEN '£' WHEN 'AUD' THEN 'A$'
                         WHEN 'CAD' THEN 'C$' ELSE '€' END
         || CASE WHEN p_amount = trunc(p_amount) THEN trunc(p_amount)::text
                 ELSE to_char(p_amount, 'FM999999999990.00') END;
$$;

-- ── submit_storefront_offer: live + local currency ─────────────────────────
DROP FUNCTION IF EXISTS public.submit_storefront_offer(uuid, numeric, text);

CREATE FUNCTION public.submit_storefront_offer(
  p_inventory_item_id uuid,
  p_offered_price     numeric,
  p_buyer_note        text    DEFAULT ''::text,
  p_currency          text    DEFAULT 'EUR',
  p_local_amount      numeric DEFAULT NULL
)
 RETURNS uuid
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO 'public'
AS $function$
DECLARE
  v_item     record;
  v_offer_id uuid;
  v_rate     numeric;
BEGIN
  -- Read item + seller status + sale_method.
  -- sale_method is the only addition vs the original SELECT.
  SELECT i.id, i.seller_id, i.is_listed, i.status, i.sale_method,
         s.status AS seller_status
  INTO   v_item
  FROM   inventory_items i
  JOIN   sellers         s ON s.id = i.seller_id
  WHERE  i.id = p_inventory_item_id;

  IF NOT FOUND THEN
    RAISE EXCEPTION 'Item not found';
  END IF;
  IF NOT v_item.is_listed THEN
    RAISE EXCEPTION 'Item is not listed for sale';
  END IF;
  IF v_item.status <> 'available' THEN
    RAISE EXCEPTION 'Item is not available for offers (status: %)', v_item.status;
  END IF;
  IF v_item.seller_status <> 'active' THEN
    RAISE EXCEPTION 'Seller is not active';
  END IF;

  -- Reject offers on buy_now-only stones.
  IF v_item.sale_method = 'buy_now' THEN
    RAISE EXCEPTION 'This item is not accepting offers';
  END IF;

  -- Offer in the buyer's own currency: the euro value at today's rate
  -- (the same rate and 2% the store uses for its local prices).
  IF coalesce(p_currency, 'EUR') <> 'EUR' THEN
    IF p_currency NOT IN ('USD', 'GBP', 'AUD', 'CAD') THEN
      RAISE EXCEPTION 'Offers in % are not possible', p_currency;
    END IF;
    IF p_local_amount IS NULL OR p_local_amount <= 0 THEN
      RAISE EXCEPTION 'Offered price must be greater than zero';
    END IF;
    IF p_local_amount <> round(p_local_amount, 2) THEN
      RAISE EXCEPTION 'Please enter your offer with at most 2 decimals, e.g. 49.80';
    END IF;
    SELECT rate INTO v_rate FROM fx_rates
    WHERE  currency = p_currency AND updated_at > now() - interval '3 days';
    IF v_rate IS NULL THEN
      RAISE EXCEPTION 'Offers in your currency are not possible right now — please try again later';
    END IF;
    p_offered_price := round(p_local_amount / (v_rate * 1.02), 2);
  END IF;

  IF p_offered_price <= 0 THEN
    RAISE EXCEPTION 'Offered price must be greater than zero';
  END IF;

  -- Offers are in whole cents: reject anything with more than 2 decimals
  -- rather than silently rounding the buyer's amount.
  IF p_offered_price <> round(p_offered_price, 2) THEN
    RAISE EXCEPTION 'Please enter your offer in euros and cents (at most 2 decimals), e.g. 49.80';
  END IF;

  -- One active offer per buyer per stone.
  IF EXISTS (
    SELECT 1 FROM storefront_offers
    WHERE  buyer_id          = auth.uid()
      AND  inventory_item_id = p_inventory_item_id
      AND  status            IN ('pending', 'countered')
  ) THEN
    RAISE EXCEPTION 'You already have a pending offer on this item';
  END IF;

  -- Blocked in this stone's conversation → no offers on this stone.
  IF EXISTS (
    SELECT 1 FROM conversations
    WHERE  buyer_id          = auth.uid()
      AND  inventory_item_id = p_inventory_item_id
      AND  status            = 'blocked'
  ) THEN
    RAISE EXCEPTION 'Offers on this stone aren''t available for your account';
  END IF;

  INSERT INTO storefront_offers (
    buyer_id,    inventory_item_id,       seller_id,
    offered_price, buyer_note,
    offer_currency, offer_rate, local_offered
  )
  VALUES (
    auth.uid(),  p_inventory_item_id,     v_item.seller_id,
    p_offered_price, COALESCE(p_buyer_note, ''),
    coalesce(p_currency, 'EUR'), v_rate,
    CASE WHEN coalesce(p_currency, 'EUR') <> 'EUR' THEN p_local_amount END
  )
  RETURNING id INTO v_offer_id;

  RETURN v_offer_id;
END;
$function$;

REVOKE ALL ON FUNCTION public.submit_storefront_offer(uuid, numeric, text, text, numeric) FROM PUBLIC, anon;
GRANT EXECUTE ON FUNCTION public.submit_storefront_offer(uuid, numeric, text, text, numeric) TO authenticated, service_role;

-- ── counter_offer: live + the buyer's counter amount in their currency ──────
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

  -- Buyer's currency: whole units, rounded up, always above their own offer.
  IF v_offer.offer_currency <> 'EUR' THEN
    v_local := greatest(ceil(p_counter_price * v_offer.offer_rate * 1.02), v_offer.local_offered + 1);
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

-- ── Offer cards in Messages: "$300 (€262.77)" for local-currency offers ─────
CREATE OR REPLACE FUNCTION public._offer_message_card()
 RETURNS trigger
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO 'public', 'pg_temp'
AS $function$
DECLARE
  v_kind    text;
  v_amount  numeric;
  v_body    text;
  v_label   text;
  v_conv_id uuid;
  v_name    text;
  v_local   numeric;
BEGIN
  IF TG_OP = 'INSERT' THEN
    IF NEW.status <> 'pending' THEN
      RETURN NEW;
    END IF;
    v_kind := 'offer_made';
  ELSIF NEW.status IS DISTINCT FROM OLD.status THEN
    IF NEW.status = 'countered' THEN
      v_kind := 'offer_countered';
    ELSIF OLD.status = 'countered' THEN
      v_kind := CASE
                  WHEN NEW.status = 'accepted'  THEN 'counter_accepted'
                  WHEN NEW.status = 'declined' AND NEW.responded_by_role = 'system'
                                                THEN 'offer_declined'
                  WHEN NEW.status = 'declined'  THEN 'counter_declined'
                  WHEN NEW.status = 'expired'   THEN 'counter_expired'
                  WHEN NEW.status = 'withdrawn' THEN 'offer_withdrawn'
                END;
    ELSE
      v_kind := CASE NEW.status
                  WHEN 'accepted'  THEN 'offer_accepted'
                  WHEN 'declined'  THEN 'offer_declined'
                  WHEN 'expired'   THEN 'offer_expired'
                  WHEN 'withdrawn' THEN 'offer_withdrawn'
                END;
    END IF;
  END IF;

  IF v_kind IS NULL THEN
    RETURN NEW;
  END IF;

  BEGIN
    v_amount := CASE WHEN v_kind IN ('offer_countered', 'counter_accepted',
                                     'counter_declined', 'counter_expired')
                     THEN NEW.counter_price
                     ELSE NEW.offered_price
                END;
    v_label := public._offer_card_label(v_amount);
    IF NEW.offer_currency <> 'EUR' THEN
      v_local := CASE WHEN v_kind IN ('offer_countered', 'counter_accepted',
                                      'counter_declined', 'counter_expired')
                      THEN NEW.local_counter ELSE NEW.local_offered END;
      IF v_local IS NOT NULL THEN
        v_label := public._offer_local_label(v_local, NEW.offer_currency) || ' (' || v_label || ')';
      END IF;
    END IF;
    v_body  := CASE v_kind
                 WHEN 'offer_made'       THEN 'Offer made: '               || v_label
                 WHEN 'offer_accepted'   THEN 'Offer accepted: '           || v_label
                 WHEN 'offer_declined'   THEN 'Offer declined: '           || v_label
                 WHEN 'offer_expired'    THEN 'Offer expired: '            || v_label
                 WHEN 'offer_withdrawn'  THEN 'Offer withdrawn: '          || v_label
                 WHEN 'offer_countered'  THEN 'Counter-offer: '            || v_label
                 WHEN 'counter_accepted' THEN 'Counter-offer accepted: '   || v_label
                 WHEN 'counter_declined' THEN 'Counter-offer declined: '   || v_label
                 WHEN 'counter_expired'  THEN 'Counter-offer expired: '    || v_label
               END;

    SELECT id INTO v_conv_id
    FROM   public.conversations
    WHERE  inventory_item_id = NEW.inventory_item_id
      AND  buyer_id          = NEW.buyer_id;

    IF v_conv_id IS NULL THEN
      SELECT NULLIF(split_part(btrim(display_name), ' ', 1), '')
      INTO   v_name
      FROM   public.buyers
      WHERE  id = NEW.buyer_id;

      INSERT INTO public.conversations (inventory_item_id, buyer_id, seller_id, buyer_first_name)
      VALUES (NEW.inventory_item_id, NEW.buyer_id, NEW.seller_id, left(v_name, 50))
      ON CONFLICT (inventory_item_id, buyer_id) DO NOTHING
      RETURNING id INTO v_conv_id;

      IF v_conv_id IS NULL THEN
        SELECT id INTO v_conv_id
        FROM   public.conversations
        WHERE  inventory_item_id = NEW.inventory_item_id
          AND  buyer_id          = NEW.buyer_id;
      END IF;
    END IF;

    INSERT INTO public.messages
      (conversation_id, sender_role, sender_user_id, body, kind, offer_id, offer_amount)
    VALUES
      (v_conv_id, 'system', NULL, v_body, v_kind, NEW.id, v_amount)
    ON CONFLICT (offer_id, kind) WHERE offer_id IS NOT NULL DO NOTHING;

    UPDATE public.conversations
    SET    last_message_at = now()
    WHERE  id = v_conv_id;
  EXCEPTION WHEN OTHERS THEN
    RAISE WARNING '[offer card] offer % kind % failed: % (%)', NEW.id, v_kind, SQLERRM, SQLSTATE;
  END;

  RETURN NEW;
END;
$function$;

-- ── An accepted local-currency offer's order: the agreed local amount ───────
-- Runs when respond_to_offer / respond_to_counter insert the order (before
-- they mark the offer accepted): the stone price on the order tells which
-- amount was agreed (the counter-offer or the buyer's own offer).
CREATE OR REPLACE FUNCTION public._order_offer_currency()
RETURNS trigger
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path TO 'public', 'pg_temp'
AS $$
DECLARE
  o       record;
  v_local numeric;
  v_ship  numeric;
BEGIN
  IF NEW.offer_id IS NULL THEN RETURN NEW; END IF;
  SELECT offer_currency, offer_rate, offered_price, local_offered, counter_price, local_counter
  INTO   o FROM storefront_offers WHERE id = NEW.offer_id;
  IF o.offer_currency IS NULL OR o.offer_currency = 'EUR' OR o.offer_rate IS NULL THEN RETURN NEW; END IF;

  v_ship  := coalesce(NEW.shipping_cost, 0);
  v_local := CASE WHEN o.counter_price IS NOT NULL AND o.local_counter IS NOT NULL
                       AND NEW.order_total - v_ship = o.counter_price THEN o.local_counter
                  WHEN NEW.order_total - v_ship = o.offered_price THEN o.local_offered END;
  IF v_local IS NULL THEN RETURN NEW; END IF;   -- unexpected price: pay in EUR

  NEW.charge_currency := o.offer_currency;
  NEW.charge_rate     := o.offer_rate;
  NEW.charge_markup   := 0.02;
  NEW.charge_shipping := public._local_price(v_ship, o.offer_rate);
  NEW.charge_amount   := v_local + NEW.charge_shipping;
  RETURN NEW;
END;
$$;
REVOKE ALL ON FUNCTION public._order_offer_currency() FROM PUBLIC, anon, authenticated;

DROP TRIGGER IF EXISTS orders_offer_currency ON public.orders;
CREATE TRIGGER orders_offer_currency BEFORE INSERT ON public.orders
  FOR EACH ROW EXECUTE FUNCTION public._order_offer_currency();

-- ── set_order_currency (local_currency.sql) + accepted-offer orders ─────────
-- Offer orders already carry their agreed amount: kept only if the buyer still
-- ships to that currency's country with no VAT, else back to EUR.
CREATE OR REPLACE FUNCTION public.set_order_currency(p_order_ids uuid[], p_currency text, p_rate numeric)
RETURNS TABLE (order_id uuid, charge_currency text, charge_amount numeric)
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public, pg_temp
AS $$
DECLARE
  v_country text;
BEGIN
  v_country := CASE p_currency WHEN 'USD' THEN 'US' WHEN 'GBP' THEN 'GB'
                               WHEN 'AUD' THEN 'AU' WHEN 'CAD' THEN 'CA' END;
  IF v_country IS NULL OR p_rate IS NULL OR NOT (
       (p_currency = 'USD' AND p_rate BETWEEN 0.8 AND 1.6) OR
       (p_currency = 'GBP' AND p_rate BETWEEN 0.6 AND 1.1) OR
       (p_currency = 'AUD' AND p_rate BETWEEN 1.2 AND 2.3) OR
       (p_currency = 'CAD' AND p_rate BETWEEN 1.1 AND 2.0)) THEN
    RAISE EXCEPTION 'Unsupported currency or implausible rate: % %', p_currency, p_rate;
  END IF;

  UPDATE public.orders o
  SET    charge_currency = p_currency,
         charge_rate     = p_rate,
         charge_markup   = 0.02,
         charge_shipping = public._local_price(coalesce(o.shipping_cost, 0), p_rate),
         charge_amount   = public._local_price(o.order_total - coalesce(o.shipping_cost, 0), p_rate)
                         + public._local_price(coalesce(o.shipping_cost, 0), p_rate)
  WHERE  o.id = ANY (p_order_ids)
    AND  o.status = 'pending_payment'
    AND  o.sale_channel = 'platform'
    AND  o.offer_id IS NULL
    AND  coalesce(o.tax_amount, 0) = 0
    AND  o.order_total > 0
    AND  coalesce(o.ship_to_country, o.shipping_country) = v_country;

  -- Accepted offers: keep the agreed amount only when it still fits.
  UPDATE public.orders o
  SET    charge_currency = 'EUR', charge_rate = NULL, charge_markup = NULL,
         charge_shipping = NULL, charge_amount = NULL
  WHERE  o.id = ANY (p_order_ids)
    AND  o.status = 'pending_payment'
    AND  o.offer_id IS NOT NULL
    AND  o.charge_currency <> 'EUR'
    AND  (o.charge_currency <> p_currency
          OR coalesce(o.tax_amount, 0) <> 0
          OR coalesce(o.ship_to_country, o.shipping_country) IS DISTINCT FROM v_country);

  RETURN QUERY
    SELECT o.id, o.charge_currency, o.charge_amount
    FROM   public.orders o WHERE o.id = ANY (p_order_ids);
END;
$$;

REVOKE ALL ON FUNCTION public.set_order_currency(uuid[], text, numeric) FROM PUBLIC, anon, authenticated;
GRANT EXECUTE ON FUNCTION public.set_order_currency(uuid[], text, numeric) TO service_role;

-- ── buyer_offers: 3 columns appended ────────────────────────────────────────
CREATE OR REPLACE VIEW public.buyer_offers AS
 SELECT id,
    inventory_item_id,
    offered_price,
    status,
    counter_price,
    counter_expires_at,
    created_at,
    responded_at,
    offer_currency,
    local_offered,
    local_counter
   FROM storefront_offers o
  WHERE buyer_id = auth.uid();

COMMIT;
