import 'package:baby_family/data/model/pregnancy/birth_result_record.dart';
import 'package:baby_family/data/model/pregnancy/journey_record.dart';
import 'package:baby_family/data/model/pregnancy/prep_group_record.dart';
import 'package:baby_family/data/model/pregnancy/prep_item_record.dart';
import 'package:baby_family/data/repository/base.dart';
import 'package:baby_family/data/repository/pregnancy_remote.dart';
import 'package:baby_family/data/repository_imp/base.dart';

class PregnancyRemoteRepositoryImp extends BaseRepositoryImp
    implements IPregnancyRemoteRepository {
  @override
  Future<JourneyRecord?> journey(String pregnancyId, {int? week}) async {
    final rs = await client!.getPregnancyJourney(pregnancyId, week: week);
    return rs.journey;
  }

  @override
  Future<List<PrepGroupRecord>> prepItems(String pregnancyId) async {
    final rs = await client!.getPrepItems(pregnancyId);
    return rs.groups ?? const [];
  }

  @override
  Future<PrepItemRecord?> createPrep(
    String pregnancyId, {
    required String groupCode,
    required String title,
  }) async {
    final rs = await client!.createPrepItem(pregnancyId, {
      'groupCode': groupCode,
      'title': title,
    });
    return rs.item;
  }

  @override
  Future<PrepItemRecord?> updatePrep(String itemId, JsonMap patch) async {
    final rs = await client!.updatePrepItem(itemId, patch);
    return rs.item;
  }

  @override
  Future<BirthResultRecord?> convert(
    String pregnancyId,
    String idempotencyKey,
    JsonMap body,
  ) async {
    final rs = await client!.convertPregnancy(
      pregnancyId,
      idempotencyKey,
      body,
    );
    return rs.result;
  }

  @override
  Future<void> archive(String pregnancyId, String reason) =>
      client!.archivePregnancy(pregnancyId, {'reason': reason});
}
