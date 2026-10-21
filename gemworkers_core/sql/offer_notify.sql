-- =============================================================================
-- GemWorkers — Offer email notifications (part 1: new / response / expired)
-- =============================================================================
-- Applied to live DB 2026-10-21
--
-- 1. storefront_offers columns
--      responded_by_role      — who moved the offer out of 'pending':
--                               'seller' | 'owner' | 'system'
--                               ('system' = auto-declined because another
--                               offer on the same stone was accepted).
--                               NULL for offers not yet responded to and for
--                               offers responded to before this migration.
--      new_offer_notified_at  — staff emailed about the new offer
--      response_notified_at   — buyer (+ other staff side) emailed about the
--                               accept / decline
--      expired_notified_at    — buyer + staff emailed that the payment window
--                               ended
--    Later parts add their own <kind>_notified_at column + claim kind
--    (e.g. payment_reminder_notified_at → 'payment_reminder').
--
-- 2. respond_to_offer — copied verbatim from the LIVE version in
--    sql/commission_default_zero.sql (applied 2026-10-18; it supersedes
--    sql/respond_to_offer_owner_override.sql, which still had the 0.10
--    commission default). The ONLY change is responded_by_role being stamped:
--      decline path        → 'seller' or 'owner' (whoever called it)
--      accept path         → 'seller' or 'owner' (whoever called it)
--      auto-decline others → 'system'
--    "seller" means the caller's own shop owns the offer; otherwise the caller
--    got past the ownership check only as the owner. If the owner is also the
--    stone's seller (house brand) the stamp is 'seller'.
--    CREATE OR REPLACE keeps the existing EXECUTE grants.
--
-- 3. claim_offer_notification(p_offer_id, p_kind) RETURNS boolean
--    Atomically stamps <kind>_notified_at = now() if it is still NULL and
--    returns true (send the email); false if already claimed or the offer
--    does not exist. Single UPDATE … RETURNING takes the row lock, so a webhook
--    retry or a duplicate delivery cannot send twice.
--    Kinds: 'new_offer' | 'response' | 'expired'.
--    Called only by the offer-notify Edge Function (service_role).
--
--    Note: the claim UPDATE itself fires the storefront_offers UPDATE webhook
--    again. offer-notify ignores it because status does not change.
--
-- Requires: storefront_commerce.sql, offer_payment_window.sql,
--           commission_default_zero.sql.
--
-- Safe to re-run: IF NOT EXISTS / CREATE OR REPLACE, all in one transaction.
-- =============================================================================

BEGIN;


-- =============================================================================
-- 1. COLUMNS
-- =============================================================================

ALTER TABLE public.storefront_offers
  ADD COLUMN IF NOT EXISTS responded_by_role     text,
  ADD COLUMN IF NOT EXISTS new_offer_notified_at timestamptz,
  ADD COLUMN IF NOT EXISTS response_notified_at  timestamptz,
  ADD COLUMN IF NOT EXISTS expired_notified_at   timestamptz;

-- Named so a later part (e.g. counter-offers) can drop + re-add it with more roles.
ALTER TABLE public.storefront_offers
  DROP CONSTRAINT IF EXISTS storefront_offers_responded_by_role_check;
ALTER TABLE public.storefront_offers
  ADD  CONSTRAINT storefront_offers_responded_by_role_check
  CHECK (responded_by_role IS NULL OR responded_by_role IN ('seller', 'owner', 'system'));


-- =============================================================================
-- 2. respond_to_offer (live version + responded_by_role stamps)
-- =============================================================================

CREATE OR REPLACE FUNCTION public.respond_to_offer(p_offer_id uuid, p_action text, p_seller_note text DEFAULT ''::text)
 RETURNS json
 LANGUAGE plpgsql
 SECURITY DEFINER
AS $function$
DECLARE
  v_offer                  record;
  v_item                   record;
  v_order_id               uuid;
  v_seller_commission_rate numeric;
  v_item_price             numeric;
  v_shipping               numeric;
  v_total                  numeric;
  v_rate                   numeric;
  v_commission             numeric;
  v_payout                 numeric;
