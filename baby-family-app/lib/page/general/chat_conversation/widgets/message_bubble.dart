part of '../mobile/chat_conversation_mobile_view.dart';

/// Bong bóng tin CHAT-02: tối đa 78% chiều ngang, đệm 10/14, bo 20 (góc
/// phía người gửi 6). Tôi: phải, `primary-100` (Papa & Mama `us-100`), giờ
/// `primary-700`; đang gửi “Đang gửi…”, chờ mạng “Đang chờ gửi” (icon
/// đồng hồ); lỗi: nền `surface` viền `error`, dòng “Chưa gửi được · Chạm để
/// gửi lại”. Người khác: trái, `surface-variant`, tên 13/600 + avatar ở tin
/// đầu chuỗi. [receipt] = “Đã gửi”/“Đã xem” dưới tin cuối của tôi.
class _MessageBubble extends StatelessWidget {
  const _MessageBubble({
    required this.item,
    required this.conversation,
    required this.couple,
    required this.onRetry,
    this.receipt,
    super.key,
  });

  final ChatTimelineItem item;
  final ChatConversation conversation;
  final bool couple;
  final ChatReceipt? receipt;
  final VoidCallback onRetry;

  static const _avatarSize = 28.0;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final message = item.message!;
    final mine = message.isMine;
    final state = message.sendState;
    final failed = state == ChatSendState.failed;
    final secondary = AppColors.resolve(context, kColorTextSecondary6B625B);
    final tertiary = AppColors.resolve(context, kColorTextTertiary9C928A);
    final success = AppColors.resolve(context, kColorSecondary7003F7A5C);
    final error = AppColors.resolve(context, kColorErrorD14B4B);
    final time = (message.createdAt ?? DateTime.now()).toLocal().toDisplayTime(
      context.localeName,
    );
    final senderName = chatMemberName(l10n, conversation, message.senderUserId);
    final sender = conversation.member(message.senderUserId);

    final Color background;
    if (failed) {
      background = kColorSurfaceFFFFFF;
    } else if (mine) {
      background = couple ? kColorUs100EAE2F8 : kColorPrimary100FFE3DC;
    } else {
      background = couple ? kColorSurfaceFFFFFF : kColorSurfaceVariantF7F1EC;
    }
    final Widget status = switch (state) {
      ChatSendState.sending || ChatSendState.waiting => Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(LucideIcons.clock, size: 12, color: secondary),
          const SizedBox(width: AppSpacing.s1),
          Text(
            state == ChatSendState.sending
                ? l10n.chatSending
                : l10n.chatWaiting,
            style: AppTypography.adapt(
              context,
              AppTypography.small.copyWith(color: secondary),
            ),
          ),
        ],
      ),
      _ => Text(
        time,
        style: AppTypography.adapt(
          context,
          AppTypography.small.copyWith(
            color: mine && !failed
                ? AppColors.resolve(
                    context,
                    couple ? kColorUs7006A549F : kColorPrimary700A2402F,
                  )
                : tertiary,
          ),
        ),
      ),
    };

    final bubble = Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.cardInset,
        vertical: AppSpacing.itemGap,
      ),
      decoration: BoxDecoration(
        color: AppColors.resolve(context, background),
        border: failed ? Border.all(color: error) : null,
        borderRadius: BorderRadius.only(
          topLeft: const Radius.circular(AppRadius.xl),
          topRight: const Radius.circular(AppRadius.xl),
          bottomLeft: Radius.circular(mine ? AppRadius.xl : AppRadius.xs),
          bottomRight: Radius.circular(mine ? AppRadius.xs : AppRadius.xl),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          Align(
            alignment: AlignmentDirectional.centerStart,
            child: SelectableText(
              message.body,
              style: AppTypography.adapt(
                context,
                AppTypography.bodyLarge.copyWith(
                  color: AppColors.resolve(context, kColorTextPrimary2E2A27),
                ),
              ),
            ),
          ),
          const SizedBox(height: 2),
          status,
        ],
      ),
    );

    final maxWidth = MediaQuery.sizeOf(context).width * 0.78;
    if (mine) {
      final current = receipt;
      return Padding(
        padding: const EdgeInsets.only(top: AppSpacing.s2),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            ConstrainedBox(
              constraints: BoxConstraints(maxWidth: maxWidth),
              child: failed || state == ChatSendState.waiting
                  ? Semantics(
                      button: true,
                      child: GestureDetector(onTap: onRetry, child: bubble),
                    )
                  : bubble,
            ),
            if (failed)
              InkWell(
                onTap: onRetry,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.s1,
                    vertical: AppSpacing.compact,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(LucideIcons.circleAlert, size: 14, color: error),
                      const SizedBox(width: AppSpacing.s1),
                      Flexible(
                        child: Text(
                          l10n.chatFailed,
                          style: AppTypography.adapt(
                            context,
                            AppTypography.caption.copyWith(color: error),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            else if (current != null)
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.s1,
                  vertical: AppSpacing.s1,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      current.seen ? LucideIcons.checkCheck : LucideIcons.check,
                      size: 14,
                      color: success,
                    ),
                    const SizedBox(width: AppSpacing.s1),
                    Flexible(
                      child: Text(
                        _receiptText(l10n, current),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTypography.adapt(
                          context,
                          AppTypography.caption.copyWith(color: success),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      );
    }

    return Padding(
      padding: EdgeInsets.only(
        top: item.showSender ? AppSpacing.s3 : AppSpacing.s1,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (item.showSender)
            ChatMemberAvatar(
              name: senderName,
              parent: sender?.isParent ?? true,
              couple: couple,
              size: _avatarSize,
            )
          else
            const SizedBox(width: _avatarSize),
          const SizedBox(width: AppSpacing.s2),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (item.showSender && !couple)
                  Padding(
                    padding: const EdgeInsets.only(
                      left: AppSpacing.s1,
                      bottom: AppSpacing.s1,
                    ),
                    child: Text(
                      senderName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTypography.adapt(
                        context,
                        AppTypography.caption.copyWith(
                          fontWeight: FontWeight.w600,
                          color: AppColors.resolve(
                            context,
                            (sender?.isParent ?? true)
                                ? kColorPrimary700A2402F
                                : kColorUs7006A549F,
                          ),
                        ),
                      ),
                    ),
                  ),
                ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: maxWidth),
                  child: bubble,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _receiptText(AppLocalizations l10n, ChatReceipt receipt) {
    if (!receipt.seen) {
      return l10n.chatSent;
    }
    if (couple) {
      return l10n.chatSeen;
    }
    const shown = 2;
    final names = receipt.seenBy.take(shown).join(', ');
    final more = receipt.seenBy.length - shown;
    return more > 0 ? l10n.chatSeenByMore(names, more) : l10n.chatSeenBy(names);
  }
}
