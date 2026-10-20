import 'package:baby_family/data/model/pregnancy/birth_result_record.dart';
import 'package:baby_family/data/model/pregnancy/journey_record.dart';
import 'package:baby_family/data/model/pregnancy/prep_group_record.dart';
import 'package:baby_family/data/model/pregnancy/prep_item_record.dart';
import 'package:baby_family/data/repository/base.dart';

/// Thai kỳ trên server (PREG-01/04/05/06).
abstract class IPregnancyRemoteRepository extends IBaseRepository {
  Future<JourneyRecord?> journey(String pregnancyId, {int? week});

  Future<List<PrepGroupRecord>> prepItems(String pregnancyId);

  Future<PrepItemRecord?> createPrep(
    String pregnancyId, {
    required String groupCode,
    required String title,
  });

  Future<PrepItemRecord?> updatePrep(String itemId, JsonMap patch);

  Future<BirthResultRecord?> convert(
    String pregnancyId,
    String idempotencyKey,
    JsonMap body,
  );

  /// [reason] = `ARCHIVED` | `ENDED_PRIVATE`.
  Future<void> archive(String pregnancyId, String reason);
}
