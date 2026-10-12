part of '../mobile/plans_mobile_view.dart';

/// Thẻ gói (Pencil `tBBNT`/`wgRmF`): nền `surface`, bo 20, đệm 18, cách 12;
/// đang chọn: viền `primary-500` 2 + vòng chọn đầy. Family có nhãn “Cả nhà”.
class _PlanOfferCard extends StatelessWidget {
  const _PlanOfferCard({
    required this.offer,
    required this.name,
    required this.selected,
    required this.onTap,
  });

  final PlanOffer offer;
  final String name;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final isFamily = offer.code == PlanState.family;
    final features = isFamily
        ? [
            (l10n.billingFamilyIncludes, true),
            (l10n.billingFamilyRelatives, true),
            (l10n.billingFamilyStorage, true),
            (l10n.billingFamilyVideos, true),
          ]
        : [
            (l10n.billingHouseChildren, true),
            (l10n.billingHouseCare, true),
            (l10n.billingHouseStorage, true),
            (l10n.billingInviteRelatives, false),
          ];
    return Semantics(
      selected: selected,
      inMutuallyExclusiveGroup: true,
      button: true,
      child: Material(
        color: AppColors.resolve(context, kColorSurfaceFFFFFF),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.xl),
          side: BorderSide(
            color: AppColors.resolve(
              context,
              selected ? kColorPrimary500EE7B67 : kColorBorderEADFD6,
            ),
            width: selected ? 2 : 1,
          ),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.sectionGap),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Wrap(
                            spacing: AppSpacing.s2,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: [
                              Text(
                                name,
                                style: AppTypography.adapt(
                                  context,
                                  AppTypography.title20,
                                ),
                              ),
                              if (isFamily)
                                _badge(context, l10n.commonAllFamily),
                            ],
                          ),
                          const SizedBox(height: 2),
                          Text(
                            offer.priceText,
                            style: AppTypography.adapt(
                              context,
                              AppTypography.body.copyWith(
                                fontWeight: FontWeight.w700,
                                color: kColorPrimary700A2402F,
                              ),
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            offer.monthlyText,
                            style: AppTypography.adapt(
                              context,
                              AppTypography.small,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: AppSpacing.itemGap),
                    AppRadioMark(selected: selected),
                  ],
                ),
                const SizedBox(height: AppSpacing.s3),
                for (final (index, feature) in features.indexed) ...[
                  if (index > 0) const SizedBox(height: AppSpacing.s2),
                  _PlanFeature(text: feature.$1, included: feature.$2),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _badge(BuildContext context, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.s2,
        vertical: 3,
      ),
      decoration: BoxDecoration(
        color: AppColors.resolve(context, kColorPrimary600C2513F),
        borderRadius: BorderRadius.circular(AppRadius.full),
      ),
      child: Text(
        text,
        style: AppTypography.tiny.copyWith(
          fontWeight: FontWeight.w700,
          color: AppColors.onPrimary(context),
        ),
      ),
    );
  }
}
