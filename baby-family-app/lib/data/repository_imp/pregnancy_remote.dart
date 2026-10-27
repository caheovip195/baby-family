import 'package:baby_family/data/model/pregnancy/birth_result_record.dart';
import 'package:baby_family/data/model/pregnancy/journey_record.dart';
import 'package:baby_family/data/model/pregnancy/pregnancy_name_record.dart';
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

  @override
  Future<PregnancyNameList?> names(String pregnancyId) async =>
      (await client!.getPregnancyNames(pregnancyId)).list;

  @override
  Future<PregnancyNameRecord?> addName(
    String pregnancyId,
    JsonMap body,
  ) async => (await client!.addPregnancyName(pregnancyId, body)).name;

  @override
  Future<PregnancyNameRecord?> likeName(
    String nameId, {
    required bool like,
  }) async =>
      (like
              ? await client!.likePregnancyName(nameId)
              : await client!.unlikePregnancyName(nameId))
          .name;

  @override
  Future<PregnancyNameRecord?> chooseName(
    String nameId, {
    required bool choose,
  }) async =>
      (choose
              ? await client!.choosePregnancyName(nameId)
              : await client!.unchoosePregnancyName(nameId))
          .name;
}
