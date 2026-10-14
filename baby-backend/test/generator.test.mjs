import assert from 'node:assert/strict';
import {
  chmod,
  mkdtemp,
  mkdir,
  readFile,
  readdir,
  rm,
  writeFile,
} from 'node:fs/promises';
import os from 'node:os';
import path from 'node:path';
import { test } from 'node:test';
import { pathToFileURL } from 'node:url';

import {
  generateResource,
  validateResourceName,
} from '../tools/generators/resource.mjs';

const INITIAL_SCHEMA = `generator client {
  provider = "prisma-client"
  output = "../src/generated/prisma"
  moduleFormat = "cjs"
}

datasource db {
  provider = "postgresql"
  schemas = ["public", "app"]
}
`;
const INITIAL_APP_MODULE = `import { Module } from '@nestjs/common';
// generator:imports

@Module({
  controllers: [
    // generator:controllers
  ],
  providers: [
    // generator:providers
  ],
})
export class AppModule {}
`;

async function createFixture(t) {
  const rootDir = await mkdtemp(
    path.join(os.tmpdir(), 'baby-backend-generator-'),
  );
  t.after(() => rm(rootDir, { recursive: true, force: true }));
  await mkdir(path.join(rootDir, 'src'));
  await mkdir(path.join(rootDir, 'prisma'));
  await writeFile(
    path.join(rootDir, 'prisma', 'schema.prisma'),
    INITIAL_SCHEMA,
  );
  await writeFile(
    path.join(rootDir, 'src', 'app.module.ts'),
    INITIAL_APP_MODULE,
  );
  return rootDir;
}

async function listFiles(directory) {
  const files = [];
  for (const entry of await readdir(directory, { withFileTypes: true })) {
    const target = path.join(directory, entry.name);
    if (entry.isDirectory()) files.push(...(await listFiles(target)));
    else files.push(target);
  }
  return files.sort();
}

async function assertUnchanged(
  rootDir,
  schema = INITIAL_SCHEMA,
  appModule = INITIAL_APP_MODULE,
) {
  assert.equal(
    await readFile(path.join(rootDir, 'prisma', 'schema.prisma'), 'utf8'),
    schema,
  );
  assert.equal(
    await readFile(path.join(rootDir, 'src', 'app.module.ts'), 'utf8'),
    appModule,
  );
  assert.deepEqual(await listFiles(path.join(rootDir, 'src')), [
    path.join(rootDir, 'src', 'app.module.ts'),
  ]);
  assert.deepEqual(await readdir(path.join(rootDir, 'src')), ['app.module.ts']);
  assert.equal(
    (await readdir(rootDir)).some((name) =>
      name.startsWith('.module-generator'),
    ),
    false,
  );
}

