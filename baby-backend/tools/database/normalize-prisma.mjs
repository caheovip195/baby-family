import { readFile, writeFile } from 'node:fs/promises';
import { createRequire } from 'node:module';

// Normalize introspection of backend migrations without changing DB mappings.
// Usage: node normalize-prisma.mjs /tmp/introspected.prisma schema.prisma
const require = createRequire(new URL('../../package.json', import.meta.url));
const pluralize = require('pluralize');
const [inputPath, outputPath] = process.argv.slice(2);
if (!inputPath || !outputPath)
  throw new Error('Expected input and output Prisma paths');
const source = await readFile(inputPath, 'utf8');
const pascal = (value) =>
  value
    .split('_')
    .filter(Boolean)
    .map((part) => part[0].toUpperCase() + part.slice(1))
    .join('');
const camel = (value) => {
  const result = pascal(value);
  return result[0].toLowerCase() + result.slice(1);
};
// Inflect the final snake_case word, preserving uncountables such as series.
const singular = (value) => {
  const parts = value.split('_');
  parts[parts.length - 1] = pluralize.singular(parts[parts.length - 1]);
  return parts.join('_');
};
const blocks = [
  ...source.matchAll(/^(model|enum)\s+(\w+)\s*\{([\s\S]*?)^\}/gm),
];
const typeNames = new Map();
const usedNames = new Set();
for (const [, kind, oldName, body] of blocks) {
  let name = pascal(kind === 'model' ? singular(oldName) : oldName);
  if (usedNames.has(name)) {
    const schema = body.match(/@@schema\("([^"]+)"\)/)?.[1];
    if (!schema) throw new Error(`Cannot disambiguate ${oldName}`);
    name = pascal(schema) + name;
  }
  if (usedNames.has(name)) throw new Error(`Duplicate Prisma type ${name}`);
  usedNames.add(name);
  typeNames.set(oldName, name);
}
// Only replace bare identifiers in attribute expressions; quoted SQL/constraint names stay exact.
const identifiers = (text) =>
  text.replace(/"(?:[^"\\]|\\.)*"|[A-Za-z_]\w*/g, (token) =>
    token.startsWith('"') || /^[A-Z][A-Z0-9_]*$/.test(token)
      ? token
      : token.includes('_')
        ? camel(token)
        : token,
  );
let output = source.replace(
  /^(model|enum)\s+(\w+)\s*\{([\s\S]*?)^\}/gm,
  (_block, kind, oldName, body) => {
    const lines = body.split('\n');
    const rendered = lines.map((line) => {
      if (line.trimStart().startsWith('@@')) return identifiers(line);
      if (kind === 'enum') return line;
      const field = line.match(/^(\s+)(\w+)\s+([A-Za-z_]\w*)(\[\]|\?)?(.*)$/);
      if (!field) return line;
      const [, indent, oldField, oldType, suffix = '', originalAttributes] =
        field;
      const relation =
        typeNames.has(oldType) &&
        blocks.some(
          ([, blockKind, blockName]) =>
            blockKind === 'model' && blockName === oldType,
        );
      let newField = camel(oldField);
      if (relation && oldField === oldType && suffix !== '[]')
        newField = camel(singular(oldField));
      let attributes = identifiers(originalAttributes);
      if (!relation && newField !== oldField && !/@map\(/.test(attributes))
        attributes += ` @map("${oldField}")`;
      if (oldField === 'updated_at' && !/@updatedAt\b/.test(attributes))
        attributes += ' @updatedAt';
      return `${indent}${newField} ${typeNames.get(oldType) ?? oldType}${suffix}${attributes}`;
    });
    if (!body.includes('@@map(')) rendered.push(`  @@map("${oldName}")`);
    return `${kind} ${typeNames.get(oldName)} {${rendered.join('\n')}\n}`;
  },
);
// Introspection can infer one-to-one from a unique subset or partial index.
// Prisma requires an exact unconditional unique tuple on the FK side; represent
// such inverse navigations as arrays without adding redundant physical indexes.
const models = new Map(
  [...output.matchAll(/^model (\w+) \{([\s\S]*?)^\}/gm)].map((m) => [
    m[1],
    m[2],
  ]),
);
for (const [modelName, body] of [...models]) {
  const uniqueKeys = [];
  for (const line of body.split('\n')) {
    const scalar = line.match(/^\s+(\w+)\s+\S+.*@(id|unique)\b/);
    if (scalar && !line.includes('where:')) uniqueKeys.push([scalar[1]]);
    const compound = line.match(/@@(?:id|unique)\(\[([^\]]+)\]/);
    if (compound && !line.includes('where:'))
      uniqueKeys.push(compound[1].split(',').map((v) => v.trim()));
  }
  for (const line of body.split('\n')) {
    const relation = line.match(/^\s+\w+\s+(\w+)\??\s+.*@relation\((.*)$/);
    const fields = line
      .match(/fields:\s*\[([^\]]+)\]/)?.[1]
      .split(',')
      .map((v) => v.trim());
    if (!relation || !fields || !models.has(relation[1])) continue;
    if (
      uniqueKeys.some(
        (key) =>
          key.length === fields.length && key.every((v) => fields.includes(v)),
      )
    )
      continue;
    const relationName = relation[2].match(/^"([^"]+)"/)?.[1];
    const targetName = relation[1];
    const target = models.get(targetName);
    const inverseLines = target.split('\n').filter((item) => {
      const candidate = item.match(/^\s+\w+\s+(\w+)(\?|\[\])?(.*)$/);
      if (
        !candidate ||
        candidate[1] !== modelName ||
        candidate[3].includes('fields:')
      )
        return false;
      const inverseName = candidate[3].match(/@relation\("([^"]+)"/)?.[1];
      return inverseName === relationName;
    });
    if (inverseLines.length !== 1)
      throw new Error(`Cannot resolve inverse ${modelName} -> ${targetName}`);
    const original = inverseLines[0];
    const inverse = original.replace(
      new RegExp(`(\\s${modelName})(?:\\?|\\[\\])?(?=\\s|$)`),
      `$1[]`,
    );
    models.set(targetName, target.replace(original, inverse));
  }
}
output = output.replace(
  /^model (\w+) \{([\s\S]*?)^\}/gm,
  (_block, name) => `model ${name} {${models.get(name)}}`,
);
output = output.replace(/model Note \{[\s\S]*?\n\}/, (note) =>
  note.replace(
    /(\bid\s+String\s+@id)(?![^\n]*@default)/,
    '$1 @default(uuid())',
  ),
);
await writeFile(
  outputPath,
  '// Backend schema. Keep SQL migrations for triggers, checks, views and partial/expression indexes.\n' +
    output,
);
process.stdout.write(
  `Normalized ${blocks.filter(([, kind]) => kind === 'model').length} models and ${blocks.filter(([, kind]) => kind === 'enum').length} enums\n`,
);