BEGIN
  IF p_action NOT IN ('accepted', 'declined') THEN
    RAISE EXCEPTION 'p_action must be ''accepted'' or ''declined''';
  END IF;

  SELECT o.id, o.buyer_id, o.inventory_item_id, o.seller_id,
         o.offered_price, o.status
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

  IF v_offer.status <> 'pending' THEN
    RAISE EXCEPTION 'Offer is no longer pending (status: %)', v_offer.status;
  END IF;

  IF p_action = 'declined' THEN
    UPDATE storefront_offers
    SET    status = 'declined', responded_at = now(),
           seller_note = COALESCE(p_seller_note, ''),
           responded_by_role = CASE WHEN v_offer.seller_id IS NOT DISTINCT FROM public.current_seller_id()
                                    THEN 'seller' ELSE 'owner' END
    WHERE  id = p_offer_id;

    RETURN json_build_object('offer_id', p_offer_id, 'order_id', null);
  END IF;

  SELECT id, status, shipping_cost
  INTO   v_item
  FROM   inventory_items
  WHERE  id = v_offer.inventory_item_id
  FOR UPDATE;

  IF v_item.status <> 'available' THEN
    RAISE EXCEPTION 'Item is no longer available (status: %)', v_item.status;
  END IF;

  SELECT commission_rate
  INTO   v_seller_commission_rate
  FROM   sellers
  WHERE  id = v_offer.seller_id;

  UPDATE inventory_items
  SET    status = 'reserved'
  WHERE  id = v_offer.inventory_item_id;

  v_item_price := v_offer.offered_price;
  v_shipping   := COALESCE(v_item.shipping_cost, 0);
  v_total      := v_item_price + v_shipping;
  -- No default commission: NULL rate means 0%.
  v_rate       := COALESCE(v_seller_commission_rate, 0);
  v_commission := ROUND(v_item_price * v_rate, 2);
  v_payout     := v_total - v_commission;

  INSERT INTO orders (
    buyer_id,         seller_id,          sale_channel,
    status,           order_total,        shipping_cost,
    commission_rate,  commission_amount,  seller_payout,
    offer_id,         payment_due_at
  )
  VALUES (
    v_offer.buyer_id, v_offer.seller_id,  'platform',
    'pending_payment', v_total,           v_shipping,
    v_rate,           v_commission,       v_payout,
    p_offer_id,       now() + interval '48 hours'
  )
  RETURNING id INTO v_order_id;

  INSERT INTO order_items (order_id, inventory_item_id, price_at_sale, quantity)
  VALUES (v_order_id, v_offer.inventory_item_id, v_item_price, 1);

  UPDATE storefront_offers
  SET    status = 'accepted', responded_at = now(),
         seller_note = COALESCE(p_seller_note, ''),
         responded_by_role = CASE WHEN v_offer.seller_id IS NOT DISTINCT FROM public.current_seller_id()
                                  THEN 'seller' ELSE 'owner' END
  WHERE  id = p_offer_id;

  UPDATE storefront_offers
  SET    status = 'declined', responded_at = now(),
         seller_note = 'Stone is no longer available',
         responded_by_role = 'system'
  WHERE  inventory_item_id = v_offer.inventory_item_id
    AND  status            = 'pending'
    AND  id                <> p_offer_id;

  RETURN json_build_object('offer_id', p_offer_id, 'order_id', v_order_id);
END;
$function$;


-- =============================================================================
-- 3. claim_offer_notification
-- =============================================================================
-- To add a kind later: add its column above, then one SET line, one WHEN in
-- the WHERE, and the name in the IN list.

CREATE OR REPLACE FUNCTION public.claim_offer_notification(
  p_offer_id uuid,
  p_kind     text
)
RETURNS boolean
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public, pg_temp
AS $$
DECLARE
  v_claimed boolean;
