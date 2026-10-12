part of '../mobile/memories_tab_mobile_view.dart';

/// Thẻ “Lần đầu tiên” (`SMA0u`): nền `surface`, viền `accent-500`, bo 16;
/// ảnh cao 180; thân đệm 14 cách 10: huy hiệu 40 `accent-100` + `star` 20,
/// nhãn 10/800, tiêu đề 17/800, phụ “4 tháng 2 ngày · Papa & Mama cùng kể”.
class _MilestoneMemoryCard extends StatelessWidget {
  const _MilestoneMemoryCard({
    required this.memory,
    required this.controller,
    required this.onTap,
  });

  final Memory memory;
  final MemoriesTabController controller;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final photo = memory.mediaAssets.firstOrNull;
    final child = controller.childById(memory.childIds.firstOrNull);
    final birth = child?.birthDate;
    final author = controller.memberByUser(memory.authorId)?.callName ?? '';
    final partner = controller
        .memberByUser(memory.perspectiveAuthorId)
        ?.callName;
    final who = memory.bothTell && partner != null
        ? l10n.memBothParentsTell(partner, author)
        : l10n.memAuthorTells(author);
    final meta = birth == null
        ? who
        : l10n.memFirstMeta(childAgeText(l10n, birth, memory.occurredAt), who);
    return Material(
      color: AppColors.resolve(context, kColorSurfaceFFFFFF),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.lg),
        side: BorderSide(
          color: AppColors.resolve(context, kColorAccent500F4BF5C),
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (photo != null)
              Image.asset(photo, height: 180, fit: BoxFit.cover),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.cardInset),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: AppColors.resolve(context, kColorAccent100FDF1D6),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      LucideIcons.star,
                      size: 20,
                      color: AppColors.resolve(context, kColorAccent500F4BF5C),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.itemGap),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.memFirstTime.toUpperCase(),
                          style: AppTypography.adapt(
                            context,
                            AppTypography.micro.copyWith(
                              fontWeight: FontWeight.w800,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          memory.title ?? memory.milestoneTitle ?? '',
                          style: AppTypography.adapt(
                            context,
                            AppTypography.title17,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          meta,
                          style: AppTypography.adapt(
                            context,
                            AppTypography.small,
                          ),
                        ),
                      ],
                    ),
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
