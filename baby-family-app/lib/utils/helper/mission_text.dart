import 'package:baby_family/data/model/care/mission.dart';
import 'package:baby_family/data/model/care/mission_template.dart';
import 'package:baby_family/generated/l10n/app_localizations.dart';
import 'package:baby_family/utils/constants/enum.dart';
import 'package:baby_family/utils/extension/date_time.dart';
import 'package:flutter/widgets.dart';
import 'package:lucide_flutter/lucide_flutter.dart';

/// Dòng phụ của thẻ nhiệm vụ (Pencil MissionCard `z1ARj` trên HOME-01/02):
/// “Gợi ý hôm nay · Gắn kết · +5 💗” — nhiệm vụ có giờ thì thay nhóm bằng giờ
/// (“Gợi ý hôm nay · 19:30 · +5 💗”). Hearts chỉ có ở nhiệm vụ của tôi
/// (BR-018 — nhiệm vụ của bạn đời có `hearts == null`).
String missionMetaText(AppLocalizations l10n, Mission mission) {
  final parts = <String>[
    if (mission.source == MissionSource.system) l10n.commonSuggestedToday,
    mission.dueTime ?? l10n.commonMissionCategory(mission.category.name),
    if (mission.hearts != null) l10n.commonHeartsPlus(mission.hearts!),
  ];
  return parts.reduce(l10n.commonDotJoin);
}

/// Dòng phụ thẻ nhiệm vụ ở CARE-01 (Pencil `jhh4V`/`qkr1a`), đủ các trạng thái:
/// - của tôi / cùng nhau: “Gợi ý hôm nay · Gắn kết · +5 💗”,
///   “Gợi ý hôm nay · 19:30 · +5 💗”, “Tự tạo · +2 💗”, “Đã xong 08:40 · +5 💗”;
/// - của bạn đời (không có Hearts — BR-018): “Xong lúc 07:15”,
///   “Gợi ý hôm nay · Gắn kết”.
String careMissionMetaText(AppLocalizations l10n, Mission mission) {
  final hearts = mission.ownerKind == MissionOwnerKind.partner
      ? null
      : mission.hearts;
  final completedAt = mission.completedAt;
  if (mission.isDone && completedAt != null) {
    final time = completedAt.toDisplayTime(l10n.localeName);
    if (hearts == null) {
      return l10n.carePartnerDoneAt(time);
    }
    return l10n.commonDotJoin(
      l10n.careMetaDoneAt(time),
      l10n.commonHeartsPlus(hearts),
    );
  }
  final system = mission.source == MissionSource.system;
  return <String>[
    if (system) l10n.commonSuggestedToday else l10n.careMetaCustom,
    if (mission.dueTime != null)
      mission.dueTime!
    else if (system)
      l10n.careCategory(mission.category.name),
    if (hearts != null) l10n.commonHeartsPlus(hearts),
  ].reduce(l10n.commonDotJoin);
}

/// Dòng phụ của mẫu nhiệm vụ: “Gắn kết · 5 phút” (CARE-04/05).
String missionTemplateMeta(AppLocalizations l10n, MissionTemplate template) =>
    <String>[
      l10n.careCategory(template.category.name),
      if (template.durationMin != null)
        l10n.careDurationMin(template.durationMin!),
    ].reduce(l10n.commonDotJoin);

/// Icon Lucide của nhiệm vụ/mẫu (dữ liệu lưu tên kebab, ví dụ `book-open`).
IconData missionIcon(String? name) => switch (name) {
  'book-open' => LucideIcons.bookOpen,
  'bath' => LucideIcons.bath,
  'music' => LucideIcons.music,
  'footprints' => LucideIcons.footprints,
  'camera' => LucideIcons.camera,
  'baby' => LucideIcons.baby,
  'video' => LucideIcons.video,
  'bed' => LucideIcons.bed,
  'trees' => LucideIcons.trees,
  'moon' => LucideIcons.moon,
  'milk' => LucideIcons.milk,
  _ => LucideIcons.heartHandshake,
};

/// Mã thứ cho các khoá ICU `select` (`careWeekday`, `careWeekdayLong`):
/// 1 = Thứ Hai … 7 = Chủ nhật.
String weekdayCode(int weekday) =>
    const ['mon', 'tue', 'wed', 'thu', 'fri', 'sat', 'sun'][(weekday - 1) % 7];
