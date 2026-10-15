import { spawn } from 'node:child_process';
import { existsSync, readFileSync } from 'node:fs';
import { rm } from 'node:fs/promises';
import { createRequire } from 'node:module';
import path from 'node:path';
import { fileURLToPath, pathToFileURL } from 'node:url';

export const PROJECT_ROOT = path.resolve(
  path.dirname(fileURLToPath(import.meta.url)),
  '../..',
);

export function resolveNativeCompiler(projectRoot = PROJECT_ROOT) {
  const require = createRequire(path.join(projectRoot, 'package.json'));
  const filename = require.resolve('@typescript/native/package.json');
  const metadata = JSON.parse(readFileSync(filename, 'utf8'));
  if (!/^7\./.test(metadata.version) || typeof metadata.bin?.tsc !== 'string')
    throw new Error('The @typescript/native alias must provide TypeScript 7.');
  const compiler = path.resolve(path.dirname(filename), metadata.bin.tsc);
  if (!existsSync(compiler))
    throw new Error('Native TypeScript CLI was not installed. Run npm ci.');
  return compiler;
}

export function spawnManaged(
  args,
  { projectRoot = PROJECT_ROOT, stdio = 'inherit' } = {},
) {
  return spawn(process.execPath, args, {
    cwd: projectRoot,
    stdio,
    // Each child owns its process group, including the native compiler or the
    // application spawned by Node's watch supervisor.
    detached: process.platform !== 'win32',
  });
}

export async function stopProcessTree(child, signal = 'SIGTERM') {
  if (!child?.pid) return;
  if (process.platform === 'win32') {
    await new Promise((resolve) => {
      const killer = spawn(
        'taskkill',
        ['/pid', String(child.pid), '/T', '/F'],
        { stdio: 'ignore' },
      );
      killer.once('error', () => {
        child.kill();
        resolve();
      });
      killer.once('close', resolve);
    });
    return;
  }
  const send = (value) => {
    try {
      process.kill(-child.pid, value);
      return true;
    } catch (error) {
      if (error.code === 'ESRCH') return false;
      throw error;
    }
  };
  if (!send(signal)) return;
  const deadline = Date.now() + 2000;
  // Waiting for only the direct child's close event would leave descendants
  // behind when a wrapper exits before its native process/application.
  while (Date.now() < deadline) {
    if (!send(0)) return;
    await new Promise((resolve) => setTimeout(resolve, 25));
  }
  send('SIGKILL');
}

export function exitStatus(code, signal) {
  return code ?? (signal === 'SIGINT' ? 130 : signal === 'SIGTERM' ? 143 : 1);
}

export async function buildProject({
  projectRoot = PROJECT_ROOT,
  stdio = 'inherit',
} = {}) {
  // Resolve before cleaning, so a missing dependency preserves the last build.
  const compiler = resolveNativeCompiler(projectRoot);
  await rm(path.join(projectRoot, 'dist'), { recursive: true, force: true });
  const child = spawnManaged(
    [
      compiler,
      '--project',
      path.join(projectRoot, 'tsconfig.build.json'),
      '--noEmitOnError',
    ],
    { projectRoot, stdio },
  );
  let interrupted;
  let shutdown;
  const interrupt = (signal) => {
    interrupted ??= signal;
    shutdown ??= stopProcessTree(child, signal);
  };
  const onInterrupt = () => interrupt('SIGINT');
  const onTerminate = () => interrupt('SIGTERM');
  process.once('SIGINT', onInterrupt);
  process.once('SIGTERM', onTerminate);
  try {
    const status = await new Promise((resolve, reject) => {
      child.once('error', reject);
      child.once('close', (code, signal) => resolve(exitStatus(code, signal)));
    });
    if (shutdown) await shutdown;
    return interrupted ? exitStatus(null, interrupted) : status;
  } finally {
    process.removeListener('SIGINT', onInterrupt);
    process.removeListener('SIGTERM', onTerminate);
    await stopProcessTree(child);
  }
}

if (
  process.argv[1] &&
  pathToFileURL(path.resolve(process.argv[1])).href === import.meta.url
) {
  try {
    process.exitCode = await buildProject();
  } catch (error) {
    process.stderr.write(`${error.message}\n`);
    process.exitCode = 1;
  }
}
