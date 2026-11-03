import 'package:auto_route/auto_route.dart';
import 'package:baby_family/page/application_base.dart';
import 'package:baby_family/page/general/chat_conversation/mobile/chat_conversation_mobile_view.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// CHAT-02 / CHAT-03a–d
@RoutePage()
class ChatConversationPage extends BaseHookWidget {
  const ChatConversationPage({
    @PathParam('conversationId') required this.conversationId,
    super.key,
  });

  final String conversationId;

  @override
  Widget buildWidget(BuildContext context, WidgetRef ref) {
    return ChatConversationMobileView(conversationId: conversationId);
  }
}
