import 'dart:async';

import 'package:baby_family/data/model/chat/chat_conversation.dart';
import 'package:baby_family/data/provider/chat.dart';
import 'package:baby_family/data/provider/family.dart';
import 'package:baby_family/data/provider/mock_store.dart';
import 'package:baby_family/data/service/chat.dart';
import 'package:baby_family/page/application_base.dart';
import 'package:hooks_riverpod/legacy.dart';

/// CHAT-01 — Tin nhắn (Pencil `XEfvk`, BF-20261101-001): các cuộc trò
/// chuyện của gia đình (Bố Mẹ: “Cả nhà” + “Papa & Mama”; người thân: “Cả
/// nhà”). Hiện bản trên máy ngay rồi đồng bộ; realtime cập nhật số chưa đọc.
final chatListControllerProvider =
    ChangeNotifierProvider.autoDispose<ChatListController>(
      ChatListController.new,
    );

class ChatListController extends BaseNotifier {
  ChatListController(super.ref) {
    _changes = chatService.changes.listen((id) {
      if (id.isEmpty) {
        notifyListeners();
      }
    });
    Future.microtask(load);
  }

  IChatService get chatService => ref.read(chatServiceProvider);

  late final StreamSubscription<String> _changes;

  String familyName = '';
  bool loaded = false;
  bool hasError = false;

  List<ChatConversation> get conversations => chatService.conversations;

  DateTime get now => ref.read(appClockProvider).now();

  Future<void> load() async {
    hasError = false;
    notifyListeners();
    try {
      await chatService.refreshConversations();
    } on Object {
      // Mất mạng: dùng bản trên máy; chỉ báo lỗi khi chưa có gì để hiện.
      hasError = conversations.isEmpty;
    }
    try {
      familyName =
          (await ref.read(familyServiceProvider).currentFamily())?.name ?? '';
    } on Object {
      familyName = '';
    }
    if (isDisposed) {
      return;
    }
    loaded = true;
    notifyListeners();
  }

  @override
  void dispose() {
    unawaited(_changes.cancel());
    super.dispose();
  }
}
