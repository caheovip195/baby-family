/// File trên máy đã đo kích thước và băm SHA-256 theo stream: upload đọc từng
/// phần từ file, không nạp cả nội dung vào bộ nhớ (video có thể rất lớn).
class MediaLocalFile {
  const MediaLocalFile({
    required this.path,
    required this.size,
    required this.sha256,
    this.temporary = false,
  });

  final String path;
  final int size;

  /// SHA-256 dạng hex.
  final String sha256;

  /// Bản nén tạm do app tạo: xoá sau khi upload xong hoặc lỗi. File gốc của
  /// người dùng luôn là `false`.
  final bool temporary;
}
