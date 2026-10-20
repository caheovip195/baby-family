part of '../enum.dart';

/// ONB-WAIT: bạn đời đã tham gia chưa (tài liệu nghiệp vụ 7.3).
enum PartnerJoinStatus {
  /// Chưa ai nhận lời mời.
  waiting,

  /// Bạn đời đã nhận, chờ người mời xác nhận lần cuối (bước 6).
  awaitingApproval,

  /// Gia đình đã đủ Bố + Mẹ → ONB-ACT.
  joined,
}
