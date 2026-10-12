import 'package:baby_family/data/repository/base.dart';

/// Cài đặt cá nhân (SET-02…12): mỗi màn là một mục trong `settings.json`
/// (`profile`, `notifications`, `privacy`, `security`, `dataExport`,
/// `deleteAccount`, `help`).
abstract class ISettingsRepository extends IBaseRepository {
  JsonMap section(String key);

  void saveSection(String key, JsonMap value);

  /// Danh sách trong `settings.json` (ví dụ `blocked`).
  List<JsonMap> sectionList(String key);

  void saveSectionList(String key, List<JsonMap> value);

  /// `catalog.json` (aiFeatures, reportReasons…).
  JsonMap catalog();
}
