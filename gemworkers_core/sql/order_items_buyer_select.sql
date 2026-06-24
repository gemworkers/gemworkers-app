-- Lets a buyer read order_items belonging to their OWN orders.
-- Mirrors orders_buyer_select (on orders) and order_items_seller_select (on order_items).
-- SELECT only — buyers have no INSERT/UPDATE/DELETE on order_items;
-- those operations go through SECURITY DEFINER functions.
-- Does NOT touch the existing order_items_owner or order_items_seller_select policies.

DROP POLICY IF EXISTS order_items_buyer_select ON public.order_items;

CREATE POLICY order_items_buyer_select
  ON public.order_items FOR SELECT
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM public.orders
      WHERE orders.id = order_items.order_id
        AND orders.buyer_id = auth.uid()
    )
  );
