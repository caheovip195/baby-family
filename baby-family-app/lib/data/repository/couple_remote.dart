import 'package:baby_family/data/model/us/appreciation_record.dart';
import 'package:baby_family/data/model/us/appreciation_wall.dart';
import 'package:baby_family/data/model/us/bridge_session_record.dart';
import 'package:baby_family/data/model/us/care_handoff.dart';
import 'package:baby_family/data/model/us/checkin_record.dart';
import 'package:baby_family/data/model/us/checkin_today.dart';
import 'package:baby_family/data/model/us/couple_question_record.dart';
import 'package:baby_family/data/model/us/journal_entry_record.dart';
import 'package:baby_family/data/model/us/journal_list.dart';
import 'package:baby_family/data/model/us/request_created.dart';
import 'package:baby_family/data/model/us/request_list.dart';
import 'package:baby_family/data/model/us/request_record.dart';
import 'package:baby_family/data/model/us/us_settings_record.dart';
import 'package:baby_family/data/repository/base.dart';

/// Papa & Mama trên server (US-01…04, tài liệu kỹ thuật 15.8).
abstract class ICoupleRemoteRepository extends IBaseRepository {
  /// [idempotencyKey]: gửi lại từ outbox không tạo trùng (offline-first).
  Future<CheckinRecord?> createCheckin(
    String familyId,
    JsonMap body, {
    String? idempotencyKey,
  });

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

  Future<AppreciationRecord?> createAppreciation(
    String familyId,
    JsonMap body, {
    String? idempotencyKey,
  });

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

  Future<JournalEntryRecord?> createJournalEntry(
    String familyId,
    JsonMap body, {
    String? idempotencyKey,
  });

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

  /// Cầu nối (BF-20261028-008).
  Future<BridgeSessionRecord?> createBridge(
    String familyId,
    String idempotencyKey,
    JsonMap body,
  );

  Future<List<BridgeSessionRecord>> bridges(String familyId);

  Future<BridgeSessionRecord?> bridge(String familyId, String sessionId);

  Future<BridgeSessionRecord?> bridgeAction(
    String familyId,
    String sessionId,
    String action, [
    JsonMap body = const {},
  ]);

  Future<BridgeSessionRecord?> bridgeNextStep(
    String familyId,
    String sessionId,
    JsonMap body,
  );

  /// Bàn giao ca (BF-20261028-007).
  Future<CareHandoff?> createHandoff(
    String familyId,
    String idempotencyKey,
    JsonMap body,
  );

  Future<List<CareHandoff>> handoffs(String familyId);

  Future<CareHandoff?> acknowledgeHandoff(String familyId, String handoffId);

  /// Câu hỏi kết nối hôm nay (BF-20261027-002).
  Future<CoupleQuestionRecord?> questionToday(String familyId);

  Future<CoupleQuestionRecord?> answerQuestion(String familyId, String answer);

  /// US-14 Tuần của hai ta.
  Future<CoupleWeekRecord?> week(String familyId, {String? weekStart});
}
