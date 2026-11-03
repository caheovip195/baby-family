import 'package:baby_family/data/model/chat/chat_conversation.dart';
import 'package:baby_family/data/model/chat/chat_message.dart';
import 'package:baby_family/data/provider/chat.dart';
import 'package:baby_family/data/service/chat.dart';
import 'package:baby_family/utils/constants/enum.dart';
import 'package:baby_family/utils/router/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/design_qa.dart';

/// Nhắn tin trên máy giả (không mạng): dựng CHAT-01/02 với đủ trạng thái tin.
class _StubChat implements IChatService {
  _StubChat({this.status = RealtimeStatus.connected});

  @override
  final RealtimeStatus status;

  final sent = <String>[];
  final retried = <String>[];

  static final _at = DateTime(2026, 10, 7, 9);

  static final _members = [
    {'userId': 'me', 'displayName': 'Mama Lan', 'role': 'PARENT'},
    {
      'userId': 'papa',
      'displayName': 'Papa Minh',
      'role': 'PARENT',
      'lastReadSeq': 3,
    },
    {
      'userId': 'ba',
      'displayName': 'Bà nội',
      'role': 'CIRCLE',
      'lastReadSeq': 3,
    },
  ];

  final _conversations = [
    ChatConversation.fromJson({
      'id': 'fam',
      'kind': 'FAMILY',
      'lastSeq': 3,
      'unreadCount': 2,
      'lastMessageAt': _at.toIso8601String(),
      'lastMessage': {
        'id': 'm3',
        'seq': 3,
        'senderUserId': 'me',
        'isMine': true,
        'body': 'Chiều con gửi ảnh Haru tập đi cho cả nhà xem nhé!',
      },
      'members': _members,
    }),
    ChatConversation.fromJson({
      'id': 'us',
      'kind': 'COUPLE',
      'members': _members.take(2).toList(),
    }),
  ];

  @override
  bool get available => true;

  @override
  Stream<String> get changes => const Stream.empty();

  @override
  String? get myUserId => 'me';

  @override
  Stream<RealtimeStatus> get statusChanges => const Stream.empty();

  @override
  List<ChatConversation> get conversations => _conversations;

  @override
  ChatConversation? conversation(String id) =>
      _conversations.where((c) => c.id == id).firstOrNull;

  @override
  List<ChatMessage> messages(String conversationId) => conversationId != 'fam'
      ? const []
      : [
          ChatMessage(
            id: 'm1',
            seq: 1,
            senderUserId: 'ba',
            body: 'Sáng nay Haru dậy sớm không các con?',
            createdAt: _at,
          ),
          ChatMessage(
            id: 'm2',
            seq: 2,
            senderUserId: 'papa',
            body: 'Dậy từ 6 giờ, ăn hết bát cháo rồi bà ạ 😄 ' * 4,
            createdAt: _at,
          ),
          ChatMessage(
            id: 'm3',
            seq: 3,
            senderUserId: 'me',
            isMine: true,
            body: 'Chiều con gửi ảnh Haru tập đi cho cả nhà xem nhé!',
            createdAt: _at,
          ),
          ChatMessage(
            id: 'k1',
            senderUserId: 'me',
            isMine: true,
            clientKey: 'k1',
            body: 'Cuối tuần cả nhà qua chơi ông nhé',
            createdAt: _at,
            localState: 'SENDING',
          ),
          ChatMessage(
            id: 'k2',
            senderUserId: 'me',
            isMine: true,
            clientKey: 'k2',
            body: 'Haru vừa biết vẫy tay chào rồi đó 👋',
            createdAt: _at,
            localState: 'FAILED',
          ),
        ];

  @override
  bool hasOlder(String conversationId) => false;

  @override
  List<String> typingUsers(String conversationId) =>
      conversationId == 'fam' ? ['papa'] : const [];

  @override
  int pendingCount(String conversationId) => 1;

  @override
  Future<void> attach({required bool active, required bool parent}) async {}

  @override
  void pause() {}

  @override
  Future<void> resume() async {}

  @override
  Future<List<ChatConversation>> refreshConversations() async => _conversations;

