import { randomUUID } from 'node:crypto';
import {
  lstat,
  mkdir,
  open,
  readFile,
  rename,
  rmdir,
  rm,
  writeFile,
} from 'node:fs/promises';
import path from 'node:path';

import { format, resolveConfig } from 'prettier';

const RESERVED_NAMES = new Set([
  'abstract',
  'any',
  'app',
  'application',
  'arguments',
  'as',
  'async',
  'await',
  'bigint',
  'boolean',
  'break',
  'case',
  'catch',
  'class',
  'common',
  'controllers',
  'services',
  'repositories',
  'models',
  'interfaces',
  'dto',
  'config',
  'const',
  'constructor',
  'continue',
  'database',
  'debugger',
  'declare',
  'default',
  'delete',
  'do',
  'domain',
  'else',
  'enum',
  'eval',
  'export',
  'extends',
  'false',
  'finally',
  'for',
  'from',
  'function',
  'generated',
  'get',
  'global',
  'health',
  'if',
  'implements',
  'import',
  'in',
  'index',
  'infer',
  'infrastructure',
  'instanceof',
  'interface',
  'is',
  'keyof',
  'let',
  'module',
  'namespace',
  'never',
  'new',
  'note',
  'null',
  'number',
  'object',
  'of',
  'package',
  'presentation',
  'prisma',
  'private',
  'protected',
  'prototype',
  'public',
  'readonly',
  'require',
  'return',
  'set',
  'static',
  'string',
  'super',
  'switch',
  'symbol',
  'this',
  'throw',
  'true',
  'try',
  'type',
  'typeof',
  'undefined',
  'unique',
  'unknown',
  'var',
  'void',
  'while',
  'with',
  'yield',
  'con',
  'prn',
  'aux',
  'nul',
]);

export function validateResourceName(name) {
  if (
    typeof name !== 'string' ||
    name.length > 64 ||
    !/^[a-z][a-z0-9]*(?:-[a-z][a-z0-9]*)*$/.test(name)
  ) {
    return 'Use a singular kebab-case name, starting with a letter, up to 64 characters.';
  }
  if (RESERVED_NAMES.has(name) || /^(?:com|lpt)[1-9]$/.test(name)) {
    return `The resource name "${name}" is reserved.`;
  }
  return true;
}

function describeResource(name) {
  const segments = name.split('-');
  const pascal = segments
    .map((segment) => segment[0].toUpperCase() + segment.slice(1))
    .join('');
  const camel = pascal[0].toLowerCase() + pascal.slice(1);
  const plural =
    name.endsWith('y') && !/[aeiou]y$/.test(name)
      ? `${name.slice(0, -1)}ies`
      : /(?:s|x|z|ch|sh)$/.test(name)
        ? `${name}es`
        : `${name}s`;
  return {
    name,
    pascal,
    camel,
    plural,
    constant: name.replaceAll('-', '_').toUpperCase(),
    snake: name.replaceAll('-', '_'),
  };
}

async function exists(file) {
  try {
    await lstat(file);
    return true;
  } catch (error) {
    if (error.code === 'ENOENT') return false;
    throw error;
  }
}

async function readRegularFile(file) {
  const stat = await lstat(file);
  if (!stat.isFile() || stat.isSymbolicLink()) {
    throw new Error(`Expected a regular file: ${file}`);
  }
  return readFile(file, 'utf8');
}

function replaceOneMarker(content, marker, addition) {
  if (content.split(marker).length !== 2) {
    throw new Error(
      `Expected exactly one ${marker} marker in src/app.module.ts.`,
    );
  }
  const escapedMarker = marker.replace(/[.*+?^${}()|[\]\\]/g, '\\$&');
  const markerLine = new RegExp(`^([\\t ]*)${escapedMarker}[\\t ]*$`, 'm');
  if (!markerLine.test(content)) {
    throw new Error(`${marker} must be on its own line in src/app.module.ts.`);
  }
  return content.replace(
    markerLine,
    (_match, indent) =>
      `${addition
        .split('\n')
        .map((line) => indent + line)
        .join('\n')}\n${indent}${marker}`,
  );
}

async function replaceFile(file, content) {
  const temporary = `${file}.generator-${randomUUID()}.tmp`;
  try {
    await writeFile(temporary, content, { flag: 'wx' });
    await rename(temporary, file);
  } finally {
    await rm(temporary, { force: true });
  }
}

