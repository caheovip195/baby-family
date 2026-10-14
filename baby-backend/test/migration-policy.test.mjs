import assert from 'node:assert/strict';
import { readFile, readdir } from 'node:fs/promises';
import { test } from 'node:test';
import { validateMigrationSQL } from '../tools/database/check-migrations.mjs';

test('accepts structural SQL and a trigger function with SELECT INTO variables', () => {
  assert.doesNotThrow(() =>
    validateMigrationSQL(`
    BEGIN;
    CREATE TABLE app.example (id uuid PRIMARY KEY);
    ALTER TABLE app.example ADD COLUMN deleted_at timestamptz(3);
    ALTER TABLE app.example ADD CONSTRAINT parent_fk FOREIGN KEY (id) REFERENCES app.other(id) ON UPDATE CASCADE;
    GRANT UPDATE (deleted_at), DELETE ON app.example TO app_writer;
    CREATE FUNCTION app.check_example() RETURNS trigger LANGUAGE plpgsql AS $$
    DECLARE item record;
    BEGIN SELECT * INTO item FROM app.example WHERE id=NEW.id; RETURN NEW; END $$;
    CREATE TRIGGER example_check BEFORE INSERT OR UPDATE ON app.example
      FOR EACH ROW EXECUTE FUNCTION app.check_example();
    COMMIT;
  `),
  );
});

test('accepts catalog loops that execute one quoted structural DDL template', () => {
  assert.doesNotThrow(() =>
    validateMigrationSQL(`
    DO $ddl$
    DECLARE t record;
    BEGIN
      FOR t IN SELECT schemaname, tablename FROM pg_tables LOOP
        EXECUTE format('CREATE TRIGGER audit BEFORE UPDATE ON %I.%I FOR EACH ROW EXECUTE FUNCTION app.audit()', t.schemaname, t.tablename);
      END LOOP;
    END $ddl$;
  `),
  );
});

test('rejects top-level data operations even through CTE, aliases or comments', () => {
  for (const sql of [
    "INSERT /* split */ INTO app.example VALUES ('x');",
    "UPDATE app.example AS e SET id='x';",
    'DELETE FROM app.example;',
    'MERGE INTO app.example USING app.other ON false WHEN MATCHED THEN DELETE;',
    'TRUNCATE app.example;',
    "COPY app.example FROM '/tmp/rows.csv';",
    'WITH x AS (DELETE FROM app.example RETURNING *) SELECT * FROM x;',
    'SELECT * INTO app.copied FROM app.example;',
    'CALL app.backfill();',
    'CREATE TABLE app.copied AS SELECT * FROM app.example;',
    'CREATE TABLE app.copied AS ((SELECT * FROM app.example));',
    'CREATE MATERIALIZED VIEW app.summary AS SELECT * FROM app.example;',
  ])
    assert.throws(() => validateMigrationSQL(sql), undefined, sql);
});

test('rejects data operations and indirect execution in anonymous DO', () => {
  for (const operation of [
    "UPDATE app.example AS e SET id='x';",
    'UPDATE "app"."example" e SET id=NULL;',
    'UPDATE /* alias */ ONLY app.example AS e SET id=NULL;',
    'INSERT /* comment */ INTO app.example DEFAULT VALUES;',
    'DELETE FROM app.example;',
    "COPY app.example FROM '/tmp/rows.csv';",
    'SELECT * INTO copied FROM app.example;',
    'PERFORM app.backfill();',
    'CALL app.backfill();',
    "EXECUTE 'UPDATE app.example SET id=NULL';",
    "EXECUTE 'COPY app.example FROM ''/tmp/rows.csv''';",
    "EXECUTE format('UPDATE %I SET id=NULL', t.tablename);",
    "EXECUTE format('CREATE TABLE %s (id uuid)', t.tablename);",
    "EXECUTE format('CREATE TABLE %I (id uuid)', app.side_effect());",
    "EXECUTE format('CREATE TABLE %I (id uuid); DELETE FROM app.example', t.tablename);",
    "EXECUTE format('CREATE TABLE %I (id uuid)' || suffix, t.tablename);",
    "EXECUTE format('CREATE TABLE %I AS SELECT * FROM app.example', t.tablename);",
    'n := "app"."backfill"(); EXECUTE format(\'CREATE TABLE %I (id int)\', \'x\');',
    "n := \"backfill\"(); EXECUTE format('CREATE TABLE %I (id int)', 'x');",
  ])
    assert.throws(
      () => validateMigrationSQL(`DO $$ BEGIN ${operation} END $$;`),
      undefined,
      operation,
    );
  assert.throws(() =>
    validateMigrationSQL(
      "DO $$ BEGIN EXECUTE format('CREATE TABLE %I (id uuid)', name); END $$ LANGUAGE plpython3u;",
    ),
  );
});

test('handles comments, quoted semicolons and rejects unterminated SQL', () => {
  assert.doesNotThrow(() =>
    validateMigrationSQL(
      "/* outer /* nested */ */ COMMENT ON TABLE app.example IS 'do not INSERT INTO;'; -- trailing",
    ),
  );
  for (const sql of [
    "COMMENT ON TABLE app.example IS 'broken",
    'DO $$ BEGIN END;',
    '/* broken',
  ])
    assert.throws(() => validateMigrationSQL(sql));
});

test('all checked-in migrations pass the same exported policy validator', async () => {
  const root = new URL('../prisma/migrations/', import.meta.url);
  for (const entry of await readdir(root, { withFileTypes: true })) {
    if (entry.isDirectory())
      validateMigrationSQL(
        await readFile(new URL(`${entry.name}/migration.sql`, root), 'utf8'),
      );
  }
});
