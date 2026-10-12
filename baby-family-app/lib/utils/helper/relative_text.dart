import 'package:baby_family/data/model/family/member.dart';
import 'package:baby_family/generated/l10n/app_localizations.dart';
import 'package:baby_family/utils/constants/enum.dart';

/// Nhãn quan hệ của người thân (FAM-03 chip, FAM-04 “Quan hệ: Bà ngoại”).
/// [RelativeRelation.other]/null dùng [fallback] (thường là tên gọi).
String relativeRelationLabel(
  AppLocalizations l10n,
  RelativeRelation? relation, {
  String fallback = '',
}) => switch (relation) {
  RelativeRelation.grandpaPaternal => l10n.relationPaternalGrandfather,
  RelativeRelation.grandmaPaternal => l10n.relationPaternalGrandmother,
  RelativeRelation.grandpaMaternal => l10n.relationMaternalGrandfather,
  RelativeRelation.grandmaMaternal => l10n.relationMaternalGrandmother,
  RelativeRelation.auntUncle => l10n.relationAunt,
  RelativeRelation.nanny => l10n.famRelationNanny,
  RelativeRelation.other || null => fallback,
};

/// “Mẹ của Papa” / “Bố của Mama” (FAM-01) — ông bà theo phía nội (Papa) hoặc
/// ngoại (Mama); quan hệ khác dùng [relativeRelationLabel].
String relativeRelationDescription(
  AppLocalizations l10n,
  Member member, {
  required String papaCallName,
  required String mamaCallName,
}) => switch (member.relation) {
  RelativeRelation.grandmaPaternal => l10n.famRelationMotherOf(papaCallName),
  RelativeRelation.grandpaPaternal => l10n.famRelationFatherOf(papaCallName),
  RelativeRelation.grandmaMaternal => l10n.famRelationMotherOf(mamaCallName),
  RelativeRelation.grandpaMaternal => l10n.famRelationFatherOf(mamaCallName),
  final relation => relativeRelationLabel(
    l10n,
    relation,
    fallback: member.callName,
  ),
};

/// Mức quyền cao nhất người thân có với các bé đang được chia sẻ (bỏ qua
/// bé tạm ẩn); null khi chưa chia sẻ bé nào.
RelativePermission? relativeTopPermission(Member member) {
  RelativePermission? top;
  for (final permission in member.childPermissions.values) {
    if (permission == RelativePermission.hidden) {
      continue;
    }
    if (top == null || permission.index > top.index) {
      top = permission;
    }
  }
  return top;
}

/// Tóm tắt quyền (FAM-01): “Xem, bình luận · được tải ảnh” /
/// “Xem, bình luận · đóng góp ảnh” / “Xem”.
String relativePermissionSummary(AppLocalizations l10n, Member member) {
  final top = relativeTopPermission(member);
  final parts = [
    if (top == null || top == RelativePermission.view)
      l10n.famPermSummaryView
    else
      l10n.famPermSummaryComment,
    if (top == RelativePermission.contribute) l10n.famPermSummaryContribute,
    if (member.allowDownload) l10n.famPermSummaryDownload,
  ];
  return parts.join(' · ');
}

/// Mã đại từ cho câu ICU `select` (“bà”/“ông”/“người thân”).
String relativePronounCode(RelativeRelation? relation) => switch (relation) {
  RelativeRelation.grandmaPaternal ||
  RelativeRelation.grandmaMaternal => 'grandma',
  RelativeRelation.grandpaPaternal ||
  RelativeRelation.grandpaMaternal => 'grandpa',
  _ => 'other',
};

/// Chữ viết tắt cho avatar chữ: “Bà nội” → “BN”, “Ông ngoại” → “ÔN”,
/// “Mama” → “M”.
String nameInitials(String name, {int max = 2}) {
  final words = name.trim().split(RegExp(r'\s+')).where((w) => w.isNotEmpty);
  return words
      .take(max)
      .map((w) => String.fromCharCode(w.runes.first).toUpperCase())
      .join();
}

/// “Hana, Haru và Bơ” — nối danh sách tên theo ngôn ngữ hiện tại.
String joinNames(AppLocalizations l10n, List<String> names) {
  if (names.length <= 1) {
    return names.join();
  }
  return l10n.commonAndList(
    names.take(names.length - 1).join(', '),
    names.last,
  );
}
