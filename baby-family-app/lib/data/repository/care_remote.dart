import 'package:baby_family/data/model/care/badge_record.dart';
import 'package:baby_family/data/model/care/calendar_event_record.dart';
import 'package:baby_family/data/model/care/calendar_record.dart';
import 'package:baby_family/data/model/care/family_tree_record.dart';
import 'package:baby_family/data/model/care/hearts_me_record.dart';
import 'package:baby_family/data/model/care/mission_board_record.dart';
import 'package:baby_family/data/model/care/mission_history_page.dart';
import 'package:baby_family/data/model/care/mission_record.dart';
import 'package:baby_family/data/model/care/mission_result_record.dart';
import 'package:baby_family/data/model/care/mission_series_record.dart';
import 'package:baby_family/data/model/care/mission_settings_record.dart';
import 'package:baby_family/data/model/care/mission_swap_options_record.dart';
import 'package:baby_family/data/model/care/mission_template_record.dart';
import 'package:baby_family/data/model/memory/memory_record.dart';
import 'package:baby_family/data/repository/base.dart';

/// Nhiệm vụ hằng ngày trên server (CARE-01…06, tài liệu kỹ thuật 11.6, 15.1–15.3).
abstract class ICareRemoteRepository extends IBaseRepository {
  /// [tab] = `MINE` | `PARTNER` | `TOGETHER`; [date] dạng `yyyy-MM-dd`.
  Future<MissionBoardRecord?> board(
    String familyId, {
    required String tab,
    String? date,
    String? childId,
  });

  Future<List<MissionTemplateRecord>> templates(
    String familyId, {
    String? childId,
  });

  Future<MissionRecord?> mission(String missionId);

  Future<MissionResultRecord?> createMission(
    String idempotencyKey,
    JsonMap body,
  );

  Future<MissionResultRecord?> complete(
    String missionId,
    String idempotencyKey, [
    JsonMap body = const {},
  ]);

  /// `undo` | `remove` | `swap` (body `{templateId, optionsToken}`).
  Future<MissionResultRecord?> action(
    String missionId,
    String action, [
    JsonMap body = const {},
  ]);

  Future<MissionSwapOptionsRecord?> swapOptions(String missionId);

  /// Hearts của chính người gọi (không có tham số người dùng — BR-018).
  Future<HeartsMeRecord?> myHearts(String familyId, {int? limit});

  Future<FamilyTreeRecord?> familyTree(String familyId);

  Future<List<BadgeRecord>> badges(String familyId);

  /// [owner] = `ME` | `PARTNER` | `TOGETHER`; ngày dạng `yyyy-MM-dd`.
  Future<MissionHistoryPage?> missionHistory(
    String familyId, {
    required String from,
    required String to,
    required String owner,
    String? cursor,
  });

  /// CARE-07: [from]/[to] dạng `yyyy-MM-dd`, khoảng ≤ 62 ngày.
  Future<CalendarRecord?> calendar(
    String familyId, {
    required String from,
    required String to,
  });

  /// CAL-02.
  Future<CalendarEventRecord?> createEvent(JsonMap body);

  /// CARE-06: `{body?, assetIds?, visibility?}` → ký ức của gia đình.
  Future<MemoryRecord?> saveMoment(
    String missionId,
    String idempotencyKey,
    JsonMap body,
  );

  /// Nhiệm vụ lặp lại tự thêm.
  Future<MissionSeriesRecord?> createSeries(String familyId, JsonMap body);

  /// CARE-03: chuỗi lặp lại (của tôi + Cùng nhau).
  Future<List<MissionSeriesRecord>> missionSeries(String familyId);

  Future<void> pauseSeries(String seriesId, String from, String to);

  Future<void> endSeries(String seriesId);

  /// CARE-12: mức bảng của cả nhà + tuỳ chọn của tôi.
  Future<MissionSettingsRecord?> missionSettings(String familyId);

  Future<MissionSettingsRecord?> updateBoardLevel(
    String familyId,
    String level,
  );

  Future<MissionSettingsRecord?> updatePreferences(
    String familyId,
    JsonMap patch,
  );
}
