-- =============================================================================
-- GemWorkers — Money practice tests (run BEFORE and AFTER every money change)
-- =============================================================================
-- Run:  node gemworkers_core/sql/tests/run_money_tests.js   (from gemworkers_app)
--
-- Plays real flows on the LIVE database with test stones and the test buyer,
-- checks every amount, then UNDOES EVERYTHING: the block always ends with an
-- error ("TESTRESULT …"), so the whole transaction rolls back — no orders,
-- offers, invoices, refunds, payouts or emails are kept (pg_net webhook calls
-- are queued in the same transaction and roll back too).
--
-- Covered: Buy now order totals + 12% service fee + €3 minimum, sold stone,
-- invoice numbering + immutability, offer rules (cents, counter limits),
-- counter-offer → order amounts, partial + full refund (credit notes, seller
-- charged once), payout = sales − open charges, earnings, vacation mode
-- blocks offers and purchases, VAT rules (NL→EU OSS, NL→NL, TH/PK buyer pays,
-- UK minimum).
-- =============================================================================

BEGIN;

DO $test$
DECLARE
  c_seller constant uuid := '8c1219af-9ca8-4647-ae50-b0716a2ea525';  -- Testseller (TH, 12%)
  c_buyer  constant uuid := 'f79ba266-0fe6-44f6-aefb-f00ffaf3dd70';  -- Zakaria's test buyer
  v_owner  uuid;
  s1 uuid; s2 uuid; s3 uuid;           -- test stones
  o1 uuid; o2 uuid; o3 uuid;           -- orders
  off uuid; r uuid; inv uuid; po uuid;
  v_num_before int; v_num_after int;
  v_open numeric; v_amount numeric;
  x record; j json; t text;
  pass int := 0;
  fails text[] := '{}';
