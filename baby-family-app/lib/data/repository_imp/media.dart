import 'dart:io';
import 'dart:typed_data';

import 'package:baby_family/data/model/memory/upload_instruction.dart';
import 'package:baby_family/data/model/memory/upload_intent.dart';
import 'package:baby_family/data/model/memory/upload_status.dart';
import 'package:baby_family/data/remote/dio_config/storage_dio.dart';
import 'package:baby_family/data/repository/base.dart';
import 'package:baby_family/data/repository/media.dart';
import 'package:baby_family/data/repository_imp/base.dart';
import 'package:dio/dio.dart';
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
