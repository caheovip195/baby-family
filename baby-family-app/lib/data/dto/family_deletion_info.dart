import 'package:baby_family/utils/constants/enum.dart';

/// Trạng thái xoá gia đình cho màn FAM-07 “Xoá gia đình”.
class FamilyDeletionInfo {
  const FamilyDeletionInfo({
    this.status = FamilyDeletionStatus.none,
    this.requestedByMe = false,
    this.scheduledFor,
    this.graceDays = 30,
  });

  final FamilyDeletionStatus status;

  /// Tôi là người yêu cầu (đang chờ người còn lại) hay cần tôi đồng ý.
  final bool requestedByMe;
  final DateTime? scheduledFor;
  final int graceDays;
}
