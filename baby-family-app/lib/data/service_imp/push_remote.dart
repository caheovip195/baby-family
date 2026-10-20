import 'dart:async';
import 'dart:io';

import 'package:baby_family/data/repository/auth.dart';
import 'package:baby_family/data/repository/push_token.dart';
import 'package:baby_family/data/service/auth.dart';
import 'package:baby_family/data/service/push.dart';
import 'package:baby_family/utils/helper/app_l10n.dart';
import 'package:logger/logger.dart';

/// ONB-10 qua server thật (BF-20261018-014): xin quyền FCM, gửi
/// `POST /v1/me/devices {platform, locale, pushToken, pushEnabled}` cho thiết
/// bị của phiên hiện tại; theo dõi token đổi. Server tự áp giờ yên tĩnh, trần
/// 3 thông báo/ngày và ẩn nội dung nhạy cảm trên màn khoá.
class PushRemoteServiceImp implements IPushService {
  PushRemoteServiceImp(
    this._auth,
    this._authRepository,
    this._tokens, {
    String Function()? platform,
  }) : _platform = platform ?? (() => Platform.isIOS ? 'IOS' : 'ANDROID');

  final IAuthService _auth;
  final IAuthRepository _authRepository;
  final IPushTokenRepository _tokens;
  final String Function() _platform;
  StreamSubscription<String>? _refresh;

  /// Gọi khi provider bị huỷ.
  Future<void> dispose() async {
    await _refresh?.cancel();
    _refresh = null;
  }

  @override
  Future<bool> enable() async {
    final allowed = await _tokens.requestPermission();
    await _register(allowed);
    return allowed;
  }

  @override
  Future<void> syncIfAuthorized() async {
    if (await _tokens.isAuthorized()) {
      await _register(true);
    }
  }

  Future<void> _register(bool allowed) async {
    if (await _auth.currentSession() == null) {
      return;
    }
    final token = allowed ? await _tokens.token() : null;
    await _send(token, allowed);
    if (allowed) {
      _refresh ??= _tokens.onTokenRefresh.listen(
        (next) => unawaited(_send(next, true)),
      );
    }
  }

  Future<void> _send(String? token, bool allowed) async {
    try {
      await _authRepository.registerDevice({
        'platform': _platform(),
        'locale': currentAppLanguage().code,
        'pushEnabled': allowed && token != null,
        // null xoá token cũ khi người dùng tắt quyền.
        'pushToken': allowed ? token : null,
      });
    } on Object catch (error) {
      Logger().w('Đăng ký push token thất bại: $error');
    }
  }
}
