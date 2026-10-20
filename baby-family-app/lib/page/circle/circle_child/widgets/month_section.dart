part of '../mobile/circle_child_mobile_view.dart';

/// Ký ức một tháng tuổi (Pencil “Month Tháng thứ 18” + “Memory big” +
/// “Grid”): chấm màu bé + “Tháng thứ 18” 16/700 + “· 08/09 – 07/10” 15
/// `text-tertiary`. Tháng gần nhất ([detailed]): ký ức đầu thẻ lớn (ảnh 210,
/// chú thích 17, “Mama · Hôm nay”, ❤ 6 💬 3), ký ức có tiêu đề lưới 2 cột
/// (ảnh 130 + tên 16/600); còn lại lưới ảnh 3 cột cao 100.
class _MonthSection extends StatelessWidget {
  const _MonthSection({
    required this.child,
    required this.month,
    required this.memories,
    required this.detailed,
    required this.controller,
    required this.onOpen,
  });

  final Child child;
  final int month;
  final List<Memory> memories;
  final bool detailed;
  final CircleChildController controller;
  final ValueChanged<Memory> onOpen;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final locale = l10n.localeName;
    final range = childMonthRange(child.birthDate!, month);
    final lastDay = range.end.subtract(const Duration(days: 1));
    final withPhoto = memories.where((m) => m.mediaAssets.isNotEmpty).toList();
    final big = detailed ? withPhoto.firstOrNull : null;
    final rest = [
      for (final memory in withPhoto)
        if (memory.id != big?.id) memory,
    ];
    final titled = detailed
        ? rest.where((m) => (m.title ?? '').isNotEmpty).toList()
        : const <Memory>[];
    final tiles = [
      for (final memory in rest)
        if (!titled.contains(memory)) memory,
    ];
    const gap = SizedBox(height: AppSpacing.cardInset);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        gap,
        Row(
          children: [
            Container(
              width: AppSpacing.itemGap,
              height: AppSpacing.itemGap,
              decoration: BoxDecoration(
                color: AppColors.resolve(context, ChildAvatar.colorOf(child)),
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: AppSpacing.s2),
            Text(
              l10n.cirChildMonth(month),
              style: AppTypography.adapt(context, AppTypography.title16),
            ),
            const SizedBox(width: AppSpacing.s2),
            Flexible(
              child: Text(
                l10n.cirChildMonthRange(
                  range.start.toDayMonth(locale),
                  lastDay.toDayMonth(locale),
                ),
                style: AppTypography.adapt(
                  context,
                  AppTypography.body.copyWith(color: kColorTextTertiary9C928A),
                ),
              ),
            ),
          ],
        ),
        if (big != null) ...[gap, _bigCard(context, big)],
        for (var index = 0; index < titled.length; index += 2) ...[
          gap,
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: _titledTile(context, titled[index])),
              const SizedBox(width: AppSpacing.itemGap),
              Expanded(
                child: index + 1 < titled.length
                    ? _titledTile(context, titled[index + 1])
                    : const SizedBox.shrink(),
              ),
            ],
          ),
        ],
        for (var index = 0; index < tiles.length; index += 3) ...[
          gap,
          Row(
            children: [
              for (var column = 0; column < 3; column++) ...[
                if (column > 0) const SizedBox(width: AppSpacing.s2),
                Expanded(
                  child: index + column < tiles.length
                      ? _photo(context, tiles[index + column], 100, 14)
                      : const SizedBox.shrink(),
                ),
              ],
            ],
          ),
        ],
      ],
    );
  }

  Widget _photo(
    BuildContext context,
    Memory memory,
    double height,
    double radius,
  ) => GestureDetector(
    onTap: () => onOpen(memory),
    child: ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: Image(
        image: mediaImageProvider(memory.mediaAssets.first),
        height: height,
        width: double.infinity,
        fit: BoxFit.cover,
      ),
    ),
  );

  Widget _titledTile(BuildContext context, Memory memory) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      _photo(context, memory, 130, AppRadius.lg),
      const SizedBox(height: AppSpacing.compact),
      Text(
        memory.title ?? '',
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: AppTypography.adapt(
          context,
          AppTypography.title16.copyWith(
            fontFamily: AppTypography.bodyFamily,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    ],
  );

  Widget _bigCard(BuildContext context, Memory memory) {
    final l10n = context.l10n;
    final today = controller.today;
    final at = memory.occurredAt;
    final day = at.isSameDay(today)
        ? l10n.memoriesToday
        : at.isSameDay(today.subtract(const Duration(days: 1)))
        ? l10n.memYesterday
        : at.toDayMonth(l10n.localeName);
    final hearts = memory.reactions.values.fold<int>(0, (a, b) => a + b);
    final secondary = AppTypography.adapt(
      context,
      AppTypography.body.copyWith(color: kColorTextSecondary6B625B),
    );
    final count = AppTypography.adapt(
      context,
      AppTypography.bodyStrong.copyWith(color: kColorTextSecondary6B625B),
    );
    final caption = memory.body ?? memory.title;
    return Material(
      color: AppColors.resolve(context, kColorSurfaceFFFFFF),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.xl),
        side: BorderSide(color: AppColors.resolve(context, kColorBorderEADFD6)),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => onOpen(memory),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Image(
              image: mediaImageProvider(memory.mediaAssets.first),
              height: 210,
              fit: BoxFit.cover,
            ),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.s4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (caption != null) ...[
                    Text(
                      caption,
                      style: AppTypography.adapt(
                        context,
                        AppTypography.bodyLarge.copyWith(height: 25 / 17),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.compact),
                  ],
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          [
                            controller.authorName(memory.authorId),
                            day,
                          ].reduce(l10n.commonDotJoin),
                          style: secondary,
                        ),
                      ),
                      Icon(
                        LucideIcons.heart,
                        size: 16,
                        color: AppColors.resolve(
                          context,
                          kColorPrimary600C2513F,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.compact),
                      Text('$hearts', style: count),
                      const SizedBox(width: AppSpacing.s3),
                      Icon(
                        LucideIcons.messageCircle,
                        size: 16,
                        color: AppColors.resolve(
                          context,
                          kColorTextSecondary6B625B,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.compact),
                      Text('${memory.commentCount}', style: count),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
