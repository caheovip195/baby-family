import 'package:baby_family/data/model/growth/growth_entry.dart';
import 'package:baby_family/data/repository/base.dart';
import 'package:baby_family/data/repository/growth_remote.dart';
import 'package:baby_family/data/repository_imp/base.dart';

class GrowthRemoteRepositoryImp extends BaseRepositoryImp
    implements IGrowthRemoteRepository {
  @override
  Future<GrowthListRecord?> list(String childId) async =>
      (await client!.getGrowth(childId)).growth;

  @override
  Future<GrowthEntry?> put(String childId, String date, JsonMap body) async =>
      (await client!.putGrowth(childId, date, body)).entry;

  @override
  Future<void> delete(String childId, String date) =>
      client!.deleteGrowth(childId, date);
}
