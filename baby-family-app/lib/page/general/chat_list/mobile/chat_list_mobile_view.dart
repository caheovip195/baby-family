import 'package:auto_route/auto_route.dart';
import 'package:baby_family/data/model/chat/chat_conversation.dart';
import 'package:baby_family/page/general/chat_list/chat_list_controller.dart';
import 'package:baby_family/utils/constants/colors.dart';
import 'package:baby_family/utils/extension/l10n.dart';
import 'package:baby_family/utils/helper/chat_text.dart';
import 'package:baby_family/utils/helper/theme.dart';
import 'package:baby_family/utils/router/app_router.dart';
import 'package:baby_family/utils/widget/app_back_title_bar.dart';
import 'package:baby_family/utils/widget/app_card.dart';
import 'package:baby_family/utils/widget/app_info_note.dart';
import 'package:baby_family/utils/widget/base_scaffold.dart';
import 'package:baby_family/utils/widget/chat_avatar_stack.dart';
import 'package:baby_family/utils/widget/empty_state.dart';
import 'package:baby_family/utils/widget/error_state.dart';
import 'package:baby_family/utils/widget/skeleton_block.dart';
import 'package:baby_family/utils/widget/us_private_label.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lucide_flutter/lucide_flutter.dart';

part '../widgets/conversation_card.dart';

/// CHAT-01 (Pencil `XEfvk`): dòng “{nhà} · N cuộc trò chuyện”, thẻ “Cả nhà”
/// (nền `surface`) và “Papa & Mama” (nền `us-50`, khoá), ghi chú cuối.
class ChatListMobileView extends HookConsumerWidget {
  const ChatListMobileView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(chatListControllerProvider);
    final l10n = context.l10n;
    final conversations = controller.conversations;
    final now = controller.now;

    final List<Widget> children;
    if (conversations.isEmpty && !controller.loaded) {
      children = [
        for (var index = 0; index < 2; index++)
          const SkeletonBlock(height: 96, radius: AppRadius.xl),
      ];
    } else if (conversations.isEmpty && controller.hasError) {
      children = [ErrorState(onRetry: controller.load)];
    } else if (conversations.isEmpty) {
      children = [
        Padding(
          padding: const EdgeInsets.only(top: AppSpacing.s8),
          child: EmptyState(
            title: l10n.chatListEmptyTitle,
            description: l10n.chatListEmptyDescription,
          ),
        ),
      ];
    } else {
      children = [
        if (controller.familyName.isNotEmpty)
          Text(
            l10n.chatListSubtitle(controller.familyName, conversations.length),
            style: AppTypography.adapt(
              context,
              AppTypography.body.copyWith(
                color: AppColors.resolve(context, kColorTextSecondary6B625B),
              ),
            ),
          ),
        for (final conversation in conversations)
          _ConversationCard(
            conversation: conversation,
            now: now,
            onTap: () => context.router.push(
              ChatConversationRoute(conversationId: conversation.id),
            ),
          ),
        AppInfoNote(
          icon: LucideIcons.info,
          text: l10n.chatInfoNote,
          background: kColorSurfaceVariantF7F1EC,
          iconColor: kColorTextSecondary6B625B,
          alignTop: true,
        ),
      ];
    }

    return BaseScaffold(
      backgroundColor: kColorBgFFFBF7,
      appBar: AppBackTitleBar(title: l10n.chatTitle),
      body: RefreshIndicator(
        onRefresh: controller.load,
        child: ListView.separated(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: EdgeInsets.fromLTRB(
            AppSpacing.screen,
            AppSpacing.s2,
            AppSpacing.screen,
            AppSpacing.s6 + MediaQuery.paddingOf(context).bottom,
          ),
          itemCount: children.length,
          separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.s3),
          itemBuilder: (_, index) => children[index],
        ),
      ),
    );
  }
}
