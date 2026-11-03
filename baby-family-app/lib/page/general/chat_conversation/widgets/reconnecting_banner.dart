part of '../mobile/chat_conversation_mobile_view.dart';

/// CHAT-03b: nền `accent-100`, đệm 10/20, icon `refresh-cw` 16, tiêu đề
/// 14/700 + dòng phụ 13 `text-secondary`.
class _ReconnectingBanner extends StatelessWidget {
  const _ReconnectingBanner();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final primary = AppColors.resolve(context, kColorTextPrimary2E2A27);
    return Semantics(
      liveRegion: true,
      child: ColoredBox(
        color: AppColors.resolve(context, kColorAccent100FDF1D6),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.screen,
            vertical: AppSpacing.itemGap,
          ),
          child: Row(
            children: [
              Icon(LucideIcons.refreshCw, size: 16, color: primary),
              const SizedBox(width: AppSpacing.itemGap),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.chatReconnectingTitle,
                      style: AppTypography.adapt(
                        context,
                        AppTypography.text14.copyWith(
                          fontWeight: FontWeight.w700,
                          color: primary,
                        ),
                      ),
                    ),
                    Text(
                      l10n.chatReconnectingSubtitle,
                      style: AppTypography.adapt(
                        context,
                        AppTypography.caption.copyWith(
                          color: AppColors.resolve(
                            context,
                            kColorTextSecondary6B625B,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
