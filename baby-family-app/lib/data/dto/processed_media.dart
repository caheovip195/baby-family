import 'dart:typed_data';

import 'package:baby_family/data/dto/media_source.dart';

/// Một biến thể do client tạo (`m1080`, `t320`, `poster`, …) để upload thẳng
/// lên S3 qua URL presign của phiên upload.
class MediaVariantFile {
  const MediaVariantFile({
    required this.code,
    required this.mime,
    required this.bytes,
    this.width,
    this.height,
  });

  final String code;
  final String mime;
  final Uint8List bytes;
  final int? width;
  final int? height;
}

/// Kết quả xử lý trên máy trước khi upload: file chính đã nén + các biến thể.
/// Server không nén/xử lý lại (quyết định 2026-10-21).
class ProcessedMedia {
  const ProcessedMedia({
    required this.kind,
    required this.mime,
    required this.bytes,
    this.width,
    this.height,
    this.durationMs,
    this.variants = const [],
    this.source,
  });

  /// `IMAGE` | `VIDEO` | `AUDIO`.
  final String kind;
  final String mime;
  final Uint8List bytes;
  final int? width;
  final int? height;
  final int? durationMs;
  final List<MediaVariantFile> variants;

  /// Dấu vết file gốc để máy khác/sau này nhận ra bản trong thư viện.
  final MediaSource? source;
}
