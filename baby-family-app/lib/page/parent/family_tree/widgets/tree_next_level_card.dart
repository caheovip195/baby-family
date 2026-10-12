part of '../mobile/family_tree_mobile_view.dart';

/// Thẻ cấp sau (Pencil `cc96t`): nền `surface` bo 20, đệm 16, cách 10;
/// “Sắp tới … 🌸” 14/600 + % 14/700 `secondary-700`, thanh 10, phần thưởng 12.
class _TreeNextLevelCard extends StatelessWidget {
  const _TreeNextLevelCard({
    required this.nextName,
    required this.percent,
    this.reward,
  });

  final String nextName;
  final int percent;
  final String? reward;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Container(
      padding: const EdgeInsets.all(AppSpacing.s4),
      decoration: BoxDecoration(
        color: AppColors.resolve(context, kColorSurfaceFFFFFF),
        borderRadius: BorderRadius.circular(AppRadius.xl),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  l10n.careTreeNextLevel(nextName),
                  style: AppTypography.adapt(
                    context,
                    AppTypography.text14.copyWith(fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              Text(
                l10n.careTreePercent(percent),
                style: AppTypography.adapt(
                  context,
                  AppTypography.text14.copyWith(
                    fontWeight: FontWeight.w700,
                    color: kColorSecondary7003F7A5C,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.itemGap),
          AppProgressBar(value: percent / 100, height: 10),
          if (reward != null) ...[
            const SizedBox(height: AppSpacing.itemGap),
            Text(
              l10n.careTreeRewardLabel(reward!),
              style: AppTypography.adapt(context, AppTypography.small),
            ),
          ],
        ],
      ),
    );
  }
}
