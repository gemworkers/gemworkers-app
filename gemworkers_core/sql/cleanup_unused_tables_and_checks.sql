-- =============================================================================
-- GemWorkers — Clean-up: unused prototype tables, old backups, two checks
-- =============================================================================
-- Applied to live DB 2026-10-25
--
-- System review 2026-10-25 (Zakaria asked for the clean-up):
--
-- 1. 13 tables from the first prototype — EMPTY (0 rows) and used by no code,
--    view or function: business_users, businesses, contacts,
--    contact_activities, contact_tags, inventory_lots, inventory_movements,
--    inventory_locations, marketplace_listings, payments, product_media,
--    profiles, tasks. (Real ones stay: locations, item_movements, purchases,
--    purchase_items, customers, suppliers, …)
--    inventory_items.business_id / lot_id pointed at two of them; those links
--    are removed first (the columns stay, all empty).
-- 2. The 5 _backup_* tables (old test-data copies, locked since today) are
--    deleted. ⚠ Permanent — they only held old test orders/buyers.
-- 3. handle_sale_customer (manual sale → customer list): any logged-in user
--    could call it and re-link ANY order to a customer. Now: owner, or the
--    seller of that order. (Copied from live; only the check is new.)
-- 4. order_refundable: owner / server only (it showed any order's amount).
-- =============================================================================

BEGIN;

-- 1. Unused prototype tables ---------------------------------------------------
ALTER TABLE public.inventory_items DROP CONSTRAINT IF EXISTS inventory_items_business_id_fkey;
ALTER TABLE public.inventory_items DROP CONSTRAINT IF EXISTS inventory_items_lot_id_fkey;

DROP TABLE IF EXISTS
  public.business_users, public.contact_activities, public.contact_tags, public.contacts,
  public.inventory_movements, public.product_media, public.inventory_lots, public.inventory_locations,
  public.marketplace_listings, public.payments, public.tasks, public.profiles, public.businesses;

-- 2. Old backups ------------------------------------------------------------------
DROP TABLE IF EXISTS
  public._backup_buyers, public._backup_customers, public._backup_inventory_items,
  public._backup_order_items, public._backup_orders;

-- 3. handle_sale_customer: staff check --------------------------------------
CREATE OR REPLACE FUNCTION public.handle_sale_customer(p_name text, p_email text, p_phone text, p_order_id uuid)
RETURNS uuid
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path TO 'public'
AS $function$
DECLARE
  v_customer_id    uuid;
  v_total_spent    numeric(14,2);
  v_order_count    integer;
  v_first_date     date;
  v_last_date      date;
  v_auto_tier      text;
BEGIN
  -- Only the owner, or the seller of this order (manual sales in the admin).
  IF NOT public.is_owner() AND NOT EXISTS (
       SELECT 1 FROM orders o WHERE o.id = p_order_id AND o.seller_id = public.current_seller_id()) THEN
    RAISE EXCEPTION 'Not allowed';
  END IF;

  -- ── a) Find existing customer ────────────────────────────────────────────
  IF p_email <> '' THEN
    SELECT id INTO v_customer_id
    FROM   customers
    WHERE  lower(email) = lower(p_email)
    LIMIT  1;
  END IF;

  IF v_customer_id IS NULL AND p_phone <> '' THEN
    SELECT id INTO v_customer_id
    FROM   customers
    WHERE  phone = p_phone
    LIMIT  1;
  END IF;

  -- ── b) Create new customer if not found ─────────────────────────────────
  IF v_customer_id IS NULL THEN
    INSERT INTO customers (name, email, phone)
    VALUES (
      COALESCE(NULLIF(TRIM(p_name), ''), 'Unknown'),
      p_email,
      p_phone
    )
    RETURNING id INTO v_customer_id;
  END IF;

  -- ── c) Link this order to the customer ──────────────────────────────────
  UPDATE orders
  SET    customer_id = v_customer_id
  WHERE  id = p_order_id;

  -- ── d) Recalculate stats from all paid orders ────────────────────────────
  SELECT
    COALESCE(SUM(order_total), 0),
    COUNT(*),
    MIN(order_date),
    MAX(order_date)
  INTO
    v_total_spent,
    v_order_count,
    v_first_date,
    v_last_date
  FROM orders
  WHERE  customer_id = v_customer_id
    AND  status = 'paid';

  -- ── e) Compute auto_tier ─────────────────────────────────────────────────
  IF    v_total_spent >= 50000 THEN v_auto_tier := 'Collector';
  ELSIF v_total_spent >= 15000 THEN v_auto_tier := 'Premium';
  ELSIF v_total_spent >= 5000  THEN v_auto_tier := 'Gold';
  ELSE                              v_auto_tier := 'Silver';
  END IF;

  -- ── f) Persist ───────────────────────────────────────────────────────────
  UPDATE customers
  SET
    total_spent      = v_total_spent,
    order_count      = v_order_count,
    first_order_date = v_first_date,
    last_order_date  = v_last_date,
    auto_tier        = v_auto_tier
  WHERE id = v_customer_id;

  RETURN v_customer_id;
END;
$function$;

-- 4. order_refundable: owner / server only -----------------------------------
CREATE OR REPLACE FUNCTION public.order_refundable(p_order_id uuid)
RETURNS numeric
LANGUAGE plpgsql
STABLE
SECURITY DEFINER
SET search_path = public, pg_temp
AS $$
BEGIN
  -- A logged-in user must be the owner; the store server (service role) and
  -- SQL jobs (no login) may always ask.
  IF auth.uid() IS NOT NULL AND coalesce(auth.role(), '') <> 'service_role' AND NOT public.is_owner() THEN
    RAISE EXCEPTION 'Owner only';
  END IF;
  RETURN (
    SELECT (o.order_total + o.tax_amount)
         - coalesce((SELECT sum(r.amount) FROM public.order_refunds r WHERE r.order_id = o.id), 0)
         - coalesce((SELECT rt.refund_amount FROM public.returns rt WHERE rt.order_id = o.id AND rt.status = 'refunded'), 0)
    FROM public.orders o WHERE o.id = p_order_id
  );
END;
$$;
REVOKE ALL ON FUNCTION public.order_refundable(uuid) FROM PUBLIC, anon;
GRANT EXECUTE ON FUNCTION public.order_refundable(uuid) TO authenticated, service_role;

COMMIT;
