import 'package:baby_family/data/model/child/child_record.dart';
import 'package:baby_family/data/model/child/child_stats_record.dart';
import 'package:baby_family/data/model/pregnancy/pregnancy_record.dart';
import 'package:baby_family/data/model/recap/week_stats_record.dart';
import 'package:baby_family/data/repository/base.dart';
import 'package:baby_family/data/repository/subject.dart';
import 'package:baby_family/data/repository_imp/base.dart';

class SubjectRepositoryImp extends BaseRepositoryImp
    implements ISubjectRepository {
  @override
  Future<ChildRecord?> createChild(String familyId, JsonMap body) async {
    final rs = await client!.createChild(familyId, body);
    return rs.child;
  }

  @override
  Future<ChildRecord?> updateChild(
    String familyId,
    String childId,
    JsonMap body,
  ) async {
    final rs = await client!.updateChild(familyId, childId, body);
    return rs.child;
  }

  @override
  Future<PregnancyRecord?> createPregnancy(
    String familyId,
    JsonMap body,
  ) async {
    final rs = await client!.createPregnancy(familyId, body);
    return rs.pregnancy;
  }

  @override
  Future<PregnancyRecord?> updatePregnancy(
    String familyId,
    String pregnancyId,
    JsonMap body,
  ) async {
    final rs = await client!.updatePregnancy(familyId, pregnancyId, body);
    return rs.pregnancy;
  }

  @override
  Future<void> reorderChildren(String familyId, List<String> childIds) =>
      client!.reorderChildren(familyId, {'childIds': childIds});

  @override
  Future<void> archiveChild(String childId) => client!.archiveChild(childId);

  @override
  Future<void> restoreChild(String childId) => client!.restoreChild(childId);

  @override
  Future<void> deleteChild(String childId, {required String confirmName}) =>
      client!.deleteChild(childId, {'confirmName': confirmName});

  @override
  Future<void> setChildAvatar(String childId, String? assetId) =>
      client!.setChildAvatar(childId, {'assetId': assetId});

  @override
  Future<void> setChildCover(String childId, String? assetId) =>
      client!.setChildCover(childId, {'assetId': assetId});

  @override
  Future<ChildStatsRecord?> childStats(String childId) async {
    final rs = await client!.getChildStats(childId);
    return rs.stats;
  }

  @override
  Future<WeekStatsRecord?> weekStats(String familyId) async =>
      (await client!.getWeekStats(familyId)).stats;
}
