import 'package:baby_family/data/repository/base.dart';

/// Micro của máy (ghi âm VOICE): AAC/m4a vào thư mục tạm của app.
abstract class IVoiceRecorderRepository extends IBaseRepository {
  /// Hỏi/kiểm quyền micro; false khi người dùng từ chối.
  Future<bool> hasPermission();

  /// Bắt đầu ghi vào [path] (`.m4a`).
  Future<void> start(String path);

  /// Dừng; trả đường dẫn tệp đã ghi (null khi chưa ghi gì).
  Future<String?> stop();

  /// Huỷ bản đang ghi (xoá tệp).
  Future<void> cancel();

  Future<void> dispose();
}
