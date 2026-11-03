part of '../mobile/chat_list_mobile_view.dart';

/// Thẻ cuộc trò chuyện CHAT-01: chồng avatar, tên 19/800 + giờ tin cuối
/// (`primary-600` khi có tin chưa đọc), dòng xem trước 15, huy hiệu số chưa
/// đọc, dòng thành viên (“Papa, Mama + 4 người thân” / khoá “Chỉ hai bạn
/// thấy”). Papa & Mama: nền `us-50`, viền `us-100`.
class _ConversationCard extends StatelessWidget {
  const _ConversationCard({
    required this.conversation,
    required this.now,
    required this.onTap,
  });

  final ChatConversation conversation;
  final DateTime now;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final couple = conversation.isCouple;
    final unread = conversation.unreadCount;
    final last = conversation.lastMessage;
    final at = conversation.lastMessageAt ?? last?.createdAt;
    final secondary = AppColors.resolve(context, kColorTextSecondary6B625B);
    final String preview;
    if (last == null) {
      preview = l10n.chatNoMessagesYet;
    } else if (last.isMine) {
      preview = l10n.chatPreviewMine(last.body);
    } else {
      preview = l10n.chatPreviewOther(
        chatMemberName(l10n, conversation, last.senderUserId),
        last.body,
      );
    }
    final parents = [
      for (final member in conversation.members)
        if (member.isParent && member.displayName.trim().isNotEmpty)
          member.displayName.trim(),
    ];
    final relatives = conversation.members.where((m) => !m.isParent).length;
    return Semantics(
      button: true,
      child: AppCard(
        onTap: onTap,
        radius: AppRadius.xl,
        padding: const EdgeInsets.all(AppSpacing.s4),
        color: couple ? kColorUs50F6F2FC : kColorSurfaceFFFFFF,
        borderColor: couple ? kColorUs100EAE2F8 : kColorBorderEADFD6,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ChatAvatarStack(
              members: conversation.members,
              couple: couple,
              size: 36,
              max: couple ? 2 : 3,
            ),
            const SizedBox(width: AppSpacing.s3),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      if (couple) ...[
                        Icon(
                          LucideIcons.lock,
                          size: 16,
                          color: AppColors.resolve(context, kColorUs7006A549F),
                        ),
                        const SizedBox(width: AppSpacing.s1),
                      ],
                      Expanded(
                        child: Text(
                          chatTitle(l10n, conversation),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTypography.adapt(
                            context,
                            AppTypography.title17,
                          ),
                        ),
                      ),
                      if (at != null) ...[
                        const SizedBox(width: AppSpacing.s2),
                        Text(
                          chatListTime(
                            l10n,
                            at,
                            now,
                            locale: context.localeName,
                          ),
                          style: AppTypography.adapt(
                            context,
                            AppTypography.caption.copyWith(
                              fontWeight: unread > 0
                                  ? FontWeight.w700
                                  : FontWeight.w400,
                              color: AppColors.resolve(
                                context,
                                unread > 0
                                    ? kColorPrimary600C2513F
                                    : kColorTextTertiary9C928A,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: AppSpacing.s1),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          preview,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: AppTypography.adapt(
                            context,
                            AppTypography.body.copyWith(
                              fontWeight: unread > 0
                                  ? FontWeight.w600
                                  : FontWeight.w400,
                              color: unread > 0
                                  ? AppColors.resolve(
                                      context,
                                      kColorTextPrimary2E2A27,
                                    )
                                  : secondary,
                            ),
                          ),
                        ),
                      ),
                      if (unread > 0) ...[
                        const SizedBox(width: AppSpacing.s2),
                        Container(
                          constraints: const BoxConstraints(minWidth: 22),
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.compact,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.resolve(
                              context,
                              couple
                                  ? kColorUs5009B85D1
                                  : kColorPrimary500EE7B67,
                            ),
                            borderRadius: BorderRadius.circular(AppRadius.full),
                          ),
                          child: Text(
                            unread > 99 ? '99+' : '$unread',
                            textAlign: TextAlign.center,
                            semanticsLabel: l10n.chatUnread(unread),
                            style: AppTypography.caption.copyWith(
                              fontWeight: FontWeight.w700,
                              color: AppColors.onPrimary(context),
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: AppSpacing.s2),
                  if (couple)
                    UsPrivateLabel(l10n.chatOnlyTwo)
                  else
                    Row(
                      children: [
                        Icon(LucideIcons.users, size: 14, color: secondary),
                        const SizedBox(width: AppSpacing.s1),
                        Expanded(
                          child: Text(
                            l10n.chatMembersSummary(
                              parents.join(', '),
                              relatives,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTypography.adapt(
                              context,
                              AppTypography.caption.copyWith(color: secondary),
                            ),
                          ),
                        ),
                      ],
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
