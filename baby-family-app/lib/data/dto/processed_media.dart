import 'dart:typed_data';

import 'package:baby_family/data/dto/media_local_file.dart';
import 'package:baby_family/data/dto/media_source.dart';
import 'package:baby_family/data/dto/media_variant_file.dart';

/// Kết quả xử lý trên máy trước khi upload: file chính đã nén + các biến thể.
/// Server không nén/xử lý lại (quyết định 2026-10-21). File chính ở trong bộ
/// nhớ ([bytes], ảnh đã nén) hoặc trên đĩa ([file], video và ghi âm).
class ProcessedMedia {
  const ProcessedMedia({
    required this.kind,
    required this.mime,
    required Uint8List this.bytes,
    this.width,
    this.height,
    this.durationMs,
    this.variants = const [],
    this.source,
  }) : file = null;

  const ProcessedMedia.file({
    required this.kind,
    required this.mime,
    required MediaLocalFile this.file,
    this.width,
    this.height,
    this.durationMs,
    this.variants = const [],
    this.source,
  }) : bytes = null;

  /// `IMAGE` | `VIDEO` | `AUDIO`.
  final String kind;
  final String mime;
  final Uint8List? bytes;
  final MediaLocalFile? file;
  final int? width;
  final int? height;
  final int? durationMs;
  final List<MediaVariantFile> variants;

  /// Dấu vết file gốc để máy khác/sau này nhận ra bản trong thư viện.
  final MediaSource? source;

  /// Kích thước file chính (byte).
  int get size => file?.size ?? bytes?.length ?? 0;
}
