part of '../mobile/family_mobile_view.dart';

/// Người thân bị khoá khi chưa có gói Family (Pencil `U983rC`, C-07): nền
/// `surface-variant`, bo 16, đệm 20, ổ khoá trong vòng tròn 48. Chạm → SUB-01.
class _LockedRelatives extends StatelessWidget {
  const _LockedRelatives({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Material(
      color: AppColors.resolve(context, kColorSurfaceVariantF7F1EC),
      borderRadius: BorderRadius.circular(AppRadius.lg),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.s5),
          child: Column(
            children: [
              const AppIconBadge(
                icon: LucideIcons.lock,
                size: 48,
                iconSize: 22,
                radius: AppRadius.full,
                color: kColorSurfaceFFFFFF,
              ),
              const SizedBox(height: AppSpacing.s2),
              Text(
                l10n.familyLockedTitle,
                textAlign: TextAlign.center,
                style: AppTypography.adapt(
                  context,
                  AppTypography.title16.copyWith(fontWeight: FontWeight.w800),
                ),
              ),
              const SizedBox(height: AppSpacing.s2),
              Text(
                l10n.familyLockedDescription,
                textAlign: TextAlign.center,
                style: AppTypography.adapt(
                  context,
                  AppTypography.caption.copyWith(height: 1.45),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
