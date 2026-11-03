import 'dart:async';

import 'package:baby_family/data/dto/chat_receipt.dart';
import 'package:baby_family/data/dto/chat_timeline_item.dart';
import 'package:baby_family/data/model/chat/chat_conversation.dart';
import 'package:baby_family/data/model/chat/chat_member.dart';
import 'package:baby_family/data/model/chat/chat_message.dart';
import 'package:baby_family/data/provider/chat.dart';
import 'package:baby_family/data/provider/connectivity.dart';
import 'package:baby_family/data/provider/mock_store.dart';
import 'package:baby_family/data/service/chat.dart';
import 'package:baby_family/page/application_base.dart';
import 'package:baby_family/utils/constants/enum.dart';
import 'package:baby_family/utils/constants/values.dart';
import 'package:baby_family/utils/extension/date_time.dart';
import 'package:hooks_riverpod/legacy.dart';

/// CHAT-02 — Hội thoại (Pencil `YQ4Ym`, 03a–03d, BF-20261101-001): tin trên
/// máy hiện ngay rồi đồng bộ `afterSeq`; gửi offline-first (đang gửi → đã
/// gửi / chờ mạng / chạm để gửi lại); “Đã xem”, “đang nhập…”, băng ngoại
/// tuyến / đang kết nối lại; đánh dấu đã đọc khi đang xem.
final chatConversationControllerProvider =
    ChangeNotifierProvider.autoDispose<ChatConversationController>(
      ChatConversationController.new,
    );

class ChatConversationController extends BaseNotifier {
  ChatConversationController(super.ref)
    : chatService = ref.read(chatServiceProvider) {
    _changes = chatService.changes.listen(_onChange);
    _status = chatService.statusChanges.listen((_) => notifyListeners());
    offline = ref.read(isOfflineProvider).value ?? false;
    ref.listen(isOfflineProvider, (_, next) {
      offline = next.value ?? false;
      notifyListeners();
    });
  }

  /// Giữ lại để [dispose] (không dùng `ref` sau khi provider bị huỷ).
  final IChatService chatService;

  late final StreamSubscription<String> _changes;
  late final StreamSubscription<RealtimeStatus> _status;

  String? conversationId;
  bool loaded = false;

  /// Đồng bộ lần gần nhất lỗi (vẫn hiện tin đã lưu).
  bool hasError = false;
  bool loadingOlder = false;
  bool offline = false;

  /// Đã đọc danh sách từ server mà không thấy cuộc trò chuyện (không có quyền
  /// / đã bị xoá, vd người thân mở link Papa & Mama).
  bool notFound = false;

  DateTime get now => ref.read(appClockProvider).now();

  ChatConversation? get conversation {
    final id = conversationId;
    return id == null ? null : chatService.conversation(id);
  }

  bool get isCouple => conversation?.isCouple ?? false;

  List<ChatMessage> get messages {
    final id = conversationId;
    return id == null ? const [] : chatService.messages(id);
  }

  bool get hasOlder {
    final id = conversationId;
    return id != null && chatService.hasOlder(id);
  }

  int get pendingCount {
    final id = conversationId;
    return id == null ? 0 : chatService.pendingCount(id);
  }

  String? get myUserId =>
      chatService.myUserId ??
      messages
          .where((m) => m.isMine && m.senderUserId.isNotEmpty)
          .firstOrNull
          ?.senderUserId;

  /// Thành viên khác tôi (bạn đời ở Papa & Mama).
  List<ChatMember> get others {
    final me = myUserId;
    return [
      for (final member in conversation?.members ?? const <ChatMember>[])
        if (member.userId != me) member,
    ];
  }

  ChatConnectionBanner get banner {
    if (offline) {
      return ChatConnectionBanner.offline;
    }
    if (chatService.status == RealtimeStatus.reconnecting) {
      return ChatConnectionBanner.reconnecting;
    }
    return ChatConnectionBanner.none;
  }

