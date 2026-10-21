import 'package:baby_family/data/repository/base.dart';
import 'package:baby_family/data/repository/local_media_index.dart';
import 'package:baby_family/data/repository_imp/base.dart';
import 'package:baby_family/utils/helper/local_store.dart';

class LocalMediaIndexRepositoryImp extends BaseRepositoryImp
    implements ILocalMediaIndexRepository {
  @override
  Future<JsonMap> load() => LocalStore().getLocalMediaIndex();

  @override
  Future<void> save(JsonMap index) => LocalStore().saveLocalMediaIndex(index);
}
