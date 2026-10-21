import 'package:baby_family/data/repository/base.dart';

/// Một ảnh/video trong thư viện máy (chỉ metadata, chưa đọc file).
class GalleryItem {
  const GalleryItem({
    required this.id,
    required this.key,
    required this.createdAt,
  });

  final String id;

  /// Cùng định dạng `MediaSource.keyOf`.
  final String key;
  final DateTime createdAt;
}

/// Thư viện ảnh/video của máy — để ưu tiên hiển thị bản local của ký ức đã
/// upload (không đọc thư viện khi người dùng chưa cho phép).
abstract class IGalleryRepository extends IBaseRepository {
  /// Đã có quyền đọc (đầy đủ hoặc giới hạn) — không hỏi.
  Future<bool> hasAccess();

  /// Hỏi quyền (khi người dùng vừa chọn ảnh/video để đăng).
  Future<bool> requestAccess();

  /// Metadata ảnh/video, mới nhất trước, tối đa [limit].
  Future<List<GalleryItem>> items({int limit});

  /// SHA-256 nội dung gốc; null khi không đọc được (iCloud chưa tải…).
  Future<String?> sha256Of(String id);

  /// Đường dẫn file hiển thị được; null khi ảnh đã bị xoá khỏi thư viện.
  Future<String?> filePath(String id);
}
