-- =============================================================================
-- GemWorkers — Counter-offer emails: claim stamp (plan step 9, SQL part)
-- =============================================================================
-- Applied to live DB 2026-10-22
--
-- 1. storefront_offers.counter_notified_at — one-time stamp for the
--    "counter-offer sent" email.
-- 2. claim_offer_notification — LIVE definition copied exactly; changed:
--      + kind 'countered' (stamps counter_notified_at)
--    The other counter events reuse existing stamps, which a countered offer
--    has never used: countered→accepted/declined → 'response',
--    countered→expired → 'expired'.
--
-- Then offer-notify is redeployed with the counter emails.
-- =============================================================================

BEGIN;

ALTER TABLE public.storefront_offers
  ADD COLUMN IF NOT EXISTS counter_notified_at timestamptz;

CREATE OR REPLACE FUNCTION public.claim_offer_notification(p_offer_id uuid, p_kind text)
 RETURNS boolean
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO 'public', 'pg_temp'
AS $function$
DECLARE
  v_claimed boolean;
BEGIN
  IF p_kind IS NULL OR p_kind NOT IN ('new_offer', 'countered', 'response', 'expired') THEN
    RAISE EXCEPTION 'claim_offer_notification: invalid kind %', p_kind;
  END IF;

  UPDATE public.storefront_offers o
  SET    new_offer_notified_at = CASE WHEN p_kind = 'new_offer' THEN now() ELSE o.new_offer_notified_at END,
         counter_notified_at   = CASE WHEN p_kind = 'countered' THEN now() ELSE o.counter_notified_at   END,
         response_notified_at  = CASE WHEN p_kind = 'response'  THEN now() ELSE o.response_notified_at  END,
         expired_notified_at   = CASE WHEN p_kind = 'expired'   THEN now() ELSE o.expired_notified_at   END
  WHERE  o.id = p_offer_id
    AND  CASE p_kind
           WHEN 'new_offer' THEN o.new_offer_notified_at IS NULL
           WHEN 'countered' THEN o.counter_notified_at   IS NULL
           WHEN 'response'  THEN o.response_notified_at  IS NULL
           WHEN 'expired'   THEN o.expired_notified_at   IS NULL
         END
  RETURNING true INTO v_claimed;

  RETURN COALESCE(v_claimed, false);
END;
$function$
;

COMMIT;
