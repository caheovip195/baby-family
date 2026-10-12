part of '../mobile/pregnancy_journey_mobile_view.dart';

/// Ô “Chụp ảnh bụng tuần 24” (Pencil `gKInn`): đệm 14, cách 12, nền `us-50`,
/// viền 1.5 `us-500`, bo 16; camera 22 `us-700`; chữ 14/700 + phụ 12.
class _TimelineBumpSlot extends StatelessWidget {
  const _TimelineBumpSlot({
    required this.week,
    required this.onTap,
    this.ghostWeek,
  });

  final int week;
  final int? ghostWeek;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Material(
      color: AppColors.resolve(context, kColorUs50F6F2FC),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.lg),
        side: BorderSide(
          color: AppColors.resolve(context, kColorUs5009B85D1),
          width: 1.5,
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.cardInset),
          child: Row(
            children: [
              Icon(
                LucideIcons.camera,
                size: 22,
                color: AppColors.resolve(context, kColorUs7006A549F),
              ),
              const SizedBox(width: AppSpacing.s3),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.pregnancyCaptureWeek(week),
                      style: AppTypography.adapt(
                        context,
                        AppTypography.text14.copyWith(
                          fontWeight: FontWeight.w700,
                          color: kColorUs7006A549F,
                        ),
                      ),
                    ),
                    if (ghostWeek != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        l10n.pregBumpGhostHint(ghostWeek!),
                        style: AppTypography.adapt(
                          context,
                          AppTypography.small,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
