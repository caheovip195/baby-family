part of '../mobile/family_mobile_view.dart';

/// Dòng người thân (Pencil `xK5xa`): avatar chữ 44 theo quan hệ, tên 15/600,
/// “Mẹ của Papa · Theo dõi Hana, Haru” 12 `text-secondary`, tóm tắt quyền
/// 12 `text-tertiary` (đang chờ: “Đang chờ tham gia”), chevron 18 → FAM-04.
class _RelativeRow extends StatelessWidget {
  const _RelativeRow({
    required this.member,
    required this.description,
    required this.childNames,
    required this.onTap,
  });

  final Member member;
  final String description;
  final List<String> childNames;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    const small = AppTypography.small;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.sm),
      child: Row(
        children: [
          AppRelativeAvatar(
            name: member.callName,
            relation: member.relation,
            size: 44,
          ),
          const SizedBox(width: AppSpacing.s3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  member.callName,
                  style: AppTypography.adapt(
                    context,
                    AppTypography.bodyStrong.copyWith(height: 19 / 15),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  childNames.isEmpty
                      ? l10n.famRelativeFollowsNone(description)
                      : l10n.famRelativeFollows(
                          description,
                          childNames.join(', '),
                        ),
                  style: AppTypography.adapt(context, small),
                ),
                const SizedBox(height: 2),
                Text(
                  member.status == MemberStatus.pending
                      ? l10n.famRelativePending
                      : relativePermissionSummary(l10n, member),
                  style: AppTypography.adapt(
                    context,
                    small.copyWith(color: kColorTextTertiary9C928A),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.s3),
          Icon(
            LucideIcons.chevronRight,
            size: 18,
            color: AppColors.resolve(context, kColorTextTertiary9C928A),
          ),
        ],
      ),
    );
  }
}
