import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:baby_family/data/dto/media_source.dart';
import 'package:baby_family/data/dto/processed_media.dart';
import 'package:baby_family/data/model/memory/upload_instruction.dart';
import 'package:baby_family/data/model/memory/upload_intent.dart';
import 'package:baby_family/data/model/memory/upload_status.dart';
import 'package:baby_family/data/remote/dio_config/storage_dio.dart';
import 'package:baby_family/data/repository/base.dart';
import 'package:baby_family/data/repository/media.dart';
import 'package:baby_family/data/repository_imp/base.dart';
import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:exif/exif.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:video_compress/video_compress.dart';
import 'package:video_player/video_player.dart';

class MediaRepositoryImp extends BaseRepositoryImp implements IMediaRepository {
  @override
  Future<UploadIntent?> createUploadIntent(
    String idempotencyKey,
    JsonMap body,
  ) async {
    final rs = await client!.createUploadIntent(idempotencyKey, body);
    return rs.intent;
  }

  @override
  Future<Uint8List> readLocalFile(String path) => File(path).readAsBytes();

  /// Ảnh (BF-20261028-005): bản chính cạnh dài 2560 px JPEG 85 — nét trên
  /// màn hình điện thoại / máy tính bảng, thường 0,6–1,2 MB thay vì 2–4 MB của
  /// 4096 px / 90; biến thể theo mã của server: m1080 (80), t320 (72).
  static const _origEdge = 2560;
  static const _origQuality = 85;
  static const _variantEdges = {'m1080': 1080, 't320': 320};
  static const _variantQuality = {'m1080': 80, 't320': 72};

  /// Video: nén về 720p (H.264, ~3–5 Mbps) — đủ đẹp để xem trên điện thoại,
  /// nhẹ hơn 1080p khoảng một nửa. Video đã nhỏ (cạnh ngắn ≤ 720 và bitrate
  /// thấp) giữ nguyên để không mất chất lượng vì nén lại.
  static const _videoShortEdge = 720;
  static const _videoKeepBitsPerSecond = 4000000;
  static const _jpeg = 'image/jpeg';

  @override
  Future<ProcessedMedia> processImage(String path) async {
    final original = await File(path).readAsBytes();
    final (width, height) = await _size(original);
    final orig = await _jpegAt(
      original,
      width,
      height,
      _origEdge,
      _origQuality,
    );
    return ProcessedMedia(
      kind: 'IMAGE',
      mime: _jpeg,
      bytes: orig.bytes,
      width: orig.width,
      height: orig.height,
      source: MediaSource(
        sha256: sha256.convert(original).toString(),
        key: MediaSource.keyOf(kind: 'IMAGE', width: width, height: height),
        capturedAt: await _capturedAt(original),
        size: original.length,
      ),
      variants: [
        for (final MapEntry(key: code, value: edge) in _variantEdges.entries)
          await _variant(code, original, width, height, edge),
      ],
    );
  }

