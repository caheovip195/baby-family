import 'package:baby_family/data/service/base.dart';

/// ONB-10 — quyền thông báo và đăng ký push token với server (mục 7.21).
abstract class IPushService extends IBaseService {
  /// Xin quyền (pre-permission đã hiện ở ONB-10) rồi đăng ký token; true khi
  /// người dùng cho phép.
  Future<bool> enable();

  /// Mở app: nếu đã được phép từ trước thì gửi lại token (token có thể đổi).
  Future<void> syncIfAuthorized();
}
