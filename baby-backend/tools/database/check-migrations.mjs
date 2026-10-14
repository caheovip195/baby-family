import { readdir, readFile } from 'node:fs/promises';
import path from 'node:path';
import { fileURLToPath, pathToFileURL } from 'node:url';

const migrations = fileURLToPath(
  new URL('../../prisma/migrations/', import.meta.url),
);
const allowed = new Set([
  'BEGIN',
  'COMMIT',
  'SET',
  'CREATE',
  'ALTER',
  'DROP',
  'COMMENT',
  'GRANT',
  'REVOKE',
  'DO',
]);
// This deliberately strict policy guard complements SQL review; it is not a
// PostgreSQL parser or a sandbox for untrusted migration authors.
function tokens(sql) {
  const result = [];
  const pattern =
    /\s+|--[^\n]*|\/\*|\$(?:[A-Za-z_]\w*)?\$|'(?:''|[^'])*'|"(?:""|[^"])*"|[A-Za-z_]\w*|./gs;
  for (let match; (match = pattern.exec(sql));) {
    const value = match[0];
    if (/^\s|^--/.test(value)) continue;
    if (value === '/*') {
      let depth = 1;
      while (depth && pattern.lastIndex < sql.length) {
        const i = pattern.lastIndex;
        if (sql.startsWith('/*', i)) {
          depth++;
          pattern.lastIndex += 2;
        } else if (sql.startsWith('*/', i)) {
          depth--;
          pattern.lastIndex += 2;
        } else pattern.lastIndex++;
      }
      if (depth) throw new Error('Unterminated SQL comment');
      continue;
    }
    if (value.startsWith('$')) {
      const end = sql.indexOf(value, pattern.lastIndex);
      if (end < 0) throw new Error('Unterminated dollar-quoted SQL');
      result.push({ kind: 'body', value: sql.slice(pattern.lastIndex, end) });
      pattern.lastIndex = end + value.length;
    } else if (value.startsWith("'")) {
      result.push({
        kind: 'string',
        value: value.slice(1, -1).replaceAll("''", "'"),
      });
    } else if (value.startsWith('"')) {
      result.push({ kind: 'identifier', value });
    } else
      result.push({
        kind: /^[A-Za-z_]/.test(value) ? 'word' : 'symbol',
        value: value.toUpperCase(),
      });
  }
  return result;
}

function hasDataMutation(parts) {
  return parts.some((part, index) => {
    if (part.kind !== 'word') return false;
    const next = parts[index + 1]?.value;
    const previous = parts[index - 1]?.value;
    return (
      (['INSERT', 'MERGE'].includes(part.value) && next === 'INTO') ||
      (part.value === 'DELETE' && next === 'FROM') ||
      ['TRUNCATE', 'COPY'].includes(part.value) ||
      (part.value === 'UPDATE' &&
        !['FOR', 'ON', 'GRANT', 'REVOKE', ','].includes(previous) &&
        !['ON', 'OF', 'OR'].includes(next))
    );
  });
}

function validateAnonymousBlock(parts) {
  const body = parts.find((part) => part.kind === 'body');
  const language = parts
    .filter((part) => part !== body)
    .map((part) => part.value)
    .join(' ');
  if (!body || !['DO', 'DO LANGUAGE PLPGSQL'].includes(language))
    throw new Error('DO requires a dollar-quoted structural block');
  const code = tokens(body.value);
  if (
    hasDataMutation(code) ||
    code.some(
      (part) =>
        part.kind === 'word' &&
        ['PERFORM', 'CALL', 'INTO'].includes(part.value),
    )
  )
    throw new Error('DO cannot perform data operations or SELECT INTO');
  let executions = 0;
  for (let i = 0; i < code.length; i++) {
    if (code[i].kind === 'identifier' && code[i + 1]?.value === '(')
      throw new Error(
        'Quoted function calls in anonymous DO require explicit review outside migrations',
      );
    if (code[i].kind !== 'word') continue;
    if (
      ['CREATE', 'ALTER', 'DROP', 'COMMENT', 'GRANT', 'REVOKE', 'DO'].includes(
        code[i].value,
      )
    )
      throw new Error(
        'DO structural commands must use the reviewed EXECUTE format pattern',
      );
    if (code[i].value === 'EXECUTE') {
      if (
        code[i + 1]?.value !== 'FORMAT' ||
        code[i + 2]?.value !== '(' ||
        code[i + 3]?.kind !== 'string'
      )
        throw new Error(
          'DO EXECUTE must use format with a literal structural template',
        );
      const template = code[i + 3].value;
      if (/%(?!%|(?:\d+\$)?[IL])/.test(template))
        throw new Error(
          'DO format allows only quoted %I/%L placeholders, never raw %s',
        );
      const rendered = template
        .replace(/%%/g, '__PERCENT__')
        .replace(/%(?:\d+\$)?I/g, '"migration_identifier"')
        .replace(/%(?:\d+\$)?L/g, "'migration_literal'");
      const statements = splitStatements(rendered);
      const keyword = tokens(rendered)[0]?.value;
      if (
        statements.length !== 1 ||
        !['CREATE', 'ALTER', 'DROP', 'COMMENT', 'GRANT', 'REVOKE'].includes(
          keyword,
        )
      )
        throw new Error(
          'DO format must contain exactly one structural DDL statement',
        );
      validateMigrationSQL(rendered);
      let j = i + 4;
      // Arguments may be local identifiers/record fields or literals, not calls,
      // concatenation, expressions or computed SQL fragments.
      while (code[j]?.value === ',') {
        j++;
        if (!['word', 'identifier', 'string'].includes(code[j]?.kind))
          throw new Error(
            'DO format arguments must be identifiers or literals',
          );
        j++;
        while (code[j]?.value === '.') {
          j++;
          if (!['word', 'identifier'].includes(code[j]?.kind))
            throw new Error('Invalid DO format record field');
          j++;
        }
      }
      if (code[j]?.value !== ')' || code[j + 1]?.value !== ';')
        throw new Error(
          'DO EXECUTE cannot evaluate expressions or additional SQL',
        );
      i = j + 1;
      executions++;
    } else if (
      code[i + 1]?.value === '(' &&
      !['IN', 'ANY', 'ALL', 'USING'].includes(code[i].value)
    ) {
      throw new Error(
        'Function calls in anonymous DO require explicit review outside migrations',
      );
    }
  }
  if (!executions)
    throw new Error('DO is reserved for structural DDL execution');
}

