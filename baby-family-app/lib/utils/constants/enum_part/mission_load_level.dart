part of '../enum.dart';

/// CARE-12 — mức nhiệm vụ hằng ngày của cả nhà (mục 7.13.2): Nhẹ 2 / Vừa 3 /
/// Nhiều 4 việc mỗi người.
enum MissionLoadLevel {
  light(2),
  medium(3),
  heavy(4);

  const MissionLoadLevel(this.perPerson);

  /// Số việc mỗi người mỗi ngày.
  final int perPerson;
}
