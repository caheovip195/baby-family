import 'package:baby_family/data/repository/base.dart';

/// Chỉ mục khớp asset server ↔ ảnh trong thư viện máy (lưu trên máy, xoá khi
/// đăng xuất).
abstract class ILocalMediaIndexRepository extends IBaseRepository {
  Future<JsonMap> load();

  Future<void> save(JsonMap index);
}
