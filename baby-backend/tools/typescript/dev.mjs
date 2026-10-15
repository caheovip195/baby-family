import { access } from 'node:fs/promises';
import path from 'node:path';
import { pathToFileURL } from 'node:url';
import {
  PROJECT_ROOT,
  buildProject,
  exitStatus,
  resolveNativeCompiler,
  spawnManaged,
  stopProcessTree,
} from './build.mjs';

export function parseDevOptions(args) {
  if (args.length > 1 || (args.length && !/^--inspect(?:=.+)?$/.test(args[0])))
    throw new Error(
      'Usage: node tools/typescript/dev.mjs [--inspect[=host:port]]',
    );
  return { inspect: args[0] };
}

export async function startDev({
  projectRoot = PROJECT_ROOT,
  inspect,
  stdio = 'inherit',
} = {}) {
  const initial = await buildProject({ projectRoot, stdio });
  if (initial !== 0) return initial;
  const entry = path.join(projectRoot, 'dist/main.js');
  await access(entry);
  const compiler = resolveNativeCompiler(projectRoot);
  const children = [];
  let stopping;
  let finish;
  const done = new Promise((resolve) => {
    finish = resolve;
  });
  const stop = (status, signal = 'SIGTERM') => {
    stopping ??= Promise.all(
      children.map((child) => stopProcessTree(child, signal)),
    ).then(
      () => finish(status),
      (error) => {
        process.stderr.write(
          `Could not stop development processes: ${error.message}\n`,
        );
        finish(1);
      },
    );
    return stopping;
  };
  const onInterrupt = () => {
    void stop(130, 'SIGINT');
  };
  const onTerminate = () => {
    void stop(143);
  };
  process.once('SIGINT', onInterrupt);
  process.once('SIGTERM', onTerminate);
  try {
    const commands = [
      [
        compiler,
        '--project',
        path.join(projectRoot, 'tsconfig.build.json'),
        '--watch',
        '--preserveWatchOutput',
        '--noEmitOnError',
      ],
      [
        '--watch',
        '--watch-preserve-output',
        ...(inspect ? [inspect] : []),
        entry,
      ],
    ];
    for (const args of commands) {
      if (stopping) break;
      const child = spawnManaged(args, { projectRoot, stdio });
      children.push(child);
      child.once('error', (error) => {
        process.stderr.write(
          `Development process failed to start: ${error.message}\n`,
        );
        void stop(1);
      });
      child.once('close', (code, signal) => {
        // Watch supervisors should stay alive until interrupted. Even a clean
        // unexpected exit must stop the other supervisor rather than orphan it.
        if (!stopping) void stop(exitStatus(code, signal) || 1);
      });
    }
    return await done;
  } finally {
    process.removeListener('SIGINT', onInterrupt);
    process.removeListener('SIGTERM', onTerminate);
    await Promise.all(children.map((child) => stopProcessTree(child)));
  }
}

if (
  process.argv[1] &&
  pathToFileURL(path.resolve(process.argv[1])).href === import.meta.url
) {
  try {
    process.exitCode = await startDev(parseDevOptions(process.argv.slice(2)));
  } catch (error) {
    process.stderr.write(`${error.message}\n`);
    process.exitCode = 1;
  }
}
