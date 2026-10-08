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

Map<String, dynamic>? serverErrorBody(DioException error) {
  final data = error.response?.data;
  if (data is Map && data['error'] is Map) {
    return Map<String, dynamic>.from(data['error'] as Map);
  }
  return null;
}