function splitStatements(sql) {
  const statements = [];
  let statement = '';
  let quote = null;
  let dollar = null;
  let blockDepth = 0;
  let lineComment = false;
  for (let i = 0; i < sql.length; i++) {
    const char = sql[i];
    const next = sql[i + 1];
    if (lineComment) {
      if (char === '\n') {
        lineComment = false;
        statement += '\n';
      }
      continue;
    }
    if (blockDepth) {
      if (char === '/' && next === '*') {
        blockDepth++;
        i++;
      } else if (char === '*' && next === '/') {
        blockDepth--;
        i++;
      }
      continue;
    }
    if (dollar) {
      if (sql.startsWith(dollar, i)) {
        statement += dollar;
        i += dollar.length - 1;
        dollar = null;
      } else statement += char;
      continue;
    }
    if (quote) {
      statement += char;
      if (char === quote) {
        if (next === quote) {
          statement += next;
          i++;
        } else quote = null;
      }
      continue;
    }
    if (char === '-' && next === '-') {
      lineComment = true;
      i++;
      continue;
    }
    if (char === '/' && next === '*') {
      blockDepth = 1;
      i++;
      statement += ' ';
      continue;
    }
    if (char === '"' || char === "'") {
      quote = char;
      statement += char;
      continue;
    }
    const tag =
      char === '$' ? sql.slice(i).match(/^\$(?:[A-Za-z_]\w*)?\$/)?.[0] : null;
    if (tag) {
      dollar = tag;
      statement += tag;
      i += tag.length - 1;
      continue;
    }
    if (char === ';') {
      if (statement.trim()) statements.push(statement.trim());
      statement = '';
    } else statement += char;
  }
  if (quote || dollar || blockDepth)
    throw new Error('Unterminated SQL string or comment');
  if (statement.trim()) statements.push(statement.trim());
  return statements;
}

export function validateMigrationSQL(sql) {
  for (const statement of splitStatements(sql)) {
    const parts = tokens(statement);
    const keyword = parts[0]?.value;
    if (!allowed.has(keyword) || hasDataMutation(parts))
      throw new Error(
        'Migration must contain DDL only; move data operations to an explicit seed/task',
      );
    const createsTableData =
      keyword === 'CREATE' &&
      parts.some((part) => part.kind === 'word' && part.value === 'TABLE') &&
      parts.some((part, index) => {
        if (part.kind !== 'word' || part.value !== 'AS') return false;
        let next = index + 1;
        while (parts[next]?.value === '(') next++;
        return ['SELECT', 'WITH', 'TABLE', 'VALUES', 'EXECUTE'].includes(
          parts[next]?.value,
        );
      });
    if (createsTableData)
      throw new Error(
        'CREATE TABLE AS populates data; use a separate explicit task',
      );
    if (
      keyword === 'CREATE' &&
      /^CREATE\s+MATERIALIZED\s+VIEW\b/i.test(statement) &&
      !/\bWITH\s+NO\s+DATA\s*$/i.test(statement)
    )
      throw new Error('Materialized views must be created WITH NO DATA');
    if (keyword === 'DO') validateAnonymousBlock(parts);
  }
}

async function main() {
  let files = 0;
  for (const entry of await readdir(migrations, { withFileTypes: true })) {
    if (!entry.isDirectory()) continue;
    const filename = path.join(migrations, entry.name, 'migration.sql');
    try {
      validateMigrationSQL(await readFile(filename, 'utf8'));
    } catch (error) {
      throw new Error(`${entry.name}: ${error.message}`, { cause: error });
    }
    files++;
  }
  process.stdout.write(
    `PASS: ${files} migrations passed the DDL policy guard; SQL review remains required\n`,
  );
}

if (
  process.argv[1] &&
  pathToFileURL(path.resolve(process.argv[1])).href === import.meta.url
)
  await main();
