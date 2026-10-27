import 'package:baby_family/data/repository/base.dart';

/// Local DB dạng bảng dùng chung (offline-first, BF-20261022-004): mỗi dòng
/// `scope|t:<table>|<id>` một giá trị mã hoá, cùng box với ký ức
/// ([ILocalMemoryDb]); xoá khi đăng xuất. [scope] là id gia đình server.
abstract class ILocalDb extends IBaseRepository {
  /// Định dạng đã lưu khác bản app hiện tại → xoá sạch, tải lại từ server.
  Future<void> ensureSchema(int version);

  Future<List<JsonMap>> rows(String scope, String table);

  /// Ghi đè các dòng theo `id`.
  Future<void> putRows(String scope, String table, List<JsonMap> rows);

  Future<void> deleteRows(String scope, String table, Iterable<String> ids);
}
