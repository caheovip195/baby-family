import { AdminApiError } from '../api/client';

/** Human message for a failed admin call (stable code kept for support). */
export function errorText(error: unknown): string {
  if (error instanceof AdminApiError) {
    if (error.status === 403) return `Không đủ quyền (${error.code}).`;
    if (error.status === 404) return 'Không tìm thấy.';
    if (error.status === 429) return 'Thử lại sau ít phút (đã bị giới hạn).';
    return `${error.message} (${error.code})`;
  }
  return 'Không kết nối được máy chủ.';
}
