import 'package:baby_family/data/repository/base.dart';

abstract class IPregnancyRepository extends IBaseRepository {
  List<JsonMap> prepItems(String pregnancyId);

  JsonMap addPrepItem(JsonMap item);

  void updatePrepItem(String id, JsonMap patch);

  /// Mục chuẩn bị đã lưu trữ (không có trong fixture) `{done, total}`.
  JsonMap prepHiddenCounts();

  List<JsonMap> names(String pregnancyId);

  JsonMap addName(JsonMap name);

  void updateName(String id, JsonMap patch);

  /// Giá trị điền sẵn của PREG-05 (mock: thông tin mẫu theo thiết kế) hoặc
  /// null.
  JsonMap? birthDraft(String pregnancyId);
}
