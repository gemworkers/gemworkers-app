-- =============================================================================
-- GemWorkers — Consignment stones, Stripe fee and payout rule (part 1)
-- =============================================================================
-- Applied to live DB 2026-10-24
--
-- Zakaria 2026-10-24 — four kinds of stone:
--   A  a brother's own seller account (ships from TH / PK)
--        payout = order_total − commission − stripe_fee
--        (seller keeps shipping; commission on the stone price, as today)
--   B/C a stone held by Zakaria in NL for someone else (a brother or another
--       person) — listed under My Shop with an owner (consignor)
--        profit = stone price − owner's price − extra postage − stripe_fee
--        owner gets owner's price + share × profit   (share default 50%)
--        GemWorkers keeps the rest (commission_amount)
--        extra postage = postage paid beyond the shipping the buyer paid
--        (a "free shipping" stone hides the postage in the price)
--   D  My Shop, no owner: GemWorkers' own stone — unchanged
-- VAT and the buyer's shipping are never part of the split (order_total is
-- already excl. VAT; tax_amount goes to the tax office).
--
-- Nothing in the live money functions changes (create_platform_order,
-- respond_to_offer, respond_to_counter). Instead:
--   • order_items insert → copies the stone's owner terms onto the order
--   • orders BEFORE UPDATE → recalculates seller_payout / commission_amount
--     for A and B/C while the payout is not yet marked paid
--   • offers: a consignment stone can't be accepted / countered below the
--     owner's price (buyers may still offer anything — the floor stays secret)
--   • a consignment stone's listed price can't be below the owner's price
--
-- Owners list (consignors): owner only. Never shown to buyers or sellers.
-- =============================================================================

BEGIN;

-- 1. Owners list ---------------------------------------------------------------
CREATE TABLE IF NOT EXISTS public.consignors (
  id              uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  name            text NOT NULL CHECK (length(trim(name)) BETWEEN 1 AND 200),
  country         text,
  email           text,
  phone           text,
  payout_method   text,              -- e.g. Wise, Payoneer, bank
  payout_details  text,              -- account / IBAN / Wise email
  notes           text,
  seller_id       uuid REFERENCES public.sellers(id),   -- set when this owner is also a seller (a brother)
  default_share   numeric(4,3) NOT NULL DEFAULT 0.5 CHECK (default_share BETWEEN 0 AND 1),
  active          boolean NOT NULL DEFAULT true,
  created_at      timestamptz NOT NULL DEFAULT now(),
  updated_at      timestamptz NOT NULL DEFAULT now()
);
CREATE UNIQUE INDEX IF NOT EXISTS consignors_one_per_seller ON public.consignors (seller_id) WHERE seller_id IS NOT NULL;

ALTER TABLE public.consignors ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS consignors_owner ON public.consignors;
CREATE POLICY consignors_owner ON public.consignors
  FOR ALL TO authenticated USING (public.is_owner()) WITH CHECK (public.is_owner());
REVOKE ALL ON public.consignors FROM anon;

-- 2. Stone: owner terms (only on My Shop stones) -----------------------------
ALTER TABLE public.inventory_items
  ADD COLUMN IF NOT EXISTS consignor_id    uuid REFERENCES public.consignors(id),
  ADD COLUMN IF NOT EXISTS consignor_price numeric(10,2) CHECK (consignor_price IS NULL OR consignor_price >= 0),
  ADD COLUMN IF NOT EXISTS profit_share    numeric(4,3)  CHECK (profit_share IS NULL OR profit_share BETWEEN 0 AND 1);

ALTER TABLE public.inventory_items DROP CONSTRAINT IF EXISTS inventory_consignment_my_shop;
ALTER TABLE public.inventory_items ADD CONSTRAINT inventory_consignment_my_shop
  CHECK (consignor_id IS NULL
         OR (seller_id = 'a0000000-0000-0000-0000-000000000001'::uuid
             AND consignor_price IS NOT NULL AND profit_share IS NOT NULL));

