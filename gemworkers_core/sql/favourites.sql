-- =============================================================================
-- GemWorkers — Favourites (buyers save stones)
-- =============================================================================
-- NOT YET APPLIED
--
-- One row per (buyer, stone). Buyers see, add and remove only their own.
-- The owner can read all (how many people saved a stone = demand signal).
-- Rows go when the login is deleted or the stone is deleted (cascade).
-- =============================================================================

BEGIN;

CREATE TABLE IF NOT EXISTS public.favourites (
  buyer_id          uuid NOT NULL DEFAULT auth.uid() REFERENCES auth.users(id) ON DELETE CASCADE,
  inventory_item_id uuid NOT NULL REFERENCES public.inventory_items(id) ON DELETE CASCADE,
  created_at        timestamptz NOT NULL DEFAULT now(),
  PRIMARY KEY (buyer_id, inventory_item_id)
);
CREATE INDEX IF NOT EXISTS favourites_item_idx ON public.favourites (inventory_item_id);

ALTER TABLE public.favourites ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS favourites_own_select ON public.favourites;
CREATE POLICY favourites_own_select ON public.favourites
  FOR SELECT TO authenticated USING (buyer_id = auth.uid() OR public.is_owner());

DROP POLICY IF EXISTS favourites_own_insert ON public.favourites;
CREATE POLICY favourites_own_insert ON public.favourites
  FOR INSERT TO authenticated WITH CHECK (buyer_id = auth.uid());

DROP POLICY IF EXISTS favourites_own_delete ON public.favourites;
CREATE POLICY favourites_own_delete ON public.favourites
  FOR DELETE TO authenticated USING (buyer_id = auth.uid());

REVOKE ALL ON public.favourites FROM anon;
GRANT SELECT, INSERT, DELETE ON public.favourites TO authenticated;

COMMIT;
