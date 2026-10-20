import 'dart:typed_data';

import 'package:baby_family/data/model/memory/upload_instruction.dart';
import 'package:baby_family/data/model/memory/upload_intent.dart';
import 'package:baby_family/data/model/memory/upload_status.dart';
import 'package:baby_family/data/repository/base.dart';

/// Tải media lên (tài liệu kỹ thuật 10.2): xin upload-intent → PUT thẳng lên
/// object storage bằng presigned URL → complete.
abstract class IMediaRepository extends IBaseRepository {
  /// `POST /v1/media/upload-intents`; giữ nguyên [idempotencyKey] khi thử lại.
  Future<UploadIntent?> createUploadIntent(String idempotencyKey, JsonMap body);

  /// Bytes của ảnh/video đã chọn trên máy (MEM-04).
  Future<Uint8List> readLocalFile(String path);

  /// Thời lượng (ms) của video/âm thanh trên máy; null khi không đọc được.
  Future<int?> mediaDurationMs(String path);

  /// PUT [bytes] tới presigned URL với đúng các header đã ký. Multipart: PUT
  /// từng part, trả `[{n, etag}]` cho [completeUpload]; single trả rỗng.
  Future<List<JsonMap>> uploadBytes(
    UploadInstruction instruction,
    Uint8List bytes,
  );

  /// `POST /v1/media/{id}/complete` ([parts] bắt buộc với multipart).
  Future<UploadStatus?> completeUpload(
    String assetId, {
    List<JsonMap> parts = const [],
  });
}