-- Owner only; listed price never below the owner's price.
CREATE OR REPLACE FUNCTION public._inventory_consignment_guard()
RETURNS trigger
LANGUAGE plpgsql
SET search_path = public, pg_temp
AS $$
BEGIN
  IF auth.uid() IS NOT NULL AND NOT public.is_owner() THEN
    IF TG_OP = 'INSERT' AND (NEW.consignor_id IS NOT NULL OR NEW.consignor_price IS NOT NULL) THEN
      RAISE EXCEPTION 'Only the owner can set who owns a stone';
    END IF;
    IF TG_OP = 'UPDATE' AND (NEW.consignor_id IS DISTINCT FROM OLD.consignor_id
                             OR NEW.consignor_price IS DISTINCT FROM OLD.consignor_price
                             OR NEW.profit_share IS DISTINCT FROM OLD.profit_share) THEN
      RAISE EXCEPTION 'Only the owner can set who owns a stone';
    END IF;
  END IF;

  IF NEW.consignor_id IS NOT NULL AND NEW.selling_price IS NOT NULL
     AND NEW.selling_price < NEW.consignor_price THEN
    RAISE EXCEPTION 'The price (€%) is below the owner''s price (€%).', NEW.selling_price, NEW.consignor_price;
  END IF;
  RETURN NEW;
END;
$$;
REVOKE ALL ON FUNCTION public._inventory_consignment_guard() FROM PUBLIC, anon, authenticated;

DROP TRIGGER IF EXISTS inventory_consignment_guard ON public.inventory_items;
CREATE TRIGGER inventory_consignment_guard
  BEFORE INSERT OR UPDATE OF consignor_id, consignor_price, profit_share, selling_price
  ON public.inventory_items
  FOR EACH ROW EXECUTE FUNCTION public._inventory_consignment_guard();

-- 3. Order: payout kind, owner terms (snapshot), Stripe fee, postage ---------
ALTER TABLE public.orders
  ADD COLUMN IF NOT EXISTS payout_kind     text CHECK (payout_kind IS NULL OR payout_kind IN ('own','commission','consignment')),
  ADD COLUMN IF NOT EXISTS consignor_id    uuid REFERENCES public.consignors(id),
  ADD COLUMN IF NOT EXISTS consignor_price numeric(10,2),
  ADD COLUMN IF NOT EXISTS profit_share    numeric(4,3),
  ADD COLUMN IF NOT EXISTS stripe_fee      numeric(10,2) CHECK (stripe_fee IS NULL OR stripe_fee >= 0),
  ADD COLUMN IF NOT EXISTS postage_paid    numeric(10,2) CHECK (postage_paid IS NULL OR postage_paid >= 0);

COMMENT ON COLUMN public.orders.seller_payout IS
  'What the stone''s seller/owner receives. A: order_total − commission − stripe_fee. Consignment: owner''s price + share × profit. Own (My Shop): unchanged.';

-- The payout rule. Runs on every order update until the payout is marked paid.
CREATE OR REPLACE FUNCTION public._order_payout_rule()
RETURNS trigger
LANGUAGE plpgsql
SET search_path = public, pg_temp
AS $$
DECLARE
  v_goods  numeric;
  v_extra  numeric;
  v_profit numeric;
  v_owner  numeric;
BEGIN
  IF NEW.payout_kind IS NULL OR NEW.payout_kind = 'own' OR NEW.payout_status = 'paid' THEN
    RETURN NEW;
  END IF;

  IF NEW.payout_kind = 'commission' THEN
    NEW.seller_payout := NEW.order_total - coalesce(NEW.commission_amount, 0) - coalesce(NEW.stripe_fee, 0);
  ELSIF NEW.payout_kind = 'consignment' THEN
    v_goods  := NEW.order_total - coalesce(NEW.shipping_cost, 0);
    v_extra  := greatest(coalesce(NEW.postage_paid, 0) - coalesce(NEW.shipping_cost, 0), 0);
    v_profit := v_goods - NEW.consignor_price - v_extra - coalesce(NEW.stripe_fee, 0);
    v_owner  := NEW.consignor_price + round(NEW.profit_share * v_profit, 2);
    NEW.seller_payout     := v_owner;
    NEW.commission_amount := v_goods - v_extra - coalesce(NEW.stripe_fee, 0) - v_owner;  -- GemWorkers' half
  END IF;
  RETURN NEW;
END;
$$;
REVOKE ALL ON FUNCTION public._order_payout_rule() FROM PUBLIC, anon, authenticated;

