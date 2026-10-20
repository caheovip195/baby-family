import 'package:baby_family/data/model/memory/memory.dart';

/// Một ô của MEM-02 (lưới ảnh): ảnh hiển thị + ký ức chứa ảnh (chạm → MEM-07).
class MemoryGridPhoto {
  const MemoryGridPhoto({required this.asset, required this.memory});

  /// URL ký (bản thu nhỏ khi có), file trên máy hoặc ảnh mẫu.
  final String asset;
  final Memory memory;
}