BEGIN
  IF p_kind IS NULL OR p_kind NOT IN ('new_offer', 'response', 'expired') THEN
    RAISE EXCEPTION 'claim_offer_notification: invalid kind %', p_kind;
  END IF;

  UPDATE public.storefront_offers o
  SET    new_offer_notified_at = CASE WHEN p_kind = 'new_offer' THEN now() ELSE o.new_offer_notified_at END,
         response_notified_at  = CASE WHEN p_kind = 'response'  THEN now() ELSE o.response_notified_at  END,
         expired_notified_at   = CASE WHEN p_kind = 'expired'   THEN now() ELSE o.expired_notified_at   END
  WHERE  o.id = p_offer_id
    AND  CASE p_kind
           WHEN 'new_offer' THEN o.new_offer_notified_at IS NULL
           WHEN 'response'  THEN o.response_notified_at  IS NULL
           WHEN 'expired'   THEN o.expired_notified_at   IS NULL
         END
  RETURNING true INTO v_claimed;

  RETURN COALESCE(v_claimed, false);
END;
$$;

REVOKE ALL     ON FUNCTION public.claim_offer_notification(uuid, text) FROM PUBLIC, anon, authenticated;
GRANT  EXECUTE ON FUNCTION public.claim_offer_notification(uuid, text) TO service_role;


COMMIT;


-- =============================================================================
-- VERIFICATION (run separately after applying)
-- =============================================================================
--
-- Columns + constraint exist:
--   SELECT column_name, data_type
--   FROM   information_schema.columns
--   WHERE  table_schema = 'public' AND table_name = 'storefront_offers'
--     AND  (column_name LIKE '%\_notified\_at' OR column_name = 'responded_by_role')
--   ORDER  BY 1;
--   -- expect 4 rows: expired_notified_at, new_offer_notified_at,
--   --                responded_by_role (text), response_notified_at
--
--   SELECT pg_get_constraintdef(oid)
--   FROM   pg_constraint
--   WHERE  conname = 'storefront_offers_responded_by_role_check';
--   -- expect: CHECK (responded_by_role IS NULL OR responded_by_role = ANY (ARRAY['seller','owner','system']))
--
-- respond_to_offer now stamps responded_by_role (3 stamps) and still uses the
-- 0% commission default:
--   SELECT p.prosrc
--   FROM   pg_proc p
--   JOIN   pg_namespace n ON n.oid = p.pronamespace
--   WHERE  n.nspname = 'public' AND p.proname = 'respond_to_offer';
--
--   SELECT (length(p.prosrc) - length(replace(p.prosrc, 'responded_by_role', '')))
--            / length('responded_by_role')                     AS stamp_count,   -- expect 3
--          p.prosrc LIKE '%COALESCE(v_seller_commission_rate, 0)%' AS zero_default -- expect true
--   FROM   pg_proc p
--   WHERE  p.proname = 'respond_to_offer';
--
-- respond_to_offer grants unchanged (authenticated can still call it):
--   SELECT has_function_privilege('authenticated', 'public.respond_to_offer(uuid, text, text)', 'EXECUTE');
--   -- expect: true
--
-- claim function is SECURITY DEFINER with a fixed search_path:
--   SELECT p.prosecdef, p.proconfig
--   FROM   pg_proc p
--   WHERE  p.proname = 'claim_offer_notification';
--   -- expect: true | {"search_path=public, pg_temp"}
--
-- Only service_role (and postgres) can execute it:
--   SELECT has_function_privilege('anon',          'public.claim_offer_notification(uuid, text)', 'EXECUTE'),
--          has_function_privilege('authenticated', 'public.claim_offer_notification(uuid, text)', 'EXECUTE'),
--          has_function_privilege('service_role',  'public.claim_offer_notification(uuid, text)', 'EXECUTE');
--   -- expect: false | false | true
--
-- Claim dry-run on a real offer (rolled back so nothing sticks). Replace <offer_id>.
--   BEGIN;
--   SELECT public.claim_offer_notification('<offer_id>', 'response');  -- true  (first claim)
--   SELECT public.claim_offer_notification('<offer_id>', 'response');  -- false (already claimed)
--   SELECT public.claim_offer_notification('<offer_id>', 'expired');   -- true  (kinds independent)
--   SELECT public.claim_offer_notification(gen_random_uuid(), 'new_offer'); -- false (no such row)
--   ROLLBACK;
--
-- After the first real accept, check the stamps:
--   SELECT id, status, responded_by_role, responded_at,
--          new_offer_notified_at, response_notified_at, expired_notified_at
--   FROM   storefront_offers
--   ORDER  BY responded_at DESC NULLS LAST
--   LIMIT  10;
-- =============================================================================
