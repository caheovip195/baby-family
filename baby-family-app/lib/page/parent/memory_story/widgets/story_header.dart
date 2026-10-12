part of '../mobile/memory_story_mobile_view.dart';

/// Đầu story (`MHi07`, `fCsd3`): các đoạn tiến độ cao 3 cách 4 (đã xem
/// trắng, chưa xem `#FFFFFF55`); avatar 36 viền màu bé; “Hôm nay của Haru”
/// 14/700 trắng; “Papa đăng · 20:05 · 3/5” 12 trắng 80%; nút `x` 22.
class _StoryHeader extends StatelessWidget {
  const _StoryHeader({required this.controller});

  final MemoryStoryController controller;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final child = controller.child;
    final story = controller.current;
    final author = controller.memberByUser(story?.authorId)?.callName ?? '';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.s3,
            vertical: AppSpacing.s1,
          ),
          child: Row(
            children: [
              for (var i = 0; i < controller.stories.length; i++) ...[
                if (i > 0) const SizedBox(width: AppSpacing.s1),
                Expanded(
                  child: Container(
                    height: 3,
                    decoration: BoxDecoration(
                      color: i <= controller.index
                          ? kColorWhite
                          : kColorWhiteAlpha33,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.cardInset,
            vertical: AppSpacing.s2,
          ),
          child: Row(
            children: [
              if (child != null)
                ChildAvatar(
                  child: child,
                  size: 36,
                  borderColor: ChildAvatar.colorOf(child),
                ),
              const SizedBox(width: AppSpacing.itemGap),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.homeChildToday(child?.name ?? ''),
                      style: AppTypography.text14.copyWith(
                        fontWeight: FontWeight.w700,
                        color: kColorWhite,
                      ),
                    ),
                    const SizedBox(height: 1),
                    if (story != null)
                      Text(
                        l10n.memStoryMeta(
                          author,
                          story.createdAt.toDisplayTime(context.localeName),
                          controller.index + 1,
                          controller.stories.length,
                        ),
                        style: AppTypography.small.copyWith(
                          color: kColorWhiteAlpha80,
                        ),
                      ),
                  ],
                ),
              ),
              Semantics(
                button: true,
                label: l10n.commonClose,
                excludeSemantics: true,
                child: InkResponse(
                  onTap: () => context.router.maybePop(),
                  child: const Padding(
                    padding: EdgeInsets.all(AppSpacing.s1),
                    child: Icon(LucideIcons.x, size: 22, color: kColorWhite),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
