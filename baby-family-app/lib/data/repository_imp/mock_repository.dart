import 'package:baby_family/data/repository/base.dart';
import 'package:baby_family/data/repository_imp/base.dart';
import 'package:baby_family/data/repository_imp/mock_store.dart';

/// Base of the mock repositories: reads/writes [MockStore] instead of
/// `AppClient`. Rows are localized for the current app language.
class MockRepositoryImp extends BaseRepositoryImp {
  MockRepositoryImp(this.store);

  final MockStore store;

  List<JsonMap> rows(String table, [bool Function(JsonMap row)? test]) => [
    for (final row in store.table(table))
      if (test == null || test(row)) store.localized(row),
  ];

  JsonMap? row(String table, String? id) {
    final value = store.find(table, id);
    return value == null ? null : store.localized(value);
  }

  JsonMap insert(String table, JsonMap value) {
    final inserted = store.insert(table, value);
    store.commit();
    return store.localized(inserted);
  }

  void patch(String table, String id, JsonMap value) {
    store.update(table, id, value);
    store.commit();
  }

  void removeRow(String table, String id) {
    store.remove(table, id);
    store.commit();
  }

  /// Non-table fixture data (`MockStore.meta[key]`), localized deep copy.
  JsonMap metaSection(String key) {
    final value = store.meta[key];
    return value is Map
        ? store.localized(Map<String, dynamic>.from(value))
        : <String, dynamic>{};
  }

  /// Localized list stored in `MockStore.meta[key]`.
  List<JsonMap> metaList(String key) => [
    for (final row in (store.meta[key] as List?) ?? const [])
      store.localized(Map<String, dynamic>.from(row as Map)),
  ];

  /// Replaces `MockStore.meta[key]` (settings screens) and notifies.
  void saveMeta(String key, Object value) {
    store.meta[key] = value;
    store.commit();
  }
}
