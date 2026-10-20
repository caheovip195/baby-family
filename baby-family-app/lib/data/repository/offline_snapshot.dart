import 'package:baby_family/data/repository/base.dart';

/// Lưu bản chụp dữ liệu đã đồng bộ trên máy (mã hoá, xoá khi đăng xuất) để
/// mở app lúc mất mạng vẫn giữ phiên.
abstract class IOfflineSnapshotRepository extends IBaseRepository {
  Future<void> save(JsonMap snapshot);

  /// null khi chưa có / hỏng.
  Future<JsonMap?> load();
}
