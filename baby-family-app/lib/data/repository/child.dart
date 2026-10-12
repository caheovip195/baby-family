import 'package:baby_family/data/repository/base.dart';

abstract class IChildRepository extends IBaseRepository {
  List<JsonMap> children(String familyId);

  JsonMap? child(String id);

  JsonMap addChild(JsonMap child);

  void updateChild(String id, JsonMap patch);

  /// `children.json › stats`: counters per child, chapters, week summary.
  JsonMap stats();

  // --- Batch 2 (CHD-01…04, MEM-11) ---
  JsonMap? profile(String childId);

  void saveProfile(JsonMap profile);

  List<JsonMap> milestoneRecords(String childId);

  JsonMap addMilestoneRecord(JsonMap record);
}
