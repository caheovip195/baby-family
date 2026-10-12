part of '../mobile/memory_detail_mobile_view.dart';

/// Thanh cảm xúc (`f96lyY`): viên bo tròn đệm 6/12 cách 6 — emoji 15 + số
/// 13/600; đã thả: nền `primary-100` viền `primary-300`, còn lại nền
/// `surface` viền `border`. Luôn có ❤️ 🥹 😍.
class _ReactionBar extends StatelessWidget {
  const _ReactionBar({required this.memory, required this.controller});

  final Memory memory;
  final MemoryDetailController controller;

  static const _defaults = ['❤️', '🥹', '😍'];

  @override
  Widget build(BuildContext context) {
    final emojis = {..._defaults, ...memory.reactions.keys};
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.compact),
      child: Wrap(
        spacing: AppSpacing.s2,
        runSpacing: AppSpacing.s2,
        children: [for (final emoji in emojis) _chip(context, emoji)],
      ),
    );
  }

  Widget _chip(BuildContext context, String emoji) {
    final mine = controller.myReactions.contains(emoji);
    final count = memory.reactions[emoji] ?? 0;
    return Material(
      color: AppColors.resolve(
        context,
        mine ? kColorPrimary100FFE3DC : kColorSurfaceFFFFFF,
      ),
      shape: StadiumBorder(
        side: BorderSide(
          color: AppColors.resolve(
            context,
            mine ? kColorPrimary300F7A796 : kColorBorderEADFD6,
          ),
        ),
      ),
      child: InkWell(
        customBorder: const StadiumBorder(),
        onTap: () => controller.react(emoji),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.s3,
            vertical: AppSpacing.compact,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(emoji, style: AppTypography.body.copyWith(height: 18 / 15)),
              if (count > 0) ...[
                const SizedBox(width: AppSpacing.compact),
                Text(
                  '$count',
                  style: AppTypography.adapt(
                    context,
                    AppTypography.caption.copyWith(
                      fontWeight: FontWeight.w600,
                      color: kColorTextPrimary2E2A27,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
