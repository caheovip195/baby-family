import 'package:baby_family/data/repository/base.dart';
import 'package:baby_family/data/repository/local_memory_db.dart';

/// Local DB giả, giữ qua nhiều instance service (mô phỏng tắt / mở lại app).
class FakeLocalMemoryDb implements ILocalMemoryDb {
  final rows = <String, Map<String, JsonMap>>{};
  final commentRows = <String, Map<String, List<JsonMap>>>{};
  int? schema;
  int writes = 0;

  @override
  Future<void> ensureSchema(int version) async {
    if (schema != version) {
      rows.clear();
      commentRows.clear();
      schema = version;
    }
  }

  @override
  Future<List<JsonMap>> memories(String scope) async => [
    ...?rows[scope]?.values,
  ];

  @override
  Future<void> putMemories(String scope, List<JsonMap> list) async {
    writes += list.length;
    final table = rows[scope] ??= {};
    for (final row in list) {
      table[row['id'] as String] = row;
    }
  }

  @override
  Future<void> deleteMemories(String scope, Iterable<String> ids) async =>
      ids.forEach(rows[scope]?.remove ?? (_) {});

  @override
  Future<Map<String, List<JsonMap>>> comments(String scope) async => {
    ...?commentRows[scope],
  };

  @override
  Future<void> putComments(
    String scope,
    Map<String, List<JsonMap>> byMemory,
  ) async => (commentRows[scope] ??= {}).addAll(byMemory);

  @override
  Future<void> deleteComments(String scope, Iterable<String> memoryIds) async =>
      memoryIds.forEach(commentRows[scope]?.remove ?? (_) {});
}
