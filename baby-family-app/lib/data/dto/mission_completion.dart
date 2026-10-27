import 'package:baby_family/data/model/care/mission.dart';

/// Kết quả hoàn thành nhiệm vụ (CARE-06): Hearts nhận được và hạn hoàn tác.
class MissionCompletion {
  const MissionCompletion({
    required this.mission,
    required this.heartsEarned,
    required this.undoUntil,
    this.pendingSync = false,
  });

  final Mission mission;
  final int heartsEarned;
  final DateTime undoUntil;

  /// Xong trên máy khi mất mạng (offline-first): Hearts do server cộng khi
  /// thao tác được gửi.
  final bool pendingSync;
}
