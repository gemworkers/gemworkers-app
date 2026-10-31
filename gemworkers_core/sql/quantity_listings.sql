-- ============================================================================
-- GemWorkers — Quantity listings (jewellery: "10 available", buyer buys 1–99)
-- 2026-10-31 · money change: run sql/tests/run_money_tests.js before + after.
-- ============================================================================
-- inventory_items.quantity now means UNITS IN STOCK (all existing listings are 1).
--   * Buying k units: quantity − k. At 0 the listing is 'reserved' (as before
--     for one-of-a-kind stones); after payment, 0 left → 'sold' + unlisted.
--     Units still left → stays 'available' and listed.
--   * Unpaid order cancelled → its units come back. Return refunded → units back
--     (unlisted only if it had sold out, as before).
--   * Order: order_items.quantity = k, price_at_sale = unit price,
--     order_total = unit price × k + shipping (one shipment). Service fee on the
--     goods total (minimum €3 per order, unchanged). Consignment owner's price × k.
--   * Invoice line shows the quantity. Cart rows carry a quantity.
--   * Offers only on single items (stock 1) — a trigger refuses the rest.
--   * One-of-a-kind stones behave exactly as before (quantity 1 → 0).
-- Trigger inventory_stock_status keeps the rule "reserved/sold = 0 left,
-- available = at least 1" for every older path (offers, Sold elsewhere, Edit).
-- Changed live functions: create_platform_order (new optional p_quantity),
-- confirm_order_paid, cancel_pending_payment_order, complete_return_refund
-- (stock lines only), issue_invoice + _order_item_payout_terms (edited inside
-- the live definition, nothing else touched). Views: column stock appended.
-- Applied to live DB 2026-10-31 (verified: stock in both views, create_platform_order(uuid, integer), 2 triggers, 0 available without stock; money tests 38/38).
-- ============================================================================

BEGIN;

-- ── 1. Stock column: tidy existing rows, default, never negative ────────────
UPDATE public.inventory_items SET quantity = 0 WHERE status IN ('reserved', 'sold') AND quantity <> 0;
UPDATE public.inventory_items SET quantity = 1 WHERE status = 'available' AND quantity < 1;
ALTER TABLE public.inventory_items ALTER COLUMN quantity SET DEFAULT 1;
ALTER TABLE public.inventory_items DROP CONSTRAINT IF EXISTS inventory_items_quantity_not_negative;
ALTER TABLE public.inventory_items ADD CONSTRAINT inventory_items_quantity_not_negative CHECK (quantity >= 0);

-- ── 2. Stock ↔ status rule for every path ────────────────────────────────────
CREATE OR REPLACE FUNCTION public._inventory_stock_status()
RETURNS trigger
LANGUAGE plpgsql
SET search_path = public, pg_temp
AS $$
BEGIN
  -- Older paths (accepted offer, Sold elsewhere, Edit → status) take the item
  -- out of sale without touching the stock: nothing is left then.
  IF TG_OP = 'UPDATE' AND NEW.status IN ('reserved', 'sold') AND OLD.status = 'available'
     AND NEW.quantity IS NOT DISTINCT FROM OLD.quantity THEN
    NEW.quantity := 0;
  END IF;
  -- Something for sale has at least one unit.
  IF NEW.status = 'available' AND coalesce(NEW.quantity, 0) < 1 THEN
    NEW.quantity := 1;
  END IF;
  RETURN NEW;
END;
$$;

DROP TRIGGER IF EXISTS inventory_stock_status ON public.inventory_items;
CREATE TRIGGER inventory_stock_status
  BEFORE INSERT OR UPDATE OF status, quantity ON public.inventory_items
  FOR EACH ROW EXECUTE FUNCTION public._inventory_stock_status();

-- ── 3. create_platform_order: optional quantity ──────────────────────────────
DROP FUNCTION IF EXISTS public.create_platform_order(uuid);

CREATE FUNCTION public.create_platform_order(p_inventory_item_id uuid, p_quantity integer DEFAULT 1)
 RETURNS uuid
 LANGUAGE plpgsql
 SECURITY DEFINER
AS $function$
DECLARE
  v_item        record;
  v_order_id    uuid;
  v_item_price  numeric;
  v_shipping    numeric;
  v_total       numeric;
  v_rate        numeric;
  v_commission  numeric;
  v_payout      numeric;
