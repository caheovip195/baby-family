import 'package:baby_family/data/repository/base.dart';

abstract class ICareRepository extends IBaseRepository {
  List<JsonMap> missions(String familyId);

  JsonMap? mission(String id);

  JsonMap addMission(JsonMap mission);

  void updateMission(String id, JsonMap patch);

  List<JsonMap> templates();

  JsonMap? template(String? id);

  List<JsonMap> heartsLedger(String familyId);

  JsonMap addHearts(JsonMap entry);

  void removeHearts(bool Function(JsonMap entry) test);

  /// `{weekBefore, totalBefore}` của một người.
  JsonMap heartsBaseline(String userId);

  JsonMap treeStats();

  List<JsonMap> treeLevels();

  int swapsUsed(String userId);

  void setSwapsUsed(String userId, int value);

  /// Bản nháp mẫu của CARE-03 (giá trị điền sẵn theo thiết kế).
  JsonMap missionDraft();

  // --- Batch 2 (CARE-07/08/10/12, CAL-02) ---
  List<JsonMap> calendarEvents(String familyId);

  JsonMap addCalendarEvent(JsonMap event);

  /// CAL-02 — sự kiện điền sẵn theo thiết kế.
  JsonMap eventDraft();

  List<JsonMap> missionHistory();

  List<JsonMap> badges(String familyId);

  JsonMap missionSettings();

  void saveMissionSettings(JsonMap settings);
}
