import 'package:baby_family/data/repository/base.dart';
import 'package:baby_family/data/repository/local_db.dart';
import 'package:baby_family/data/repository_imp/base.dart';
import 'package:baby_family/data/repository_imp/local_memory_db.dart';
import 'package:baby_family/utils/helper/local_store.dart';

class LocalDbImp extends BaseRepositoryImp implements ILocalDb {
  static String _prefix(String scope, String table) => '$scope|t:$table|';

  /// Cùng khoá schema với DB ký ức (một box, một phiên bản).
  @override
  Future<void> ensureSchema(int version) =>
      LocalMemoryDbImp().ensureSchema(version);

  @override
  Future<List<JsonMap>> rows(String scope, String table) async => [
    for (final row in (await LocalStore().localRows(
      _prefix(scope, table),
    )).values)
      if (row is Map) Map<String, dynamic>.from(row),
  ];

  @override
  Future<void> putRows(String scope, String table, List<JsonMap> rows) =>
      LocalStore().putLocalRows({
        for (final row in rows) '${_prefix(scope, table)}${row['id']}': row,
      });

  @override
  Future<void> deleteRows(String scope, String table, Iterable<String> ids) =>
      LocalStore().deleteLocalRows([
        for (final id in ids) '${_prefix(scope, table)}$id',
      ]);
}
