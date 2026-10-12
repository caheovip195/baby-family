import 'package:baby_family/data/repository/base.dart';

abstract class IMemoryRepository extends IBaseRepository {
  List<JsonMap> memories(String familyId);

  JsonMap? memory(String id);

  JsonMap addMemory(JsonMap memory);

  void updateMemory(String id, JsonMap patch);

  List<JsonMap> comments(String memoryId);

  JsonMap addComment(JsonMap comment);

  List<JsonMap> perspectives(String memoryId);

  JsonMap addPerspective(JsonMap perspective);

  void updatePerspective(String id, JsonMap patch);

  List<JsonMap> stories(String familyId);

  JsonMap? story(String id);

  void updateStory(String id, JsonMap patch);

  List<JsonMap> collections();

  /// `catalog.json`: prompts, milestones, stickers.
  JsonMap catalog();

  // --- Batch 2 (MEM-03/08/10/11/13/14/15/16, REC-02) ---
  List<JsonMap> albums(String familyId);

  JsonMap? album(String id);

  JsonMap addAlbum(JsonMap album);

  void updateAlbum(String id, JsonMap patch);

  void removeAlbum(String id);

  void updateComment(String id, JsonMap patch);

  void removeComment(String id);

  /// Kho tìm kiếm mẫu của MEM-15 (ảnh/nhật ký “nhà trẻ”).
  List<JsonMap> searchMemories(String familyId);

  /// Ký ức các năm trước cho MEM-16 “Ngày này năm xưa”.
  List<JsonMap> pastMemories(String familyId);

  List<String> searchRecents();

  void saveSearchRecents(List<String> recents);

  JsonMap weeklyRecap();
}
