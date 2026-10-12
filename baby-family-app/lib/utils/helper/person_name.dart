import 'package:baby_family/generated/l10n/app_localizations.dart';

/// Tên ngắn để ghép với tên gọi (“Mama Lan”): từ đầu tiên của tên hiển thị
/// theo cách người dùng nhập ở AUTH-04 (“Lan Nguyễn” → “Lan”).
String shortPersonName(String fullName) {
  final parts = fullName.trim().split(RegExp(r'\s+'));
  return parts.isEmpty ? '' : parts.first;
}

/// “Mama Lan” — tên gọi + tên ngắn (ONB-04, ONB-06, INV-01); chỉ tên gọi khi
/// chưa có tên.
String memberLabel(
  AppLocalizations l10n, {
  required String callName,
  required String displayName,
}) {
  final name = shortPersonName(displayName);
  return name.isEmpty ? callName : l10n.onbMemberLabel(callName, name);
}