BEGIN
  IF p_quantity IS NULL OR p_quantity < 1 OR p_quantity > 99 THEN
    RAISE EXCEPTION 'Please choose a quantity between 1 and 99.';
  END IF;

  SELECT i.id, i.selling_price, i.seller_id, i.status, i.is_listed, i.quantity,
         s.status          AS seller_status,
         i.shipping_cost,
         s.commission_rate AS seller_commission_rate
  INTO   v_item
  FROM   inventory_items i
  JOIN   sellers         s ON s.id = i.seller_id
  WHERE  i.id = p_inventory_item_id
  FOR UPDATE;

  IF NOT FOUND THEN
    RAISE EXCEPTION 'Item not found';
  END IF;
  IF NOT v_item.is_listed THEN
    RAISE EXCEPTION 'Item is not listed for sale';
  END IF;
  IF v_item.status <> 'available' THEN
    RAISE EXCEPTION 'Item is not available (status: %)', v_item.status;
  END IF;
  IF v_item.seller_status <> 'active' THEN
    RAISE EXCEPTION 'Seller is not active';
  END IF;
  IF v_item.selling_price IS NULL THEN
    RAISE EXCEPTION 'Item has no listed price';
  END IF;
  IF coalesce(v_item.quantity, 1) < p_quantity THEN
    RAISE EXCEPTION 'Only % available', coalesce(v_item.quantity, 0);
  END IF;

  -- Take the units out of stock; the last one reserves the listing (as before).
  UPDATE inventory_items
  SET    quantity = quantity - p_quantity,
         status   = CASE WHEN quantity - p_quantity <= 0 THEN 'reserved' ELSE status END
  WHERE  id = p_inventory_item_id;

  v_item_price := v_item.selling_price * p_quantity;
  v_shipping   := COALESCE(v_item.shipping_cost, 0);
  v_total      := v_item_price + v_shipping;
  -- No default commission: NULL rate means 0%.
  v_rate       := COALESCE(v_item.seller_commission_rate, 0);
  v_commission := ROUND(v_item_price * v_rate, 2);
  v_payout     := v_total - v_commission;

  INSERT INTO orders (
    buyer_id,          seller_id,          sale_channel,
    status,            order_total,        shipping_cost,
    commission_rate,   commission_amount,  seller_payout
  )
  VALUES (
    auth.uid(),        v_item.seller_id,   'platform',
    'pending_payment', v_total,            v_shipping,
    v_rate,            v_commission,       v_payout
  )
  RETURNING id INTO v_order_id;

  INSERT INTO order_items (order_id, inventory_item_id, price_at_sale, quantity)
  VALUES (v_order_id, p_inventory_item_id, v_item.selling_price, p_quantity);

  RETURN v_order_id;
END;
$function$;

REVOKE ALL ON FUNCTION public.create_platform_order(uuid, integer) FROM PUBLIC, anon;
GRANT EXECUTE ON FUNCTION public.create_platform_order(uuid, integer) TO authenticated, service_role;

-- ── 4. Paid: sold only when nothing is left ──────────────────────────────────
CREATE OR REPLACE FUNCTION public.confirm_order_paid(p_order_id uuid)
 RETURNS void
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO 'public'
AS $function$
DECLARE
  v_status text;
BEGIN
  SELECT status INTO v_status
  FROM orders WHERE id = p_order_id
  FOR UPDATE;

  IF NOT FOUND THEN
    RAISE EXCEPTION 'Order not found: %', p_order_id;
  END IF;

  -- Idempotent: already confirmed
  IF v_status = 'confirmed' THEN
    RETURN;
  END IF;

  IF v_status <> 'pending_payment' THEN
    RAISE EXCEPTION
      'Cannot confirm order %: expected status ''pending_payment'', found ''%''',
      p_order_id, v_status;
  END IF;

  UPDATE orders
  SET    status = 'confirmed'
  WHERE  id = p_order_id;

  -- Sold out (0 left): remove it from sale. Units still in stock stay listed.
  UPDATE inventory_items
  SET    status    = 'sold',
         is_listed = false
  WHERE  id IN (
    SELECT inventory_item_id
    FROM   order_items
    WHERE  order_id = p_order_id
  )
    AND  coalesce(quantity, 0) = 0;
END;
$function$;

-- ── 5. Unpaid order cancelled: its units come back ───────────────────────────
CREATE OR REPLACE FUNCTION public.cancel_pending_payment_order(p_order_id uuid)
 RETURNS void
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO 'public'
AS $function$
DECLARE
  v_status         text;
  v_offer_id       uuid;
  v_payment_due_at timestamptz;
