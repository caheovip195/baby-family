import 'package:baby_family/data/model/sync/outbox_entry.dart';
import 'package:baby_family/data/repository/base.dart';

/// Hàng đợi thao tác ghi chờ đồng bộ (offline-first, BF-20261022-001/002): lưu
/// trên máy (mã hoá, xoá khi đăng xuất) để còn sau khi tắt app.
abstract class IOutboxRepository extends IBaseRepository {
  Future<List<OutboxEntry>> load();

  Future<void> save(List<OutboxEntry> entries);

  /// Cursor của changes API theo phạm vi (vd id gia đình server); null = chưa
  /// đồng bộ lần nào.
  Future<String?> cursor(String scope);

  Future<void> saveCursor(String scope, String? cursor);

  /// Sao file media vào thư mục của app (file picker có thể bị hệ điều hành
  /// dọn) — trả đường dẫn mới, cùng thứ tự.
  Future<List<String>> keepFiles(String entryId, List<String> paths);

  /// Xoá các bản sao của [entryId] (đã gửi xong hoặc người dùng huỷ).
  Future<void> discardFiles(String entryId);

  /// Xoá bản sao của các thao tác đã xong (gọi lúc mở app: ký ức vừa đăng có
  /// thể còn hiển thị file trên máy tới lần đồng bộ sau).
  Future<void> pruneFiles(Set<String> keep);
}
