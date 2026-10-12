part of '../mobile/care_tab_mobile_view.dart';

/// Nút nổi “+ Thêm nhiệm vụ” (Pencil `F0R79n`): cao 48, đệm ngang 18, nền
/// `primary-600` bo tròn, bóng `#C2513F40` y 6 blur 16; `plus` 18 + 14/700.
class _CareAddFab extends StatelessWidget {
  const _CareAddFab({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final foreground = AppColors.onPrimary(context);
    return DecoratedBox(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(AppRadius.full)),
        boxShadow: AppShadows.extendedFab,
      ),
      child: Material(
        color: AppColors.resolve(context, kColorPrimary600C2513F),
        shape: const StadiumBorder(),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: AppSpacing.s12),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(LucideIcons.plus, size: 18, color: foreground),
                  const SizedBox(width: AppSpacing.s2),
                  Text(
                    context.l10n.careAddMission,
                    style: AppTypography.text14.copyWith(
                      fontWeight: FontWeight.w700,
                      color: foreground,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
