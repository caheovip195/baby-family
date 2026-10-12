import 'package:baby_family/data/repository/base.dart';

abstract class IFamilyRepository extends IBaseRepository {
  JsonMap? family(String? id);

  JsonMap createFamily(JsonMap family);

  void updateFamily(String id, JsonMap patch);

  List<JsonMap> members(String familyId);

  JsonMap? member(String? id);

  JsonMap addMember(JsonMap member);

  void updateMember(String id, JsonMap patch);

  List<JsonMap> invites(String familyId);

  JsonMap? inviteByCode(String code);

  JsonMap addInvite(JsonMap invite);

  void updateInvite(String id, JsonMap patch);

  /// `catalog.plans` (giá đã dịch).
  List<JsonMap> planOffers();

  /// Cấu hình chung của bản mock (`session.json`: lượt AI, khoá ứng dụng…).
  JsonMap config();

  // --- Batch 2 (FAM-04, FAM-07) ---
  JsonMap familySettings();

  void saveFamilySettings(JsonMap settings);

  // --- Batch 3 (FAM-05/08, SUB-03, CIR-06) ---
  List<JsonMap> memberships(String userId);

  JsonMap planDetails();

  JsonMap circlePreferences(String userId);

  void saveCirclePreferences(String userId, JsonMap preferences);

  void removeMember(String id);
}
