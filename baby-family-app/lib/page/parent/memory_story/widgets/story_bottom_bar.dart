part of '../mobile/memory_story_mobile_view.dart';

/// Đáy story (`wZzZu`): đệm 0/16/36/16, cách 14 — chú thích 16/600 trắng
/// (1.4); 5 nút cảm xúc 44 (`#FFFFFF26`, emoji 20); ô “Trả lời Papa…” cao
/// 44 viền `#FFFFFF80` + nút “Góc nhìn” trắng (`heart-handshake` 16 +
/// 13/700 `us-700`).
class _StoryBottomBar extends StatelessWidget {
  const _StoryBottomBar({required this.controller});

  final MemoryStoryController controller;

  static const _emojis = ['❤️', '😍', '😂', '🥹', '👏'];

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final story = controller.current;
    final author = controller.memberByUser(story?.authorId)?.callName ?? '';
    final caption = story?.caption;
    final memoryId = story?.memoryId;
    final inset = MediaQuery.viewInsetsOf(context).bottom;
    return Padding(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.s4,
        0,
        AppSpacing.s4,
        inset > 0 ? inset + AppSpacing.s3 : AppSpacing.s3,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (caption != null) ...[
            Text(
              caption,
              style: AppTypography.body.copyWith(
                fontSize: 16,
                height: 1.4,
                fontWeight: FontWeight.w600,
                color: kColorWhite,
              ),
            ),
            const SizedBox(height: AppSpacing.cardInset),
          ],
          Row(
            children: [
              for (final emoji in _emojis) ...[
                if (emoji != _emojis.first)
                  const SizedBox(width: AppSpacing.itemGap),
                GestureDetector(
                  onTap: () => controller.react(emoji),
                  child: Container(
                    width: 44,
                    height: 44,
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(
                      color: kColorWhiteAlpha15,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      emoji,
                      style: AppTypography.title20.copyWith(height: 1.15),
                    ),
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: AppSpacing.cardInset),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: controller.reply,
                  textInputAction: TextInputAction.send,
                  onSubmitted: (_) => controller.sendReply(),
                  style: AppTypography.text14.copyWith(color: kColorWhite),
                  cursorColor: kColorWhite,
                  decoration: InputDecoration(
                    hintText: l10n.memStoryReply(author),
                    hintStyle: AppTypography.text14.copyWith(
                      color: kColorWhiteAlpha70,
                    ),
                    filled: false,
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.s4,
                      vertical: 13,
                    ),
                    border: _border,
                    enabledBorder: _border,
                    focusedBorder: _border,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.itemGap),
              Material(
                color: kColorWhite,
                shape: const StadiumBorder(),
                child: InkWell(
                  customBorder: const StadiumBorder(),
                  onTap: memoryId == null
                      ? null
                      : () => context.router.push(
                          MemoryPerspectiveRoute(memoryId: memoryId),
                        ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.cardInset,
                      vertical: 13,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          LucideIcons.heartHandshake,
                          size: 16,
                          color: kColorUs7006A549F,
                        ),
                        const SizedBox(width: AppSpacing.compact),
                        Text(
                          l10n.memoriesPerspectiveshort,
                          style: AppTypography.caption.copyWith(
                            fontWeight: FontWeight.w700,
                            height: 16 / 13,
                            color: kColorUs7006A549F,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  static final _border = OutlineInputBorder(
    borderRadius: BorderRadius.circular(AppRadius.full),
    borderSide: const BorderSide(color: kColorWhiteAlpha50),
  );
}
