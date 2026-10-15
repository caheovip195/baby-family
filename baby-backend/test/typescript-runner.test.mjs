import assert from 'node:assert/strict';
import { spawn } from 'node:child_process';
import { mkdtemp, mkdir, readFile, rm, writeFile } from 'node:fs/promises';
import os from 'node:os';
import path from 'node:path';
import { test } from 'node:test';
import {
  buildProject,
  resolveNativeCompiler,
} from '../tools/typescript/build.mjs';
import { parseDevOptions } from '../tools/typescript/dev.mjs';

const devUrl = new URL('../tools/typescript/dev.mjs', import.meta.url).href;
const delay = (ms) => new Promise((resolve) => setTimeout(resolve, ms));
async function waitUntil(predicate, message) {
  const deadline = Date.now() + 5000;
  while (Date.now() < deadline) {
    if (await predicate()) return;
    await delay(25);
  }
  assert.fail(message);
}
async function readIfPresent(filename) {
  try {
    return await readFile(filename, 'utf8');
  } catch (error) {
    if (error.code === 'ENOENT') return null;
    throw error;
  }
}
function alive(pid) {
  try {
    process.kill(pid, 0);
    return true;
  } catch (error) {
    if (error.code === 'ESRCH') return false;
    throw error;
  }
}
async function fixture(
  t,
  { version = '7.0.2', failBuild = false, failWatch = false } = {},
) {
  const root = await mkdtemp(path.join(os.tmpdir(), 'baby-ts-runner-'));
  await writeFile(
    path.join(root, 'package.json'),
    JSON.stringify({ type: 'commonjs' }),
  );
  await writeFile(path.join(root, 'tsconfig.build.json'), '{}');
  const compilerDir = path.join(root, 'node_modules/@typescript/native');
  await mkdir(path.join(compilerDir, 'bin'), { recursive: true });
  await writeFile(
    path.join(compilerDir, 'package.json'),
    JSON.stringify({
      name: 'typescript',
      type: 'module',
      version,
      bin: { tsc: 'bin/tsc' },
    }),
  );
  const application = `const fs = require('node:fs'); const path = require('node:path');
    fs.writeFileSync(path.join(__dirname, '../application.json'), JSON.stringify({ pid: process.pid, parent: process.ppid }));
    setInterval(() => {}, 1000);`;
  await writeFile(
    path.join(compilerDir, 'bin/tsc'),
    `
    import fs from 'node:fs'; import path from 'node:path';
    const root = process.cwd(); const args = process.argv.slice(2);
    fs.appendFileSync(path.join(root, 'arguments.jsonl'), JSON.stringify(args) + '\\n');
    if (args.includes('--watch')) {
      fs.writeFileSync(path.join(root, 'compiler.pid'), String(process.pid));
      ${failWatch ? "setInterval(() => { if (fs.existsSync(path.join(root, 'application.json'))) process.exit(7); }, 25);" : 'setInterval(() => {}, 1000);'}
    } else {
      ${failBuild ? 'process.exitCode = 2;' : `fs.mkdirSync(path.join(root, 'dist'), { recursive: true }); fs.writeFileSync(path.join(root, 'dist/main.js'), ${JSON.stringify(application)});`}
    }
  `,
  );
  return root;
}
async function startFixture(t, root) {
  const child = spawn(
    process.execPath,
    [
      '--input-type=module',
      '-e',
      `import {startDev} from ${JSON.stringify(devUrl)}; process.exitCode = await startDev({projectRoot:${JSON.stringify(root)},stdio:'ignore'});`,
    ],
    { stdio: 'pipe' },
  );
  const closed = new Promise((resolve, reject) => {
    child.once('error', reject);
    child.once('close', (code) => resolve(code));
  });
  t.after(async () => {
    if (child.exitCode === null) child.kill('SIGTERM');
    const timer = setTimeout(() => child.kill('SIGKILL'), 7000);
    try {
      await closed;
    } finally {
      clearTimeout(timer);
    }
    // Emergency cleanup is restricted to IDs recorded by this synthetic fixture.
    const compiler = Number(
      await readIfPresent(path.join(root, 'compiler.pid')),
    );
    const application = JSON.parse(
      (await readIfPresent(path.join(root, 'application.json'))) ?? '{}',
    );
    for (const pid of [compiler, application.parent]) {
      if (pid && alive(pid)) {
        try {
          process.kill(-pid, 'SIGKILL');
        } catch (error) {
          if (error.code !== 'ESRCH') throw error;
        }
      }
    }
    await rm(root, { recursive: true, force: true });
  });
  return { child, closed };
}

