import 'package:baby_family/data/model/chat/chat_conversation.dart';
import 'package:baby_family/generated/l10n/app_localizations.dart';
import 'package:baby_family/utils/extension/date_time.dart';

/// Chữ dùng chung của CHAT-01/02 (BF-20261101-001).

/// Tên cuộc trò chuyện theo loại (server không gửi tên).
String chatTitle(AppLocalizations l10n, ChatConversation conversation) =>
    conversation.isCouple ? l10n.chatCoupleTitle : l10n.chatFamilyTitle;

/// Tên hiển thị của thành viên; không còn trong danh sách → “Thành viên”.
String chatMemberName(
  AppLocalizations l10n,
  ChatConversation? conversation,
  String userId,
) {
  final name = conversation?.member(userId)?.displayName.trim() ?? '';
  return name.isEmpty ? l10n.chatSomeone : name;
}

/// Giờ ở danh sách: cùng ngày `HH:mm`, hôm qua “Hôm qua”, còn lại ngày.
String chatListTime(
  AppLocalizations l10n,
  DateTime time,
  DateTime now, {
  String? locale,
}) {
  final local = time.toLocal();
  if (local.isSameDay(now)) {
    return local.toDisplayTime(locale);
  }
  if (local.isSameDay(now.subtract(const Duration(days: 1)))) {
    return l10n.chatYesterday;
  }
  return local.toDisplayDate(locale);
}

/// Ngăn cách ngày trong hội thoại: “Hôm nay” / “Hôm qua” / ngày.
String chatDayLabel(
  AppLocalizations l10n,
  DateTime day,
  DateTime now, {
  String? locale,
}) {
  if (day.isSameDay(now)) {
    return l10n.chatToday;
  }
  if (day.isSameDay(now.subtract(const Duration(days: 1)))) {
    return l10n.chatYesterday;
  }
  return day.toDisplayDateMedium(locale);
}
