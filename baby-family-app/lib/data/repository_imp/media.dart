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

  /// Cạnh dài tối đa của từng bản ảnh (khớp mã biến thể của server).
  static const _origEdge = 4096;
  static const _variantEdges = {'m1080': 1080, 't320': 320};
  static const _jpeg = 'image/jpeg';

  @override
  Future<ProcessedMedia> processImage(String path) async {
    final original = await File(path).readAsBytes();
    final (width, height) = await _size(original);
    final orig = await _jpegAt(original, width, height, _origEdge, 90);
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
    final info = await VideoCompress.compressVideo(
      path,
      quality: VideoQuality.Res1920x1080Quality,
      includeAudio: true,
    );
    final output = info?.path;
    if (info == null || output == null) {
      throw StateError('Video compression failed');
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
      bytes: await File(output).readAsBytes(),
      width: info.width,
      height: info.height,
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

  Future<MediaVariantFile> _variant(
    String code,
    Uint8List source,
    int width,
    int height,
    int edge,
  ) async {
    final image = await _jpegAt(source, width, height, edge, 80);
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
    Uint8List bytes,
  ) async {
    if (instruction.mode == 'multipart') {
      return _uploadParts(instruction, bytes);
    }
    final url = instruction.url;
    if (instruction.mode != 'single' || url == null) {
      throw UnsupportedError('Upload mode ${instruction.mode} is unsupported');
    }
    await _put(url, instruction.headers, bytes);
    return const [];
  }

  /// Mỗi part [UploadInstruction.partSize] byte (part cuối ngắn hơn); ETag
  /// của từng PUT gửi lại khi complete.
  Future<List<JsonMap>> _uploadParts(
    UploadInstruction instruction,
    Uint8List bytes,
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
    Uint8List bytes,
  ) => StorageDio.instance.put<void>(
    url,
    data: Stream<List<int>>.value(bytes),
    options: Options(
      headers: {...headers, Headers.contentLengthHeader: bytes.length},
    ),
  );

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
