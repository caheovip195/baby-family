part of '../mobile/memory_detail_mobile_view.dart';

/// Người đăng (`jLR6V`): avatar chữ 36 (nền `child-mint`, viền `surface`),
/// tên 14/700, “Hôm nay, 19:05 · 👨‍👩‍👧‍👦 Cả nhà” 12 `text-secondary`.
class _AuthorRow extends StatelessWidget {
  const _AuthorRow({required this.memory, required this.controller});

  final Memory memory;
  final MemoryDetailController controller;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final author = controller.memberByUser(memory.authorId);
    final initial = (author?.displayName.isNotEmpty ?? false)
        ? author!.displayName.characters.first
        : (author?.callName.characters.firstOrNull ?? '');
    final visibility = switch (memory.visibility) {
      MemoryVisibility.family => l10n.memVisibilityFamilyTag,
      MemoryVisibility.parents => l10n.memVisibilityParentsTag,
      MemoryVisibility.onlyMe => l10n.memVisibilityOnlyMeTag,
    };
    final time = memoryDayTime(
      l10n,
      memory.createdAt ?? memory.occurredAt,
      controller.today,
    );
    return Row(
      children: [
        Container(
          width: 36,
          height: 36,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: kColorChildMint9EDCC4,
            shape: BoxShape.circle,
            border: Border.all(
              color: AppColors.resolve(context, kColorSurfaceFFFFFF),
            ),
          ),
          child: Text(
            initial,
            style: AppTypography.title16.copyWith(
              fontSize: 14,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.itemGap),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                author == null ? '' : memberFullName(author),
                style: AppTypography.adapt(
                  context,
                  AppTypography.text14.copyWith(fontWeight: FontWeight.w700),
                ),
              ),
              const SizedBox(height: 1),
              Text(
                '$time · $visibility',
                style: AppTypography.adapt(context, AppTypography.small),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
