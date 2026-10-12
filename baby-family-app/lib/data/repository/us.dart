import 'package:baby_family/data/repository/base.dart';

abstract class IUsRepository extends IBaseRepository {
  List<JsonMap> checkins(String familyId);

  JsonMap addCheckin(JsonMap checkin);

  List<JsonMap> requests(String familyId);

  JsonMap? request(String id);

  JsonMap addRequest(JsonMap request);

  void updateRequest(String id, JsonMap patch);

  List<JsonMap> thanks(String familyId);

  JsonMap addThanks(JsonMap thanks);

  /// Câu hỏi kết nối (đã dịch) — `index` theo ngày.
  List<String> dailyQuestions();

  List<JsonMap> questionAnswers(String familyId);

  JsonMap addQuestionAnswer(JsonMap answer);

  // --- Batch 2 (US-06/07/15) ---
  void updateThanks(String id, JsonMap patch);

  List<JsonMap> journal(String userId);

  JsonMap addJournal(JsonMap entry);

  void updateJournal(String id, JsonMap patch);

  JsonMap coupleSettings();

  void saveCoupleSettings(JsonMap settings);

  // --- Batch 3 (US-08…14) ---
  List<JsonMap> bridgeSessions(String familyId);

  JsonMap? bridgeSession(String id);

  JsonMap addBridgeSession(JsonMap session);

  void updateBridgeSession(String id, JsonMap patch);

  JsonMap bridgeRewrite();

  JsonMap coupleWeek();

  /// `catalog.json` (bridge, safetyHotlines…).
  JsonMap catalog();
}
