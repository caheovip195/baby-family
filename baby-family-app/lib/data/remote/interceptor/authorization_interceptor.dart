import 'dart:async';

import 'package:baby_family/data/model/auth_certificate.dart';
import 'package:baby_family/data/remote/request_options.dart';
import 'package:baby_family/data/repository_imp/auth.dart';
import 'package:baby_family/utils/constants/values.dart';
import 'package:baby_family/utils/helper/app_l10n.dart';
import 'package:baby_family/utils/helper/local_store.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

/// Gắn access token và giữ phiên bằng refresh token (tài liệu kỹ thuật 5.1).
///
/// Server xoay vòng refresh token: gia hạn thành công thì refresh token cũ hết
/// dùng được (dùng lại sẽ bị coi là đánh cắp và thu hồi cả phiên). Vì vậy:
/// - mọi lần gia hạn đi qua CÙNG một Future [_pendingRenew] — nhiều request
///   đồng thời chỉ gọi server một lần;
/// - server từ chối (400/401/403) → hết phiên, phải đăng nhập lại;
/// - lỗi mạng khi gia hạn → KHÔNG đăng xuất; access token cũ còn hạn thì dùng
///   tiếp, hết hạn thì báo lỗi kết nối để thử lại sau.
class AuthorizationInterceptor extends Interceptor {
  static Future<AuthCertificate?>? _pendingRenew;

  @visibleForTesting
  static Future<AuthCertificate?> Function() readCertificate = () =>
      LocalStore().getAuthCertificate();

  @visibleForTesting
  static Future<void> Function(AuthCertificate certificate) writeCertificate =
      (certificate) async => LocalStore().saveAuthCertificate(certificate);

  @visibleForTesting
  static Future<void> Function() clearCertificate = () async =>
      LocalStore().clearAuthCertificate();

  @visibleForTesting
  static Future<AuthCertificate> Function(String refreshToken) requestRefresh =
      (refreshToken) => AuthRepositoryImp().refreshToken(refreshToken);

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    if (options.extra[RequestOptionsExtra.requiresAuth] != true) {
      options.headers.remove('authorization');
      handler.next(options);
      return;
    }

    final certificate = await readCertificate();
    if (certificate?.accessToken == null) {
      handler.next(options);
      return;
    }
    if (!_needsRenewAt(certificate!, DateTime.now())) {
      _attachToken(options, certificate);
      handler.next(options);
      return;
    }

    final renewed = await (_pendingRenew ??= _renew().whenComplete(
      () => _pendingRenew = null,
    ));
    if (renewed?.accessToken != null &&
        !_isAccessExpiredAt(renewed!, DateTime.now())) {
      _attachToken(options, renewed);
      handler.next(options);
      return;
    }

    if (await readCertificate() != null) {
      // Chứng chỉ còn (gia hạn hỏng vì mạng): báo lỗi kết nối, giữ phiên.
      handler.reject(
        DioException(
          requestOptions: options,
          type: DioExceptionType.connectionError,
          message: currentL10n().errorRenewSessionNetwork,
        ),
        true,
      );
      return;
    }
    handler.reject(
      DioException(
        requestOptions: options,
        type: DioExceptionType.badResponse,
        response: Response(
          requestOptions: options,
          statusCode: 401,
          data: {
            'error': {
              'code': 'AUTH_SESSION_EXPIRED',
              'message': currentL10n().errorSessionExpired,
            },
          },
        ),
      ),
      true,
    );
  }

  static Future<AuthCertificate?> _renew() async {
    final certificate = await readCertificate();
    final refreshToken = certificate?.refreshToken;
    if (certificate == null || refreshToken == null || refreshToken.isEmpty) {
      return null;
    }
    if (!_needsRenewAt(certificate, DateTime.now())) {
      // Request khác vừa gia hạn xong.
      return certificate;
    }
    try {
      final fresh = await requestRefresh(refreshToken);
      final updated = fresh.copyWith(
        user: fresh.user ?? certificate.user,
        expiredAccessTokenDateTime: DateTime.now().add(
          Duration(seconds: fresh.expiresIn ?? 0),
        ),
      );
      await writeCertificate(updated);
      return updated;
    } catch (e) {
      Logger().e('Gia hạn phiên thất bại: $e');
      if (_isRefreshRejected(e)) {
        await clearCertificate();
        return null;
      }
      return _isAccessExpiredAt(certificate, DateTime.now())
          ? null
          : certificate;
    }
  }

  static bool _needsRenewAt(AuthCertificate certificate, DateTime now) {
    final expiredAt = certificate.expiredAccessTokenDateTime;
    return expiredAt == null ||
        now.isAfter(
          expiredAt.subtract(
            const Duration(seconds: kValueRenewAccessTokenBefore),
          ),
        );
  }

  static bool _isAccessExpiredAt(AuthCertificate certificate, DateTime now) {
    final expiredAt = certificate.expiredAccessTokenDateTime;
    return expiredAt == null || !now.isBefore(expiredAt);
  }

  static bool _isRefreshRejected(Object error) {
    if (error is! DioException) {
      return false;
    }
    final status = error.response?.statusCode;
    return status == 400 || status == 401 || status == 403;
  }

  void _attachToken(RequestOptions options, AuthCertificate certificate) {
    options.headers['authorization'] = 'Bearer ${certificate.accessToken}';
  }
}
