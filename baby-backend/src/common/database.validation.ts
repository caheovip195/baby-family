import type { PaginationInput } from './pagination/pagination.types';
import { ValidationError } from './errors/domain.error';
type KeyKind = 'string' | 'number' | 'bigint' | 'boolean' | 'date' | 'bytes';
export function assertDatabaseKey(
  key: object,
  fields: Readonly<Record<string, KeyKind>>,
): void {
  if (key === null || typeof key !== 'object')
    throw new ValidationError('A complete primary key is required');
  const values = key as Record<string, unknown>;
  if (Object.keys(values).length !== Object.keys(fields).length)
    throw new ValidationError('A complete primary key is required');
  for (const [field, kind] of Object.entries(fields)) {
    const value = values[field];
    const valid =
      Object.hasOwn(values, field) &&
      (kind === 'date'
        ? value instanceof Date && Number.isFinite(value.getTime())
        : kind === 'bytes'
          ? value instanceof Uint8Array
          : kind === 'number'
            ? typeof value === 'number' && Number.isFinite(value)
            : typeof value === kind);
    if (!valid)
      throw new ValidationError(`Invalid primary key field: ${field}`);
  }
}
export function assertDatabasePagination(input: PaginationInput): void {
  if (
    !Number.isInteger(input.page) ||
    input.page < 1 ||
    !Number.isInteger(input.limit) ||
    input.limit < 1 ||
    input.limit > 100 ||
    !Number.isSafeInteger((input.page - 1) * input.limit)
  )
    throw new ValidationError(
      'Repository pagination requires page >= 1 and limit between 1 and 100',
    );
}
export function assertDatabaseUpdate(
  input: object,
  allowed: readonly string[],
): void {
  if (input === null || typeof input !== 'object')
    throw new ValidationError('A valid update is required');
  const keys = Object.entries(input)
    .filter(([, value]) => value !== undefined)
    .map(([key]) => key);
  if (!keys.length || keys.some((key) => !allowed.includes(key)))
    throw new ValidationError(
      'Update contains no mutable fields or protected fields',
    );
}
export function assertDatabaseScope(
  scope: object,
  fields: Readonly<Record<string, 'string' | 'nullable-string'>>,
  nullFamilyPrivileged = false,
): void {
  if (scope === null || typeof scope !== 'object')
    throw new ValidationError('An explicit repository scope is required');
  const values = scope as Record<string, unknown>;
  if (!Object.keys(fields).length) {
    if (values.privileged !== true || Object.keys(values).length !== 1)
      throw new ValidationError('A privileged global scope is required');
    return;
  }
  const needsPrivilege = nullFamilyPrivileged && values.familyId === null;
  if (needsPrivilege && values.privileged !== true)
    throw new ValidationError('A privileged scope is required for global rows');
  if (
    Object.keys(values).length !==
    Object.keys(fields).length + (needsPrivilege ? 1 : 0)
  )
    throw new ValidationError('Incomplete repository scope');
  for (const [field, kind] of Object.entries(fields)) {
    if (
      !Object.hasOwn(values, field) ||
      !(
        typeof values[field] === 'string' ||
        (kind === 'nullable-string' && values[field] === null)
      )
    )
      throw new ValidationError(`Invalid repository scope: ${field}`);
  }
}
export function assertDatabaseScopeKey(
  key: object,
  scope: Readonly<Record<string, unknown>>,
): void {
  if (key === null || typeof key !== 'object')
    throw new ValidationError('A complete primary key is required');
  for (const [field, value] of Object.entries(scope)) {
    if (
      Object.hasOwn(key, field) &&
      (key as Record<string, unknown>)[field] !== value
    )
      throw new ValidationError('Primary key does not match repository scope');
  }
}
