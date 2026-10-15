import assert from 'node:assert/strict';
import { execFileSync } from 'node:child_process';
import { createRequire } from 'node:module';
import {
  mkdtemp,
  readFile,
  writeFile,
  mkdir,
  rm,
  symlink,
} from 'node:fs/promises';
import os from 'node:os';
import path from 'node:path';
import { fileURLToPath } from 'node:url';
import { test } from 'node:test';

const root = fileURLToPath(new URL('../', import.meta.url));
const require = createRequire(import.meta.url);
async function nativeCompiler() {
  const packageFile = require.resolve('@typescript/native/package.json');
  const metadata = JSON.parse(await readFile(packageFile, 'utf8'));
  return {
    metadata,
    executable: path.join(path.dirname(packageFile), metadata.bin.tsc),
  };
}
function runCompiler(executable, args, cwd = root) {
  return execFileSync(process.execPath, [executable, ...args], {
    cwd,
    encoding: 'utf8',
    stdio: 'pipe',
    timeout: 30000,
  });
}

test('main compiler executable is the pinned native TypeScript 7 release', async () => {
  const { metadata, executable } = await nativeCompiler();
  assert.equal(metadata.name, 'typescript');
  assert.equal(metadata.version, '7.0.2');
  assert.match(runCompiler(executable, ['--version']), /^Version 7\.0\.2\s*$/);
  const api = require('@typescript/native');
  assert.equal(
    typeof api.createSourceFile,
    'undefined',
    'Native package must not be mistaken for the legacy compiler API',
  );
});

test('legacy tooling alias supplies the TypeScript 6 compiler API used by generators', () => {
  const ts = require('typescript');
  assert.match(ts.version, /^6\./);
  const tree = ts.createSourceFile(
    'port.ts',
    'export interface IPort { get(id: string): Promise<string>; }',
    ts.ScriptTarget.Latest,
    true,
  );
  assert.equal(tree.parseDiagnostics.length, 0);
  const contract = tree.statements.find(ts.isInterfaceDeclaration);
  assert.ok(contract);
  assert.equal(contract.name.text, 'IPort');
  assert.ok(ts.isMethodSignature(contract.members[0]));
  assert.equal(contract.members[0].name.getText(tree), 'get');
});

test('main project configuration supports native resolution and Nest decorator metadata', async () => {
  const project = JSON.parse(
    await readFile(path.join(root, 'tsconfig.json'), 'utf8'),
  );
  const options = project.compilerOptions;
  assert.equal(options.module.toLowerCase(), 'nodenext');
  assert.equal(options.moduleResolution.toLowerCase(), 'nodenext');
  assert.equal(
    Object.hasOwn(options, 'ignoreDeprecations'),
    false,
    'Removed TS6 options must not be hidden by ignoreDeprecations',
  );
  assert.equal(options.experimentalDecorators, true);
  assert.equal(options.emitDecoratorMetadata, true);
  assert.equal(options.strict, true);
  assert.ok(options.rootDir);
  assert.ok(options.types.includes('node'));
  assert.ok(options.types.includes('jest'));
});

test('native compiler emits runnable constructor metadata and rejects a real type error', async () => {
  const { executable } = await nativeCompiler();
  const project = JSON.parse(
    await readFile(path.join(root, 'tsconfig.json'), 'utf8'),
  );
  const fixture = await mkdtemp(
    path.join(os.tmpdir(), 'baby-ts7-compatibility-'),
  );
  try {
    await mkdir(path.join(fixture, 'src'));
    await symlink(
      path.join(root, 'node_modules'),
      path.join(fixture, 'node_modules'),
      'dir',
    );
    const source = path.join(fixture, 'src/service.ts');
    await writeFile(
      source,
      `import 'reflect-metadata';
function Injectable(): ClassDecorator { return () => undefined; }
export class Dependency {}
@Injectable()
export class Service { constructor(readonly dependency: Dependency) {} }
`,
    );
    const config = path.join(fixture, 'tsconfig.json');
    await writeFile(
      config,
      JSON.stringify({
        compilerOptions: {
          ...project.compilerOptions,
          rootDir: 'src',
          outDir: 'dist',
          types: ['node'],
          noEmitOnError: true,
        },
        include: ['src/**/*.ts'],
      }),
    );
    runCompiler(executable, ['--project', config], fixture);
    const emitted = require(path.join(fixture, 'dist/service.js'));
    const dependencies = Reflect.getMetadata(
      'design:paramtypes',
      emitted.Service,
    );
    assert.deepEqual(dependencies, [emitted.Dependency]);
    const dependency = new emitted.Dependency();
    assert.equal(new emitted.Service(dependency).dependency, dependency);
    await writeFile(source, `export const invalid: string = 123;\n`);
    assert.throws(
      () => runCompiler(executable, ['--project', config, '--noEmit'], fixture),
      (error) => {
        assert.notEqual(error.status, 0);
        assert.match(error.stdout, /TS2322/);
        return true;
      },
    );
  } finally {
    await rm(fixture, { recursive: true, force: true });
  }
});

test('seed tooling resolves explicit .js imports to TypeScript sources through its legacy runtime config', async () => {
  const fixture = await mkdtemp(path.join(os.tmpdir(), 'baby-ts-tools-'));
  try {
    await symlink(
      path.join(root, 'node_modules'),
      path.join(fixture, 'node_modules'),
      'dir',
    );
    await writeFile(
      path.join(fixture, 'dependency.ts'),
      `export const marker = 'typescript-source-resolved';\n`,
    );
    const entry = path.join(fixture, 'entry.ts');
    await writeFile(
      entry,
      `import ts from 'typescript';
import { marker } from './dependency.js';
if (typeof ts.createSourceFile !== 'function') throw new Error('Tooling requires the legacy compiler API');
process.stdout.write(JSON.stringify({ marker, compilerVersion: ts.version }));
`,
    );
    const missingJs = path.join(fixture, 'dependency.js');
    await assert.rejects(readFile(missingJs), { code: 'ENOENT' });
    const packageFile = require.resolve('ts-node/package.json');
    const metadata = JSON.parse(await readFile(packageFile, 'utf8'));
    const executable = path.resolve(
      path.dirname(packageFile),
      metadata.bin['ts-node'],
    );
    const output = execFileSync(
      process.execPath,
      [
        executable,
        '--project',
        path.join(root, 'tsconfig.tools.json'),
        '--transpile-only',
        entry,
      ],
      { cwd: root, encoding: 'utf8', stdio: 'pipe', timeout: 30000 },
    );
    const result = JSON.parse(output);
    assert.equal(result.marker, 'typescript-source-resolved');
    assert.match(result.compilerVersion, /^6\./);
    await assert.rejects(readFile(missingJs), { code: 'ENOENT' });
  } finally {
    await rm(fixture, { recursive: true, force: true });
  }
});
