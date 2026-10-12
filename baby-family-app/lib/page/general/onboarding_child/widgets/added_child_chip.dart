part of '../mobile/onboarding_child_mobile_view.dart';

/// Chip bé đã thêm: cao 48, đệm `8 14 8 8`, nền `surface`, viền `border`, bo
/// tròn; avatar 32 + “Tên · tuổi” 14/600.
class _AddedChildChip extends StatelessWidget {
  const _AddedChildChip({required this.child, required this.today});

  final Child child;
  final DateTime today;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final birth = child.birthDate;
    return Container(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.s2,
        AppSpacing.s2,
        AppSpacing.cardInset,
        AppSpacing.s2,
      ),
      decoration: BoxDecoration(
        color: AppColors.resolve(context, kColorSurfaceFFFFFF),
        borderRadius: BorderRadius.circular(AppRadius.full),
        border: Border.all(
          color: AppColors.resolve(context, kColorBorderEADFD6),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          ChildAvatar(
            child: child,
            size: AppSpacing.s8,
            borderColor: AppColors.resolve(context, kColorSurfaceFFFFFF),
          ),
          const SizedBox(width: AppSpacing.s2),
          Flexible(
            child: Text(
              birth == null
                  ? child.name
                  : l10n.commonChildNameAge(
                      child.name,
                      childAgeText(l10n, birth, today),
                    ),
              style: AppTypography.adapt(
                context,
                AppTypography.text14.copyWith(fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