test('resolves only native TypeScript 7 and preserves output when configuration is wrong', async (t) => {
  const root = await fixture(t, { version: '6.0.3' });
  t.after(() => rm(root, { recursive: true, force: true }));
  await mkdir(path.join(root, 'dist'));
  await writeFile(path.join(root, 'dist/previous.js'), 'previous');
  assert.throws(() => resolveNativeCompiler(root), /TypeScript 7/);
  await assert.rejects(
    buildProject({ projectRoot: root, stdio: 'ignore' }),
    /TypeScript 7/,
  );
  assert.equal(
    await readFile(path.join(root, 'dist/previous.js'), 'utf8'),
    'previous',
  );
});

test('cleans stale output and invokes the native CLI with the build config and noEmitOnError', async (t) => {
  const root = await fixture(t);
  t.after(() => rm(root, { recursive: true, force: true }));
  await mkdir(path.join(root, 'dist'));
  await writeFile(path.join(root, 'dist/stale.js'), 'stale');
  assert.equal(await buildProject({ projectRoot: root, stdio: 'ignore' }), 0);
  assert.equal(await readIfPresent(path.join(root, 'dist/stale.js')), null);
  const args = JSON.parse(
    (await readFile(path.join(root, 'arguments.jsonl'), 'utf8')).trim(),
  );
  assert.deepEqual(args, [
    '--project',
    path.join(root, 'tsconfig.build.json'),
    '--noEmitOnError',
  ]);
});

test('does not start watchers or the application after an initial compilation error', async (t) => {
  const root = await fixture(t, { failBuild: true });
  const { closed } = await startFixture(t, root);
  assert.equal(await closed, 2);
  assert.equal(await readIfPresent(path.join(root, 'compiler.pid')), null);
  assert.equal(await readIfPresent(path.join(root, 'application.json')), null);
});

test('validates the supported inspector option without accepting arbitrary Node arguments', () => {
  assert.deepEqual(parseDevOptions([]), { inspect: undefined });
  assert.deepEqual(parseDevOptions(['--inspect']), { inspect: '--inspect' });
  assert.deepEqual(parseDevOptions(['--inspect=127.0.0.1:9230']), {
    inspect: '--inspect=127.0.0.1:9230',
  });
  assert.throws(() => parseDevOptions(['--eval=process.exit()']), /Usage/);
  assert.throws(() => parseDevOptions(['--inspect', '--watch']), /Usage/);
});

for (const { failWatch, signal, status } of [
  { failWatch: false, signal: 'SIGTERM', status: 143 },
  { failWatch: false, signal: 'SIGINT', status: 130 },
  { failWatch: true, signal: undefined, status: 7 },
]) {
  test(
    failWatch
      ? 'stops the application tree if the compiler watcher exits unexpectedly'
      : `stops both watcher trees on ${signal}`,
    { skip: process.platform === 'win32', timeout: 15000 },
    async (t) => {
      const root = await fixture(t, { failWatch });
      const { child, closed } = await startFixture(t, root);
      await waitUntil(
        async () =>
          Boolean(await readIfPresent(path.join(root, 'application.json'))),
        'Application did not start after initial build',
      );
      const application = JSON.parse(
        await readFile(path.join(root, 'application.json'), 'utf8'),
      );
      await waitUntil(
        async () =>
          Boolean(await readIfPresent(path.join(root, 'compiler.pid'))),
        'Compiler watcher did not start',
      );
      const compiler = Number(
        await readFile(path.join(root, 'compiler.pid'), 'utf8'),
      );
      if (signal) child.kill(signal);
      assert.equal(await closed, status);
      await waitUntil(
        () =>
          [compiler, application.pid, application.parent].every(
            (pid) => !alive(pid),
          ),
        'Development process left an owned descendant running',
      );
    },
  );
}
