import 'package:baby_family/app.dart';
import 'package:baby_family/data/remote/request_options.dart';
import 'package:baby_family/utils/helper/app_l10n.dart';
import 'package:baby_family/utils/helper/broadcast_manager.dart';
import 'package:baby_family/utils/helper/local_store.dart';
import 'package:baby_family/utils/helper/server_error_message.dart';
import 'package:baby_family/utils/router/app_router.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

/// Xử lý lỗi dùng chung:
/// - 401 của request cần đăng nhập → xoá phiên, về màn Welcome.
/// - 426 `UPGRADE_REQUIRED` → thông báo cập nhật app.
/// Các lỗi nghiệp vụ khác (403 `FAMILY_NOT_ACTIVE`, 402 `SUBSCRIPTION_REQUIRED`...)
/// để controller tự xử lý theo màn.
class ErrorHandleInterceptor extends QueuedInterceptorsWrapper {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    switch (err.response?.statusCode) {
      case 401:
        final requiresAuth =
            err.requestOptions.extra[RequestOptionsExtra.requiresAuth] == true;
        if (requiresAuth) {
          _handleExpiredSession(serverErrorMessage(err));
        }
        break;
      case 426:
        _showMessage(currentL10n().errorUpgradeRequired);
        break;
    }
    handler.next(err);
  }

  Future<void> _handleExpiredSession(String message) async {
    await LocalStore().clearAuthCertificate();
    BroadcastManager().notifySessionExpired();
    _showMessage(message);
    if (appRouter.current.name != WelcomeRoute.name) {
      await appRouter.replaceAll([const WelcomeRoute()]);
    }
  }

  void _showMessage(String message) {
    scaffoldMessengerKey.currentState
      ?..removeCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }
}
