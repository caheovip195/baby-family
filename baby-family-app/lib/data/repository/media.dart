import 'dart:typed_data';

import 'package:baby_family/data/dto/media_local_file.dart';
import 'package:baby_family/data/dto/processed_media.dart';
import 'package:baby_family/data/model/memory/upload_instruction.dart';
import 'package:baby_family/data/model/memory/upload_intent.dart';
import 'package:baby_family/data/model/memory/upload_status.dart';
import 'package:baby_family/data/repository/base.dart';

/// Tải media lên (tài liệu kỹ thuật 10.2): xin upload-intent → PUT thẳng lên
/// object storage bằng presigned URL → complete.
/// Số byte đã gửi / tổng số byte của một file.
typedef UploadProgress = void Function(int sent, int total);

abstract class IMediaRepository extends IBaseRepository {
  /// `POST /v1/media/upload-intents`; giữ nguyên [idempotencyKey] khi thử lại.
  Future<UploadIntent?> createUploadIntent(String idempotencyKey, JsonMap body);

  /// SHA-256 (hex) của file trên máy, băm theo stream ngoài UI isolate.
  Future<String> hashLocalFile(String path);

  /// Kích thước + SHA-256 của file trên máy, không nạp file vào bộ nhớ.
  Future<MediaLocalFile> describeLocalFile(
    String path, {
    bool temporary = false,
  });

  /// Xoá bản nén tạm; bỏ qua lỗi (file đã mất).
  Future<void> deleteLocalFile(String path);

  /// Ảnh trên máy → bản `orig` đã nén (cạnh dài ≤ 4096) + biến thể `m1080`,
  /// `t320` (JPEG). Xử lý hoàn toàn trên client.
  Future<ProcessedMedia> processImage(String path);

  /// Video trên máy → mp4 nén (file chính, server ghi là `v1080`) + `poster` +
  /// `t320`, kèm thời lượng đo trên máy. File chính nằm trên đĩa; người gọi xoá
  /// khi [MediaLocalFile.temporary] sau khi upload.
  Future<ProcessedMedia> processVideo(String path);

  /// Thời lượng (ms) của video/âm thanh trên máy; null khi không đọc được.
  Future<int?> mediaDurationMs(String path);

  /// PUT [bytes] tới presigned URL với đúng các header đã ký. Multipart: PUT
  /// từng part, trả `[{n, etag}]` cho [completeUpload]; single trả rỗng.
  /// [onProgress] báo số byte đã gửi / tổng (hiện tiến độ đăng bài).
  Future<List<JsonMap>> uploadBytes(
    UploadInstruction instruction,
    Uint8List bytes, {
    UploadProgress? onProgress,
  });

  /// Như [uploadBytes] nhưng đọc từng khúc từ file [path] (mỗi part chỉ giữ
  /// một khúc trong bộ nhớ).
  Future<List<JsonMap>> uploadFile(
    UploadInstruction instruction,
    String path, {
    UploadProgress? onProgress,
  });

  /// `GET /v1/media/{id}`: trạng thái xử lý (PROCESSING | READY | FAILED…).
  Future<UploadStatus?> assetStatus(String assetId);

  /// `POST /v1/media/{id}/complete` ([parts] bắt buộc với multipart).
  Future<UploadStatus?> completeUpload(
    String assetId, {
    List<JsonMap> parts = const [],
  });
}
