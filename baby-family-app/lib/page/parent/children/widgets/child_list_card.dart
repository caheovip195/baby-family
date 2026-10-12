part of '../mobile/children_mobile_view.dart';

/// Thẻ bé CHD-03 (Pencil “Hana”): đệm 12/12/12/16 cách 12, bo 16 viền
/// `border`; vạch màu 4×44, avatar 52 (viền màu bé 2.5), tên 18/800 (+ nhãn
/// “Thai #3”), tuổi 13 `text-secondary`, màu bé 11 `text-tertiary`, tay kéo 20.
class _ChildListCard extends StatelessWidget {
  const _ChildListCard({
    required this.child,
    required this.today,
    required this.onTap,
  });

  final Child child;
  final DateTime today;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final color = child.isPregnancy
        ? AppColors.resolve(context, kColorUs5009B85D1)
        : ChildAvatar.colorOf(child);
    final due = child.dueDate;
    final birth = child.birthDate;
    final String? subtitle;
    if (child.isPregnancy) {
      subtitle = due == null
          ? null
          : l10n.commonDotJoin(
              pregnancyWeekText(l10n, due, today),
              l10n.childDueShort(due.toDayMonth(l10n.localeName)),
            );
    } else {
      subtitle = birth == null ? null : childAgeText(l10n, birth, today);
    }
    return Material(
      color: AppColors.resolve(context, kColorSurfaceFFFFFF),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.lg),
        side: BorderSide(color: AppColors.resolve(context, kColorBorderEADFD6)),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.s4,
            AppSpacing.s3,
            AppSpacing.s3,
            AppSpacing.s3,
          ),
          child: Row(
            children: [
              Container(
                width: 4,
                height: 44,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: AppSpacing.s3),
              ChildAvatar(
                child: child,
                size: child.isPregnancy ? 52 : 47,
                iconSize: 24,
                borderColor: child.isPregnancy ? null : color,
                borderWidth: 2.5,
              ),
              const SizedBox(width: AppSpacing.s3),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Wrap(
                      spacing: AppSpacing.compact,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Text(
                          child.name,
                          style: AppTypography.adapt(
                            context,
                            AppTypography.h3.copyWith(
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                        if (child.isPregnancy && child.pregnancyOrder != null)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppSpacing.compact,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.resolve(
                                context,
                                kColorUs100EAE2F8,
                              ),
                              borderRadius: BorderRadius.circular(AppRadius.xs),
                            ),
                            child: Text(
                              l10n.childPregnancyTag(child.pregnancyOrder!),
                              style: AppTypography.adapt(
                                context,
                                AppTypography.micro.copyWith(
                                  fontWeight: FontWeight.w700,
                                  color: kColorUs7006A549F,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                    if (subtitle != null) ...[
                      const SizedBox(height: 3),
                      Text(
                        subtitle,
                        style: AppTypography.adapt(
                          context,
                          AppTypography.caption,
                        ),
                      ),
                    ],
                    const SizedBox(height: 3),
                    Row(
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: color,
                          ),
                        ),
                        const SizedBox(width: 5),
                        Flexible(
                          child: Text(
                            l10n.childColorNamed(
                              child.isPregnancy
                                  ? l10n.childColorName('3')
                                  : l10n.childColorName('${child.colorIndex}'),
                            ),
                            style: AppTypography.adapt(
                              context,
                              AppTypography.tiny,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Icon(
                LucideIcons.gripVertical,
                size: 20,
                color: AppColors.resolve(context, kColorTextTertiary9C928A),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
