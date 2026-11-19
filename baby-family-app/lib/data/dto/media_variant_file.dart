import 'dart:typed_data';

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
