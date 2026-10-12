part of '../enum.dart';

/// Bộ dữ liệu mẫu chọn bằng `--dart-define=BABY_FAMILY_DEMO=<name>`.
enum DemoSeed {
  /// Chưa đăng nhập, chưa có gia đình — đi từ Welcome.
  fresh,

  /// Gia đình “Nhà Lan” đầy đủ, đăng nhập là Mama Lan, gói Family với
  /// Bà nội, Bà ngoại, Ông ngoại (story v2).
  active,

  /// Gia đình chỉ có thai kỳ Bơ (chưa có bé chào đời).
  pregnant,

  /// Đăng nhập là Bà ngoại (người thân), gia đình dùng gói Family.
  circle,

  /// Gia đình hết hạn dùng thử → SUB-07.
  expired,

  /// Như `active` nhưng đang dùng thử, chưa có người thân (C-07) — biến thể
  /// “FAM-01 · Gia đình (đang dùng thử)”, SUB-01 từ thẻ dùng thử.
  trial,

  /// Papa đã xoá tài khoản (PARTNER_LEFT): gia đình chỉ xem & tải về,
  /// Papa & Mama tạm khoá (US-00), mời bạn đời mới (FAM-02).
  partnerLeft,

  /// Bà ngoại đăng nhập, gia đình tạm dừng chia sẻ với bà (CIR-05).
  circlePaused,

  /// Như `active` nhưng gia hạn gói chưa thành công (banner SUB-06).
  paymentIssue,

  /// Như `active` nhưng dùng gói House (SUB-04 nâng cấp lên Family).
  house;

  static DemoSeed fromName(String? name) =>
      DemoSeed.values.where((seed) => seed.name == name).firstOrNull ??
      DemoSeed.fresh;
}
