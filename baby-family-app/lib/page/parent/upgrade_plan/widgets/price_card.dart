part of '../mobile/upgrade_plan_mobile_view.dart';

/// Thẻ giá (Pencil “Price”): nền `primary-50`, viền `primary-100`, bo 16,
/// đệm 16, cách 10 — “Hiện tại” → “Gói Family” 20/800, kẻ `primary-100`,
/// ghi chú tính chênh lệch (icon `calculator` 16).
class _PriceCard extends StatelessWidget {
  const _PriceCard({
    required this.currentPrice,
    required this.newPrice,
    required this.channel,
  });

  final String currentPrice;
  final String newPrice;
  final String channel;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final accent = AppColors.resolve(context, kColorPrimary600C2513F);
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
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.subUpgradeCurrent,
                      style: AppTypography.adapt(context, AppTypography.small),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      currentPrice,
                      style: AppTypography.adapt(
                        context,
                        AppTypography.text14.copyWith(
                          fontWeight: FontWeight.w600,
                          color: kColorTextSecondary6B625B,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s2),
                child: Icon(LucideIcons.arrowRight, size: 18, color: accent),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      l10n.famPlanFamily,
                      style: AppTypography.adapt(
                        context,
                        AppTypography.small.copyWith(
                          fontWeight: FontWeight.w600,
                          color: kColorPrimary700A2402F,
                        ),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      newPrice,
                      textAlign: TextAlign.end,
                      style: AppTypography.adapt(
                        context,
                        AppTypography.title20,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.itemGap),
          Container(
            height: 1,
            color: AppColors.resolve(context, kColorPrimary100FFE3DC),
          ),
          const SizedBox(height: AppSpacing.itemGap),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(LucideIcons.calculator, size: 16, color: accent),
              const SizedBox(width: AppSpacing.itemGap),
              Expanded(
                child: Text(
                  l10n.subUpgradeProrate(channel),
                  style: AppTypography.adapt(
                    context,
                    AppTypography.small.copyWith(height: 1.45),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