  @override
  Future<ProcessedMedia> processVideo(String path) async {
    final source = await VideoCompress.getMediaInfo(path);
    final original = File(path);
    final sourceHash = await sha256.bind(original.openRead()).first;
    final sourceBytes = await original.length();
    final MediaInfo? info;
    if (_keepVideo(source, sourceBytes, path)) {
      info = source;
    } else {
      info = await VideoCompress.compressVideo(
        path,
        quality: VideoQuality.Res1280x720Quality,
        includeAudio: true,
        frameRate: 30,
      );
    }
    var output = info?.path;
    if (info == null || output == null) {
      throw StateError('Video compression failed');
    }
    // Bản nén to hơn bản gốc (video gốc đã rất nhẹ): dùng bản gốc mp4.
    if (output != path &&
        await File(output).length() >= sourceBytes &&
        _isMp4(path)) {
      await _deleteQuietly(output);
      output = path;
    }
    final poster = await VideoCompress.getByteThumbnail(path, quality: 85);
    if (poster == null) {
      throw StateError('Video poster failed');
    }
    final (posterWidth, posterHeight) = await _size(poster);
    final durationMs = info.duration?.round();
    return ProcessedMedia(
      kind: 'VIDEO',
      mime: 'video/mp4',
      bytes: await _readThenClean(output, keep: path),
      width: output == path ? source.width : info.width,
      height: output == path ? source.height : info.height,
      durationMs: durationMs ?? await mediaDurationMs(output),
      source: MediaSource(
        sha256: sourceHash.toString(),
        key: MediaSource.keyOf(
          kind: 'VIDEO',
          width: source.width ?? 0,
          height: source.height ?? 0,
          durationMs: source.duration?.round(),
        ),
        size: await original.length(),
      ),
      variants: [
        await _variant('poster', poster, posterWidth, posterHeight, 1080),
        await _variant('t320', poster, posterWidth, posterHeight, 320),
      ],
    );
  }

  /// Giữ nguyên video mp4 đã nhỏ: cạnh ngắn ≤ 720 và bitrate ≤ 4 Mbps.
  static bool _keepVideo(MediaInfo source, int bytes, String path) {
    final width = source.width ?? 0;
    final height = source.height ?? 0;
    final seconds = (source.duration ?? 0) / 1000;
    if (!_isMp4(path) || width == 0 || height == 0 || seconds <= 0) {
      return false;
    }
    final shortEdge = width < height ? width : height;
    return shortEdge <= _videoShortEdge &&
        bytes * 8 / seconds <= _videoKeepBitsPerSecond;
  }

  static bool _isMp4(String path) {
    final name = path.toLowerCase();
    return name.endsWith('.mp4') || name.endsWith('.m4v');
  }

  /// Đọc file nén rồi xoá bản tạm (không xoá file gốc [keep]).
  static Future<Uint8List> _readThenClean(
    String path, {
    required String keep,
  }) async {
    final bytes = await File(path).readAsBytes();
    if (path != keep) {
      await _deleteQuietly(path);
    }
    return bytes;
  }

  static Future<void> _deleteQuietly(String path) async {
    try {
      await File(path).delete();
    } on Object {
      return;
    }
  }

  Future<MediaVariantFile> _variant(
    String code,
    Uint8List source,
    int width,
    int height,
    int edge,
  ) async {
    final image = await _jpegAt(
      source,
      width,
      height,
      edge,
      _variantQuality[code] ?? 80,
    );
    return MediaVariantFile(
      code: code,
      mime: _jpeg,
      bytes: image.bytes,
      width: image.width,
      height: image.height,
    );
  }

  /// JPEG có cạnh dài ≤ [edge] (không phóng to), bỏ EXIF (vị trí…).
  Future<({Uint8List bytes, int width, int height})> _jpegAt(
    Uint8List source,
    int width,
    int height,
    int edge,
    int quality,
  ) async {
    final longest = width > height ? width : height;
    final scale = longest > edge ? edge / longest : 1.0;
    final bytes = await FlutterImageCompress.compressWithList(
      source,
      minWidth: (width * scale).round(),
      minHeight: (height * scale).round(),
      quality: quality,
    );
    final (outWidth, outHeight) = await _size(bytes);
    return (bytes: bytes, width: outWidth, height: outHeight);
  }

  /// Thời điểm chụp trong EXIF (giờ địa phương của máy chụp); null khi thiếu.
  static Future<DateTime?> _capturedAt(Uint8List bytes) async {
    try {
      final tags = await readExifFromBytes(bytes);
      final raw =
          (tags['EXIF DateTimeOriginal'] ?? tags['Image DateTime'])?.printable;
      if (raw == null || raw.length < 19) {
        return null;
      }
      // “YYYY:MM:DD HH:MM:SS”
      return DateTime.tryParse(
        '${raw.substring(0, 10).replaceAll(':', '-')}T${raw.substring(11, 19)}',
      );
    } on Object {
      return null;
    }
  }