  @override
  void open(String conversationId) {}

  @override
  void close(String conversationId) {}

  @override
  Future<void> refresh(String conversationId) async {}

  @override
  Future<bool> loadOlder(String conversationId) async => false;

  @override
  Future<void> send(String conversationId, String body) async => sent.add(body);

  @override
  Future<void> retry(String clientKey) async => retried.add(clientKey);

  @override
  void typing(String conversationId) {}

  @override
  void markRead(String conversationId) {}

  @override
  Future<void> syncPending() async {}
}

void main() {
  testWidgets('BF-20261101-001: CHAT-01 lists family + Papa & Mama with '
      'unread and preview', (tester) async {
    final chat = _StubChat();
    await pumpRoute(
      tester,
      const ChatListRoute(),
      overrides: [chatServiceProvider.overrideWithValue(chat)],
    );
    expect(find.text('Tin nhắn'), findsOneWidget);
    expect(find.text('Cả nhà'), findsOneWidget);
    expect(find.text('Papa & Mama'), findsOneWidget);
    expect(find.text('Chỉ hai bạn thấy'), findsOneWidget);
    expect(find.text('2'), findsOneWidget);
    expect(find.textContaining('Bạn: Chiều con gửi'), findsOneWidget);
    expect(find.text('Mama Lan, Papa Minh + 1 người thân'), findsOneWidget);
  });

  testWidgets('BF-20261101-001: CHAT-02 shows bubbles, states, receipt, '
      'typing; failed message retries; send clears the composer', (
    tester,
  ) async {
    final chat = _StubChat(status: RealtimeStatus.reconnecting);
    await pumpRoute(
      tester,
      ChatConversationRoute(conversationId: 'fam'),
      size: const Size(390, 1400),
      overrides: [chatServiceProvider.overrideWithValue(chat)],
    );
    expect(find.text('Bà nội'), findsWidgets);
    expect(find.text('Đang gửi…'), findsOneWidget);
    expect(find.text('Chưa gửi được · Chạm để gửi lại'), findsOneWidget);
    expect(find.text('Đã xem · Papa Minh, Bà nội'), findsOneWidget);
    expect(find.text('Papa Minh đang nhập…'), findsOneWidget);
    expect(find.text('Đang kết nối lại…'), findsOneWidget);

    await tester.tap(find.text('Chưa gửi được · Chạm để gửi lại'));
    await tester.pump();
    expect(chat.retried, ['k2']);

    await tester.enterText(find.byType(TextField), '  Chào cả nhà  ');
    await tester.pump();
    await tester.tap(find.bySemanticsLabel('Gửi'));
    await tester.pump();
    expect(chat.sent, ['Chào cả nhà']);
    expect(
      tester.widget<TextField>(find.byType(TextField)).controller!.text,
      isEmpty,
    );
  });

  testWidgets('BF-20261101-001: CHAT-03c/03d empty private conversation, dark '
      'mode + 200% text at 360 dp without overflow', (tester) async {
    final chat = _StubChat();
    await pumpRoute(
      tester,
      ChatConversationRoute(conversationId: 'us'),
      size: const Size(360, 780),
      themeMode: ThemeMode.dark,
      textScale: 2,
      overrides: [chatServiceProvider.overrideWithValue(chat)],
    );
    expect(tester.takeException(), isNull);
    expect(find.text('Chưa có tin nhắn nào'), findsOneWidget);
    expect(
      find.text('Chỉ Papa & Mama thấy cuộc trò chuyện này'),
      findsOneWidget,
    );
    expect(find.text('Nhắn riêng cho Papa Minh…'), findsOneWidget);
  });

  testWidgets('BF-20261101-001: CHAT-02 family conversation at 200% text on '
      '360 dp lays out without overflow', (tester) async {
    await pumpRoute(
      tester,
      ChatConversationRoute(conversationId: 'fam'),
      size: const Size(360, 780),
      textScale: 2,
      overrides: [chatServiceProvider.overrideWithValue(_StubChat())],
    );
    expect(tester.takeException(), isNull);
  });
}
