part of '../mobile/home_tab_mobile_view.dart';

/// “Những lần đầu gần đây” (Pencil `BPDzB`): 2 thẻ lần đầu mới nhất (ảnh cao
/// 86, sao 12 `accent-500` + tên 13/700, tuổi lúc đạt 11) + thẻ “Lần đầu tiếp
/// theo?” viền 1.5.
class _FirstsRow extends StatelessWidget {
  const _FirstsRow({required this.controller, required this.child});

  final HomeTabController controller;
  final Child child;

  static const _shown = 2;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final router = context.router;
    final firsts = controller.achievedFirsts.take(_shown).toList();
    final next = controller.nextFirsts;
    final birth = child.birthDate;
    Widget first(MilestoneItem item) {
      final asset = item.asset;
      return Material(
        color: AppColors.resolve(context, kColorSurfaceFFFFFF),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.lg),
          side: BorderSide(
            color: AppColors.resolve(context, kColorBorderEADFD6),
          ),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: item.memoryId == null
              ? null
              : () => router.push(MemoryDetailRoute(memoryId: item.memoryId!)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (asset != null) _Photo(asset: asset, height: 86, radius: 0),
              Padding(
                padding: const EdgeInsets.all(AppSpacing.itemGap),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          LucideIcons.star,
                          size: 12,
                          color: AppColors.resolve(
                            context,
                            kColorAccent500F4BF5C,
                          ),
                        ),
                        const SizedBox(width: AppSpacing.s1),
                        Flexible(
                          child: Text(
                            item.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTypography.adapt(
                              context,
                              AppTypography.caption.copyWith(
                                fontWeight: FontWeight.w700,
                                color: kColorTextPrimary2E2A27,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    if (birth != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        childAgeText(l10n, birth, item.achievedAt!),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTypography.adapt(
                          context,
                          AppTypography.tiny.copyWith(
                            color: kColorTextSecondary6B625B,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }

    final tertiary = AppColors.resolve(context, kColorTextTertiary9C928A);
    final nextCard = Material(
      color: kColorTransparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.lg),
        side: BorderSide(
          color: AppColors.resolve(context, kColorBorderEADFD6),
          width: 1.5,
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => router.push(
          MemoryComposerRoute(
            kind: MemoryKind.milestone.name,
            childId: child.id,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.itemGap),
          child: Column(
            children: [
              Icon(LucideIcons.sparkle, size: 22, color: tertiary),
              const SizedBox(height: AppSpacing.compact),
              Text(
                l10n.homeNextFirst,
                textAlign: TextAlign.center,
                style: AppTypography.adapt(
                  context,
                  AppTypography.small.copyWith(fontWeight: FontWeight.w700),
                ),
              ),
              if (next.isNotEmpty) ...[
                const SizedBox(height: AppSpacing.compact),
                Text(
                  next
                      .take(_shown)
                      .map((item) => item.title)
                      .reduce(l10n.commonDotJoin),
                  textAlign: TextAlign.center,
                  style: AppTypography.adapt(context, AppTypography.tiny),
                ),
              ],
            ],
          ),
        ),
      ),
    );
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final item in firsts) ...[
          Expanded(child: first(item)),
          const SizedBox(width: AppSpacing.itemGap),
        ],
        Expanded(child: nextCard),
        for (var index = firsts.length; index < _shown; index++) ...[
          const SizedBox(width: AppSpacing.itemGap),
          const Spacer(),
        ],
      ],
    );
  }
}
