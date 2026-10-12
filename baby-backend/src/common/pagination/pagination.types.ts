export interface PaginationInput {
  page: number;
  limit: number;
}
export interface Paginated<T> {
  data: T[];
  meta: { page: number; limit: number; total: number; totalPages: number };
}
