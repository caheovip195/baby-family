part of '../mobile/relative_invite_mobile_view.dart';

/// Dòng chọn bé (Pencil `qtPRj`): avatar 36, tên 15/600 (thai kỳ:
/// “Bơ (thai kỳ)”), ô chọn 24 bo 8 `primary-600` + `check` 16 trắng.
class _ChildCheckRow extends StatelessWidget {
  const _ChildCheckRow({
    required this.child,
    required this.selected,
    required this.onTap,
  });

  final Child child;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final name = child.isPregnancy
        ? context.l10n.famPregnancyChild(child.name)
        : child.name;
    return Semantics(
      checked: selected,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.sm),
        child: Row(
          children: [
            ChildAvatar(
              child: child,
              size: 36,
              borderColor: kColorSurfaceFFFFFF,
              iconSize: 16,
            ),
            const SizedBox(width: AppSpacing.s3),
            Expanded(
              child: Text(
                name,
                style: AppTypography.adapt(context, AppTypography.bodyStrong),
              ),
            ),
            const SizedBox(width: AppSpacing.s3),
            AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: selected
                    ? AppColors.resolve(context, kColorPrimary600C2513F)
                    : kColorTransparent,
                borderRadius: BorderRadius.circular(AppSpacing.s2),
                border: selected
                    ? null
                    : Border.all(
                        color: AppColors.resolve(context, kColorBorderEADFD6),
                        width: 2,
                      ),
              ),
              child: selected
                  ? Icon(
                      LucideIcons.check,
                      size: 16,
                      color: AppColors.onPrimary(context),
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
