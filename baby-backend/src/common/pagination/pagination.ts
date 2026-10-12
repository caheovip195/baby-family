import type { Paginated, PaginationInput } from './pagination.types';

export function paginate<T>(
  data: T[],
  total: number,
  input: PaginationInput,
): Paginated<T> {
  return {
    data,
    meta: {
      page: input.page,
      limit: input.limit,
      total,
      totalPages: Math.ceil(total / input.limit),
    },
  };
}
