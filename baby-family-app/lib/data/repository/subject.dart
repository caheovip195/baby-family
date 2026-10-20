import 'package:baby_family/data/model/child/child_record.dart';
import 'package:baby_family/data/model/child/child_stats_record.dart';
import 'package:baby_family/data/model/pregnancy/pregnancy_record.dart';
import 'package:baby_family/data/model/recap/week_stats_record.dart';
import 'package:baby_family/data/repository/base.dart';

/// Hồ sơ bé và thai kỳ trên server (tài liệu kỹ thuật 11.3; ONB-04/05, CHD-*,
/// PREG-*).
abstract class ISubjectRepository extends IBaseRepository {
  /// `POST /v1/families/{fid}/children`.
  Future<ChildRecord?> createChild(String familyId, JsonMap body);

  /// `PATCH /v1/families/{fid}/children/{id}`.
  Future<ChildRecord?> updateChild(
    String familyId,
    String childId,
    JsonMap body,
  );

  /// `POST /v1/families/{fid}/pregnancies`.
  Future<PregnancyRecord?> createPregnancy(String familyId, JsonMap body);

  /// `PATCH /v1/families/{fid}/pregnancies/{id}`.
  Future<PregnancyRecord?> updatePregnancy(
    String familyId,
    String pregnancyId,
    JsonMap body,
  );

  /// CHD-03: mọi bé đang hoạt động, mỗi bé đúng một lần.
  Future<void> reorderChildren(String familyId, List<String> childIds);

  /// CHD-05.
  Future<void> archiveChild(String childId);

  Future<void> restoreChild(String childId);

  Future<void> deleteChild(String childId, {required String confirmName});

  /// Ảnh đại diện / ảnh bìa: [assetId] null = gỡ ảnh.
  Future<void> setChildAvatar(String childId, String? assetId);

  Future<void> setChildCover(String childId, String? assetId);

  /// CHD-01.
  Future<ChildStatsRecord?> childStats(String childId);

  /// HOME-01: số liệu tuần này của gia đình theo quyền xem.
  Future<WeekStatsRecord?> weekStats(String familyId);
}