  /// Kích thước thật sau khi giải mã (đã xoay theo EXIF).
  static Future<(int, int)> _size(Uint8List bytes) async {
    final codec = await ui.instantiateImageCodec(bytes);
    try {
      final frame = await codec.getNextFrame();
      final size = (frame.image.width, frame.image.height);
      frame.image.dispose();
      return size;
    } finally {
      codec.dispose();
    }
  }

  @override
  Future<int?> mediaDurationMs(String path) async {
    final player = VideoPlayerController.file(File(path));
    try {
      await player.initialize();
      final duration = player.value.duration;
      return duration == Duration.zero ? null : duration.inMilliseconds;
    } on Object {
      return null;
    } finally {
      await player.dispose();
    }
  }

  @override
  Future<List<JsonMap>> uploadBytes(
    UploadInstruction instruction,
    Uint8List bytes, {
    UploadProgress? onProgress,
  }) async {
    if (instruction.mode == 'multipart') {
      return _uploadParts(instruction, bytes, onProgress);
    }
    final url = instruction.url;
    if (instruction.mode != 'single' || url == null) {
      throw UnsupportedError('Upload mode ${instruction.mode} is unsupported');
    }
    await _put(
      url,
      instruction.headers,
      bytes,
      onProgress == null ? null : (sent, _) => onProgress(sent, bytes.length),
    );
    return const [];
  }

  /// Mỗi part [UploadInstruction.partSize] byte (part cuối ngắn hơn); ETag
  /// của từng PUT gửi lại khi complete.
  Future<List<JsonMap>> _uploadParts(
    UploadInstruction instruction,
    Uint8List bytes,
    UploadProgress? onProgress,
  ) async {
    final size = instruction.partSize;
    if (size == null || size <= 0 || instruction.parts.isEmpty) {
      throw StateError('Multipart upload without parts');
    }
    final done = <JsonMap>[];
    for (final part in instruction.parts) {
      final start = (part.n - 1) * size;
      if (start >= bytes.length) {
        break;
      }
      final end = start + size > bytes.length ? bytes.length : start + size;
      final response = await _put(
        part.url,
        const {},
        Uint8List.sublistView(bytes, start, end),
        onProgress == null
            ? null
            : (sent, _) => onProgress(start + sent, bytes.length),
      );
      final etag = response.headers.value('etag');
      if (etag == null) {
        throw StateError('Part ${part.n} returned no ETag');
      }
      done.add({'n': part.n, 'etag': etag});
    }
    return done;
  }

  Future<Response<void>> _put(
    String url,
    Map<String, String> headers,
    Uint8List bytes, [
    ProgressCallback? onSendProgress,
  ]) => StorageDio.instance.put<void>(
    url,
    // Gửi từng khúc 64 KB để báo tiến độ theo byte.
    data: Stream<List<int>>.fromIterable(_chunks(bytes)),
    options: Options(
      headers: {...headers, Headers.contentLengthHeader: bytes.length},
    ),
    onSendProgress: onSendProgress,
  );

  static Iterable<List<int>> _chunks(Uint8List bytes) sync* {
    const size = 64 * 1024;
    for (var start = 0; start < bytes.length; start += size) {
      final end = start + size > bytes.length ? bytes.length : start + size;
      yield Uint8List.sublistView(bytes, start, end);
    }
  }

  @override
  Future<UploadStatus?> assetStatus(String assetId) async =>
      (await client!.getMediaAsset(assetId)).upload;

  @override
  Future<UploadStatus?> completeUpload(
    String assetId, {
    List<JsonMap> parts = const [],
  }) async {
    final rs = await client!.completeUpload(assetId, {
      if (parts.isNotEmpty) 'parts': parts,
    });
    return rs.upload;
  }
}
