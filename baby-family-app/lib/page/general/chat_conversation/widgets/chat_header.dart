part of '../mobile/chat_conversation_mobile_view.dart';

/// Thanh tiêu đề CHAT-02: back 40, chồng avatar 32, tên 20/800 (Papa & Mama
/// có khoá `us-700`), dòng phụ số thành viên / “Tin nhắn riêng của hai
/// bạn…” (`us-700`); viền dưới `border`. Cao tối thiểu 64, giãn theo cỡ chữ
/// hệ thống (nằm trong thân màn, không cố định chiều cao app bar).
class _ChatHeader extends StatelessWidget {
  const _ChatHeader({required this.conversation});

  final ChatConversation? conversation;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final current = conversation;
    final couple = current?.isCouple ?? false;
    final accent = AppColors.resolve(context, kColorUs7006A549F);
    return Material(
      color: AppColors.resolve(
        context,
        couple ? kColorUs50F6F2FC : kColorBgFFFBF7,
      ),
      shape: Border(
        bottom: BorderSide(
          color: AppColors.resolve(
            context,
            couple ? kColorUs100EAE2F8 : kColorBorderEADFD6,
          ),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 64),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.s2,
              vertical: AppSpacing.s1,
            ),
            child: Row(
              children: [
                Semantics(
                  button: true,
                  label: l10n.commonBack,
                  excludeSemantics: true,
                  child: InkResponse(
                    onTap: () => context.router.maybePop(),
                    radius: AppSpacing.s6,
                    child: SizedBox.square(
                      dimension: AppSpacing.s10,
                      child: Icon(
                        LucideIcons.chevronLeft,
                        size: 24,
                        color: AppColors.resolve(
                          context,
                          kColorTextPrimary2E2A27,
                        ),
                      ),
                    ),
                  ),
                ),
                if (current != null) ...[
                  ChatAvatarStack(
                    members: current.members,
                    couple: couple,
                    max: 2,
                  ),
                  const SizedBox(width: AppSpacing.itemGap),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            if (couple) ...[
                              Icon(LucideIcons.lock, size: 16, color: accent),
                              const SizedBox(width: AppSpacing.s1),
                            ],
                            Flexible(
                              child: Text(
                                chatTitle(l10n, current),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: AppTypography.adapt(
                                  context,
                                  AppTypography.title20,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Text(
                          couple
                              ? l10n.chatCoupleSubtitle
                              : l10n.chatMembersCount(current.members.length),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTypography.adapt(
                            context,
                            AppTypography.caption.copyWith(
                              color: couple
                                  ? accent
                                  : AppColors.resolve(
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
