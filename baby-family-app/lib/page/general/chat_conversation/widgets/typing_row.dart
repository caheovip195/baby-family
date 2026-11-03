part of '../mobile/chat_conversation_mobile_view.dart';

/// “X đang nhập…” CHAT-02: avatar 28 + viên ba chấm `surface-variant` + chữ
/// 14 `text-secondary`.
class _TypingRow extends StatelessWidget {
  const _TypingRow({
    required this.text,
    required this.name,
    required this.couple,
  });

  final String text;
  final String name;
  final bool couple;

  @override
  Widget build(BuildContext context) {
    final dot = AppColors.resolve(context, kColorTextTertiary9C928A);
    return Semantics(
      liveRegion: true,
      label: text,
      excludeSemantics: true,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.s4,
          0,
          AppSpacing.s4,
          AppSpacing.s2,
        ),
        child: Row(
          children: [
            ChatMemberAvatar(name: name, couple: couple),
            const SizedBox(width: AppSpacing.s2),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.cardInset,
                vertical: AppSpacing.s3,
              ),
              decoration: BoxDecoration(
                color: AppColors.resolve(context, kColorSurfaceVariantF7F1EC),
                borderRadius: BorderRadius.circular(AppRadius.xl),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  for (var index = 0; index < 3; index++) ...[
                    if (index > 0) const SizedBox(width: AppSpacing.s1),
                    Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: dot,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.s2),
            Expanded(
              child: Text(
                text,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTypography.adapt(
                  context,
                  AppTypography.text14.copyWith(
                    color: AppColors.resolve(
                      context,
                      kColorTextSecondary6B625B,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
