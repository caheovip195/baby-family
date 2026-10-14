import { Prisma } from '../generated/prisma/client';
import {
  DATABASE_NULL,
  DATABASE_JSON_NULL,
  DatabaseDecimal,
} from '../common/database.types';
import type {
  DatabaseJsonInput,
  NullableDatabaseJsonInput,
  DatabaseDecimalInput,
} from '../common/database.types';
export function toPrismaJson(
  value: DatabaseJsonInput,
): Prisma.InputJsonValue | typeof Prisma.JsonNull;
export function toPrismaJson(
  value: NullableDatabaseJsonInput,
): Prisma.InputJsonValue | typeof Prisma.JsonNull | typeof Prisma.DbNull;
export function toPrismaJson(
  value: NullableDatabaseJsonInput,
): Prisma.InputJsonValue | typeof Prisma.JsonNull | typeof Prisma.DbNull {
  if (value === DATABASE_NULL) return Prisma.DbNull;
  if (value === DATABASE_JSON_NULL) return Prisma.JsonNull;
  return value;
}
export function toPrismaDecimal(value: DatabaseDecimalInput): string {
  return value instanceof DatabaseDecimal
    ? value.toString()
    : new DatabaseDecimal(value).toString();
}
