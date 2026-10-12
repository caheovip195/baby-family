part of '../mobile/home_tab_mobile_view.dart';

/// “Lần đầu của Bơ” (Pencil `Y0Ny5`): chip 34 — đã có: nền `accent-100`, sao
/// `accent-500`; chưa có: nền `surface` viền, `circle-dashed` `text-tertiary`.
/// Hàng đầu là các lần đầu đã có, hàng sau là chưa có (cách 8).
class _PregnancyFirsts extends StatelessWidget {
  const _PregnancyFirsts({required this.controller});

  final HomeTabController controller;

  @override
  Widget build(BuildContext context) {
    final router = context.router;
    final items = controller.pregnancyFirsts;
    final done = items.where((item) => item.achievedAt != null).toList();
    final todo = items.where((item) => item.achievedAt == null).toList();
    Widget chip(MilestoneItem item) {
      final achieved = item.achievedAt != null;
      final color = AppColors.resolve(
        context,
        achieved ? kColorTextPrimary2E2A27 : kColorTextTertiary9C928A,
      );
      return Material(
        color: AppColors.resolve(
          context,
          achieved ? kColorAccent100FDF1D6 : kColorSurfaceFFFFFF,
        ),
        shape: StadiumBorder(
          side: achieved
              ? BorderSide.none
              : BorderSide(
                  color: AppColors.resolve(context, kColorBorderEADFD6),
                ),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () => item.memoryId == null
              ? router.push(
                  MemoryComposerRoute(
                    kind: MemoryKind.milestone.name,
                    childId: controller.subjectId,
                  ),
                )
              : router.push(MemoryDetailRoute(memoryId: item.memoryId!)),
          child: Container(
            constraints: const BoxConstraints(minHeight: 34),
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.s3,
              vertical: AppSpacing.s1,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  achieved ? LucideIcons.star : LucideIcons.circleDashed,
                  size: 13,
                  color: achieved
                      ? AppColors.resolve(context, kColorAccent500F4BF5C)
                      : color,
                ),
                const SizedBox(width: AppSpacing.compact),
                Text(
                  item.title,
                  style: AppTypography.small.copyWith(
                    fontWeight: FontWeight.w600,
                    color: color,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    Widget wrap(List<MilestoneItem> list) => Wrap(
      spacing: AppSpacing.s2,
      runSpacing: AppSpacing.s2,
      children: [for (final item in list) chip(item)],
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (done.isNotEmpty) wrap(done),
        if (done.isNotEmpty && todo.isNotEmpty)
          const SizedBox(height: AppSpacing.s2),
        if (todo.isNotEmpty) wrap(todo),
      ],
    );
  }
}
