import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:baby_family/data/dto/media_local_file.dart';
import 'package:baby_family/data/dto/media_source.dart';
import 'package:baby_family/data/dto/processed_media.dart';
import 'package:baby_family/data/model/memory/upload_instruction.dart';
import 'package:baby_family/data/model/memory/upload_intent.dart';
import 'package:baby_family/data/model/memory/upload_part_url.dart';
import 'package:baby_family/data/model/memory/upload_status.dart';
import 'package:baby_family/data/remote/dio_config/storage_dio.dart';
import 'package:baby_family/data/repository/base.dart';
import 'package:baby_family/data/repository/media.dart';
import 'package:baby_family/data/repository_imp/media.dart';
import 'package:baby_family/data/service_imp/media_uploader.dart';
import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

/// Giả storage: ghi lại từng PUT, kích thước khúc nhận được, trả ETag theo URL.
class _RecordingAdapter implements HttpClientAdapter {
  final requests = <_Put>[];
  bool omitEtag = false;
  String? failOnUrl;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    final put = _Put(options.uri.toString(), options.headers);
    await for (final chunk
        in requestStream ?? const Stream<Uint8List>.empty()) {
      put.chunks.add(chunk.length);
      put.body.add(chunk);
    }
    requests.add(put);
    if (options.uri.toString() == failOnUrl) {
      throw DioException.connectionError(
        requestOptions: options,
        reason: 'offline',
      );
    }
    return ResponseBody.fromString(
      '',
      200,
      headers: {
        if (!omitEtag) 'etag': ['"etag-${requests.length}"'],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}

class _Put {
  _Put(this.url, this.headers);

  final String url;
  final Map<String, dynamic> headers;
  final chunks = <int>[];
  final body = BytesBuilder(copy: false);
}

/// Nội dung không lặp để phát hiện đọc sai vị trí part.
Uint8List _content(int length) => Uint8List.fromList([
  for (var i = 0; i < length; i++) (i * 31 + (i >> 8) * 7) & 0xff,
]);

UploadInstruction _multipart(int partSize, int count) => UploadInstruction(
  mode: 'multipart',
  partSize: partSize,
  partCount: count,
  parts: [
    for (var n = 1; n <= count; n++)
      UploadPartUrl(n: n, url: 'https://storage.test/part/$n'),
  ],
);

void main() {
  const kib = 1024;
  late Directory dir;
  late _RecordingAdapter storage;
  late HttpClientAdapter realAdapter;
  final repository = MediaRepositoryImp();

  Future<String> writeFile(Uint8List content) async {
    final file = File('${dir.path}/video.mp4');
    await file.writeAsBytes(content);
    return file.path;
  }

  setUp(() async {
    dir = await Directory.systemTemp.createTemp('media_upload_file_test');
    storage = _RecordingAdapter();
    realAdapter = StorageDio.instance.httpClientAdapter;
    StorageDio.instance.httpClientAdapter = storage;
  });

  tearDown(() async {
    StorageDio.instance.httpClientAdapter = realAdapter;
    await dir.delete(recursive: true);
  });

  group('uploadFile', () {
    test(
      'multipart reads each part from its offset, in small chunks',
      () async {
        const partSize = 256 * kib;
        final content = _content(partSize * 2 + 100 * kib);
        final path = await writeFile(content);

        final parts = await repository.uploadFile(
          _multipart(partSize, 3),
          path,
        );

        expect(parts, [
          {'n': 1, 'etag': '"etag-1"'},
          {'n': 2, 'etag': '"etag-2"'},
          {'n': 3, 'etag': '"etag-3"'},
        ]);
        expect(storage.requests.map((put) => put.url), [
          'https://storage.test/part/1',
          'https://storage.test/part/2',
          'https://storage.test/part/3',
        ]);
        expect(storage.requests.map((put) => put.headers['content-length']), [
          partSize,
          partSize,
          100 * kib,
        ]);
        final sent = BytesBuilder();
        for (final put in storage.requests) {
          sent.add(put.body.takeBytes());
          // Không part nào đi thành một khối lớn: file đọc theo khúc 64 KB.
          expect(put.chunks.length, greaterThan(1));
          expect(put.chunks.every((size) => size <= 64 * kib), isTrue);
        }
        expect(sha256.convert(sent.takeBytes()), sha256.convert(content));
      },
    );

    test(
      'multipart progress grows monotonically up to the file size',
      () async {
        const partSize = 128 * kib;
        final content = _content(partSize + 50 * kib);
        final path = await writeFile(content);
        final seen = <(int, int)>[];

        await repository.uploadFile(
          _multipart(partSize, 2),
          path,
          onProgress: (sent, total) => seen.add((sent, total)),
        );

        expect(seen.every((item) => item.$2 == content.length), isTrue);
        final sent = seen.map((item) => item.$1).toList();
        expect(sent, orderedEquals([...sent]..sort()));
        expect(sent.last, content.length);
      },
    );

    test('a part without ETag fails instead of completing', () async {
      storage.omitEtag = true;
      final path = await writeFile(_content(10 * kib));

      await expectLater(
        repository.uploadFile(_multipart(8 * kib, 2), path),
        throwsA(isA<StateError>()),
      );
    });

    test('multipart without parts is rejected', () async {
      final path = await writeFile(_content(kib));

      await expectLater(
        repository.uploadFile(const UploadInstruction(mode: 'multipart'), path),
        throwsA(isA<StateError>()),
      );
    });

    test('single PUT streams the file with the signed headers', () async {
      final content = _content(200 * kib);
      final path = await writeFile(content);

      final parts = await repository.uploadFile(
        const UploadInstruction(
          mode: 'single',
          url: 'https://storage.test/orig',
          headers: {'x-amz-checksum-sha256': 'signed'},
        ),
        path,
      );

      expect(parts, isEmpty);
      final put = storage.requests.single;
      expect(put.headers['x-amz-checksum-sha256'], 'signed');
      expect(put.headers['content-length'], content.length);
      expect(put.chunks.every((size) => size <= 64 * kib), isTrue);
      expect(sha256.convert(put.body.takeBytes()), sha256.convert(content));
    });

    test(
      'single POST sends the signed policy fields first, the file last',
      () async {
        final content = _content(200 * kib);
        final path = await writeFile(content);
        const fields = {
          'key': 'fam/f/a/a/orig',
          'Content-Type': 'image/jpeg',
          'x-amz-checksum-sha256': 'c2lnbmVk',
          'Policy': 'cG9saWN5',
          'x-amz-signature': 'sig',
        };
        final seen = <(int, int)>[];

        final parts = await repository.uploadFile(
          const UploadInstruction(
            mode: 'single',
            method: 'POST',
            url: 'https://storage.test/bf-media',
            fields: fields,
          ),
          path,
          onProgress: (sent, total) => seen.add((sent, total)),
        );

        expect(parts, isEmpty);
        final post = storage.requests.single;
        expect(post.url, 'https://storage.test/bf-media');
        expect(
          post.headers['content-type'],
          startsWith('multipart/form-data; boundary='),
        );
        final body = post.body.takeBytes();
        final text = latin1.decode(body);
        // Mọi field có mặt nguyên giá trị và đứng trước field file.
        final fileAt = text.indexOf('name="file"');
        expect(fileAt, greaterThan(0));
        for (final entry in fields.entries) {
          final at = text.indexOf('name="${entry.key}"\r\n\r\n${entry.value}');
          expect(at, inInclusiveRange(0, fileAt), reason: entry.key);
        }
        expect(text, contains('filename="upload"'));
        // Nội dung file nằm nguyên vẹn trong form.
        final start = text.indexOf('\r\n\r\n', fileAt) + 4;
        expect(
          sha256.convert(body.sublist(start, start + content.length)),
          sha256.convert(content),
        );
        expect(seen.last, (content.length, content.length));
        expect(post.chunks.every((size) => size <= 64 * kib), isTrue);
      },
    );

    test('each multipart part carries its own Content-MD5', () async {
      const partSize = 64 * kib;
      final content = _content(partSize + 10 * kib);
      final path = await writeFile(content);

      await repository.uploadFile(_multipart(partSize, 2), path);

      expect(storage.requests.map((put) => put.headers['Content-MD5']), [
        base64Encode(md5.convert(content.sublist(0, partSize)).bytes),
        base64Encode(md5.convert(content.sublist(partSize)).bytes),
      ]);
    });

    test('an unknown upload mode is rejected', () async {
      final path = await writeFile(_content(kib));

      await expectLater(
        repository.uploadFile(const UploadInstruction(mode: 'tus'), path),
        throwsA(isA<UnsupportedError>()),
      );
    });
  });

  test('uploadBytes keeps multipart slicing for in-memory content', () async {
    final content = _content(20 * kib);

    await repository.uploadBytes(_multipart(8 * kib, 3), content);

    expect(storage.requests.map((put) => put.headers['content-length']), [
      8 * kib,
      8 * kib,
      4 * kib,
    ]);
  });

  test(
    'hash and describe stream the file, matching a whole-file hash',
    () async {
      final content = _content(300 * kib);
      final path = await writeFile(content);
      final expected = sha256.convert(content).toString();

      expect(await repository.hashLocalFile(path), expected);
      final described = await repository.describeLocalFile(path);
      expect(described.size, content.length);
      expect(described.sha256, expected);
      expect(described.temporary, isFalse);
    },
  );

  group('MediaUploader with a file on disk', () {
    late _FakeMedia media;

    setUp(() => media = _FakeMedia());

    test(
      'declares the size and hash of the file, uploads by path, completes parts',
      () async {
        media.nextFile = const MediaLocalFile(
          path: '/tmp/compressed.mp4',
          size: 21 * 1024 * 1024,
          sha256: 'hash-of-file',
          temporary: true,
        );

        final assetId = await MediaUploader(media).upload(
          'family-1',
          '/gallery/video.mp4',
          purpose: 'MEMORY',
          idempotencyKey: 'key-1',
        );

        expect(assetId, 'asset-1');
        expect(media.keys, ['key-1']);
        expect(media.intent?['size'], 21 * 1024 * 1024);
        expect(media.intent?['sha256'], 'hash-of-file');
        expect(media.uploadedFiles, ['/tmp/compressed.mp4']);
        expect(media.completedParts, [
          {'n': 1, 'etag': 'e1'},
        ]);
        expect(media.deleted, ['/tmp/compressed.mp4']);
      },
    );

    test('source sent to the server keeps only the fields of the contract', () {
      final json = MediaSource(
        sha256: 'hash',
        key: 'VIDEO|1080x1920|170',
        capturedAt: DateTime.utc(2026, 11),
      ).toJson();

      expect(json.keys.toSet(), {'sha256', 'key', 'capturedAt'});
    });

    test('a failed upload still removes the temporary file', () async {
      media
        ..nextFile = const MediaLocalFile(
          path: '/tmp/compressed.mp4',
          size: 10,
          sha256: 'h',
          temporary: true,
        )
        ..failUpload = true;

      await expectLater(
        MediaUploader(
          media,
        ).upload('family-1', '/gallery/video.mp4', purpose: 'MEMORY'),
        throwsA(isA<StateError>()),
      );

      expect(media.deleted, ['/tmp/compressed.mp4']);
      expect(media.completedParts, isEmpty);
    });

    test('the file the user picked is never deleted', () async {
      media.nextFile = const MediaLocalFile(
        path: '/gallery/video.mp4',
        size: 10,
        sha256: 'h',
      );

      await MediaUploader(
        media,
      ).upload('family-1', '/gallery/video.mp4', purpose: 'MEMORY');

      expect(media.deleted, isEmpty);
    });

    test('voice notes upload by path without being read into memory', () async {
      media.described = const MediaLocalFile(
        path: '/tmp/voice.m4a',
        size: 500,
        sha256: 'voice-hash',
      );

      await MediaUploader(
        media,
      ).upload('family-1', '/tmp/voice.m4a', purpose: 'MEMORY');

      expect(media.intent?['kind'], 'AUDIO');
      expect(media.intent?['size'], 500);
      expect(media.intent?['sha256'], 'voice-hash');
      expect(media.uploadedFiles, ['/tmp/voice.m4a']);
      expect(media.deleted, isEmpty);
    });

    test('an already stored asset (dedup) skips upload, cleans up', () async {
      media
        ..nextFile = const MediaLocalFile(
          path: '/tmp/compressed.mp4',
          size: 10,
          sha256: 'h',
          temporary: true,
        )
        ..intentStatus = 'READY';

      await MediaUploader(
        media,
      ).upload('family-1', '/gallery/video.mp4', purpose: 'MEMORY');

      expect(media.uploadedFiles, isEmpty);
      expect(media.deleted, ['/tmp/compressed.mp4']);
    });
  });
}

class _FakeMedia extends Fake implements IMediaRepository {
  MediaLocalFile? nextFile;
  MediaLocalFile? described;
  JsonMap? intent;
  String intentStatus = 'PENDING_UPLOAD';
  bool failUpload = false;
  final keys = <String>[];
  final uploadedFiles = <String>[];
  final deleted = <String>[];
  final completedParts = <JsonMap>[];

  @override
  Future<ProcessedMedia> processVideo(String path) async => ProcessedMedia.file(
    kind: 'VIDEO',
    mime: 'video/mp4',
    file: nextFile!,
    durationMs: 1000,
  );

  @override
  Future<int?> mediaDurationMs(String path) async => 1000;

  @override
  Future<MediaLocalFile> describeLocalFile(
    String path, {
    bool temporary = false,
  }) async => described!;

  @override
  Future<UploadIntent?> createUploadIntent(
    String idempotencyKey,
    JsonMap body,
  ) async {
    keys.add(idempotencyKey);
    intent = body;
    return UploadIntent(
      assetId: 'asset-1',
      status: intentStatus,
      upload: const UploadInstruction(
        mode: 'multipart',
        partSize: 8,
        parts: [UploadPartUrl(n: 1, url: 'https://storage.test/p1')],
      ),
    );
  }

  @override
  Future<List<JsonMap>> uploadFile(
    UploadInstruction instruction,
    String path, {
    UploadProgress? onProgress,
  }) async {
    if (failUpload) {
      throw StateError('offline');
    }
    uploadedFiles.add(path);
    return [
      {'n': 1, 'etag': 'e1'},
    ];
  }

  @override
  Future<UploadStatus?> completeUpload(
    String assetId, {
    List<JsonMap> parts = const [],
  }) async {
    completedParts.addAll(parts);
    return const UploadStatus();
  }

  @override
  Future<void> deleteLocalFile(String path) async => deleted.add(path);
}
