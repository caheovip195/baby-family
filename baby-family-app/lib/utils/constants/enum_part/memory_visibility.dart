part of '../enum.dart';

/// Ai thấy ký ức (mục 7.6). Góc nhìn thứ hai kế thừa, không rộng hơn (BR-071).
enum MemoryVisibility {
  /// Cả nhà, gồm người thân được cấp quyền bé đó.
  family,

  /// Chỉ Papa & Mama.
  parents,

  /// Chỉ người tạo.
  onlyMe;

  /// Mức rộng: số lớn = nhiều người thấy hơn.
  int get breadth => switch (this) {
    MemoryVisibility.family => 2,
    MemoryVisibility.parents => 1,
    MemoryVisibility.onlyMe => 0,
  };
}
