import 'dart:async';
import 'dart:typed_data';

import 'package:baby_family/data/dto/processed_media.dart';
import 'package:baby_family/data/model/memory/upload_intent.dart';
import 'package:baby_family/data/repository/base.dart';
import 'package:baby_family/data/repository/media.dart';
import 'package:crypto/crypto.dart';
import 'package:uuid/uuid.dart';

/// Tải ảnh/video/ghi âm trên máy lên S3: client nén + tạo biến thể → xin
/// phiên upload (presign file chính + từng biến thể) → PUT thẳng lên S3 (file
/// lớn theo multipart) → complete (BF-20261021-008). Trùng nội dung (SHA-256)
/// thì server trả lại asset cũ.
class MediaUploader {
  MediaUploader(this._media);

  final IMediaRepository _media;

  /// [purpose] theo `media-policy` của server: `AVATAR`, `COVER`, `MEMORY`…
  Future<String> uploadImage(
    String serverFamilyId,
    String path, {
    required String purpose,
  }) => upload(serverFamilyId, path, purpose: purpose);

  /// Ảnh, video hoặc ghi âm (theo đuôi file). Client tự nén và tạo mọi biến
  /// thể (BF-20261021-008); server chỉ cấp phiên upload presign và kiểm tra
  /// khi `complete` — không xử lý media. [idempotencyKey] giữ nguyên khi thử
  /// lại. Video và ghi âm đọc theo file, không nạp cả file vào bộ nhớ.
  Future<String> upload(
    String serverFamilyId,
    String path, {
    required String purpose,
    String? idempotencyKey,
    void Function(double fraction)? onProgress,
  }) async {
    final media = await _process(path);
    return _send(
      media,
      {'familyId': serverFamilyId, 'kind': media.kind, 'purpose': purpose},
      create: (body) =>
          _media.createUploadIntent(idempotencyKey ?? const Uuid().v4(), body),
      complete: (assetId, parts) =>
          _media.completeUpload(assetId, parts: parts),
      onProgress: onProgress,
    );
  }

  /// Avatar tài khoản (`/v1/me/avatar/upload-intents`): nén và tạo biến thể
  /// như ảnh ký ức nhưng qua route riêng, không có `familyId`/`kind`.
  Future<String> uploadAvatar(
    String path, {
    required Future<UploadIntent?> Function(JsonMap body) create,
    required Future<void> Function(String assetId) complete,
  }) async => _send(
    await _media.processImage(path),
    const {'purpose': 'AVATAR'},
    create: create,
    complete: (assetId, _) => complete(assetId),
  );

  /// Xin phiên upload cho file chính + biến thể, PUT thẳng lên S3, complete.
  Future<String> _send(
    ProcessedMedia media,
    JsonMap base, {
    required Future<UploadIntent?> Function(JsonMap body) create,
    required Future<void> Function(String assetId, List<JsonMap> parts)
    complete,
    void Function(double fraction)? onProgress,
  }) async {
    final file = media.file;
    try {
      return await _sendContent(
        media,
        base,
        create: create,
        complete: complete,
        onProgress: onProgress,
      );
    } finally {
      if (file != null && file.temporary) {
        await _media.deleteLocalFile(file.path);
      }
    }
  }

  Future<String> _sendContent(
    ProcessedMedia media,
    JsonMap base, {
    required Future<UploadIntent?> Function(JsonMap body) create,
    required Future<void> Function(String assetId, List<JsonMap> parts)
    complete,
    void Function(double fraction)? onProgress,
  }) async {
    final file = media.file;
    final bytes = media.bytes ?? Uint8List(0);
    final variants = [
      for (final variant in media.variants)
        (variant: variant, sha: sha256.convert(variant.bytes).toString()),
    ];
    final intent = await create({
      ...base,
      'mime': media.mime,
      'size': media.size,
      'sha256': file?.sha256 ?? sha256.convert(bytes).toString(),
      'width': ?media.width,
      'height': ?media.height,
      'durationMs': ?media.durationMs,
      // Dấu vết file gốc: máy còn bản này trong thư viện sẽ hiển thị local.
      'source': ?media.source?.toJson(),
      if (variants.isNotEmpty)
        'variants': [
          for (final (:variant, :sha) in variants)
            {
              'code': variant.code,
              'mime': variant.mime,
              'size': variant.bytes.length,
              'sha256': sha,
              'width': ?variant.width,
              'height': ?variant.height,
            },
        ],
    });
    final assetId = intent?.assetId;
    if (assetId == null) {
      throw StateError('Upload intent without asset');
    }
    final upload = intent?.upload;
    if (intent?.status == 'PENDING_UPLOAD' && upload != null) {
      // Tiến độ theo byte của file chính + mọi biến thể.
      final total =
          media.size +
          variants.fold<int>(0, (sum, item) => sum + item.variant.bytes.length);
      var sentBefore = 0;
      UploadProgress? progress() => onProgress == null
          ? null
          : (sent, _) => onProgress((sentBefore + sent) / total);
      // File chính và từng biến thể đi thẳng lên S3 qua URL presign.
      final parts = file != null
          ? await _media.uploadFile(upload, file.path, onProgress: progress())
          : await _media.uploadBytes(upload, bytes, onProgress: progress());
      sentBefore += media.size;
      final byCode = {
        for (final (:variant, sha: _) in variants) variant.code: variant,
      };
      for (final variantUpload in intent?.variantUploads ?? const []) {
        final variant = byCode[variantUpload.code];
        final instruction = variantUpload.upload;
        if (variant == null || instruction == null) {
          throw StateError('Unknown variant upload ${variantUpload.code}');
        }
        await _media.uploadBytes(
          instruction,
          variant.bytes,
          onProgress: progress(),
        );
        sentBefore += variant.bytes.length;
      }
      await complete(assetId, parts);
    }
    onProgress?.call(1);
    return assetId;
  }

  /// Nén/tạo biến thể trên máy theo loại file.
  Future<ProcessedMedia> _process(String path) async {
    if (isVideo(path)) {
      return _media.processVideo(path);
    }
    if (isAudio(path)) {
      final durationMs = await _media.mediaDurationMs(path);
      if (durationMs == null) {
        throw StateError('Audio duration is unknown');
      }
      return ProcessedMedia.file(
        kind: 'AUDIO',
        mime: mimeOf(path),
        file: await _media.describeLocalFile(path),
        durationMs: durationMs,
      );
    }
    return _media.processImage(path);
  }

  static const _videoMimes = {
    '.mp4': 'video/mp4',
    '.m4v': 'video/mp4',
    '.mov': 'video/quicktime',
  };

  /// Ghi âm VOICE (m4a/aac).
  static bool isAudio(String path) {
    final name = path.toLowerCase();
    return name.endsWith('.m4a') || name.endsWith('.aac');
  }

  /// VOICE: server chỉ nhận asset audio đã xử lý xong (READY) khi tạo ký ức —
  /// hỏi lại tối đa [attempts] lần, cách [interval].
  Future<void> waitReady(
    String assetId, {
    int attempts = 30,
    Duration interval = const Duration(seconds: 1),
  }) async {
    for (var i = 0; i < attempts; i++) {
      final status = (await _media.assetStatus(assetId))?.status;
      if (status == 'READY') {
        return;
      }
      if (status == 'FAILED' || status == 'REJECTED') {
        throw StateError('Media processing failed');
      }
      await Future<void>.delayed(interval);
    }
    throw TimeoutException('Media is still processing');
  }

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
    if (name.endsWith('.m4a') || name.endsWith('.aac')) {
      // Ghi âm (VOICE): AAC trong vỏ MP4.
      return 'audio/mp4';
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
