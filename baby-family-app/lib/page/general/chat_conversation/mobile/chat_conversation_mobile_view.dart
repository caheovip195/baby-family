import 'package:auto_route/auto_route.dart';
import 'package:baby_family/data/dto/chat_receipt.dart';
import 'package:baby_family/data/dto/chat_timeline_item.dart';
import 'package:baby_family/data/model/chat/chat_conversation.dart';
import 'package:baby_family/generated/l10n/app_localizations.dart';
import 'package:baby_family/page/general/chat_conversation/chat_conversation_controller.dart';
import 'package:baby_family/utils/constants/colors.dart';
import 'package:baby_family/utils/constants/enum.dart';
import 'package:baby_family/utils/constants/values.dart';
import 'package:baby_family/utils/extension/date_time.dart';
import 'package:baby_family/utils/extension/l10n.dart';
import 'package:baby_family/utils/helper/chat_text.dart';
import 'package:baby_family/utils/helper/theme.dart';
import 'package:baby_family/utils/widget/app_outline_chip.dart';
import 'package:baby_family/utils/widget/base_scaffold.dart';
import 'package:baby_family/utils/widget/chat_avatar_stack.dart';
import 'package:baby_family/utils/widget/chat_member_avatar.dart';
import 'package:baby_family/utils/widget/empty_state.dart';
import 'package:baby_family/utils/widget/error_state.dart';
import 'package:baby_family/utils/widget/loading_progress.dart';
import 'package:baby_family/utils/widget/offline_banner.dart';
import 'package:baby_family/utils/widget/us_private_label.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lucide_flutter/lucide_flutter.dart';

part '../widgets/chat_composer.dart';
part '../widgets/chat_header.dart';
part '../widgets/day_separator.dart';
part '../widgets/empty_conversation.dart';
part '../widgets/message_bubble.dart';
part '../widgets/reconnecting_banner.dart';
part '../widgets/typing_row.dart';

/// CHAT-02 (Pencil `YQ4Ym`): tin của tôi bên phải (`primary-100`; Papa &
/// Mama `us-100`), người khác bên trái kèm tên + avatar, ngăn cách ngày,
/// giờ gửi, “Đã gửi”/“Đã xem” dưới tin cuối của tôi, “X đang nhập…”, ô soạn.
/// CHAT-03a băng ngoại tuyến, 03b đang kết nối lại, 03c chưa có tin, 03d
/// Papa & Mama (khoá, tông tím, ghi chú riêng tư).
class ChatConversationMobileView extends HookConsumerWidget {
  const ChatConversationMobileView({required this.conversationId, super.key});

  final String conversationId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(chatConversationControllerProvider);
    final l10n = context.l10n;
    final composer = useTextEditingController();
    useEffect(() {
      Future.microtask(() => controller.init(conversationId));
      return null;
    }, [conversationId]);

    final conversation = controller.conversation;
    final couple = controller.isCouple;
    final timeline = controller.timeline;
    final receipt = controller.receipt;
    final now = controller.now;

    Future<void> send() async {
      final text = composer.text;
      if (await controller.send(text)) {
        composer.clear();
      }
    }

    Widget body;
    if (conversation == null) {
      if (!controller.loaded) {
        body = const Center(child: CircleLoadingProgress());
      } else if (controller.notFound) {
        body = EmptyState(title: l10n.chatNotFound);
      } else {
        body = ErrorState(onRetry: controller.load);
      }
      return BaseScaffold(
        backgroundColor: kColorBgFFFBF7,
        body: Column(
          children: [
            const _ChatHeader(conversation: null),
            Expanded(child: body),
          ],
        ),
      );
    }

    final Widget messages;
    if (timeline.isEmpty && !controller.loaded) {
      messages = const Center(child: CircleLoadingProgress());
    } else if (timeline.isEmpty) {
      messages = _EmptyConversation(
        couple: couple,
        onSuggestion: (text) {
          composer.text = text;
          composer.selection = TextSelection.collapsed(offset: text.length);
        },
      );
    } else {
      final reversed = timeline.reversed.toList();
      messages = NotificationListener<ScrollNotification>(
        onNotification: (notification) {
          // Danh sách đảo: cuộn lên gần đầu (tin cũ) → tải thêm.
          if (notification.metrics.extentAfter < 400) {
            controller.loadOlder();
          }
          return false;
        },
        child: ListView.builder(
          reverse: true,
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.s4,
            AppSpacing.s4,
            AppSpacing.s4,
            AppSpacing.s3,
          ),
          itemCount: reversed.length + (controller.loadingOlder ? 1 : 0),
          itemBuilder: (context, index) {
            if (index == reversed.length) {
              return const Padding(
                padding: EdgeInsets.all(AppSpacing.s3),
                child: Center(child: CircleLoadingProgress()),
              );
            }
            final item = reversed[index];
            final day = item.day;
            if (day != null) {
              return _DaySeparator(
                label: chatDayLabel(l10n, day, now, locale: context.localeName),
              );
            }
            final message = item.message!;
            return _MessageBubble(
              key: ValueKey(message.clientKey ?? message.id),
              item: item,
              conversation: conversation,
              couple: couple,
              receipt: receipt?.messageId == message.id ? receipt : null,
              onRetry: () => controller.retry(message),
            );
          },
        ),
      );
    }

    final typing = controller.typingUsers;
    return BaseScaffold(
      backgroundColor: couple ? kColorUs50F6F2FC : kColorBgFFFBF7,
      body: Column(
        children: [
          _ChatHeader(conversation: conversation),
          switch (controller.banner) {
            ChatConnectionBanner.offline => OfflineBanner(
              subtitle: l10n.chatOfflineSubtitle(controller.pendingCount),
            ),
            ChatConnectionBanner.reconnecting => const _ReconnectingBanner(),
            ChatConnectionBanner.none => const SizedBox.shrink(),
          },
          Expanded(child: messages),
          if (typing.isNotEmpty)
            _TypingRow(
              text: typing.length == 1
                  ? l10n.chatTyping(
                      chatMemberName(l10n, conversation, typing.single),
                    )
                  : l10n.chatTypingMany(typing.length),
              name: chatMemberName(l10n, conversation, typing.first),
              couple: couple,
            ),
          if (couple)
            Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.s2),
              child: UsPrivateLabel(l10n.chatCoupleNote),
            ),
          _ChatComposer(
            controller: composer,
            couple: couple,
            hint: couple
                ? l10n.chatComposerCoupleHint(
                    controller.others.firstOrNull?.displayName ??
                        l10n.chatCoupleTitle,
                  )
                : l10n.chatComposerHint,
            onChanged: (_) => controller.typing(),
            onSend: send,
          ),
        ],
      ),
    );
  }
}
