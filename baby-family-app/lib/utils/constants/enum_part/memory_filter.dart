part of '../enum.dart';

/// Chip lọc của MEM-01 (Tất cả / Cột mốc / Ảnh / Ghi âm — mục 7.10).
enum MemoryFilter {
  all,
  milestones,
  photos,
  voices;

  /// Loại ký ức thuộc bộ lọc; null = mọi loại.
  Set<MemoryKind>? get kinds => switch (this) {
    MemoryFilter.all => null,
    MemoryFilter.milestones => {MemoryKind.milestone},
    MemoryFilter.photos => {
      MemoryKind.photo,
      MemoryKind.keepsake,
      MemoryKind.ultrasound,
      MemoryKind.bump,
      MemoryKind.monthlyPhoto,
      MemoryKind.fromMission,
    },
    MemoryFilter.voices => {MemoryKind.voice},
  };
}