/** Generate a resource across category folders; roll back a failed commit. */
export async function generateResource(name, { rootDir = process.cwd() } = {}) {
  const validation = validateResourceName(name);
  if (validation !== true) throw new Error(validation);
  const root = path.resolve(rootDir);
  const lockPath = path.join(root, '.module-generator.lock');
  try {
    await writeFile(lockPath, `${process.pid}\n`, { flag: 'wx' });
  } catch (error) {
    if (error.code === 'EEXIST') {
      throw new Error(
        'A resource generator lock exists. Wait for the active run; remove .module-generator.lock only if that process has stopped.',
      );
    }
    throw error;
  }
  try {
    return await generateResourceLocked(name, root);
  } finally {
    await rm(lockPath, { force: true });
  }
}

async function generateResourceLocked(name, root) {
  const resource = describeResource(name);
  const files = renderResourceFiles(resource);
  const targets = Object.keys(files).map((relative) =>
    path.join(root, 'src', relative),
  );
  for (const target of targets) {
    if (await exists(target))
      throw new Error(
        `Resource ${name} already exists at ${path.relative(root, target)}; no files were changed.`,
      );
  }
  const schemaPath = path.join(root, 'prisma', 'schema.prisma');
  const appModulePath = path.join(root, 'src', 'app.module.ts');
  const [originalSchema, originalAppModule] = await Promise.all([
    readRegularFile(schemaPath),
    readRegularFile(appModulePath),
  ]);
  if (
    new RegExp(`\\b(?:model|enum|type)\\s+${resource.pascal}\\s*\\{`).test(
      originalSchema,
    )
  ) {
    throw new Error(
      `Prisma type ${resource.pascal} already exists; no files were changed.`,
    );
  }
  if (
    new RegExp(
      `\\b${resource.pascal}(?:Controller|Repository|Service)\\b`,
    ).test(originalAppModule)
  ) {
    throw new Error(
      `Resource ${resource.pascal} is already registered; no files were changed.`,
    );
  }
  if (
    new RegExp(`@@map\\(\\s*["']${resource.snake}["']\\s*\\)`).test(
      originalSchema,
    )
  ) {
    throw new Error(
      `Prisma table ${resource.snake} is already mapped; no files were changed.`,
    );
  }
  let appModule = replaceOneMarker(
    originalAppModule,
    '// generator:imports',
    [
      `import { ${resource.pascal}Controller } from './controllers/${name}.controller';`,
      `import { ${resource.pascal}Service } from './services/${name}.service';`,
      `import { ${resource.pascal}Repository } from './repositories/${name}.repository';`,
      `import { ${resource.constant}_REPOSITORY } from './interfaces/repositories/${name}-repository.interface';`,
      `import { ${resource.constant}_SERVICE } from './interfaces/services/${name}-service.interface';`,
    ].join('\n'),
  );
  appModule = replaceOneMarker(
    appModule,
    '// generator:controllers',
    `${resource.pascal}Controller,`,
  );
  appModule = replaceOneMarker(
    appModule,
    '// generator:providers',
    [
      `{ provide: ${resource.constant}_REPOSITORY, useClass: ${resource.pascal}Repository },`,
      `{ provide: ${resource.constant}_SERVICE, useClass: ${resource.pascal}Service },`,
    ].join('\n'),
  );
  const formatting = (await resolveConfig(appModulePath)) ?? {
    singleQuote: true,
    trailingComma: 'all',
  };
  appModule = await format(appModule, { ...formatting, parser: 'typescript' });
  const schema = `${originalSchema.trimEnd()}\n\n${renderPrismaModel(resource)}`;
  const stagingDirectory = path.join(root, `.module-generator-${randomUUID()}`);
  const createdFiles = [];
  const createdDirectories = new Set();
  let appModuleChanged = false;
  let schemaChanged = false;
  try {
    await mkdir(stagingDirectory);
    for (const [relative, content] of Object.entries(files)) {
      const staged = path.join(stagingDirectory, relative);
      await mkdir(path.dirname(staged), { recursive: true });
      await writeFile(
        staged,
        await format(content, { ...formatting, parser: 'typescript' }),
        { flag: 'wx' },
      );
    }
    const [currentSchema, currentAppModule] = await Promise.all([
      readRegularFile(schemaPath),
      readRegularFile(appModulePath),
    ]);
    if (
      currentSchema !== originalSchema ||
      currentAppModule !== originalAppModule
    ) {
      throw new Error(
        'Project files changed during generation. Retry after other edits complete.',
      );
    }
    for (const relative of Object.keys(files)) {
      const destination = path.join(root, 'src', relative);
      const firstCreated = await mkdir(path.dirname(destination), {
        recursive: true,
      });
      if (firstCreated !== undefined) {
        let directory = path.dirname(destination);
        while (directory.startsWith(firstCreated)) {
          createdDirectories.add(directory);
          if (directory === firstCreated) break;
          directory = path.dirname(directory);
        }
      }
      const handle = await open(destination, 'wx');
      createdFiles.push(destination);
      try {
        await handle.writeFile(
          await readFile(path.join(stagingDirectory, relative)),
        );
      } finally {
        await handle.close();
      }
    }
    await replaceFile(appModulePath, appModule);
    appModuleChanged = true;
    await replaceFile(schemaPath, schema);
    schemaChanged = true;
  } catch (error) {
    if (schemaChanged) await replaceFile(schemaPath, originalSchema);
    if (appModuleChanged) await replaceFile(appModulePath, originalAppModule);
    for (const file of createdFiles) await rm(file, { force: true });
    for (const directory of [...createdDirectories].sort(
      (left, right) => right.length - left.length,
    )) {
      try {
        await rmdir(directory);
      } catch (cleanupError) {
        if (!['ENOENT', 'ENOTEMPTY', 'EEXIST'].includes(cleanupError.code))
          throw cleanupError;
      }
    }
    throw error;
  } finally {
    await rm(stagingDirectory, { recursive: true, force: true });
  }
  return { name, files: targets };
}

