/// Phân loại lỗi trước khi đẩy lên Crashlytics.
///
/// Trước đây mọi lỗi đều được ghi là `fatal: true`, nên Crashlytics đầy những
/// thứ không phải sự cố của app: máy mất mạng giữa chừng, ảnh tin tức tải dở,
/// FCM đăng ký hỏng vì thiếu Google Play, người dùng bấm 2 lần vào nút xin
/// quyền... Những lỗi này vẫn cần thấy được nên vẫn ghi nhận, nhưng ghi ở mức
/// **non-fatal** để không phá chỉ số crash-free và không lấp mất crash thật.
library;

import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/services.dart';

/// Lỗi mạng/hạ tầng ngoài tầm kiểm soát của app.
bool _isTransientNetworkError(Object error) {
  if (error is SocketException ||
      error is HttpException ||
      error is HandshakeException ||
      error is TimeoutException) {
    return true;
  }
  if (error is DioException) {
    return switch (error.type) {
      DioExceptionType.connectionTimeout ||
      DioExceptionType.sendTimeout ||
      DioExceptionType.receiveTimeout ||
      DioExceptionType.connectionError ||
      DioExceptionType.cancel => true,
      DioExceptionType.unknown =>
        error.error is SocketException ||
            error.error is HttpException ||
            error.error is HandshakeException,
      _ => false,
    };
  }
  return false;
}

/// Lỗi từ plugin nền tảng đã biết rõ, không phải sự cố cần sửa gấp.
bool _isKnownPlatformNoise(Object error) {
  if (error is! PlatformException) {
    return false;
  }
  final code = error.code;
  final message = error.message ?? '';
  // Người dùng bấm liên tiếp làm 2 lần xin quyền chồng nhau.
  if (message.contains('permissions is already running')) {
    return true;
  }
  return switch (code) {
    // Máy không có app nào mở được deep link / link ngoài.
    'ACTIVITY_NOT_FOUND' => true,
    // Máy thiếu Google Play Services hoặc không có mạng lúc lấy FCM token.
    'firebase_messaging/unknown' => message.contains('FCM Registration failed'),
    _ => false,
  };
}

/// Lỗi này có nên tính là crash của app hay không.
///
/// Trả `false` thì vẫn gửi lên Crashlytics nhưng ở mức non-fatal.
bool isFatalAppError(Object error) =>
    !_isTransientNetworkError(error) && !_isKnownPlatformNoise(error);
