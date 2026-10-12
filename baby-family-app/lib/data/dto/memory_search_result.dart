import 'package:baby_family/data/model/memory/memory.dart';

/// MEM-15: kết quả tìm kiếm chia nhóm Ảnh & video / Nhật ký.
class MemorySearchResult {
  const MemorySearchResult({
    required this.query,
    this.media = const [],
    this.diaries = const [],
  });

  final String query;
  final List<Memory> media;
  final List<Memory> diaries;

  int get total => media.length + diaries.length;
}
