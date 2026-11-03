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

  /// `deepLink` của thông báo người dùng vừa chạm: lúc app đang tắt
  /// ([initialLink]) hoặc đang chạy nền ([onOpenedLink]) (BF-20261030-005).
  Future<String?> initialLink();

  Stream<String> get onOpenedLink;

  /// Thông báo đến khi app đang mở (hệ điều hành không hiện banner): tiêu đề,
  /// nội dung (đã ẩn với loại nhạy cảm từ server) và deep link.
  Stream<({String title, String body, String? link})> get onForeground;
}
