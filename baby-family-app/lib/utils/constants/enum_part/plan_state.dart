part of '../enum.dart';

/// Gói của gia đình (mục 5, BR-054…056, C-05/C-07).
enum PlanState {
  /// Dùng thử 90 ngày: chỉ Papa & Mama, 10 GB, không mời người thân (C-07).
  trial,
  house,
  family,
  expired;

  bool get allowsRelatives => this == PlanState.family;
}
