import 'package:auto_route/auto_route.dart';
import 'package:baby_family/page/application_base.dart';
import 'package:baby_family/page/general/chat_list/mobile/chat_list_mobile_view.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// CHAT-01
@RoutePage()
class ChatListPage extends BaseHookWidget {
  const ChatListPage({super.key});

  @override
  Widget buildWidget(BuildContext context, WidgetRef ref) {
    return const ChatListMobileView();
  }
}
