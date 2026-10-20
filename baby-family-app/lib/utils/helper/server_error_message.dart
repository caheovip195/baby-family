import 'package:baby_family/utils/helper/app_l10n.dart';
import 'package:dio/dio.dart';

/// Lấy câu thông báo lỗi hiển thị cho người dùng từ lỗi API.
///
/// Server đã dịch `message` theo `Accept-Language`; khi không có message thì
/// dùng chuỗi l10n của app.
///
/// Định dạng lỗi server (tài liệu kỹ thuật 11.2):
/// `{ "error": { "code", "messageKey", "message", "details", "traceId" } }`.
String serverErrorMessage(Object error, {String? fallback}) {
  if (error is DioException) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.connectionError:
        return currentL10n().errorNetwork;
      default:
        break;
    }
    final message = serverErrorBody(error)?['message'];
    if (message is String && message.isNotEmpty) {
      return message;
    }
  }
  return fallback ?? currentL10n().errorGeneric;
}

/// Mã lỗi nghiệp vụ (`error.code`), ví dụ `FAMILY_NOT_ACTIVE`.
String? serverErrorCode(Object error) {
  if (error is! DioException) {
    return null;
  }
  final code = serverErrorBody(error)?['code'];
  return code is String ? code : null;
}

/// Câu báo lỗi cho thao tác người dùng (đăng nhập/onboarding, lưu/sửa ký ức): rẽ nhánh theo `error.code`
/// rồi lấy chuỗi l10n của app (Skill 10 mục 7); mã lạ → câu chung.
String actionErrorMessage(Object error) {
  if (error is UnsupportedError && error.message != null) {
    return error.message!;
  }
  final l10n = currentL10n();
  return switch (serverErrorCode(error)) {
    'OTP_INVALID' => l10n.errorOtpInvalid,
    'RATE_LIMITED' || 'INVITE_DAILY_LIMIT' => l10n.errorRateLimited,
    'PHONE_NOT_SUPPORTED' => l10n.errorPhoneNotSupported,
    'INVITE_EXPIRED' || 'INVITE_ALREADY_USED' => l10n.errorInviteUnavailable,
    'ALREADY_PARENT_OF_ANOTHER_FAMILY' ||
    'PARENT_SLOTS_FULL' => l10n.errorAlreadyInFamily,
    'SERVICE_UNAVAILABLE' => l10n.errorServiceUnavailable,
    'VERSION_CONFLICT' => l10n.errorVersionConflict,
    'REQUEST_OPEN_LIMIT' => l10n.errorRequestOpenLimit,
    'REQUEST_RESEND_BLOCKED' => l10n.errorRequestResendBlocked,
    'INVALID_REQUEST_TRANSITION' ||
    'REQUEST_REMINDER_USED' => l10n.errorRequestChanged,
    'MEMORY_FIELD_NOT_EDITABLE' ||
    'MEMORY_VISIBILITY_INVALID' => l10n.errorMemoryNotEditable,
    'REAUTH_REQUIRED' => l10n.errorReauthRequired,
    'REAUTH_UNAVAILABLE' => l10n.errorServiceUnavailable,
    'EXPORT_ALREADY_ACTIVE' => l10n.errorExportActive,
    'EXPORT_RATE_LIMITED' => l10n.errorRateLimited,
    'EVENT_DATE_INVALID' ||
    'EVENT_LUNAR_DATE_INVALID' => l10n.errorEventDateInvalid,
    _ when error is DioException && error.response == null => l10n.errorNetwork,
    _ => l10n.errorGeneric,
  };
}

Map<String, dynamic>? serverErrorBody(DioException error) {
  final data = error.response?.data;
  if (data is Map && data['error'] is Map) {
    return Map<String, dynamic>.from(data['error'] as Map);
  }
  return null;
}
