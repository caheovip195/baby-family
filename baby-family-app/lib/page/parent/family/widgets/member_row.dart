part of '../mobile/family_mobile_view.dart';

/// Dòng Papa/Mama (Pencil `KULeZ`): avatar chữ cái 44, tên 15/600, dòng phụ
/// 12 “Quản lý gia đình”, nhãn vai trò dạng viên (Bố: `secondary-100`/
/// `secondary-700`, Mẹ: `primary-50`/`primary-700`).
class _MemberRow extends StatelessWidget {
  const _MemberRow({required this.member, required this.isMe});

  final Member member;
  final bool isMe;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final isMother = member.role == FamilyRole.mother;
    return Row(
      children: [
        AppInitialAvatar(
          name: member.callName,
          color: isMother ? kColorPrimary500EE7B67 : kColorSecondary5006FAE8E,
        ),
        const SizedBox(width: AppSpacing.s3),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                isMe ? l10n.familyYou(member.callName) : member.callName,
                style: AppTypography.adapt(context, AppTypography.bodyStrong),
              ),
              if (member.isAdmin) ...[
                const SizedBox(height: 2),
                Text(
                  l10n.familyManage,
                  style: AppTypography.adapt(context, AppTypography.small),
                ),
              ],
            ],
          ),
        ),
        const SizedBox(width: AppSpacing.s3),
        AppTagPill(
          label: isMother ? l10n.famRoleMother : l10n.famRoleFather,
          color: isMother ? kColorPrimary50FFF4F1 : kColorSecondary100E4F2EA,
          foreground: isMother
              ? kColorPrimary700A2402F
              : kColorSecondary7003F7A5C,
        ),
      ],
    );
  }
}
