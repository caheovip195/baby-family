import 'package:baby_family/data/dto/care_board.dart';
import 'package:baby_family/data/dto/mission_completion.dart';
import 'package:baby_family/data/dto/mission_draft.dart';
import 'package:baby_family/data/model/care/calendar_event.dart';
import 'package:baby_family/data/model/care/family_badge.dart';
import 'package:baby_family/data/model/care/family_tree.dart';
import 'package:baby_family/data/model/care/hearts_summary.dart';
import 'package:baby_family/data/model/care/mission.dart';
import 'package:baby_family/data/model/care/mission_history_day.dart';
import 'package:baby_family/data/model/care/mission_settings.dart';
import 'package:baby_family/data/model/care/mission_template.dart';
import 'package:baby_family/data/model/care/swap_option.dart';
import 'package:baby_family/data/service/base.dart';
import 'package:baby_family/utils/constants/enum.dart';

/// Chăm con: bảng nhiệm vụ ngày, Hearts riêng tư, Cây gia đình (CARE-01…09).
abstract class ICareService extends IBaseService {
  /// Bảng nhiệm vụ của [date] (mặc định hôm nay), chia Của tôi / Của bạn đời /
  /// Cùng nhau. [childId] lọc theo bé đang chọn (nhiệm vụ không gắn bé luôn hiện).
  Future<CareBoard> board({DateTime? date, String? childId});

  Future<Mission?> mission(String id);

  /// Thư viện nhiệm vụ (CARE-04), lọc theo tuổi bé khi có [childId].
  Future<List<MissionTemplate>> templates({String? childId});

  /// CARE-03: chỉ `me` hoặc `together` (BR-020 — nhờ bạn đời dùng Lời nhờ).
  /// Có [templateId] → Hearts theo mẫu; tự gõ → 2 Hearts (BR-069).
  Future<Mission> createMission({
    String? title,
    String? templateId,
    MissionOwnerKind ownerKind = MissionOwnerKind.me,
    List<String> childIds = const [],
    DateTime? date,
    String? dueTime,
    MissionRepeat repeat = MissionRepeat.none,
    MissionReminder reminder = MissionReminder.none,
    String? icon,
  });

  /// Giá trị điền sẵn của CARE-03: theo [templateId] nếu có, ngược lại bản
  /// nháp mặc định; [childId] (bé đang chọn) thay cho bé của bản nháp.
  Future<MissionDraft> missionDraft({String? childId, String? templateId});

  /// Các ngày (00:00) trong [from]…[to] có nhiệm vụ — chấm ở dải ngày CARE-01.
  Future<Set<DateTime>> missionDays(DateTime from, DateTime to);

  /// Chủ nhiệm vụ (hoặc Cùng nhau) bấm xong → Hearts + lá cây; hoàn tác
  /// trong `kValueMissionUndoWindow`.
  Future<MissionCompletion> completeMission(String id);

  Future<void> undoCompletion(String id);

  /// CARE-05: 3 lựa chọn Hearts ±1 + số lần đổi còn lại (tối đa 3/ngày).
  Future<SwapOption> swapOptions(String missionId);

  Future<void> swapMission(String missionId, String templateId);

  /// “Bỏ khỏi hôm nay (không bị trừ gì)”.
  Future<void> removeFromToday(String missionId);

  /// 💛 Cảm ơn trên việc bạn đời đã xong (CARE-01b).
  Future<void> thankPartner(String missionId);

  /// CARE-06 “Lưu lại khoảnh khắc này?” → ký ức gắn bé của nhiệm vụ.
  Future<void> saveMoment(String missionId, {String? asset, String? note});

  /// Hearts của CHÍNH người đang đăng nhập (BR-018).
  Future<HeartsSummary> myHearts();

  Future<FamilyTree> tree();

  // --- Batch 2 (CARE-07/08/10/12, CAL-02) ---

  /// CARE-07: mục lịch trong [from, to] (gồm cả hai đầu), sắp theo ngày/giờ.
  /// Sự kiện “Hai ta” chỉ có cho Papa & Mama.
  Future<List<CalendarEvent>> calendarEvents(DateTime from, DateTime to);

  /// CAL-02: sự kiện điền sẵn theo thiết kế (“Sinh nhật Bà nội”).
  Future<CalendarEvent> eventDraft();

  Future<CalendarEvent> createEvent(CalendarEvent event);

  /// CARE-08: lịch sử nhiệm vụ theo ngày, mới nhất trước. Việc của bạn đời
  /// chỉ hiện khi đã xong và không có Hearts (BR-018).
  Future<List<MissionHistoryDay>> missionHistory();

  /// CARE-10: huy hiệu đã đạt trước, sắp mở sau.
  Future<List<FamilyBadge>> badges();

  /// CARE-12.
  Future<MissionSettings> missionSettings();

  Future<void> saveMissionSettings(MissionSettings settings);
}
