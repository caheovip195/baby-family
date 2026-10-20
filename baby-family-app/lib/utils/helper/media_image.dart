import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/widgets.dart';

/// Ảnh của ký ức/bé theo nguồn: URL đã ký của server (`https://…`, cache theo
/// đường dẫn không kèm chữ ký để không tải lại khi URL được ký lại), file trên
/// máy vừa chọn ở MEM-04 (`/…`) hoặc asset trong app (dữ liệu mẫu).
ImageProvider mediaImageProvider(String source) {
  if (source.startsWith('http://') || source.startsWith('https://')) {
    final uri = Uri.parse(source);
    return CachedNetworkImageProvider(
      source,
      cacheKey: uri.replace(query: '').toString(),
    );
  }
  if (source.startsWith('/')) {
    return FileImage(File(source));
  }
  return AssetImage(source);
}

/// Video vừa chọn trên máy (MEM-04) — chưa có ảnh xem trước.
bool isLocalVideo(String source) {
  if (!source.startsWith('/')) {
    return false;
  }
  final name = source.toLowerCase();
  return name.endsWith('.mp4') ||
      name.endsWith('.mov') ||
      name.endsWith('.m4v');
}
