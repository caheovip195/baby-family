part of '../mobile/chat_conversation_mobile_view.dart';

/// CHAT-03c: icon tim trong bóng thoại (nền `primary-50`), “Chưa có tin nhắn
/// nào”, lời mời gửi lời chào; cả nhà có gợi ý “Chào cả nhà 👋” điền sẵn ô
/// soạn.
class _EmptyConversation extends StatelessWidget {
  const _EmptyConversation({required this.couple, required this.onSuggestion});

  final bool couple;
  final ValueChanged<String> onSuggestion;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final hello = l10n.chatHelloSuggestion;
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.s6),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.resolve(
                  context,
                  couple ? kColorUs100EAE2F8 : kColorPrimary50FFF4F1,
                ),
              ),
              child: Icon(
                LucideIcons.messageCircleHeart,
                size: 32,
                color: AppColors.resolve(
                  context,
                  couple ? kColorUs7006A549F : kColorPrimary600C2513F,
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.s4),
            Text(
              l10n.chatEmptyTitle,
              textAlign: TextAlign.center,
              style: AppTypography.adapt(context, AppTypography.h2),
            ),
            const SizedBox(height: AppSpacing.s2),
            Text(
              couple
                  ? l10n.chatEmptyCoupleDescription
                  : l10n.chatEmptyDescription,
              textAlign: TextAlign.center,
              style: AppTypography.adapt(
                context,
                AppTypography.body.copyWith(
                  color: AppColors.resolve(context, kColorTextSecondary6B625B),
                ),
              ),
            ),
            if (!couple) ...[
              const SizedBox(height: AppSpacing.s4),
              AppOutlineChip(label: hello, onTap: () => onSuggestion(hello)),
            ],
          ],
        ),
      ),
    );
  }
}