DROP TRIGGER IF EXISTS orders_payout_rule ON public.orders;
CREATE TRIGGER orders_payout_rule
  BEFORE UPDATE ON public.orders
  FOR EACH ROW EXECUTE FUNCTION public._order_payout_rule();

-- When the stone is attached to a new platform order: copy the owner terms.
CREATE OR REPLACE FUNCTION public._order_item_payout_terms()
RETURNS trigger
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public, pg_temp
AS $$
DECLARE
  i record;
BEGIN
  SELECT seller_id, consignor_id, consignor_price, profit_share INTO i
  FROM   public.inventory_items WHERE id = NEW.inventory_item_id;

  UPDATE public.orders o
  SET    payout_kind = CASE
                         WHEN i.consignor_id IS NOT NULL THEN 'consignment'
                         WHEN o.seller_id = 'a0000000-0000-0000-0000-000000000001'::uuid THEN 'own'
                         ELSE 'commission'
                       END,
         consignor_id    = i.consignor_id,
         consignor_price = i.consignor_price,
         profit_share    = i.profit_share
  WHERE  o.id = NEW.order_id
    AND  o.sale_channel = 'platform'
    AND  o.payout_kind IS NULL;
  RETURN NEW;
END;
$$;
REVOKE ALL ON FUNCTION public._order_item_payout_terms() FROM PUBLIC, anon, authenticated;

DROP TRIGGER IF EXISTS order_items_payout_terms ON public.order_items;
CREATE TRIGGER order_items_payout_terms
  AFTER INSERT ON public.order_items
  FOR EACH ROW EXECUTE FUNCTION public._order_item_payout_terms();

-- 4. Offers: never accept / counter a consignment stone below the owner's price
CREATE OR REPLACE FUNCTION public._offer_consignment_floor()
RETURNS trigger
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public, pg_temp
AS $$
DECLARE
  v_floor numeric;
  v_price numeric;
BEGIN
  SELECT consignor_price INTO v_floor
  FROM   public.inventory_items
  WHERE  id = NEW.inventory_item_id AND consignor_id IS NOT NULL;
  IF v_floor IS NULL THEN RETURN NEW; END IF;

  -- Staff sends a counter-offer
  IF NEW.counter_price IS NOT NULL AND NEW.counter_price IS DISTINCT FROM OLD.counter_price
     AND NEW.counter_price < v_floor THEN
    RAISE EXCEPTION 'This stone''s owner price is €% — counter at €% or more.', v_floor, v_floor;
  END IF;

  -- Offer accepted (by staff) or counter accepted (by the buyer)
  IF NEW.status = 'accepted' AND OLD.status IS DISTINCT FROM 'accepted' THEN
    v_price := CASE WHEN OLD.status = 'countered' THEN NEW.counter_price ELSE NEW.offered_price END;
    IF v_price < v_floor THEN
      RAISE EXCEPTION 'This offer is below the stone''s owner price (€%). Send a counter-offer of at least €% instead.', v_floor, v_floor;
    END IF;
  END IF;
  RETURN NEW;
END;
$$;
REVOKE ALL ON FUNCTION public._offer_consignment_floor() FROM PUBLIC, anon, authenticated;

DROP TRIGGER IF EXISTS offers_consignment_floor ON public.storefront_offers;
CREATE TRIGGER offers_consignment_floor
  BEFORE UPDATE OF status, counter_price ON public.storefront_offers
  FOR EACH ROW EXECUTE FUNCTION public._offer_consignment_floor();

-- 5. Existing platform orders: set their payout kind (no amounts change:
--    no Stripe fee recorded yet, no consignment stones yet).
UPDATE public.orders o
SET    payout_kind = CASE WHEN o.seller_id = 'a0000000-0000-0000-0000-000000000001'::uuid THEN 'own' ELSE 'commission' END
WHERE  o.sale_channel = 'platform' AND o.payout_kind IS NULL;

COMMIT;

-- VERIFICATION (read-only):
--   SELECT payout_kind, count(*) FROM orders GROUP BY 1;
--   SELECT tgname FROM pg_trigger WHERE tgname IN ('orders_payout_rule','order_items_payout_terms',
--     'offers_consignment_floor','inventory_consignment_guard');
