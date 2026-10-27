import 'package:baby_family/data/repository/base.dart';
import 'package:baby_family/data/repository/local_memory_db.dart';
import 'package:baby_family/data/repository_imp/base.dart';
import 'package:baby_family/utils/helper/local_store.dart';

/// Hive box riêng (`LocalStoreKey.localDbBoxName`), khoá `scope|m|id` (ký ức)
/// và `scope|c|memoryId` (bình luận của ký ức).
class LocalMemoryDbImp extends BaseRepositoryImp implements ILocalMemoryDb {
  static const _schemaKey = 'meta|schema';

  static String _memoryKey(String scope, String id) => '$scope|m|$id';

  @override
  Future<void> ensureSchema(int version) async {
    final stored = (await LocalStore().localRows(_schemaKey))[_schemaKey];
    if (stored == version) {
      return;
    }
    await LocalStore().clearLocalDb();
    await LocalStore().putLocalRows({_schemaKey: version});
  }

  static String _commentsKey(String scope, String id) => '$scope|c|$id';

  @override
  Future<List<JsonMap>> memories(String scope) async => [
    for (final row in (await LocalStore().localRows('$scope|m|')).values)
      if (row is Map) Map<String, dynamic>.from(row),
  ];

  @override
  Future<void> putMemories(String scope, List<JsonMap> rows) =>
      LocalStore().putLocalRows({
        for (final row in rows) _memoryKey(scope, row['id'] as String): row,
      });

  @override
  Future<void> deleteMemories(String scope, Iterable<String> ids) =>
      LocalStore().deleteLocalRows([
        for (final id in ids) _memoryKey(scope, id),
      ]);

  @override
  Future<Map<String, List<JsonMap>>> comments(String scope) async {
    final prefix = '$scope|c|';
    return {
      for (final MapEntry(:key, :value) in (await LocalStore().localRows(
        prefix,
      )).entries)
        if (value is List)
          key.substring(prefix.length): [
            for (final row in value)
              if (row is Map) Map<String, dynamic>.from(row),
          ],
    };
  }

  @override
  Future<void> putComments(String scope, Map<String, List<JsonMap>> byMemory) =>
      LocalStore().putLocalRows({
        for (final MapEntry(:key, :value) in byMemory.entries)
          _commentsKey(scope, key): value,
      });

  @override
  Future<void> deleteComments(String scope, Iterable<String> memoryIds) =>
      LocalStore().deleteLocalRows([
        for (final id in memoryIds) _commentsKey(scope, id),
      ]);
}