function renderPrismaModel({ pascal, snake }) {
  return `model ${pascal} {
  id        String   @id @default(uuid()) @db.Uuid
  title     String   @db.VarChar(200)
  content   String?
  createdAt DateTime @default(now()) @map("created_at") @db.Timestamptz(3)
  updatedAt DateTime @updatedAt @map("updated_at") @db.Timestamptz(3)

  @@map("${snake}")
}
`;
}

function renderResourceFiles({
  name,
  pascal: P,
  camel: c,
  constant: C,
  plural,
}) {
  return {
    [`models/${name}.model.ts`]: `export interface ${P}Attributes {
  id: string;
  title: string;
  content: string | null;
  createdAt: Date;
  updatedAt: Date;
}

export class ${P} implements ${P}Attributes {
  readonly id: string;
  readonly title: string;
  readonly content: string | null;
  readonly createdAt: Date;
  readonly updatedAt: Date;

  constructor(attributes: ${P}Attributes) {
    this.id = attributes.id;
    this.title = attributes.title;
    this.content = attributes.content;
    this.createdAt = attributes.createdAt;
    this.updatedAt = attributes.updatedAt;
  }

  hasContent(): boolean {
    return this.content !== null && this.content.trim().length > 0;
  }
}
`,
    [`interfaces/repositories/${name}-repository.interface.ts`]: `import type { Paginated, PaginationInput } from '../../common/pagination/pagination.types';
import type { Create${P}Dto } from '../../dto/${name}/create-${name}.dto';
import type { Update${P}Dto } from '../../dto/${name}/update-${name}.dto';
import type { ${P} } from '../../models/${name}.model';

export const ${C}_REPOSITORY = Symbol('${C}_REPOSITORY');

export interface I${P}Repository {
  list(input: PaginationInput): Promise<Paginated<${P}>>;
  findById(id: string): Promise<${P} | null>;
  create(input: Create${P}Dto): Promise<${P}>;
  update(id: string, input: Update${P}Dto): Promise<${P} | null>;
  remove(id: string): Promise<boolean>;
}
`,
    [`interfaces/services/${name}-service.interface.ts`]: `import type { Paginated, PaginationInput } from '../../common/pagination/pagination.types';
import type { Create${P}Dto } from '../../dto/${name}/create-${name}.dto';
import type { Update${P}Dto } from '../../dto/${name}/update-${name}.dto';
import type { ${P} } from '../../models/${name}.model';

export const ${C}_SERVICE = Symbol('${C}_SERVICE');

export interface I${P}Service {
  list(input: PaginationInput): Promise<Paginated<${P}>>;
  getById(id: string): Promise<${P}>;
  create(input: Create${P}Dto): Promise<${P}>;
  update(id: string, input: Update${P}Dto): Promise<${P}>;
  remove(id: string): Promise<void>;
}
`,
    [`services/${name}.service.ts`]: `import { Inject, Injectable } from '@nestjs/common';

import { NotFoundError, ValidationError } from '../common/errors/domain.error';
import type { Paginated, PaginationInput } from '../common/pagination/pagination.types';
import type { Create${P}Dto } from '../dto/${name}/create-${name}.dto';
import type { Update${P}Dto } from '../dto/${name}/update-${name}.dto';
import { ${C}_REPOSITORY } from '../interfaces/repositories/${name}-repository.interface';
import type { I${P}Repository } from '../interfaces/repositories/${name}-repository.interface';
import type { I${P}Service } from '../interfaces/services/${name}-service.interface';
import type { ${P} } from '../models/${name}.model';

@Injectable()
export class ${P}Service implements I${P}Service {
  constructor(@Inject(${C}_REPOSITORY) private readonly repository: I${P}Repository) {}

  list(input: PaginationInput): Promise<Paginated<${P}>> {
    return this.repository.list(input);
  }

  async getById(id: string): Promise<${P}> {
    const model = await this.repository.findById(id);
    if (!model) throw new NotFoundError('${P} ' + id + ' was not found.');
    return model;
  }

  create(input: Create${P}Dto): Promise<${P}> {
    return this.repository.create({ ...input, title: this.normalizeTitle(input.title) });
  }

  async update(id: string, input: Update${P}Dto): Promise<${P}> {
    if (input.title === undefined && input.content === undefined) {
      throw new ValidationError('Provide at least one field to update.');
    }
    const data = { ...input };
    if (data.title !== undefined) data.title = this.normalizeTitle(data.title);
    const model = await this.repository.update(id, data);
    if (!model) throw new NotFoundError('${P} ' + id + ' was not found.');
    return model;
  }

  async remove(id: string): Promise<void> {
    if (!(await this.repository.remove(id))) {
      throw new NotFoundError('${P} ' + id + ' was not found.');
    }
  }

  private normalizeTitle(title: string): string {
    const normalized = title.trim();
    if (!normalized || normalized.length > 200) {
      throw new ValidationError('Title must contain between 1 and 200 characters.');
    }
    return normalized;
  }
}
`,
    [`repositories/${name}.repository.ts`]: `import { Injectable } from '@nestjs/common';

import { paginate } from '../common/pagination/pagination';
import type { Paginated, PaginationInput } from '../common/pagination/pagination.types';
import { PrismaService } from '../database/prisma.service';
import type { Create${P}Dto } from '../dto/${name}/create-${name}.dto';
import type { Update${P}Dto } from '../dto/${name}/update-${name}.dto';
import { Prisma } from '../generated/prisma/client';
import type { I${P}Repository } from '../interfaces/repositories/${name}-repository.interface';
import { ${P} } from '../models/${name}.model';

@Injectable()
export class ${P}Repository implements I${P}Repository {
  constructor(private readonly prisma: PrismaService) {}

  async list(input: PaginationInput): Promise<Paginated<${P}>> {
    const [rows, total] = await this.prisma.$transaction(
      [
        this.prisma.${c}.findMany({
          skip: (input.page - 1) * input.limit,
          take: input.limit,
          orderBy: [{ createdAt: 'desc' }, { id: 'desc' }],
        }),
        this.prisma.${c}.count(),
      ],
      { isolationLevel: Prisma.TransactionIsolationLevel.RepeatableRead },
    );
    return paginate(rows.map((row) => new ${P}(row)), total, input);
  }

  async findById(id: string): Promise<${P} | null> {
    const row = await this.prisma.${c}.findUnique({ where: { id } });
    return row ? new ${P}(row) : null;
  }

  async create(input: Create${P}Dto): Promise<${P}> {
    const row = await this.prisma.${c}.create({ data: input });
    return new ${P}(row);
  }

  async update(id: string, input: Update${P}Dto): Promise<${P} | null> {
    try {
      const row = await this.prisma.${c}.update({ where: { id }, data: input });
      return new ${P}(row);
    } catch (error) {
      if (error instanceof Prisma.PrismaClientKnownRequestError && error.code === 'P2025') return null;
      throw error;
    }
  }

  async remove(id: string): Promise<boolean> {
    try {
      await this.prisma.${c}.delete({ where: { id } });
      return true;
    } catch (error) {
      if (error instanceof Prisma.PrismaClientKnownRequestError && error.code === 'P2025') return false;
      throw error;
    }
  }
}
`,
    [`dto/${name}/create-${name}.dto.ts`]: `import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { IsString, MaxLength, MinLength, ValidateIf } from 'class-validator';

export class Create${P}Dto {
  @ApiProperty({ example: 'My ${name}', minLength: 1, maxLength: 200 })
  @IsString()
  @MinLength(1)
  @MaxLength(200)
  title!: string;

  @ApiPropertyOptional({ example: 'Details', maxLength: 10000 })
  @ValidateIf((_object: unknown, value: unknown) => value !== undefined)
  @IsString()
  @MaxLength(10000)
  content?: string;
}
`,
    [`dto/${name}/update-${name}.dto.ts`]: `import { PartialType } from '@nestjs/swagger';

import { Create${P}Dto } from './create-${name}.dto';

export class Update${P}Dto extends PartialType(Create${P}Dto, { skipNullProperties: false }) {}
`,
    [`dto/${name}/${name}-response.dto.ts`]: `import { ApiProperty } from '@nestjs/swagger';

import type { Paginated } from '../../common/pagination/pagination.types';
import type { ${P}Attributes } from '../../models/${name}.model';

export class ${P}ResponseDto implements ${P}Attributes {
  @ApiProperty({ format: 'uuid' })
  id!: string;

  @ApiProperty()
  title!: string;

  @ApiProperty({ type: String, nullable: true })
  content!: string | null;

  @ApiProperty({ type: String, format: 'date-time' })
  createdAt!: Date;

  @ApiProperty({ type: String, format: 'date-time' })
  updatedAt!: Date;
}

export class ${P}PaginationMetaDto {
  @ApiProperty({ minimum: 1, example: 1 })
  page!: number;

  @ApiProperty({ minimum: 1, example: 20 })
  limit!: number;

  @ApiProperty({ minimum: 0, example: 2 })
  total!: number;

  @ApiProperty({ minimum: 0, example: 1 })
  totalPages!: number;
}

export class ${P}PageDto implements Paginated<${P}ResponseDto> {
  @ApiProperty({ type: [${P}ResponseDto] })
  data!: ${P}ResponseDto[];

  @ApiProperty({ type: ${P}PaginationMetaDto })
  meta!: ${P}PaginationMetaDto;
}
`,
    [`controllers/${name}.controller.ts`]: `import { Body, Controller, Delete, Get, HttpCode, HttpStatus, Inject, Param, ParseUUIDPipe, Patch, Post, Query } from '@nestjs/common';
import { ApiCreatedResponse, ApiNoContentResponse, ApiNotFoundResponse, ApiOkResponse, ApiTags } from '@nestjs/swagger';

import { PaginationQueryDto } from '../dto/common/pagination-query.dto';
import { Create${P}Dto } from '../dto/${name}/create-${name}.dto';
import { ${P}PageDto, ${P}ResponseDto } from '../dto/${name}/${name}-response.dto';
import { Update${P}Dto } from '../dto/${name}/update-${name}.dto';
import { ${C}_SERVICE } from '../interfaces/services/${name}-service.interface';
import type { I${P}Service } from '../interfaces/services/${name}-service.interface';

@ApiTags('${plural}')
@Controller('${plural}')
export class ${P}Controller {
  constructor(@Inject(${C}_SERVICE) private readonly service: I${P}Service) {}

  @Get()
  @ApiOkResponse({ type: ${P}PageDto })
  list(@Query() query: PaginationQueryDto): Promise<${P}PageDto> {
    return this.service.list(query);
  }

  @Get(':id')
  @ApiOkResponse({ type: ${P}ResponseDto })
  @ApiNotFoundResponse({ description: '${P} does not exist.' })
  getById(@Param('id', new ParseUUIDPipe({ version: '4' })) id: string): Promise<${P}ResponseDto> {
    return this.service.getById(id);
  }

  @Post()
  @ApiCreatedResponse({ type: ${P}ResponseDto })
  create(@Body() input: Create${P}Dto): Promise<${P}ResponseDto> {
    return this.service.create(input);
  }

  @Patch(':id')
  @ApiOkResponse({ type: ${P}ResponseDto })
  @ApiNotFoundResponse({ description: '${P} does not exist.' })
  update(
    @Param('id', new ParseUUIDPipe({ version: '4' })) id: string,
    @Body() input: Update${P}Dto,
  ): Promise<${P}ResponseDto> {
    return this.service.update(id, input);
  }

  @Delete(':id')
  @HttpCode(HttpStatus.NO_CONTENT)
  @ApiNoContentResponse({ description: '${P} deleted.' })
  @ApiNotFoundResponse({ description: '${P} does not exist.' })
  remove(@Param('id', new ParseUUIDPipe({ version: '4' })) id: string): Promise<void> {
    return this.service.remove(id);
  }
}
`,
  };
}
