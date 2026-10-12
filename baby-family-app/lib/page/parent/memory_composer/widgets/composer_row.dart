part of '../mobile/memory_composer_mobile_view.dart';

/// Dòng chọn (`jNAsi`): cao 52, đệm ngang 14, cách 12, nền `surface`, viền,
/// bo 14; icon 20 `text-secondary`, nhãn 15, giá trị 14/600
/// `text-secondary`, `chevron-right` 18 `text-tertiary`.
class _ComposerRow extends StatelessWidget {
  const _ComposerRow({
    required this.icon,
    required this.label,
    this.value,
    this.onTap,
  });

  final IconData icon;
  final String label;
  final String? value;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.resolve(context, kColorSurfaceFFFFFF),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.md),
        side: BorderSide(color: AppColors.resolve(context, kColorBorderEADFD6)),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: AppSpacing.fieldHeight),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.cardInset,
              vertical: AppSpacing.s2,
            ),
            child: Row(
              children: [
                Icon(
                  icon,
                  size: 20,
                  color: AppColors.resolve(context, kColorTextSecondary6B625B),
                ),
                const SizedBox(width: AppSpacing.s3),
                Expanded(
                  child: Text(
                    label,
                    style: AppTypography.adapt(
                      context,
                      AppTypography.body.copyWith(height: 19 / 15),
                    ),
                  ),
                ),
                if (value != null) ...[
                  const SizedBox(width: AppSpacing.s3),
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 160),
                    child: Text(
                      value!,
                      textAlign: TextAlign.end,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppTypography.adapt(
                        context,
                        AppTypography.text14.copyWith(
                          fontWeight: FontWeight.w600,
                          color: kColorTextSecondary6B625B,
                        ),
                      ),
                    ),
                  ),
                ],
                const SizedBox(width: AppSpacing.s3),
                Icon(
                  LucideIcons.chevronRight,
                  size: 18,
                  color: AppColors.resolve(context, kColorTextTertiary9C928A),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
