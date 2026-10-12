part of '../mobile/baby_names_mobile_view.dart';

/// Thẻ tên (Pencil `L1RpBT`/`LXwrw`): đệm 14, cách 12, `surface`, bo 16 —
/// chọn: viền 2 `us-500`, khác: viền 1 `us-100`. Tên 18/800, nhãn “Cả hai
/// thích 💞” (`us-700`, 10/800), ý nghĩa 12, “Thêm bởi …” 11; cột tim M
/// (`primary-500`) / P (`secondary-500`) 30, chưa thích `surface-variant`.
class _NameCard extends StatelessWidget {
  const _NameCard({
    required this.name,
    required this.selected,
    required this.iAmMama,
    required this.onTap,
    required this.onLike,
  });

  final NameCandidate name;
  final bool selected;
  final bool iAmMama;
  final VoidCallback onTap;
  final VoidCallback onLike;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final mamaLikes = iAmMama ? name.likedByMe : name.likedByPartner;
    final papaLikes = iAmMama ? name.likedByPartner : name.likedByMe;
    return Material(
      color: AppColors.resolve(context, kColorSurfaceFFFFFF),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.lg),
        side: BorderSide(
          color: AppColors.resolve(
            context,
            selected ? kColorUs5009B85D1 : kColorUs100EAE2F8,
          ),
          width: selected ? 2 : 1,
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.cardInset),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Wrap(
                      spacing: AppSpacing.s2,
                      runSpacing: AppSpacing.s1,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Text(
                          name.name,
                          style: AppTypography.adapt(
                            context,
                            AppTypography.h3.copyWith(
                              fontWeight: FontWeight.w800,
                              height: 25 / 18,
                            ),
                          ),
                        ),
                        if (name.bothLike)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppSpacing.s2,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.resolve(
                                context,
                                kColorUs7006A549F,
                              ),
                              borderRadius: BorderRadius.circular(
                                AppRadius.full,
                              ),
                            ),
                            child: Text(
                              l10n.pregNamesBothLike,
                              style: AppTypography.micro.copyWith(
                                fontWeight: FontWeight.w800,
                                color: AppColors.onPrimary(context),
                              ),
                            ),
                          ),
                      ],
                    ),
                    if (name.meaning != null) ...[
                      const SizedBox(height: 3),
                      Text(
                        name.meaning!,
                        style: AppTypography.adapt(
                          context,
                          AppTypography.small,
                        ),
                      ),
                    ],
                    if (name.addedByCallName != null) ...[
                      const SizedBox(height: 3),
                      Text(
                        l10n.pregNamesAddedBy(name.addedByCallName!),
                        style: AppTypography.adapt(context, AppTypography.tiny),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.s3),
              Column(
                children: [
                  _heart(
                    context,
                    liked: mamaLikes,
                    color: kColorPrimary500EE7B67,
                    callName: kValueDefaultCallNameMother,
                    onTap: iAmMama ? onLike : null,
                  ),
                  const SizedBox(height: AppSpacing.s1),
                  _heart(
                    context,
                    liked: papaLikes,
                    color: kColorSecondary5006FAE8E,
                    callName: kValueDefaultCallNameFather,
                    onTap: iAmMama ? null : onLike,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _heart(
    BuildContext context, {
    required bool liked,
    required Color color,
    required String callName,
    VoidCallback? onTap,
  }) {
    return Semantics(
      button: onTap != null,
      toggled: liked,
      label: context.l10n.pregNamesLikeBy(callName),
      child: InkResponse(
        onTap: onTap,
        radius: 22,
        child: Container(
          width: 30,
          height: 30,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: AppColors.resolve(
              context,
              liked ? color : kColorSurfaceVariantF7F1EC,
            ),
            shape: BoxShape.circle,
          ),
          child: Icon(
            LucideIcons.heart,
            size: 14,
            color: liked
                ? kColorWhite
                : AppColors.resolve(context, kColorTextTertiary9C928A),
          ),
        ),
      ),
    );
  }
}