BEGIN
  SELECT status, offer_id, payment_due_at
  INTO   v_status, v_offer_id, v_payment_due_at
  FROM   orders
  WHERE  id = p_order_id
  FOR UPDATE;

  IF NOT FOUND THEN
    RAISE EXCEPTION 'Order not found: %', p_order_id;
  END IF;

  IF v_status = 'cancelled' THEN
    RETURN;
  END IF;

  IF v_status <> 'pending_payment' THEN
    RAISE EXCEPTION
      'Cannot cancel order %: expected status ''pending_payment'', found ''%''',
      p_order_id, v_status;
  END IF;

  -- Accepted-offer orders keep their window: backing out of Stripe must not
  -- cancel them. Only the deadline (via the sweep) releases them.
  IF v_offer_id IS NOT NULL AND v_payment_due_at IS NOT NULL AND v_payment_due_at > now() THEN
    RETURN;
  END IF;

  UPDATE orders
  SET    status = 'cancelled'
  WHERE  id = p_order_id;

  UPDATE inventory_items i
  SET    quantity  = coalesce(i.quantity, 0) + coalesce(oi.quantity, 1),
         status    = 'available',
         is_listed = true
  FROM   order_items oi
  WHERE  oi.order_id = p_order_id
    AND  i.id = oi.inventory_item_id;

  IF v_offer_id IS NOT NULL THEN
    UPDATE storefront_offers
    SET    status = 'expired'
    WHERE  id = v_offer_id
      AND  status = 'accepted';
  END IF;
END;
$function$;

-- ── 6. Return refunded: units back in stock ──────────────────────────────────
CREATE OR REPLACE FUNCTION public.complete_return_refund(p_return_id uuid, p_deduction numeric, p_deduction_reason text, p_stripe_refund_id text)
 RETURNS void
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO 'public'
AS $function$
DECLARE
  r        record;
  v_refund numeric;
BEGIN
  SELECT rt.id, rt.order_id, o.order_total, o.tax_amount, o.payout_status, o.seller_payout
  INTO   r
  FROM   public.returns rt JOIN public.orders o ON o.id = rt.order_id
  WHERE  rt.id = p_return_id AND rt.status = 'received'
  FOR UPDATE OF rt, o;
  IF r.id IS NULL THEN RAISE EXCEPTION 'Only a received return can be refunded.'; END IF;

  v_refund := public.return_refund_amount(p_return_id, p_deduction);

  UPDATE public.returns
  SET    status = 'refunded', refunded_at = now(),
         refund_amount = v_refund,
         refund_tax = CASE WHEN r.tax_amount > 0
                           THEN round(v_refund * r.tax_amount / (r.order_total + r.tax_amount), 2)
                           ELSE 0 END,
         deduction = p_deduction, deduction_reason = nullif(trim(p_deduction_reason), ''),
         stripe_refund_id = p_stripe_refund_id,
         payout_clawback = CASE WHEN r.payout_status = 'paid' THEN r.seller_payout ELSE 0 END,
         updated_at = now()
  WHERE  id = p_return_id;

  UPDATE public.orders SET status = 'refunded' WHERE id = r.order_id;

  -- The units are back in stock. A sold-out listing comes back unlisted until
  -- the owner relists it (as before); one still on sale stays listed.
  UPDATE public.inventory_items i
  SET    quantity  = coalesce(i.quantity, 0) + coalesce(oi.quantity, 1),
         is_listed = CASE WHEN i.status = 'available' THEN i.is_listed ELSE false END,
         status    = 'available',
         updated_at = now()
  FROM   public.order_items oi
  WHERE  oi.order_id = r.order_id AND i.id = oi.inventory_item_id;
END;
$function$;

-- ── 7. Invoice line quantity + consignment price × quantity ──────────────────
-- Edited inside the live definitions (exact text swaps; fails if not found).
DO $do$
DECLARE
  d text;
  nl text;   -- the stored definition may use Windows line endings
  a1 text;
  b1 text;
  a2 constant text := '''quantity'', 1, ''amount'', v_goods)';
  b2 constant text := '''quantity'', coalesce(it.qty, 1), ''amount'', v_goods)';
  a3 constant text := 'consignor_price = i.consignor_price,';
  b3 constant text := 'consignor_price = i.consignor_price * coalesce(NEW.quantity, 1),';
