part of '../mobile/day_story_mobile_view.dart';

/// “Ai sẽ thấy” (`f1HWB0`): thẻ `surface` viền bo 16, đệm 12/14; `eye` 18 +
/// nhãn 11 `text-tertiary` / giá trị 14/700; `chevron-down` 18.
class _DayWhoSees extends StatelessWidget {
  const _DayWhoSees({required this.value, required this.onTap});

  final String value;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppRadius.lg),
      side: BorderSide(color: AppColors.resolve(context, kColorBorderEADFD6)),
    );
    return Material(
      color: AppColors.resolve(context, kColorSurfaceFFFFFF),
      shape: shape,
      child: InkWell(
        onTap: onTap,
        customBorder: shape,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.cardInset,
            vertical: AppSpacing.s3,
          ),
          child: Row(
            children: [
              Icon(
                LucideIcons.eye,
                size: 18,
                color: AppColors.resolve(context, kColorTextSecondary6B625B),
              ),
              const SizedBox(width: AppSpacing.itemGap),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      context.l10n.recapDayWhoSees,
                      style: AppTypography.adapt(context, AppTypography.tiny),
                    ),
                    const SizedBox(height: 1),
                    Text(
                      value,
                      style: AppTypography.adapt(
                        context,
                        AppTypography.text14.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                LucideIcons.chevronDown,
                size: 18,
                color: AppColors.resolve(context, kColorTextTertiary9C928A),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
