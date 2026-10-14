import { execFileSync } from 'node:child_process';
import { mkdtemp, readFile, writeFile, rm } from 'node:fs/promises';
import os from 'node:os';
import path from 'node:path';

describe('Prisma introspection naming', () => {
  it('singularizes the final snake_case word while preserving uncountable series', async () => {
    const fixture = await mkdtemp(
      path.join(os.tmpdir(), 'baby-prisma-naming-'),
    );
    try {
      const input = path.join(fixture, 'input.prisma');
      const output = path.join(fixture, 'output.prisma');
      await writeFile(
        input,
        `
model mission_series {
  id String @id @db.Uuid
  status mission_status @default(ACTIVE)
  mission_series_children mission_series_children[]
  @@schema("app")
}
model mission_series_children {
  series_id String @db.Uuid
  child_id String @db.Uuid
  mission_series mission_series @relation(fields: [series_id], references: [id])
  @@id([series_id, child_id])
  @@schema("app")
}
model auth_identities {
  id String @id @db.Uuid
  @@schema("app")
}
enum mission_status {
  ACTIVE
  ARCHIVED
  @@schema("app")
}
`,
      );
      execFileSync(
        process.execPath,
        [
          path.resolve(__dirname, '../../tools/database/normalize-prisma.mjs'),
          input,
          output,
        ],
        { encoding: 'utf8', stdio: 'pipe' },
      );
      const schema = await readFile(output, 'utf8');
      expect(schema).toContain('model MissionSeries {');
      expect(schema).toContain('model MissionSeriesChild {');
      expect(schema).toContain('model AuthIdentity {');
      expect(schema).toContain(
        'missionSeries MissionSeries @relation(fields: [seriesId], references: [id])',
      );
      expect(schema).toContain('@@map("mission_series")');
      expect(schema).toContain('@@map("mission_series_children")');
      expect(schema).toContain('status MissionStatus @default(ACTIVE)');
      expect(schema).not.toContain('MissionSery');
      expect(schema).not.toContain('missionSery');
    } finally {
      await rm(fixture, { recursive: true, force: true });
    }
  });
});