BEGIN
  d := pg_get_functiondef('public.issue_invoice(uuid)'::regprocedure);
  nl := CASE WHEN position(chr(13) IN d) > 0 THEN chr(13) || chr(10) ELSE chr(10) END;
  a1 := 'SELECT i.title, i.sku, i.product_type, i.gem_type, i.weight_value, i.weight_unit' || nl || '  INTO   it';
  b1 := 'SELECT i.title, i.sku, i.product_type, i.gem_type, i.weight_value, i.weight_unit, oi.quantity AS qty' || nl || '  INTO   it';
  IF position(a1 IN d) = 0 OR position(a2 IN d) = 0 THEN
    RAISE EXCEPTION 'issue_invoice: expected text not found — live definition changed, stop.';
  END IF;
  EXECUTE replace(replace(d, a1, b1), a2, b2);

  d := pg_get_functiondef('public._order_item_payout_terms()'::regprocedure);
  IF position(a3 IN d) = 0 THEN
    RAISE EXCEPTION '_order_item_payout_terms: expected text not found — stop.';
  END IF;
  EXECUTE replace(d, a3, b3);
END
$do$;

-- ── 8. Offers only on single items ───────────────────────────────────────────
CREATE OR REPLACE FUNCTION public._offers_single_items_only()
RETURNS trigger
LANGUAGE plpgsql
SET search_path = public, pg_temp
AS $$
BEGIN
  IF (SELECT quantity FROM public.inventory_items WHERE id = NEW.inventory_item_id) > 1 THEN
    RAISE EXCEPTION 'Offers are not possible on items with more than one in stock — please buy at the listed price.';
  END IF;
  RETURN NEW;
END;
$$;

DROP TRIGGER IF EXISTS offers_single_items_only ON public.storefront_offers;
CREATE TRIGGER offers_single_items_only
  BEFORE INSERT ON public.storefront_offers
  FOR EACH ROW EXECUTE FUNCTION public._offers_single_items_only();

-- ── 9. Cart quantity ─────────────────────────────────────────────────────────
ALTER TABLE public.storefront_cart ADD COLUMN IF NOT EXISTS quantity integer NOT NULL DEFAULT 1;
ALTER TABLE public.storefront_cart DROP CONSTRAINT IF EXISTS storefront_cart_quantity_range;
ALTER TABLE public.storefront_cart ADD CONSTRAINT storefront_cart_quantity_range CHECK (quantity BETWEEN 1 AND 99);

DROP POLICY IF EXISTS cart_buyer_update ON public.storefront_cart;
CREATE POLICY cart_buyer_update ON public.storefront_cart FOR UPDATE TO authenticated
  USING (buyer_id = auth.uid()) WITH CHECK (buyer_id = auth.uid());

-- ── 10. Public views: stock appended ─────────────────────────────────────────
DO $do$
DECLARE
  v text;
  a constant text := 'i.is_featured' || chr(10) || '   FROM';
  b constant text := 'i.is_featured,' || chr(10) || '    i.quantity AS stock' || chr(10) || '   FROM';
BEGIN
  v := pg_get_viewdef('public.public_listings'::regclass, true);
  IF position('AS stock' IN v) = 0 THEN
    IF position(a IN v) = 0 THEN RAISE EXCEPTION 'public_listings: expected text not found — stop.'; END IF;
    EXECUTE 'CREATE OR REPLACE VIEW public.public_listings AS ' || replace(v, a, b);
  END IF;
  v := pg_get_viewdef('public.public_listing_details'::regclass, true);
  IF position('AS stock' IN v) = 0 THEN
    IF position(a IN v) = 0 THEN RAISE EXCEPTION 'public_listing_details: expected text not found — stop.'; END IF;
    EXECUTE 'CREATE OR REPLACE VIEW public.public_listing_details AS ' || replace(v, a, b);
  END IF;
END
$do$;

-- Check: stock column in both views, one create_platform_order, triggers present
SELECT
  (SELECT count(*) FROM information_schema.columns WHERE table_name IN ('public_listings', 'public_listing_details') AND column_name = 'stock') AS views_with_stock,
  (SELECT count(*) FROM pg_proc WHERE proname = 'create_platform_order') AS create_order_versions,
  (SELECT count(*) FROM pg_trigger WHERE tgname IN ('inventory_stock_status', 'offers_single_items_only')) AS new_triggers,
  (SELECT count(*) FROM public.inventory_items WHERE status = 'available' AND quantity < 1) AS available_without_stock;

COMMIT;
