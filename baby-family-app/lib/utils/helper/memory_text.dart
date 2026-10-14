import 'package:baby_family/data/model/family/member.dart';
import 'package:baby_family/data/model/memory/memory.dart';
import 'package:baby_family/generated/l10n/app_localizations.dart';
import 'package:baby_family/utils/constants/enum.dart';
import 'package:baby_family/utils/extension/date_time.dart';

/// Chuỗi hiển thị dùng chung của khu Ký ức (MEM-01/05/07/23/24/25).

/// “Vừa xong” • “20 phút trước” • “2 giờ trước” • “Hôm qua” • “05/10”.
String memoryRelativeTime(AppLocalizations l10n, DateTime at, DateTime now) {
  final diff = now.difference(at);
  if (diff.inMinutes < 1) {
    return l10n.memJustNow;
  }
  if (diff.inMinutes < 60) {
    return l10n.memMinutesAgo(diff.inMinutes);
  }
  if (at.isSameDay(now)) {
    return l10n.memHoursAgo(diff.inHours);
  }
  if (at.isSameDay(now.subtract(const Duration(days: 1)))) {
    return l10n.memYesterday;
  }
  return at.toDayMonth(l10n.localeName);
}

/// “Hôm nay, 19:05” • “Hôm qua, 19:05” • “05/10, 19:05”.
String memoryDayTime(AppLocalizations l10n, DateTime at, DateTime today) {
  final time = at.toDisplayTime(l10n.localeName);
  if (at.isSameDay(today)) {
    return l10n.memTodayAt(time);
  }
  if (at.isSameDay(today.subtract(const Duration(days: 1)))) {
    return l10n.memYesterdayAt(time);
  }
  return l10n.memDateAt(at.toDayMonth(l10n.localeName), time);
}

/// “Hôm nay, 07/10” (MEM-05 dòng Ngày xảy ra) hoặc “05/10/2026”.
String memoryDayLabel(AppLocalizations l10n, DateTime at, DateTime today) =>
    at.isSameDay(today)
    ? l10n.memTodayAt(at.toDayMonth(l10n.localeName))
    : at.toFormDate(l10n.localeName);

/// Tên đầy đủ của thành viên: “Mama Lan”, “Bà nội”.
String memberFullName(Member member) {
  final call = member.callName.trim();
  final name = member.displayName.trim();
  if (call.isEmpty) {
    return name;
  }
  if (name.isEmpty || call.endsWith(name)) {
    return call;
  }
  return '$call $name';
}

/// Nhãn ngắn của chế độ người xem: Cả nhà / Chỉ Papa & Mama / Chỉ mình tôi.
String memoryVisibilityLabel(
  AppLocalizations l10n,
  MemoryVisibility visibility,
) => switch (visibility) {
  MemoryVisibility.family => l10n.memoriesFamily,
  MemoryVisibility.parents => l10n.commonOnlyParents,
  MemoryVisibility.onlyMe => l10n.commonOnlyYou,
};

/// “Cả nhà · 6 người” (MEM-23/24) — [people] = số thành viên gia đình.
String memoryAudience(
  AppLocalizations l10n,
  MemoryVisibility visibility,
  int people,
) => visibility == MemoryVisibility.family
    ? l10n.memAudiencePeople(people)
    : memoryVisibilityLabel(l10n, visibility);

/// “0:12” — thời lượng ghi âm.
String memoryDuration(int seconds) =>
    '${seconds ~/ 60}:${(seconds % 60).toString().padLeft(2, '0')}';

/// Nhãn loại ký ức (MEM-17 “Nhật ký · Haru…”, MEM-18 “Khoảnh khắc · Haru…”).
String memoryKindLabel(AppLocalizations l10n, MemoryKind kind) =>
    switch (kind) {
      MemoryKind.photo || MemoryKind.fromMission => l10n.memKindMoment,
      MemoryKind.diary => l10n.commonDiary,
      MemoryKind.voice => l10n.memoriesVoices,
      MemoryKind.quote => l10n.memoriesQuotes,
      MemoryKind.monthlyPhoto => l10n.memKindMoment,
      MemoryKind.keepsake => l10n.memoriesKeepsakes,
      MemoryKind.letter => l10n.commonLetter,
      MemoryKind.ultrasound => l10n.pregnancyUltrasound,
      MemoryKind.bump => l10n.pregnancyBumpPhoto,
      MemoryKind.milestone => l10n.commonMilestone,
    };

/// Tiêu đề hiển thị của ký ức: tiêu đề, không có thì nội dung.
String memoryTitle(Memory memory) => memory.title ?? memory.body ?? '';
