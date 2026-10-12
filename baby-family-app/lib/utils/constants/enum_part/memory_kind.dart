part of '../enum.dart';

/// Loại ký ức (mục 7.5…7.11). Dùng làm query `kind` của MEM-05.
enum MemoryKind {
  photo,
  diary,
  voice,
  quote,
  monthlyPhoto,
  keepsake,
  letter,
  ultrasound,
  bump,
  milestone,
  fromMission;

  static MemoryKind? fromName(String? name) =>
      MemoryKind.values.where((kind) => kind.name == name).firstOrNull;
}
