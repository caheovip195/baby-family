import 'package:baby_family/data/repository/base.dart';
import 'package:baby_family/data/repository/local_db.dart';

/// Local DB bảng giả, giữ qua nhiều instance service (tắt / mở lại app).
class FakeLocalDb implements ILocalDb {
  /// `scope|table` → id → dòng.
  final tables = <String, Map<String, JsonMap>>{};
  int? schema;

  Map<String, JsonMap> table(String scope, String name) =>
      tables['$scope|$name'] ??= {};

  @override
  Future<void> ensureSchema(int version) async {
    if (schema != version) {
      tables.clear();
      schema = version;
    }
  }

  @override
  Future<List<JsonMap>> rows(String scope, String table) async => [
    ...this.table(scope, table).values,
  ];

  @override
  Future<void> putRows(String scope, String table, List<JsonMap> rows) async {
    for (final row in rows) {
      this.table(scope, table)[row['id'] as String] = row;
    }
  }

  @override
  Future<void> deleteRows(
    String scope,
    String table,
    Iterable<String> ids,
  ) async => ids.forEach(this.table(scope, table).remove);
}
