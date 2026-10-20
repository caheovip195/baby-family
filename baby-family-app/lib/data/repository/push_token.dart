import 'package:baby_family/data/repository/base.dart';

/// Nguồn quyền thông báo + push token của máy (FCM). Tách khỏi service để
/// test thay bằng bản giả, không gọi plugin nền tảng.
abstract class IPushTokenRepository extends IBaseRepository {
  /// Hộp thoại xin quyền của hệ điều hành; true khi được phép.
  Future<bool> requestPermission();

  /// Đã được phép từ trước (không hỏi lại).
  Future<bool> isAuthorized();

  /// FCM registration token; null khi Firebase chưa sẵn sàng.
  Future<String?> token();

  /// Token đổi (cài lại app, FCM xoay token).
  Stream<String> get onTokenRefresh;
}
