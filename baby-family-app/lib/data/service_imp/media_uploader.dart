import 'dart:typed_data';

import 'package:baby_family/data/repository/media.dart';
import 'package:crypto/crypto.dart';
import 'package:uuid/uuid.dart';

/// Tải một ảnh/video trên máy lên server: upload-intent → PUT (một lần, hoặc
/// từng part khi file > 20 MiB) → complete (BF-20261019-001, video và
/// multipart từ BF-20261019-007). Trùng nội dung (SHA-256) thì server trả lại
/// asset cũ.
class MediaUploader {
  MediaUploader(this._media);

  final IMediaRepository _media;

  /// [purpose] theo `media-policy` của server: `AVATAR`, `COVER`, `MEMORY`…
  Future<String> uploadImage(
    String serverFamilyId,
    String path, {
    required String purpose,
  }) => upload(serverFamilyId, path, purpose: purpose);

  /// Ảnh hoặc video (theo đuôi file); video gửi kèm thời lượng để server
  /// kiểm giới hạn của gói. [idempotencyKey] giữ nguyên khi thử lại; [bytes]
  /// khi đã đọc file (tránh đọc video lớn hai lần).
  Future<String> upload(
    String serverFamilyId,
    String path, {
    required String purpose,
    String? idempotencyKey,
    Uint8List? bytes,
  }) async {
    final content = bytes ?? await _media.readLocalFile(path);
    final checksum = sha256.convert(content).toString();
    final video = isVideo(path);
    final durationMs = video ? await _media.mediaDurationMs(path) : null;
    if (video && durationMs == null) {
      throw StateError('Video duration is unknown');
    }
    final intent = await _media
        .createUploadIntent(idempotencyKey ?? const Uuid().v4(), {
          'familyId': serverFamilyId,
          'kind': video ? 'VIDEO' : 'IMAGE',
          'purpose': purpose,
          'mime': mimeOf(path),
          'size': content.length,
          'sha256': checksum,
          'durationMs': ?durationMs,
        });
    final assetId = intent?.assetId;
    if (assetId == null) {
      throw StateError('Upload intent without asset');
    }
    final upload = intent?.upload;
    if (intent?.status == 'PENDING_UPLOAD' && upload != null) {
      final parts = await _media.uploadBytes(upload, content);
      await _media.completeUpload(assetId, parts: parts);
    }
    return assetId;
  }

  static const _videoMimes = {
    '.mp4': 'video/mp4',
    '.m4v': 'video/mp4',
    '.mov': 'video/quicktime',
  };

  static bool isVideo(String path) {
    final name = path.toLowerCase();
    return _videoMimes.keys.any(name.endsWith);
  }

  static String mimeOf(String path) {
    final name = path.toLowerCase();
    for (final entry in _videoMimes.entries) {
      if (name.endsWith(entry.key)) {
        return entry.value;
      }
    }
    if (name.endsWith('.png')) {
      return 'image/png';
    }
    if (name.endsWith('.webp')) {
      return 'image/webp';
    }
    if (name.endsWith('.gif')) {
      return 'image/gif';
    }
    if (name.endsWith('.heic')) {
      return 'image/heic';
    }
    return 'image/jpeg';
  }
}
