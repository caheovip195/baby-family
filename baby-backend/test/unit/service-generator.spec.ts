import { execFileSync } from 'node:child_process';
import {
  cp,
  mkdtemp,
  mkdir,
  readFile,
  writeFile,
  rm,
  symlink,
} from 'node:fs/promises';
import os from 'node:os';
import path from 'node:path';

describe('Internal service generation', () => {
  it('preserves manual services and requires explicit force for customized generated sources', async () => {
    const root = path.resolve(__dirname, '../..');
    const fixture = await mkdtemp(
      path.join(os.tmpdir(), 'baby-service-generator-'),
    );
    try {
      await mkdir(path.join(fixture, 'tools/application'), { recursive: true });
      await mkdir(path.join(fixture, 'prisma'), { recursive: true });
      await mkdir(path.join(fixture, 'src/services'), { recursive: true });
      await cp(
        path.join(root, 'tools/application/generate-services.mjs'),
        path.join(fixture, 'tools/application/generate-services.mjs'),
      );
      await cp(
        path.join(root, 'prisma/schema.prisma'),
        path.join(fixture, 'prisma/schema.prisma'),
      );
      await cp(
        path.join(root, 'src/interfaces/repositories'),
        path.join(fixture, 'src/interfaces/repositories'),
        { recursive: true },
      );
      await symlink(
        path.join(root, 'node_modules'),
        path.join(fixture, 'node_modules'),
        'dir',
      );
      const manual = path.join(fixture, 'src/services/user.service.ts');
      await writeFile(manual, '// Hand-written authenticated user workflow.\n');
      const run = (...args: string[]) =>
        execFileSync(
          process.execPath,
          ['tools/application/generate-services.mjs', ...args],
          { cwd: fixture, encoding: 'utf8', stdio: 'pipe' },
        );
      expect(run()).toContain('Generated 117');
      expect(await readFile(manual, 'utf8')).toBe(
        '// Hand-written authenticated user workflow.\n',
      );
      const target = path.join(
        fixture,
        'src/services/ai-usage-monthly.service.ts',
      );
      const original = await readFile(target, 'utf8');
      const modified = `${original}\n// Custom helper.\n`;
      await writeFile(target, modified);
      expect(() => run()).toThrow('Generated file was customized');
      expect(await readFile(target, 'utf8')).toBe(modified);
      expect(() => run('--check', '--force')).toThrow(
        'Generated file was customized',
      );
      expect(run('--force')).toContain('Generated 117');
      expect(await readFile(target, 'utf8')).toBe(original);
      expect(run('--check')).toContain('Verified 117');
      await writeFile(target, '// Hand-written application logic.\n');
      expect(() => run('--force')).toThrow(
        'Refusing to overwrite hand-written',
      );
      expect(await readFile(target, 'utf8')).toBe(
        '// Hand-written application logic.\n',
      );
    } finally {
      await rm(fixture, { recursive: true, force: true });
    }
  }, 30000);
});
