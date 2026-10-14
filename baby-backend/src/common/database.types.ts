export type DatabaseJsonValue =
  | string
  | number
  | boolean
  | null
  | DatabaseJsonValue[]
  | { [key: string]: DatabaseJsonValue };
export const DATABASE_JSON_NULL = Symbol('DATABASE_JSON_NULL');
export const DATABASE_NULL = Symbol('DATABASE_NULL');
export type DatabaseJsonInput =
  Exclude<DatabaseJsonValue, null> | typeof DATABASE_JSON_NULL;
export type NullableDatabaseJsonInput =
  DatabaseJsonInput | typeof DATABASE_NULL;
export type DatabaseDecimalInput = string | DatabaseDecimal;

/** Exact decimal representation independent of an ORM or floating-point number. */
export class DatabaseDecimal {
  private readonly value: string;
  constructor(value: string) {
    if (!/^[+-]?(?:\d+(?:\.\d*)?|\.\d+)(?:e[+-]?\d+)?$/i.test(value))
      throw new RangeError('Invalid exact decimal string');
    this.value = value;
  }
  toString(): string {
    return this.value;
  }
  toJSON(): string {
    return this.value;
  }
}
export function cloneDatabaseJson(value: unknown): DatabaseJsonValue {
  if (value === null || typeof value === 'string' || typeof value === 'boolean')
    return value;
  if (typeof value === 'number' && Number.isFinite(value)) return value;
  if (Array.isArray(value)) return value.map(cloneDatabaseJson);
  if (
    typeof value === 'object' &&
    value !== null &&
    Object.getPrototypeOf(value) === Object.prototype
  ) {
    return Object.fromEntries(
      Object.entries(value).map(([key, item]) => [
        key,
        cloneDatabaseJson(item),
      ]),
    );
  }
  throw new TypeError('Expected a JSON database value');
}
