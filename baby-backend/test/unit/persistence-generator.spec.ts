import { execFileSync } from 'node:child_process';
import {
  mkdtemp,
  mkdir,
  cp,
  symlink,
  readFile,
  writeFile,
  rm,
} from 'node:fs/promises';
import os from 'node:os';
import path from 'node:path';

describe('Persistence code generation', () => {
  it('preflights customized generated files and only replaces them with explicit force', async () => {
    const root = path.resolve(__dirname, '../..');
    const fixture = await mkdtemp(path.join(os.tmpdir(), 'baby-persistence-'));
    try {
      await mkdir(path.join(fixture, 'tools/database'), { recursive: true });
      await cp(
        path.join(root, 'tools/database/generate-persistence.mjs'),
        path.join(fixture, 'tools/database/generate-persistence.mjs'),
      );
      await cp(path.join(root, 'prisma'), path.join(fixture, 'prisma'), {
        recursive: true,
        filter: (source) => !source.endsWith('.ts'),
      });
      await symlink(
        path.join(root, 'node_modules'),
        path.join(fixture, 'node_modules'),
        'dir',
      );
      const run = (...args: string[]) =>
        execFileSync(
          process.execPath,
          ['tools/database/generate-persistence.mjs', ...args],
          { cwd: fixture, encoding: 'utf8', stdio: 'pipe' },
        );
      expect(run()).toContain('Generated 122');
      const target = path.join(fixture, 'src/models/ai-usage-monthly.model.ts');
      const original = await readFile(target, 'utf8');
      const modified = `${original}\n// Preserved custom helper.\n`;
      await writeFile(target, modified);
      expect(() => run()).toThrow('Generated file was customized');
      expect(await readFile(target, 'utf8')).toBe(modified);
      expect(() => run('--check', '--force')).toThrow(
        'Generated file was customized',
      );
      expect(run('--force')).toContain('Generated 122');
      expect(await readFile(target, 'utf8')).toBe(original);
      expect(run('--check')).toContain('Verified 122');
    } finally {
      await rm(fixture, { recursive: true, force: true });
    }
  }, 30000);
});
