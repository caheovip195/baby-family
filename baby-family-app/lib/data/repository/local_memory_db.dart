import 'package:baby_family/data/repository/base.dart';

/// Local DB bền vững của ký ức và bình luận đã đồng bộ (offline-first,
/// BF-20261022-003): mỗi ký ức / danh sách bình luận của một ký ức là một dòng
/// mã hoá, ghi tăng dần, xoá khi đăng xuất. [scope] là id gia đình server.
abstract class ILocalMemoryDb extends IBaseRepository {
  /// Định dạng dòng đã lưu khác bản app hiện tại (app cập nhật đổi cấu trúc)
  /// → xoá sạch; dữ liệu được tải lại từ server, không đọc dòng cũ.
  Future<void> ensureSchema(int version);

  Future<List<JsonMap>> memories(String scope);

  Future<void> putMemories(String scope, List<JsonMap> rows);

  Future<void> deleteMemories(String scope, Iterable<String> ids);

  /// memoryId → bình luận (dạng `MemoryComment.toJson`).
  Future<Map<String, List<JsonMap>>> comments(String scope);

  Future<void> putComments(String scope, Map<String, List<JsonMap>> byMemory);

  Future<void> deleteComments(String scope, Iterable<String> memoryIds);
}
