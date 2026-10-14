part of '../mobile/ai_settings_mobile_view.dart';

/// Thẻ lượt AI (Pencil “Quota”): nền `primary-50`, viền `primary-100`, bo 16,
/// đệm 16, cách 10 — “286” 26/800 + “/ 300 lượt”, ngày làm mới, thanh 8 trắng
/// (phần còn lại `primary-500`), dòng gói.
class _AiQuotaCard extends StatelessWidget {
  const _AiQuotaCard({
    required this.remaining,
    required this.total,
    this.renews,
    this.planLabel,
  });

  final int remaining;
  final int total;
  final String? renews;
  final String? planLabel;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Container(
      padding: const EdgeInsets.all(AppSpacing.s4),
      decoration: BoxDecoration(
        color: AppColors.resolve(context, kColorPrimary50FFF4F1),
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(
          color: AppColors.resolve(context, kColorPrimary100FFE3DC),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.setAiQuotaLabel,
                      style: AppTypography.adapt(context, AppTypography.small),
                    ),
                    const SizedBox(height: 2),
                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: '$remaining',
                            style: AppTypography.h1.copyWith(
                              color: AppColors.resolve(
                                context,
                                kColorTextPrimary2E2A27,
                              ),
                            ),
                          ),
                          const WidgetSpan(
                            child: SizedBox(width: AppSpacing.s1),
                          ),
                          TextSpan(
                            text: l10n.setAiQuotaTotal(total),
                            style: AppTypography.caption.copyWith(
                              fontWeight: FontWeight.w600,
                              color: AppColors.resolve(
                                context,
                                kColorTextSecondary6B625B,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              if (renews != null)
                Text(
                  l10n.setAiRenews(renews!),
                  style: AppTypography.adapt(
                    context,
                    AppTypography.small.copyWith(
                      color: kColorTextTertiary9C928A,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.itemGap),
          AppProgressBar(
            value: total <= 0 ? 0 : remaining / total,
            color: AppColors.resolve(context, kColorPrimary500EE7B67),
            trackColor: AppColors.resolve(context, kColorSurfaceFFFFFF),
          ),
          if (planLabel != null) ...[
            const SizedBox(height: AppSpacing.itemGap),
            Text(
              l10n.setAiPlanQuota(planLabel!, total),
              style: AppTypography.adapt(context, AppTypography.small),
            ),
          ],
        ],
      ),
    );
  }
}
