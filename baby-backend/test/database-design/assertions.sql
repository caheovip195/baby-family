-- Contract assertions for every project-owned table. Disposable DB only.
DO $check$
DECLARE missing text;
BEGIN
  SELECT string_agg(format('%I.%I', t.table_schema, t.table_name), ', ')
    INTO missing
  FROM information_schema.tables t
  WHERE t.table_type = 'BASE TABLE' AND t.table_schema IN ('app', 'us', 'billing', 'ops')
    AND EXISTS (
      SELECT 1 FROM (VALUES ('created_at'), ('updated_at'), ('deleted_at')) required(name)
      WHERE NOT EXISTS (
        SELECT 1 FROM information_schema.columns c
        WHERE c.table_schema = t.table_schema AND c.table_name = t.table_name
          AND c.column_name = required.name AND c.data_type = 'timestamp with time zone'
          AND c.datetime_precision = 3
          AND c.is_nullable = CASE WHEN required.name = 'deleted_at' THEN 'YES' ELSE 'NO' END
          AND (required.name = 'deleted_at' OR c.column_default IS NOT NULL)
      )
    );
  IF missing IS NOT NULL THEN RAISE EXCEPTION 'Audit-column contract failed: %', missing; END IF;

  SELECT string_agg(format('%I.%I', n.nspname, c.relname), ', ')
    INTO missing
  FROM pg_class c JOIN pg_namespace n ON n.oid = c.relnamespace
  WHERE c.relkind = 'r' AND n.nspname IN ('app', 'us', 'billing', 'ops')
    AND NOT EXISTS (SELECT 1 FROM pg_constraint k WHERE k.conrelid = c.oid AND k.contype = 'p');
  IF missing IS NOT NULL THEN RAISE EXCEPTION 'Missing primary key: %', missing; END IF;

  SELECT string_agg(format('%I.%I', n.nspname, c.relname), ', ')
    INTO missing
  FROM pg_class c JOIN pg_namespace n ON n.oid = c.relnamespace
  WHERE c.relkind = 'r' AND n.nspname IN ('app', 'us', 'billing', 'ops')
    AND NOT EXISTS (
      SELECT 1 FROM pg_trigger t JOIN pg_proc p ON p.oid = t.tgfoid
      WHERE t.tgrelid = c.oid AND NOT t.tgisinternal AND t.tgenabled <> 'D'
        AND (t.tgtype::int & 1) = 1 AND (t.tgtype::int & 2) = 2 AND (t.tgtype::int & 16) = 16
        AND p.prosrc LIKE '%updated_at%'
    );
  IF missing IS NOT NULL THEN RAISE EXCEPTION 'Missing row BEFORE UPDATE audit trigger: %', missing; END IF;
  RAISE NOTICE 'PASS: audit column types/nullability/defaults, primary keys and update triggers on all app tables';
END
$check$;

DO $note$
BEGIN
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema='public' AND table_name='notes' AND column_name='deleted_at' AND data_type='timestamp with time zone' AND datetime_precision=3 AND is_nullable='YES') THEN
    RAISE EXCEPTION 'Existing Note must receive deleted_at by forward migration';
  END IF;
  IF NOT EXISTS (SELECT 1 FROM pg_trigger WHERE tgrelid='public.notes'::regclass AND tgname='trg_audit_update') THEN
    RAISE EXCEPTION 'Existing Note must have DB audit trigger';
  END IF;
  RAISE NOTICE 'PASS: public Note preserved with forward audit migration';
END
$note$;

SELECT table_schema, count(*) AS tables
FROM information_schema.tables
WHERE table_type = 'BASE TABLE' AND table_schema IN ('app', 'us', 'billing', 'ops')
GROUP BY table_schema ORDER BY table_schema;

-- Domain-specific rejection/acceptance scenarios follow below as the candidate is finalized.
