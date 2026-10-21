import type { JobPolicy } from './jobs';

export const TRANSACTIONAL_MAIL_POLICY = {
  version: 1,
  everyMs: 60_000,
  batchSize: 100,
  reminderBeforeMs: 24 * 60 * 60 * 1000,
  downloadTtlSeconds: 900,
} as const;
export const TRANSACTIONAL_MAIL_JOBS = {
  deliver: {
    queue: 'transactional-mail',
    name: 'mail.deliver-transactional',
    maxAttempts: 3,
    backoffMs: 10_000,
    leaseMs: 120_000,
  },
  reconcile: {
    queue: 'transactional-mail',
    name: 'mail.reconcile-transactional',
    maxAttempts: 3,
    backoffMs: 10_000,
    leaseMs: 120_000,
  },
} as const satisfies Record<string, JobPolicy>;
export type TransactionalMailKind =
  | 'EXPORT_READY'
  | 'ACCOUNT_DELETION_SCHEDULED'
  | 'ACCOUNT_DELETION_REMINDER'
  | 'FAMILY_DELETION_SCHEDULED'
  | 'FAMILY_DELETION_REMINDER'
  | 'PHONE_CHANGED'
  | 'SIGN_IN_METHOD_ADDED';
export const TRANSACTIONAL_MAIL_TEMPLATES = {
  vi: {
    EXPORT_READY: [
      'Bản xuất dữ liệu đã sẵn sàng',
      'Bản xuất dữ liệu của bạn đã sẵn sàng. Liên kết tải có thời hạn ngắn:',
    ],
    ACCOUNT_DELETION_SCHEDULED: [
      'Đã hẹn xoá tài khoản',
      'Yêu cầu xoá tài khoản đã được lên lịch. Bạn có thể đăng nhập để huỷ trước thời hạn:',
    ],
    ACCOUNT_DELETION_REMINDER: [
      'Nhắc lịch xoá tài khoản',
      'Tài khoản của bạn sắp được xoá. Bạn có thể đăng nhập để huỷ trước thời hạn:',
    ],
    FAMILY_DELETION_SCHEDULED: [
      'Đã hẹn xoá gia đình',
      'Yêu cầu xoá gia đình đã được lên lịch. Bạn có thể mở ứng dụng để huỷ trước thời hạn:',
    ],
    FAMILY_DELETION_REMINDER: [
      'Nhắc lịch xoá gia đình',
      'Gia đình của bạn sắp được xoá. Bạn có thể mở ứng dụng để huỷ trước thời hạn:',
    ],
    PHONE_CHANGED: [
      'Cảnh báo bảo mật',
      'Số điện thoại đăng nhập của bạn vừa được đổi. Nếu bạn không thực hiện, hãy liên hệ bộ phận hỗ trợ ngay.',
    ],
    SIGN_IN_METHOD_ADDED: [
      'Cảnh báo bảo mật',
      'Một phương thức đăng nhập vừa được thêm vào tài khoản của bạn. Nếu bạn không thực hiện, hãy liên hệ bộ phận hỗ trợ ngay.',
    ],
  },
  en: {
    EXPORT_READY: [
      'Your data export is ready',
      'Your data export is ready. This download link expires shortly:',
    ],
    ACCOUNT_DELETION_SCHEDULED: [
      'Account deletion scheduled',
      'Your account deletion is scheduled. Sign in to cancel before:',
    ],
    ACCOUNT_DELETION_REMINDER: [
      'Account deletion reminder',
      'Your account will be deleted soon. Sign in to cancel before:',
    ],
    FAMILY_DELETION_SCHEDULED: [
      'Family deletion scheduled',
      'Your family deletion is scheduled. Open the app to cancel before:',
    ],
    FAMILY_DELETION_REMINDER: [
      'Family deletion reminder',
      'Your family will be deleted soon. Open the app to cancel before:',
    ],
    PHONE_CHANGED: [
      'Security alert',
      'Your sign-in phone number was changed. If this was not you, contact support immediately.',
    ],
    SIGN_IN_METHOD_ADDED: [
      'Security alert',
      'A sign-in method was added to your account. If this was not you, contact support immediately.',
    ],
  },
} as const;
