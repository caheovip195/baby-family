import type { SupportedLocale } from './request-locale';

type Translation = Readonly<Record<SupportedLocale, string>>;
/** Publish a new version for copy changes; protocol error codes remain stable. */
export const ERROR_MESSAGE_CATALOG = {
  version: 1,
  messages: {
    INTERNAL_SERVER_ERROR: {
      vi: 'Đã xảy ra lỗi ngoài dự kiến. Vui lòng thử lại.',
      en: 'An unexpected error occurred. Please try again.',
    },
    HTTP_ERROR: {
      vi: 'Không thể xử lý yêu cầu.',
      en: 'The request could not be processed.',
    },
    BAD_REQUEST: { vi: 'Yêu cầu không hợp lệ.', en: 'The request is invalid.' },
    VALIDATION_ERROR: {
      vi: 'Dữ liệu yêu cầu không hợp lệ.',
      en: 'Request validation failed.',
    },
    UNAUTHORIZED: {
      vi: 'Vui lòng đăng nhập lại để tiếp tục.',
      en: 'Please sign in again to continue.',
    },
    FORBIDDEN: {
      vi: 'Bạn không có quyền thực hiện thao tác này.',
      en: 'You do not have permission to perform this action.',
    },
    NOT_FOUND: {
      vi: 'Không tìm thấy nội dung yêu cầu.',
      en: 'The requested content was not found.',
    },
    CONFLICT: {
      vi: 'Dữ liệu đã thay đổi hoặc thao tác bị trùng. Vui lòng thử lại.',
      en: 'The data has changed or the operation conflicts with an existing one. Please try again.',
    },
    UNPROCESSABLE_ENTITY: {
      vi: 'Không thể thực hiện thao tác với dữ liệu này.',
      en: 'This operation cannot be performed with the supplied data.',
    },
    PAYMENT_REQUIRED: {
      vi: 'Gia đình cần quyền lợi phù hợp để tiếp tục.',
      en: 'Your family needs the required entitlement to continue.',
    },
    TOO_MANY_REQUESTS: {
      vi: 'Bạn thao tác quá nhanh. Vui lòng thử lại sau.',
      en: 'Too many requests. Please try again later.',
    },
    SERVICE_UNAVAILABLE: {
      vi: 'Dịch vụ tạm thời không khả dụng. Vui lòng thử lại sau.',
      en: 'The service is temporarily unavailable. Please try again later.',
    },
    FAMILY_NOT_ACTIVE: {
      vi: 'Gia đình chưa đủ Papa và Mama để tiếp tục.',
      en: 'Your family needs both parents to continue.',
    },
    FAMILY_ACCESS_DENIED: {
      vi: 'Bạn không có quyền truy cập gia đình này.',
      en: 'You do not have access to this family.',
    },
    FAMILY_DELETING: {
      vi: 'Gia đình đang chờ xoá.',
      en: 'This family is scheduled for deletion.',
    },
    CIRCLE_PAUSED: {
      vi: 'Chia sẻ với người thân đang tạm dừng.',
      en: 'Circle sharing is paused.',
    },
    CIRCLE_NOT_ALLOWED: {
      vi: 'Bạn chưa được cấp quyền cho thao tác này.',
      en: 'You have not been granted permission for this action.',
    },
    CHILD_NOT_FOUND: {
      vi: 'Không tìm thấy hồ sơ bé.',
      en: 'The child profile was not found.',
    },
    MEMORY_NOT_FOUND: {
      vi: 'Không tìm thấy ký ức.',
      en: 'The memory was not found.',
    },
    MEDIA_NOT_FOUND: {
      vi: 'Không tìm thấy ảnh hoặc video.',
      en: 'The photo or video was not found.',
    },
    MEDIA_NOT_READY: {
      vi: 'Ảnh hoặc video vẫn đang được xử lý.',
      en: 'The photo or video is still being processed.',
    },
    MEDIA_INVALID: {
      vi: 'Ảnh hoặc video không hợp lệ.',
      en: 'The photo or video is invalid.',
    },
    QUOTA_PHOTOS_PER_MEMORY: {
      vi: 'Ký ức đã đạt giới hạn số ảnh.',
      en: 'This memory has reached its photo limit.',
    },
    QUOTA_STORAGE: {
      vi: 'Gia đình đã dùng hết dung lượng hiện có.',
      en: 'Your family has used all available storage.',
    },
    MONTHLY_PHOTO_INVALID: {
      vi: 'Ảnh tháng không hợp lệ.',
      en: 'The monthly photo is invalid.',
    },
    MONTH_INDEX_MISMATCH: {
      vi: 'Tháng tuổi không khớp với ngày chụp ảnh.',
      en: 'The month index does not match the photo date.',
    },
    MONTH_INDEX_INVALID: {
      vi: 'Tháng tuổi không hợp lệ.',
      en: 'The month index is invalid.',
    },
    RECAP_NOT_FOUND: {
      vi: 'Chưa có bản tổng kết cho thời gian này.',
      en: 'No recap is available for this period.',
    },
    REPORT_SELF_NOT_ALLOWED: {
      vi: 'Bạn không thể báo cáo nội dung của chính mình.',
      en: 'You cannot report your own content.',
    },
    BLOCK_SELF_NOT_ALLOWED: {
      vi: 'Bạn không thể chặn chính mình.',
      en: 'You cannot block yourself.',
    },
    BLOCK_PARTNER_NOT_ALLOWED: {
      vi: 'Không thể chặn bạn đời trong gia đình.',
      en: 'You cannot block your partner in this family.',
    },
  } satisfies Record<string, Translation>,
} as const;

/** Unknown domain codes use a translated status fallback; never expose raw server errors. */
export function localizedErrorMessage(
  code: string,
  status: number,
  locale: SupportedLocale,
): string {
  const messages: Readonly<Record<string, Translation>> =
    ERROR_MESSAGE_CATALOG.messages;
  const statusKey: Record<number, string> = {
    400: 'BAD_REQUEST',
    401: 'UNAUTHORIZED',
    402: 'PAYMENT_REQUIRED',
    403: 'FORBIDDEN',
    404: 'NOT_FOUND',
    409: 'CONFLICT',
    422: 'UNPROCESSABLE_ENTITY',
    429: 'TOO_MANY_REQUESTS',
    503: 'SERVICE_UNAVAILABLE',
  };
  return (messages[code] ??
    messages[statusKey[status] ?? 'HTTP_ERROR'] ??
    ERROR_MESSAGE_CATALOG.messages.HTTP_ERROR)[locale];
}
