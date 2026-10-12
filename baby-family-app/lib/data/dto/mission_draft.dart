import 'package:baby_family/utils/constants/enum.dart';

/// Giá trị điền sẵn của form CARE-03 “Thêm nhiệm vụ” (từ mẫu thư viện hoặc
/// bản nháp mặc định của gia đình).
class MissionDraft {
  const MissionDraft({
    this.title = '',
    this.templateId,
    this.icon,
    this.childIds = const [],
    this.ownerKind = MissionOwnerKind.me,
    this.dueTime,
    this.repeat = MissionRepeat.none,
    this.repeatDays = const [],
    this.reminder = MissionReminder.none,
    this.memoryPrompt = true,
  });

  final String title;
  final String? templateId;

  /// Tên icon Lucide dạng kebab (`bath`, `book-open`…).
  final String? icon;
  final List<String> childIds;
  final MissionOwnerKind ownerKind;

  /// `HH:mm`.
  final String? dueTime;
  final MissionRepeat repeat;

  /// Thứ trong tuần khi [repeat] = `customDays` (1 = Thứ Hai … 7 = Chủ nhật).
  final List<int> repeatDays;
  final MissionReminder reminder;
  final bool memoryPrompt;
}