  /// userId đang nhập (không gồm tôi).
  List<String> get typingUsers {
    final id = conversationId;
    final me = myUserId;
    return id == null
        ? const []
        : [
            for (final userId in chatService.typingUsers(id))
              if (userId != me) userId,
          ];
  }

  /// Ngăn cách ngày + tin, tăng dần; tên/avatar ở tin đầu mỗi chuỗi.
  List<ChatTimelineItem> get timeline {
    final items = <ChatTimelineItem>[];
    DateTime? day;
    String? previousSender;
    for (final message in messages) {
      final at = (message.createdAt ?? now).toLocal().dateOnly;
      if (day != at) {
        day = at;
        previousSender = null;
        items.add(ChatTimelineItem.day(at));
      }
      final sender = message.isMine ? '' : message.senderUserId;
      items.add(
        ChatTimelineItem.message(
          message,
          showSender: !message.isMine && sender != previousSender,
        ),
      );
      previousSender = sender;
    }
    return items;
  }

  /// “Đã gửi / Đã xem” dưới tin cuối đã lên server của tôi (tin đang chờ /
  /// lỗi sau nó có trạng thái riêng).
  ChatReceipt? get receipt {
    final mine = messages
        .where((m) => m.isMine && !m.isPending && m.seq > 0)
        .lastOrNull;
    if (mine == null) {
      return null;
    }
    return ChatReceipt(
      messageId: mine.id,
      seenBy: [
        for (final member in conversation?.members ?? const <ChatMember>[])
          if (member.userId != mine.senderUserId &&
              member.lastReadSeq >= mine.seq)
            member.displayName,
      ],
    );
  }

  Future<void> init(String id) async {
    if (conversationId == id) {
      return;
    }
    conversationId = id;
    chatService.open(id);
    notifyListeners();
    await load();
  }

  Future<void> load() async {
    final id = conversationId;
    if (id == null) {
      return;
    }
    hasError = false;
    var listed = chatService.conversation(id) != null;
    if (!listed) {
      try {
        await chatService.refreshConversations();
        listed = chatService.conversation(id) != null;
        notFound = !listed;
      } on Object {
        hasError = true;
      }
    }
    if (isDisposed) {
      return;
    }
    if (listed) {
      try {
        await chatService.refresh(id);
      } on Object {
        hasError = true;
      }
    }
    if (isDisposed) {
      return;
    }
    loaded = true;
    notifyListeners();
    if (listed) {
      chatService.markRead(id);
    }
  }

  void _onChange(String id) {
    final current = conversationId;
    if (current == null || (id.isNotEmpty && id != current)) {
      return;
    }
    if (id == current && chatService.conversation(current) != null) {
      // Đang xem: tin mới tới → đánh dấu đã đọc (service gộp + bỏ khi đã đọc).
      chatService.markRead(current);
    }
    notifyListeners();
  }

  Future<void> loadOlder() async {
    final id = conversationId;
    if (id == null || loadingOlder || !hasOlder) {
      return;
    }
    loadingOlder = true;
    notifyListeners();
    try {
      await chatService.loadOlder(id);
    } on Object {
      // Mất mạng: thử lại khi cuộn tiếp.
    }
    loadingOlder = false;
    notifyListeners();
  }

  /// false khi nội dung rỗng / quá dài.
  Future<bool> send(String text) async {
    final id = conversationId;
    final body = text.trim();
    if (id == null ||
        body.isEmpty ||
        body.length > kValueChatBodyMaxLength ||
        conversation == null) {
      return false;
    }
    await chatService.send(id, body);
    return true;
  }

  Future<void> retry(ChatMessage message) async {
    if (message.isPending && message.clientKey != null) {
      await chatService.retry(message.clientKey!);
    }
  }

  void typing() {
    final id = conversationId;
    if (id != null) {
      chatService.typing(id);
    }
  }

  @override
  void dispose() {
    final id = conversationId;
    if (id != null) {
      chatService.close(id);
    }
    unawaited(_changes.cancel());
    unawaited(_status.cancel());
    super.dispose();
  }
}
