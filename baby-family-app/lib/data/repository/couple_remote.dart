import 'package:baby_family/data/model/us/appreciation_record.dart';
import 'package:baby_family/data/model/us/appreciation_wall.dart';
import 'package:baby_family/data/model/us/checkin_record.dart';
import 'package:baby_family/data/model/us/checkin_today.dart';
import 'package:baby_family/data/model/us/journal_entry_record.dart';
import 'package:baby_family/data/model/us/journal_list.dart';
import 'package:baby_family/data/model/us/request_created.dart';
import 'package:baby_family/data/model/us/request_list.dart';
import 'package:baby_family/data/model/us/request_record.dart';
import 'package:baby_family/data/model/us/us_settings_record.dart';
import 'package:baby_family/data/repository/base.dart';

/// Papa & Mama trên server (US-01…04, tài liệu kỹ thuật 15.8).
abstract class ICoupleRemoteRepository extends IBaseRepository {
  Future<CheckinRecord?> createCheckin(String familyId, JsonMap body);

  Future<CheckinToday?> checkinsToday(String familyId);

  Future<RequestCreated?> createRequest(
    String familyId,
    String idempotencyKey,
    JsonMap body,
  );

  Future<RequestList?> requests(
    String familyId, {
    String? box,
    String? cursor,
    int? limit,
  });

  Future<AppreciationRecord?> createAppreciation(String familyId, JsonMap body);

  /// US-05: đề nghị đăng lời cảm ơn thành khoảnh khắc gia đình.
  Future<void> requestAppreciationShare(String familyId, String appreciationId);

  /// Bạn đời duyệt ([approve]) / không duyệt đăng lời cảm ơn lên gia đình.
  Future<void> respondAppreciationShare(
    String familyId,
    String appreciationId, {
    required bool approve,
  });

  /// Bức tường cảm ơn; [month] dạng `yyyy-MM`.
  Future<AppreciationWall?> appreciations(
    String familyId, {
    String? cursor,
    int? limit,
    String? month,
  });

  Future<AppreciationRecord?> reactAppreciation(
    String familyId,
    String appreciationId,
    String reaction,
  );

  Future<JournalList?> journal(String familyId, {String? cursor, int? limit});

  Future<JournalEntryRecord?> createJournalEntry(String familyId, JsonMap body);

  Future<void> shareJournalExcerpt(
    String familyId,
    String entryId,
    String excerpt,
  );

  /// Chuyển trạng thái lời nhờ ([action] theo state machine 15.8).
  Future<RequestRecord?> requestAction(
    String familyId,
    String requestId,
    String action, [
    JsonMap body = const {},
  ]);

  /// US-15: cài đặt Papa & Mama của chính tôi.
  Future<UsSettingsRecord?> usSettings();

  Future<UsSettingsRecord?> updateUsSettings(JsonMap patch);
}