test('generates category folders, I-prefixed DI interfaces, a real model and AppModule providers', async (t) => {
  const rootDir = await createFixture(t);
  const result = await generateResource('task', { rootDir });
  assert.equal(result.files.length, 9);
  for (const file of result.files)
    assert.ok((await readFile(file, 'utf8')).length > 0);
  const read = (relative) =>
    readFile(path.join(rootDir, 'src', relative), 'utf8');
  assert.match(
    await read('interfaces/repositories/task-repository.interface.ts'),
    /interface ITaskRepository/,
  );
  assert.match(
    await read('interfaces/repositories/task-repository.interface.ts'),
    /TASK_REPOSITORY = Symbol\('TASK_REPOSITORY'\)/,
  );
  assert.match(
    await read('interfaces/services/task-service.interface.ts'),
    /interface ITaskService/,
  );
  assert.match(
    await read('services/task.service.ts'),
    /class TaskService implements ITaskService/,
  );
  assert.match(
    await read('services/task.service.ts'),
    /@Inject\(TASK_REPOSITORY\)/,
  );
  assert.match(
    await read('controllers/task.controller.ts'),
    /@Inject\(TASK_SERVICE\)/,
  );
  assert.match(
    await read('controllers/task.controller.ts'),
    /@Controller\('tasks'\)/,
  );
  assert.match(
    await read('controllers/task.controller.ts'),
    /from '\.\.\/dto\/common\/pagination-query.dto'/,
  );
  assert.match(
    await read('repositories/task.repository.ts'),
    /class TaskRepository implements ITaskRepository/,
  );
  assert.match(
    await read('repositories/task.repository.ts'),
    /new Task\(row\)/,
  );
  assert.match(
    await read('repositories/task.repository.ts'),
    /this\.prisma\.task\.findMany/,
  );
  assert.match(
    await read('repositories/task.repository.ts'),
    /error\.code === 'P2025'/,
  );
  assert.match(
    await read('repositories/task.repository.ts'),
    /isolationLevel: Prisma\.TransactionIsolationLevel\.RepeatableRead/,
  );
  assert.match(
    await read('controllers/task.controller.ts'),
    /@ApiOkResponse\(\{ type: TaskPageDto \}\)/,
  );
  assert.match(
    await read('dto/task/task-response.dto.ts'),
    /class TaskPageDto implements Paginated<TaskResponseDto>/,
  );
  const schema = await readFile(
    path.join(rootDir, 'prisma', 'schema.prisma'),
    'utf8',
  );
  assert.match(schema, /model Task \{/);
  assert.match(schema, /@@map\("task"\)/);
  assert.match(schema, /@@schema\("public"\)/);
  assert.match(schema, /updatedAt DateTime @default\(now\(\)\) @updatedAt/);
  assert.match(schema, /deletedAt DateTime\? @map\("deleted_at"\)/);
  const repository = await read('repositories/task.repository.ts');
  assert.match(repository, /count\(\{\s*where: \{ deletedAt: null \}/);
  assert.match(repository, /where: \{ id, deletedAt: null \}/);
  assert.match(repository, /data: \{ deletedAt: new Date\(\) \}/);
  assert.doesNotMatch(repository, /\.delete\(/);
  const appModule = await read('app.module.ts');
  assert.match(
    appModule,
    /import \{ TaskController \} from '\.\/controllers\/task\.controller';/,
  );
  assert.match(appModule, /controllers:\s*\[\s*TaskController,/);
  assert.match(appModule, /provide: TASK_REPOSITORY, useClass: TaskRepository/);
  assert.match(appModule, /provide: TASK_SERVICE, useClass: TaskService/);
  assert.equal(
    (await readdir(path.join(rootDir, 'src'))).includes('modules'),
    false,
  );
  const { Task } = await import(
    pathToFileURL(path.join(rootDir, 'src', 'models', 'task.model.ts')).href
  );
  const attributes = {
    id: 'id',
    title: 'Task',
    content: 'Details',
    createdAt: new Date(),
    updatedAt: new Date(),
    deletedAt: null,
  };
  const model = new Task(attributes);
  assert.equal(model instanceof Task, true);
  assert.equal(model.hasContent(), true);
  assert.equal(new Task({ ...attributes, content: null }).hasContent(), false);
  assert.equal(new Task({ ...attributes, content: '  ' }).hasContent(), false);
  assert.deepEqual(JSON.parse(JSON.stringify(model)), {
    ...attributes,
    createdAt: attributes.createdAt.toISOString(),
    updatedAt: attributes.updatedAt.toISOString(),
  });
});

test('supports kebab-case resources with PascalCase interfaces and camelCase Prisma delegates', async (t) => {
  const rootDir = await createFixture(t);
  await generateResource('family-category', { rootDir });
  const read = (relative) =>
    readFile(path.join(rootDir, 'src', relative), 'utf8');
  assert.match(
    await read(
      'interfaces/repositories/family-category-repository.interface.ts',
    ),
    /IFamilyCategoryRepository/,
  );
  assert.match(
    await read('repositories/family-category.repository.ts'),
    /this\.prisma\.familyCategory\.findUnique/,
  );
  assert.match(
    await read('controllers/family-category.controller.ts'),
    /@Controller\('family-categories'\)/,
  );
  assert.match(
    await readFile(path.join(rootDir, 'prisma', 'schema.prisma'), 'utf8'),
    /@@map\("family_category"\)/,
  );
});

test('allows the same table name in another database schema without changing that model', async (t) => {
  const rootDir = await createFixture(t);
  const domainModel = `model DomainTask {\n  id String @id\n  @@map("task")\n  @@schema("app")\n}\n`;
  await writeFile(
    path.join(rootDir, 'prisma', 'schema.prisma'),
    INITIAL_SCHEMA + domainModel,
  );
  await generateResource('task', { rootDir });
  const schema = await readFile(
    path.join(rootDir, 'prisma', 'schema.prisma'),
    'utf8',
  );
  assert.ok(schema.includes(domainModel.trim()));
  assert.match(schema, /model Task \{[\s\S]*?@@schema\("public"\)/);
});

test('refuses any existing target without overwriting changes or leaving other category files', async (t) => {
  const rootDir = await createFixture(t);
  const controllerPath = path.join(
    rootDir,
    'src',
    'controllers',
    'task.controller.ts',
  );
  await mkdir(path.dirname(controllerPath));
  await writeFile(controllerPath, '// user changes\n');
  await assert.rejects(generateResource('task', { rootDir }), /already exists/);
  assert.equal(await readFile(controllerPath, 'utf8'), '// user changes\n');
  assert.deepEqual(await listFiles(path.join(rootDir, 'src')), [
    path.join(rootDir, 'src', 'app.module.ts'),
    controllerPath,
  ]);
  assert.equal(
    await readFile(path.join(rootDir, 'prisma', 'schema.prisma'), 'utf8'),
    INITIAL_SCHEMA,
  );
  assert.equal(
    await readFile(path.join(rootDir, 'src', 'app.module.ts'), 'utf8'),
    INITIAL_APP_MODULE,
  );
});

test('rejects traversal, malformed names and reserved category names before writing', async (t) => {
  const rootDir = await createFixture(t);
  for (const name of [
    '../outside',
    'task/../../outside',
    '/tmp/task',
    'Task',
    'task_name',
    'task name',
    '',
    'health',
    'common',
    'note',
    'config',
    'database',
    'class',
    'constructor',
    'con',
    'controllers',
    'services',
    'repositories',
    'models',
    'interfaces',
    'dto',
  ]) {
    assert.notEqual(validateResourceName(name), true, name);
    await assert.rejects(generateResource(name, { rootDir }));
  }
  await assertUnchanged(rootDir);
});

test('rejects an existing Prisma model before creating any category files', async (t) => {
  const rootDir = await createFixture(t);
  const schema = `${INITIAL_SCHEMA}\nmodel Task {\n  id String @id\n}\n`;
  await writeFile(path.join(rootDir, 'prisma', 'schema.prisma'), schema);
  await assert.rejects(
    generateResource('task', { rootDir }),
    /Prisma type Task already exists/,
  );
  await assertUnchanged(rootDir, schema);
});

test('rejects an existing table mapping and composition-root registration before writing', async (t) => {
  const rootDir = await createFixture(t);
  const schema = `${INITIAL_SCHEMA}\nmodel ExistingTask {\n  id String @id\n  @@map("task")\n}\n`;
  await writeFile(path.join(rootDir, 'prisma', 'schema.prisma'), schema);
  await assert.rejects(
    generateResource('task', { rootDir }),
    /table task is already mapped/,
  );
  await assertUnchanged(rootDir, schema);
  await writeFile(
    path.join(rootDir, 'prisma', 'schema.prisma'),
    INITIAL_SCHEMA,
  );
  const appModule = INITIAL_APP_MODULE.replace(
    '// generator:imports',
    '// generator:imports\n// TaskController already exists',
  );
  await writeFile(path.join(rootDir, 'src', 'app.module.ts'), appModule);
  await assert.rejects(
    generateResource('task', { rootDir }),
    /Resource Task is already registered/,
  );
  await assertUnchanged(rootDir, INITIAL_SCHEMA, appModule);
});

test('missing or duplicated registration markers cannot leave a partially generated resource', async (t) => {
  for (const marker of [
    '// generator:imports',
    '// generator:controllers',
    '// generator:providers',
  ]) {
    for (const replacement of ['', `${marker}\n${marker}`]) {
      const rootDir = await createFixture(t);
      const appModule = INITIAL_APP_MODULE.replace(marker, replacement);
      await writeFile(path.join(rootDir, 'src', 'app.module.ts'), appModule);
      await assert.rejects(
        generateResource('task', { rootDir }),
        /Expected exactly one/,
      );
      await assertUnchanged(rootDir, INITIAL_SCHEMA, appModule);
    }
  }
});

test('serializes project mutations so concurrent generators cannot lose providers or models', async (t) => {
  const rootDir = await createFixture(t);
  const results = await Promise.allSettled([
    generateResource('task', { rootDir }),
    generateResource('reminder', { rootDir }),
  ]);
  const successful = results.filter((result) => result.status === 'fulfilled');
  const rejected = results.filter((result) => result.status === 'rejected');
  assert.equal(successful.length, 1);
  assert.equal(rejected.length, 1);
  assert.match(rejected[0].reason.message, /generator lock exists/);
  const successfulName = successful[0].value.name;
  const otherName = successfulName === 'task' ? 'reminder' : 'task';
  assert.deepEqual(await readdir(path.join(rootDir, 'src', 'controllers')), [
    `${successfulName}.controller.ts`,
  ]);
  await generateResource(otherName, { rootDir });
  const schema = await readFile(
    path.join(rootDir, 'prisma', 'schema.prisma'),
    'utf8',
  );
  const appModule = await readFile(
    path.join(rootDir, 'src', 'app.module.ts'),
    'utf8',
  );
  for (const resource of ['Task', 'Reminder']) {
    assert.match(schema, new RegExp(`model ${resource} \\{`));
    assert.match(appModule, new RegExp(`${resource}Controller,`));
    assert.match(appModule, new RegExp(`useClass: ${resource}Repository`));
    assert.match(appModule, new RegExp(`useClass: ${resource}Service`));
  }
  assert.equal(
    (await readdir(rootDir)).includes('.module-generator.lock'),
    false,
  );
});

test('rolls back category files and AppModule when the Prisma schema commit fails', async (t) => {
  if (process.platform === 'win32' || process.getuid?.() === 0) {
    t.skip('Requires POSIX permissions under a non-root user.');
    return;
  }
  const rootDir = await createFixture(t);
  const prismaDirectory = path.join(rootDir, 'prisma');
  await chmod(prismaDirectory, 0o555);
  try {
    await assert.rejects(generateResource('task', { rootDir }), /EACCES|EPERM/);
  } finally {
    await chmod(prismaDirectory, 0o755);
  }
  await assertUnchanged(rootDir);
});
