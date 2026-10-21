/// Dấu vết của file gốc trong thư viện máy (trước khi nén) gửi kèm asset để
/// sau này máy nào còn file đó thì ưu tiên hiển thị bản local
/// (BF-20261021-008).
///
/// - [sha256]: SHA-256 bytes gốc — định danh thật, so trùng cuối cùng.
/// - [key]: khoá dò nhanh từ metadata (loại · cạnh ngắn x cạnh dài · giây
///   thời lượng), lấy được từ thư viện mà không cần đọc file. Không dùng tên
///   file: tên lặp giữa các máy (IMG_0001), đổi khi khôi phục, picker trả tên
///   tạm — dễ nhận nhầm ảnh.
/// - [capturedAt]: thời điểm chụp (EXIF) để thu hẹp ứng viên.
class MediaSource {
  const MediaSource({
    required this.sha256,
    required this.key,
    this.capturedAt,
    this.size,
  });

  final String sha256;
  final String key;
  final DateTime? capturedAt;
  final int? size;

  /// Khoá không phụ thuộc chiều xoay (ảnh dọc/ngang lưu khác nhau).
  static String keyOf({
    required String kind,
    required int width,
    required int height,
    int? durationMs,
  }) {
    final short = width < height ? width : height;
    final long = width < height ? height : width;
    final seconds = durationMs == null ? 0 : (durationMs / 1000).round();
    return '$kind|${short}x$long|$seconds';
  }

  Map<String, dynamic> toJson() => {
    'sha256': sha256,
    'key': key,
    'capturedAt': ?capturedAt?.toUtc().toIso8601String(),
    'size': ?size,
  };
}
