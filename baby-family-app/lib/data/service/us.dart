import 'package:baby_family/data/dto/couple_today.dart';
import 'package:baby_family/data/model/us/bridge_next_step.dart';
import 'package:baby_family/data/model/us/bridge_option.dart';
import 'package:baby_family/data/model/us/bridge_session.dart';
import 'package:baby_family/data/model/us/couple_request.dart';
import 'package:baby_family/data/model/us/couple_settings.dart';
import 'package:baby_family/data/model/us/couple_week.dart';
import 'package:baby_family/data/model/us/journal_entry.dart';
import 'package:baby_family/data/model/us/mood_checkin.dart';
import 'package:baby_family/data/model/us/rewrite_suggestion.dart';
import 'package:baby_family/data/model/us/safety_hotline.dart';
import 'package:baby_family/data/model/us/thanks.dart';
import 'package:baby_family/data/service/base.dart';
import 'package:baby_family/utils/constants/enum.dart';

/// Papa & Mama — vùng riêng của hai người (US-01…05, mục 7.16). Người thân
/// không bao giờ đọc được dữ liệu này (BR-070).
abstract class IUsService extends IBaseService {
  /// Hub US-01 + thẻ Papa & Mama ở HOME-01.
  Future<CoupleToday> coupleToday();

  /// US-02: lưu check-in của tôi (mặc định chia sẻ với bạn đời).
  Future<MoodCheckin> checkIn({
    required MoodCode mood,
    int energy = 3,
    List<CoupleNeed> needs = const [],
    String? note,
    bool shared = true,
  });

  /// Tất cả lời nhờ giữa hai người, mới nhất trước.
  Future<List<CoupleRequest>> requests({bool openOnly = false});

  Future<CoupleRequest?> request(String id);

  /// US-03: gửi lời nhờ cho bạn đời. Tối đa 5 lời nhờ đang mở (BR-067).
  Future<CoupleRequest> sendRequest({
    RequestKind kind = RequestKind.task,
    String? templateCode,
    CoupleNeed? needCode,
    String title = '',
    String? message,
    List<String> childIds = const [],
    String? dueLabel,
    DateTime? dueAt,
    int? durationMin,
    RequestUrgency urgency = RequestUrgency.normal,
  });

  Future<void> markSeen(String id);

  Future<void> accept(String id);

  /// “Hôm nay không được” — không bị trừ gì (BR-067).
  Future<void> decline(String id, {String? reason});

  /// Đã xong — lời nhờ một việc: +5 Hearts cho người làm (BR-068).
  Future<void> markDone(String id);

  /// NEED: Đã thấy / Gửi 🤗.
  Future<void> acknowledge(String id);

  Future<void> cancel(String id);

  /// US-04b “Nhắc mình lúc 19:30”.
  Future<void> setReminder(String id, DateTime at);

  /// US-05.
  Future<Thanks> sendThanks({
    required String body,
    String? sticker,
    String? missionId,
    String? memoryId,
  });

  Future<List<Thanks>> thanks();

  Future<void> answerQuestion(String answer);

  // --- Batch 2 (US-06/07/15) ---

  /// US-06: lời cảm ơn hai chiều trong tháng [month] (null = tất cả), theo
  /// thứ tự bức tường của thiết kế rồi mới nhất trước.
  Future<List<Thanks>> thanksWall({DateTime? month});

  /// Thả / bỏ tim một lời cảm ơn.
  Future<void> toggleThanksHeart(String thanksId);

  /// US-07: nhật ký riêng của tôi, mới nhất trước — không bao giờ của bạn đời.
  Future<List<JournalEntry>> journal();

  Future<JournalEntry> addJournalEntry({
    required JournalMood mood,
    required String title,
    String body,
    String? photoAsset,
  });

  /// “Chia sẻ đoạn này với bạn đời”.
  Future<void> shareJournalExcerpt(String entryId);

  /// US-15 (cài đặt của riêng tôi).
  Future<CoupleSettings> coupleSettings();

  Future<void> saveCoupleSettings(CoupleSettings settings);

  // --- Batch 3 (US-08…14) ---

  /// Catalog Cầu nối (đã dịch): `feelings`, `needs`, `nextSteps`
  /// (`{partner}` trong tiêu đề = tên gọi bạn đời).
  Future<List<BridgeOption>> bridgeOptions(String group);

  /// US-08: nháp riêng của tôi (bước 3/5 theo thiết kế).
  Future<BridgeSession?> bridgeDraft();

  Future<void> saveBridgeDraft(BridgeSession draft);

  /// US-10/11/12: phiên đang mở giữa hai người (không gồm nháp).
  Future<BridgeSession?> bridgeSession(String id);

  Future<List<BridgeSession>> bridgeSessions();

  /// Gửi lời mời từ nháp → `invited`.
  Future<void> sendBridgeInvite(String draftId);

  /// US-10 “Tham gia ngay” → `active`.
  Future<void> joinBridge(String sessionId);

  /// US-10 “Để sau” / US-11 “Tạm dừng”.
  Future<void> pauseBridge(String sessionId);

  /// US-11 “Mình hiểu”.
  Future<void> markBridgeUnderstood(String sessionId);

  /// US-12: chọn / xác nhận bước tiếp theo.
  Future<void> chooseNextStep(String sessionId, BridgeNextStep step);

  Future<void> confirmNextStep(String sessionId);

  /// US-12b: đóng phiên khi cả hai đồng ý.
  Future<void> closeBridge(String sessionId);

  /// US-09: câu gốc + 3 gợi ý viết lại.
  Future<RewriteSuggestion?> rewriteSuggestion();

  /// US-13: số khẩn cấp.
  Future<List<SafetyHotline>> safetyHotlines();

  /// US-14: tuần của hai ta.
  Future<CoupleWeek?> coupleWeek();
}
