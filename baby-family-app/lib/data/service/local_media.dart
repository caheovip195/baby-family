/// Asset trên server kèm dấu vết file gốc (`assets[].source`).
class RemoteMediaRef {
  const RemoteMediaRef({
    required this.assetId,
    required this.sha256,
    required this.key,
    this.capturedAt,
  });

  final String assetId;
  final String sha256;
  final String key;
  final DateTime? capturedAt;
}

/// Ưu tiên hiển thị ảnh/video còn trong thư viện máy thay vì tải từ server
/// (BF-20261021-008). Không có quyền thư viện → không làm gì.
abstract class ILocalMediaService {
  /// Hỏi quyền đọc thư viện (khi người dùng vừa chọn ảnh/video để đăng).
  Future<void> enable();

  /// assetId → đường dẫn file trên máy, chỉ cho asset khớp bản trong thư
  /// viện (cùng SHA-256 nội dung gốc).
  Future<Map<String, String>> resolve(List<RemoteMediaRef> refs);
}
