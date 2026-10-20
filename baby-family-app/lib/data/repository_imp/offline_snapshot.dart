import 'package:baby_family/data/repository/base.dart';
import 'package:baby_family/data/repository/offline_snapshot.dart';
import 'package:baby_family/data/repository_imp/base.dart';
import 'package:baby_family/utils/helper/local_store.dart';

class OfflineSnapshotRepositoryImp extends BaseRepositoryImp
    implements IOfflineSnapshotRepository {
  @override
  Future<void> save(JsonMap snapshot) =>
      LocalStore().saveOfflineSnapshot(snapshot);

  @override
  Future<JsonMap?> load() => LocalStore().getOfflineSnapshot();
}
