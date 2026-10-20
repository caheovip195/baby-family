import 'package:baby_family/data/service/push.dart';
import 'package:flutter/foundation.dart';
import 'package:permission_handler/permission_handler.dart';

/// Bản mock: chỉ hộp thoại quyền của hệ điều hành, không đăng ký token.
class PushServiceImp implements IPushService {
  @override
  Future<bool> enable() async {
    try {
      return (await Permission.notification.request()).isGranted;
    } on Object catch (error) {
      // Giả lập / test không có plugin.
      debugPrint('notification permission failed: $error');
      return false;
    }
  }

  @override
  Future<void> syncIfAuthorized() async {}
}
