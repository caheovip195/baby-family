import { readFile, writeFile } from 'node:fs/promises';
import { fileURLToPath } from 'node:url';

import pg from 'pg';

if (!process.env.DATABASE_URL)
  throw new Error('DATABASE_URL is required; use a verified isolated database');
const pool = new pg.Pool({ connectionString: process.env.DATABASE_URL });
const schema = await readFile(
  new URL('../../prisma/schema.prisma', import.meta.url),
  'utf8',
);
const modelMap = new Map(
  [...schema.matchAll(/^model (\w+) \{([\s\S]*?)^\}/gm)].map(
    ([, model, body]) => [
      `${body.match(/@@schema\("([^"]+)"\)/)?.[1] ?? 'public'}.${body.match(/@@map\("([^"]+)"\)/)?.[1] ?? model}`,
      model,
    ],
  ),
);
const filter =
  "n.nspname IN ('app','us','billing','ops') OR (n.nspname='public' AND c.relname='notes')";
const escape = (value) =>
  String(value ?? '')
    .replaceAll('|', '\\|')
    .replaceAll('\n', ' ');
try {
  const { rows: tables } = await pool.query(
    `SELECT c.oid, n.nspname AS schema, c.relname AS name FROM pg_class c JOIN pg_namespace n ON n.oid=c.relnamespace WHERE c.relkind='r' AND (${filter}) ORDER BY n.nspname,c.relname`,
  );
  if (tables.length !== modelMap.size)
    throw new Error(
      `DB tables ${tables.length} do not match Prisma models ${modelMap.size}`,
    );
  const lines = [
    '# Data dictionary — Baby Family',
    '',
    'Sinh từ metadata PostgreSQL cách ly sau khi replay migration backend, đối chiếu Prisma schema. Không đọc dữ liệu nghiệp vụ. Ngày kiểm chứng: 2026-10-14.',
    '',
    `[Prisma schema](../../baby-backend/prisma/schema.prisma) · [Migration](../../baby-backend/prisma/migrations/20261013150000_family_domain/migration.sql) · [Thiết kế/phase](README.md) · [Kết quả kiểm chứng](verification.md).`,
    '',
    `${tables.length} bảng dự án ↔ ${modelMap.size} Prisma models. Bảng hệ thống/extension và _prisma_migrations không thuộc danh mục ứng dụng.`,
    '',
    'Mọi bảng có created_at/updated_at/deleted_at; SQL constraints không thay thế authorization ở service. Model/repository tương ứng nằm trong backend src/models, src/interfaces/repositories, src/repositories và DI registry. Không suy ra runtime feature đã hoàn chỉnh chỉ từ bảng hoặc persistence class.',
    '',
    '## Danh mục',
    '',
    '| Bảng | Prisma model | Cột | Constraints | Indexes |',
    '| --- | --- | ---: | ---: | ---: |',
  ];
  const details = [];
  const code = (value) =>
    String.fromCharCode(96) + escape(value) + String.fromCharCode(96);
  for (const table of tables) {
    const full = `${table.schema}.${table.name}`;
    const model = modelMap.get(full);
    if (!model) throw new Error(`No Prisma mapping for ${full}`);
    const { rows: columns } = await pool.query(
      `SELECT a.attname AS name, format_type(a.atttypid,a.atttypmod) AS type, a.attnotnull AS required, pg_get_expr(d.adbin,d.adrelid) AS default FROM pg_attribute a LEFT JOIN pg_attrdef d ON d.adrelid=a.attrelid AND d.adnum=a.attnum WHERE a.attrelid=$1 AND a.attnum>0 AND NOT a.attisdropped ORDER BY a.attnum`,
      [table.oid],
    );
    const { rows: constraints } = await pool.query(
      'SELECT conname AS name, pg_get_constraintdef(oid) AS definition FROM pg_constraint WHERE conrelid=$1 ORDER BY contype,conname',
      [table.oid],
    );
    const { rows: indexes } = await pool.query(
      'SELECT indexname AS name,indexdef AS definition FROM pg_indexes WHERE schemaname=$1 AND tablename=$2 ORDER BY indexname',
      [table.schema, table.name],
    );
    const { rows: triggers } = await pool.query(
      'SELECT tgname AS name,pg_get_triggerdef(oid) AS definition FROM pg_trigger WHERE tgrelid=$1 AND NOT tgisinternal ORDER BY tgname',
      [table.oid],
    );
    lines.push(
      `| ${full} | ${model} | ${columns.length} | ${constraints.length} | ${indexes.length} |`,
    );
    details.push(
      '',
      `## ${full} — ${model}`,
      '',
      '| Cột | PostgreSQL type | NOT NULL | Default |',
      '| --- | --- | --- | --- |',
      ...columns.map(
        (column) =>
          `| ${column.name} | ${escape(column.type)} | ${column.required ? 'Có' : 'Không'} | ${escape(column.default) || '—'} |`,
      ),
      '',
      'Constraints:',
      '',
      ...constraints.map(
        (item) => '- ' + code(item.name) + ': ' + code(item.definition),
      ),
      '',
      'Indexes:',
      '',
      ...indexes.map(
        (item) => '- ' + code(item.name) + ': ' + code(item.definition),
      ),
      '',
      'Triggers:',
      '',
      ...triggers.map(
        (item) => '- ' + code(item.name) + ': ' + code(item.definition),
      ),
    );
  }
  const destination = fileURLToPath(
    new URL('../../../docs/database/data-dictionary.md', import.meta.url),
  );
  await writeFile(destination, [...lines, ...details, ''].join('\n'));
  process.stdout.write(
    `Exported ${tables.length} tables and their columns/constraints/indexes/triggers\n`,
  );
} finally {
  await pool.end();
}