BEGIN
  SELECT id INTO v_owner FROM user_profiles WHERE role = 'owner' LIMIT 1;
  -- Rate as the tests expect (rolled back anyway).
  UPDATE sellers SET commission_rate = 0.12, on_vacation = false WHERE id = c_seller;

  -- Fixtures: three listed test stones of the Testseller.
  INSERT INTO inventory_items (sku, title, seller_id, selling_price, shipping_cost, is_listed, status, sale_method, product_type, quantity)
  VALUES ('TEST-MT-1', 'Practice test stone 1', c_seller, 100, 10, true, 'available', 'buy_now', 'loose_stone', 1) RETURNING id INTO s1;
  INSERT INTO inventory_items (sku, title, seller_id, selling_price, shipping_cost, is_listed, status, sale_method, product_type, quantity)
  VALUES ('TEST-MT-2', 'Practice test stone 2', c_seller, 100, 10, true, 'available', 'both', 'loose_stone', 1) RETURNING id INTO s2;
  INSERT INTO inventory_items (sku, title, seller_id, selling_price, shipping_cost, is_listed, status, sale_method, product_type, quantity)
  VALUES ('TEST-MT-3', 'Practice test stone 3', c_seller, 20, 0, true, 'available', 'buy_now', 'loose_stone', 1) RETURNING id INTO s3;

  -- ── 1. Buy now: totals, 12% service fee, sold stone ───────────────────────
  PERFORM set_config('request.jwt.claims', json_build_object('sub', c_buyer, 'role', 'authenticated')::text, true);
  o1 := create_platform_order(s1);
  PERFORM apply_order_tax(ARRAY[o1], 'US');
  PERFORM confirm_order_paid(o1);
  SELECT * INTO x FROM orders WHERE id = o1;
  IF x.order_total = 110 AND x.tax_amount = 0 THEN pass := pass + 1; ELSE fails := fails || format('1a order total %s + VAT %s, want 110 + 0', x.order_total, x.tax_amount); END IF;
  IF x.commission_amount = 12 AND x.seller_payout = 98 THEN pass := pass + 1; ELSE fails := fails || format('1b fee %s / payout %s, want 12 / 98', x.commission_amount, x.seller_payout); END IF;
  IF x.status = 'confirmed' AND x.paid_at IS NOT NULL AND x.payout_kind = 'commission' THEN pass := pass + 1; ELSE fails := fails || format('1c status %s kind %s paid_at %s', x.status, x.payout_kind, x.paid_at); END IF;
  IF (SELECT status = 'sold' AND NOT is_listed FROM inventory_items WHERE id = s1) THEN pass := pass + 1; ELSE fails := fails || '1d stone not sold/unlisted after payment'; END IF;

  -- ── 2. €3 minimum fee ─────────────────────────────────────────────────────
  o3 := create_platform_order(s3);
  PERFORM confirm_order_paid(o3);
  SELECT * INTO x FROM orders WHERE id = o3;
  IF x.commission_amount = 3 AND x.seller_payout = 17 THEN pass := pass + 1; ELSE fails := fails || format('2 fee %s / payout %s on €20, want 3 / 17', x.commission_amount, x.seller_payout); END IF;

  -- ── 3. Invoices: next number, totals, immutable ───────────────────────────
  SELECT coalesce(max(split_part(number, '-', 3)::int), 0) INTO v_num_before FROM invoices
  WHERE number LIKE 'GW-' || to_char(now() AT TIME ZONE 'Europe/Amsterdam', 'YYYY') || '-%';
  inv := issue_invoice(o1);
  SELECT split_part(number, '-', 3)::int, total INTO v_num_after, v_amount FROM invoices WHERE id = inv;
  IF v_num_after = v_num_before + 1 AND v_amount = 110 THEN pass := pass + 1; ELSE fails := fails || format('3a invoice no. %s after %s, total %s (want +1, 110)', v_num_after, v_num_before, v_amount); END IF;
  IF issue_invoice(o1) = inv THEN pass := pass + 1; ELSE fails := fails || '3b second issue_invoice made a new invoice'; END IF;
  BEGIN
    UPDATE invoices SET total = 1 WHERE id = inv;
    fails := fails || '3c invoice could be changed';
  EXCEPTION WHEN others THEN pass := pass + 1;
  END;

  -- ── 4. Offer rules ────────────────────────────────────────────────────────
  BEGIN
    PERFORM submit_storefront_offer(s2, 70.555, 'rh');
    fails := fails || '4a offer with 3 decimals accepted';
  EXCEPTION WHEN others THEN pass := pass + 1;
  END;
  off := submit_storefront_offer(s2, 70, 'rh');
  PERFORM set_config('request.jwt.claims', json_build_object('sub', v_owner, 'role', 'authenticated')::text, true);
  BEGIN
    PERFORM counter_offer(off, 70);
    fails := fails || '4b counter equal to the offer accepted';
  EXCEPTION WHEN others THEN pass := pass + 1;
  END;
  BEGIN
    PERFORM counter_offer(off, 100);
    fails := fails || '4c counter at the listed price accepted';
  EXCEPTION WHEN others THEN pass := pass + 1;
  END;
  PERFORM counter_offer(off, 85);
  IF (SELECT count(*) FROM messages WHERE offer_id = off AND body LIKE '%€85%') = 1 THEN pass := pass + 1; ELSE fails := fails || '4d no "€85" counter card in Messages'; END IF;

  -- ── 5. Accepted counter → order amounts ───────────────────────────────────
  PERFORM set_config('request.jwt.claims', json_build_object('sub', c_buyer, 'role', 'authenticated')::text, true);
  PERFORM respond_to_counter(off, 'accepted');
  SELECT id INTO o2 FROM orders WHERE offer_id = off;
  PERFORM confirm_order_paid(o2);
  SELECT * INTO x FROM orders WHERE id = o2;
  IF x.order_total = 95 AND x.commission_amount = 10.20 AND x.seller_payout = 84.80 THEN pass := pass + 1;
  ELSE fails := fails || format('5 counter order total %s fee %s payout %s, want 95 / 10.20 / 84.80', x.order_total, x.commission_amount, x.seller_payout); END IF;

  -- ── 6. Refunds: partial then full, credit notes, seller charged once ──────
  PERFORM set_config('request.jwt.claims', json_build_object('sub', v_owner, 'role', 'authenticated')::text, true);
  r := record_order_refund(o1, 20, 'Practice partial', 'kept', 're_practice_1');
  IF (SELECT coalesce(sum(amount), 0) FROM owner_charges WHERE order_id = o1) = 20 THEN pass := pass + 1; ELSE fails := fails || '6a partial €20: seller not charged €20'; END IF;
  r := record_order_refund(o1, 90, 'Practice rest', 'other', 're_practice_2');
  SELECT * INTO x FROM orders WHERE id = o1;
  IF x.status = 'refunded' THEN pass := pass + 1; ELSE fails := fails || format('6b status after full refund %s', x.status); END IF;
  IF (SELECT coalesce(sum(amount), 0) FROM owner_charges WHERE order_id = o1) = 0 THEN pass := pass + 1; ELSE fails := fails || format('6c unpaid seller still charged %s in total', (SELECT sum(amount) FROM owner_charges WHERE order_id = o1)); END IF;
  IF (SELECT count(*) = 2 AND sum(total) = -110 FROM invoices WHERE order_id = o1 AND kind = 'credit_note') THEN pass := pass + 1; ELSE fails := fails || '6d credit notes do not add up to −€110'; END IF;
  BEGIN
    PERFORM record_order_refund(o1, 1, 'Too much', 'other', 're_practice_3');
    fails := fails || '6e refund beyond what was paid accepted';
  EXCEPTION WHEN others THEN pass := pass + 1;
  END;

  -- ── 7. Payout = sales − open charges ──────────────────────────────────────
  UPDATE orders SET shipped_at = now() - interval '90 days', received_at = now() - interval '80 days', status = 'received' WHERE id = o2;
  SELECT coalesce(sum(amount), 0) INTO v_open FROM payout_open_charges WHERE payee_seller_id = c_seller;
  po := create_payout(c_seller, NULL, ARRAY[o2], 'wise', 'practice', '');
  SELECT amount INTO v_amount FROM payouts WHERE id = po;
  IF v_amount = 84.80 - v_open THEN pass := pass + 1; ELSE fails := fails || format('7a payout %s, want 84.80 − open charges %s', v_amount, v_open); END IF;
  IF (SELECT payout_status = 'paid' FROM orders WHERE id = o2) THEN pass := pass + 1; ELSE fails := fails || '7b order not marked paid out'; END IF;

  -- ── 8. Earnings ───────────────────────────────────────────────────────────
  j := earnings_report((now() AT TIME ZONE 'Europe/Amsterdam')::date, (now() AT TIME ZONE 'Europe/Amsterdam')::date + 1);
  SELECT (e->>'earned')::numeric INTO v_amount FROM json_array_elements(j->'orders') e WHERE (e->>'order_id')::uuid = o2;
  IF v_amount = 10.20 THEN pass := pass + 1; ELSE fails := fails || format('8 earnings for the counter order %s, want 10.20', v_amount); END IF;

  -- ── 9. Vacation mode blocks offers and purchases ──────────────────────────
  UPDATE inventory_items SET status = 'available', is_listed = true WHERE id = s3;
  UPDATE sellers SET on_vacation = true WHERE id = c_seller;
  PERFORM set_config('request.jwt.claims', json_build_object('sub', c_buyer, 'role', 'authenticated')::text, true);
  BEGIN
    PERFORM create_platform_order(s3);
    fails := fails || '9a purchase from a seller on vacation accepted';
  EXCEPTION WHEN others THEN pass := pass + 1;
  END;
  BEGIN
    UPDATE inventory_items SET sale_method = 'both' WHERE id = s3;
    PERFORM submit_storefront_offer(s3, 15, 'rh');
    fails := fails || '9b offer to a seller on vacation accepted';
  EXCEPTION WHEN others THEN pass := pass + 1;
  END;
  UPDATE sellers SET on_vacation = false WHERE id = c_seller;

  -- ── 10. VAT rules ─────────────────────────────────────────────────────────
  FOR x IN SELECT * FROM (VALUES
      ('NL', 'DE', 'oss',        19::numeric, NULL::numeric),
      ('NL', 'NL', 'domestic',   21,          NULL),
      ('TH', 'DE', 'buyer_pays', 0,           NULL),
      ('PK', 'US', 'buyer_pays', 0,           NULL),
      ('NL', 'GB', 'buyer_pays', 0,           160)) AS v(o, d, scheme, vat, min_eur)
  LOOP
    SELECT scheme || '/' || tax_amount || '/' || coalesce(min_order_eur::text, '-') INTO t FROM _tax_calc(x.o, x.d, 'loose_stone', 100, NULL);
    IF t = x.scheme || '/' || x.vat || '/' || coalesce(x.min_eur::text, '-')
       OR t = x.scheme || '/' || x.vat || '.00/' || coalesce(x.min_eur::text, '-')
       OR t = x.scheme || '/' || x.vat || '/' || coalesce(x.min_eur::text || '.00', '-') THEN pass := pass + 1;
    ELSE fails := fails || format('10 VAT %s→%s on €100: %s, want %s/%s/%s', x.o, x.d, t, x.scheme, x.vat, coalesce(x.min_eur::text, '-')); END IF;
  END LOOP;

  RAISE EXCEPTION 'TESTRESULT passed=% failed=% %', pass, cardinality(fails),
    CASE WHEN cardinality(fails) = 0 THEN '' ELSE ':: ' || array_to_string(fails, ' || ') END;
END
$test$;

ROLLBACK;
