-- =============================================================================
-- GemWorkers — Error log + daily health report
-- =============================================================================
-- Applied to live DB 2026-10-28
--
-- Zakaria 2026-10-28: an email when something breaks at night (emails not
-- sent, webhooks failing, scheduled jobs failing) — not only money.
--   • app_errors: errors written by the store (instrumentation.ts: every
--     server console.error + uncaught request errors) and failed webhook
--     calls from the database (pg_net), copied hourly because pg_net keeps
--     its responses only a few hours. Owner can read; only the server writes.
--     Kept 90 days.
--   • health_report(hours): failed pg_cron runs + app_errors of the last
--     hours, grouped. Called by the nightly check (server only), which
--     emails the owner only when something is listed.
-- =============================================================================

BEGIN;

CREATE TABLE IF NOT EXISTS public.app_errors (
  id      bigserial PRIMARY KEY,
  at      timestamptz NOT NULL DEFAULT now(),
  source  text NOT NULL CHECK (length(source) <= 40),
  message text NOT NULL CHECK (length(message) <= 2000),
  ref     text UNIQUE                                   -- e.g. 'net:123' (no duplicates)
);
CREATE INDEX IF NOT EXISTS app_errors_at ON public.app_errors (at);
ALTER TABLE public.app_errors ENABLE ROW LEVEL SECURITY;
REVOKE ALL ON public.app_errors FROM PUBLIC, anon, authenticated;
GRANT SELECT ON public.app_errors TO authenticated;
GRANT SELECT, INSERT ON public.app_errors TO service_role;
GRANT USAGE ON SEQUENCE public.app_errors_id_seq TO service_role;
DROP POLICY IF EXISTS app_errors_owner_read ON public.app_errors;
CREATE POLICY app_errors_owner_read ON public.app_errors FOR SELECT TO authenticated USING (public.is_owner());

-- Hourly: failed webhook calls (pg_net) → app_errors; old entries removed.
CREATE OR REPLACE FUNCTION public._collect_net_errors()
RETURNS void
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public, pg_temp
AS $$
BEGIN
  INSERT INTO public.app_errors (at, source, message, ref)
  SELECT r.created, 'webhook',
         left(coalesce('HTTP ' || r.status_code, '') ||
              CASE WHEN r.error_msg IS NOT NULL THEN ' ' || r.error_msg ELSE '' END ||
              coalesce(' — ' || left(r.content, 300), ''), 2000),
         'net:' || r.id
  FROM   net._http_response r
  WHERE  r.created > now() - interval '3 hours'
    AND  (r.status_code >= 400 OR r.error_msg IS NOT NULL OR r.timed_out)
  ON CONFLICT (ref) DO NOTHING;

  DELETE FROM public.app_errors WHERE at < now() - interval '90 days';
END;
$$;
REVOKE ALL ON FUNCTION public._collect_net_errors() FROM PUBLIC, anon, authenticated;

SELECT cron.unschedule(jobid) FROM cron.job WHERE jobname = 'gemworkers_collect_errors';
SELECT cron.schedule('gemworkers_collect_errors', '17 * * * *', $c$SELECT public._collect_net_errors()$c$);

-- Nightly check: what went wrong in the last p_hours.
CREATE OR REPLACE FUNCTION public.health_report(p_hours int DEFAULT 24)
RETURNS json
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public, pg_temp
AS $$
DECLARE
  v json;
BEGIN
  PERFORM public._collect_net_errors();
  SELECT json_build_object(
    'cron_failures', (
      SELECT coalesce(json_agg(json_build_object('job', j.jobname, 'runs', x.n, 'last', x.last_at, 'message', x.msg) ORDER BY x.n DESC), '[]')
      FROM (
        SELECT d.jobid, count(*) AS n, max(d.start_time) AS last_at,
               left((array_agg(d.return_message ORDER BY d.start_time DESC))[1], 300) AS msg
        FROM   cron.job_run_details d
        WHERE  d.status NOT IN ('succeeded', 'running', 'starting')
          AND  d.start_time > now() - make_interval(hours => p_hours)
        GROUP  BY d.jobid
      ) x LEFT JOIN cron.job j ON j.jobid = x.jobid),
    'errors', (
      SELECT coalesce(json_agg(json_build_object('source', source, 'message', m, 'count', n, 'last', last_at) ORDER BY n DESC), '[]')
      FROM (
        SELECT source, left(message, 200) AS m, count(*) AS n, max(at) AS last_at
        FROM   public.app_errors
        WHERE  at > now() - make_interval(hours => p_hours)
        GROUP  BY source, left(message, 200)
        ORDER  BY count(*) DESC
        LIMIT  20
      ) e)
  ) INTO v;
  RETURN v;
END;
$$;
REVOKE ALL ON FUNCTION public.health_report(int) FROM PUBLIC, anon, authenticated;
GRANT EXECUTE ON FUNCTION public.health_report(int) TO service_role;

COMMIT;
