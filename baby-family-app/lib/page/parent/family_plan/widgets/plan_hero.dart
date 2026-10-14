part of '../mobile/family_plan_mobile_view.dart';

/// Thẻ gói SUB-03 (Pencil “Plan Hero”): nền `primary-50`, viền `primary-100`,
/// bo 16, đệm 16, cách 14; ô icon 44 trắng bo 12 (`crown` 22), tên gói
/// 20/800 + giá 13, nhãn “Đang hoạt động”; khung thông tin trắng bo 12.
class _PlanHero extends StatelessWidget {
  const _PlanHero({required this.title, required this.rows, this.price});

  final String title;
  final String? price;
  final List<(String, String)> rows;

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
            children: [
              const AppIconBadge(
                icon: LucideIcons.crown,
                size: 44,
                iconSize: 22,
                radius: AppRadius.tile,
                color: kColorSurfaceFFFFFF,
                foreground: kColorPrimary600C2513F,
              ),
              const SizedBox(width: AppSpacing.s3),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppTypography.adapt(
                        context,
                        AppTypography.title20,
                      ),
                    ),
                    if (price != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        price!,
                        style: AppTypography.adapt(
                          context,
                          AppTypography.caption.copyWith(height: 16 / 13),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.s3),
              AppTagPill(
                label: l10n.subPlanActive,
                dotColor: kColorSuccess3E9B6E,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.cardInset),
          Container(
            padding: const EdgeInsets.all(AppSpacing.s3),
            decoration: BoxDecoration(
              color: AppColors.resolve(context, kColorSurfaceFFFFFF),
              borderRadius: BorderRadius.circular(AppRadius.tile),
            ),
            child: Column(
              children: [
                for (final (index, (label, value)) in rows.indexed) ...[
                  if (index > 0) const SizedBox(height: AppSpacing.s2),
                  AppKeyValueRow(label: label, value: value),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
