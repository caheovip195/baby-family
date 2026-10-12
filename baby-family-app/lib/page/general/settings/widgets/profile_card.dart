part of '../mobile/settings_mobile_view.dart';

/// Thẻ hồ sơ (Pencil `SmVqC`): avatar 56 chữ cái đầu theo vai trò, tên 18/800,
/// “Papa · Nhà Lan” 13, chevron 20.
class _ProfileCard extends StatelessWidget {
  const _ProfileCard({required this.member, required this.onTap, this.family});

  final Member member;
  final Family? family;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final name = member.displayName.isEmpty
        ? member.callName
        : member.displayName;
    return Material(
      color: AppColors.resolve(context, kColorSurfaceFFFFFF),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.lg),
        side: BorderSide(color: AppColors.resolve(context, kColorBorderEADFD6)),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.s4),
          child: Row(
            children: [
              AppInitialAvatar(
                name: member.callName,
                size: 56,
                color: member.role == FamilyRole.mother
                    ? kColorPrimary500EE7B67
                    : kColorSecondary5006FAE8E,
              ),
              const SizedBox(width: AppSpacing.cardInset),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: AppTypography.adapt(
                        context,
                        AppTypography.h3.copyWith(fontWeight: FontWeight.w800),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      family == null
                          ? member.callName
                          : context.l10n.setProfileSubtitle(
                              member.callName,
                              family!.name,
                            ),
                      style: AppTypography.adapt(
                        context,
                        AppTypography.caption,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.cardInset),
              Icon(
                LucideIcons.chevronRight,
                size: 20,
                color: AppColors.resolve(context, kColorTextTertiary9C928A),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
