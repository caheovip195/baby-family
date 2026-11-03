import 'dart:async';

import 'package:baby_family/data/dto/realtime_event.dart';
import 'package:baby_family/data/model/chat/chat_conversation.dart';
import 'package:baby_family/data/model/chat/chat_message.dart';
import 'package:baby_family/data/model/chat/chat_message_page.dart';
import 'package:baby_family/data/provider/chat.dart';
import 'package:baby_family/data/provider/mock_store.dart';
import 'package:baby_family/data/provider/session.dart';
import 'package:baby_family/data/repository/base.dart';
import 'package:baby_family/data/repository/chat_remote.dart';
import 'package:baby_family/data/repository/realtime.dart';
import 'package:baby_family/data/repository_imp/realtime.dart';
import 'package:baby_family/data/service_imp/chat.dart';
import 'package:baby_family/page/general/chat_conversation/chat_conversation_controller.dart';
import 'package:baby_family/utils/constants/enum.dart';
import 'package:baby_family/utils/constants/values.dart';
import 'package:baby_family/utils/router/deep_link_route.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../helpers/design_qa.dart';
import '../helpers/fake_local_db.dart';
import '../helpers/fake_outbox.dart';

const _family = 'srv-family';
const _familyChat = 'c-family';
const _coupleChat = 'c-couple';
const _me = 'u-mama';
const _papa = 'u-papa';
const _grandma = 'u-grandma';

/// Server chat giả: seq tăng theo cuộc trò chuyện, Idempotency-Key trùng →
/// cùng tin.
class _FakeChatServer implements IChatRemoteRepository {
  bool offline = false;
  int? rejectWith;
  final rows = <String, List<JsonMap>>{_familyChat: [], _coupleChat: []};
  final byKey = <String, JsonMap>{};
  final reads = <String, int>{};
  final calls = <String>[];

  void _check(String path) {
    if (offline) {
      throw DioException(requestOptions: RequestOptions(path: path));
    }
    final status = rejectWith;
    if (status != null) {
      rejectWith = null;
      final options = RequestOptions(path: path);
      throw DioException(
        requestOptions: options,
        response: Response(requestOptions: options, statusCode: status),
      );
    }
  }

  JsonMap add(String conversationId, String sender, String body) {
    final list = rows[conversationId]!;
    final row = {
      'id': 'm-$conversationId-${list.length + 1}',
      'conversationId': conversationId,
      'seq': list.length + 1,
      'senderUserId': sender,
      'body': body,
      'createdAt': DateTime.utc(2026, 11, 1, 8, list.length).toIso8601String(),
      // Field server mới: app phải bỏ qua.
      'reactions': {'❤️': 2},
    };
    list.add(row);
    return row;
  }

  ChatMessage _view(JsonMap row) => ChatMessage.fromJson({
    ...row,
    'isMine': row['senderUserId'] == _me,
    'clientKey': row['senderUserId'] == _me ? row['clientKey'] : null,
  });

  @override
  Future<List<ChatConversation>> conversations(String familyId) async {
    _check('/chats');
    calls.add('list');
    ChatConversation of(String id, String kind, List<JsonMap> members) {
      final list = rows[id]!;
      final readSeq = reads[id] ?? 0;
      return chatConversationList([
        {
          'id': id,
          'familyId': familyId,
          'kind': kind,
          'lastSeq': list.length,
          'readSeq': readSeq,
          'unreadCount': list.length - readSeq,
          'lastMessageAt': list.lastOrNull?['createdAt'],
          'lastMessage': list.isEmpty ? null : _view(list.last).toJson(),
          'members': members,
        },
      ]).single;
    }

    return [
      of(_familyChat, 'FAMILY', [
        {'userId': _me, 'displayName': 'Mama', 'role': 'PARENT'},
        {'userId': _papa, 'displayName': 'Papa', 'role': 'PARENT'},
        {'userId': _grandma, 'displayName': 'Bà nội', 'role': 'CIRCLE'},
      ]),
      of(_coupleChat, 'COUPLE', [
        {'userId': _me, 'displayName': 'Mama', 'role': 'PARENT'},
        {'userId': _papa, 'displayName': 'Papa', 'role': 'PARENT'},
      ]),
    ];
  }

  @override
  Future<ChatMessagePage> messages(
    String familyId,
    String conversationId, {
    int? beforeSeq,
    int? afterSeq,
    int? limit,
  }) async {
    _check('/messages');
    calls.add('messages:${afterSeq ?? '-'}:${beforeSeq ?? '-'}');
    final size = limit ?? 50;
    var list = rows[conversationId]!;
    if (afterSeq != null) {
      list = list.where((r) => (r['seq'] as int) > afterSeq).toList();
      final page = list.take(size).toList();
      return ChatMessagePage(
        items: page.map(_view).toList(),
        hasMore: list.length > size,
      );
    }
    if (beforeSeq != null) {
      list = list.where((r) => (r['seq'] as int) < beforeSeq).toList();
    }
    final start = list.length > size ? list.length - size : 0;
    return ChatMessagePage(
      items: list.sublist(start).map(_view).toList(),
      hasMore: start > 0,
    );
  }

  @override
  Future<ChatMessage?> send(
    String familyId,
    String conversationId,
    String idempotencyKey,
    String body,
  ) async {
    _check('/send');
    calls.add('send:$idempotencyKey');
    final row = byKey[idempotencyKey] ??= add(conversationId, _me, body)
      ..['clientKey'] = idempotencyKey;
    return _view(row);
  }

  @override
  Future<int?> markRead(String familyId, String conversationId, int seq) async {
    _check('/read');
    calls.add('read:$conversationId:$seq');
    return reads[conversationId] = seq;
  }
}

class _FakeRealtime implements IRealtimeRepository {
  final _events = StreamController<RealtimeEvent>.broadcast();
  final _statuses = StreamController<RealtimeStatus>.broadcast();
  final emitted = <String>[];
  RealtimeStatus _status = RealtimeStatus.idle;

  void push(String name, JsonMap data) =>
      _events.add(RealtimeEvent(name, data));

  @override
  Stream<RealtimeEvent> get events => _events.stream;

  @override
  Stream<RealtimeStatus> get statusChanges => _statuses.stream;

  @override
  RealtimeStatus get status => _status;

  void setStatus(RealtimeStatus value) {
    _status = value;
    _statuses.add(value);
  }

  @override
  void connect() => setStatus(RealtimeStatus.connected);

  @override
  void disconnect() => setStatus(RealtimeStatus.idle);

  @override
  void emit(String event, JsonMap data) =>
      emitted.add('$event:${data['conversationId']}');
}

Future<void> _settle() =>
    Future<void>.delayed(const Duration(milliseconds: 20));

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late ProviderContainer container;
  late _FakeChatServer server;
  late _FakeRealtime realtime;

  setUp(() async {
    container = ProviderContainer(overrides: mockOverrides());
    addTearDown(container.dispose);
    server = _FakeChatServer();
    realtime = _FakeRealtime();
    final session = container.read(sessionRepositoryProvider);
    await session.ensureLoaded();
    session.patchSession({kValueSessionKeyServerFamilyId: _family});
  });

  ChatServiceImp service({FakeOutbox? outbox, FakeLocalDb? db}) =>
      ChatServiceImp(
          container.read(sessionRepositoryProvider),
          container.read(appClockProvider),
          server,
          realtime,
        )
        ..outbox = outbox
        ..localDb = db;

  test('BF-20261101-001: offline message shows at once as waiting and is '
      'sent exactly once when back online (matched by clientKey)', () async {
    final chat = service();
    await chat.attach(active: true, parent: true);
    server.add(_familyChat, _papa, 'Chào cả nhà');
    await chat.refresh(_familyChat);
    expect(chat.messages(_familyChat).single.body, 'Chào cả nhà');

    server.offline = true;
    await chat.send(_familyChat, '  Con ngủ rồi  ');
    await _settle();
    final pending = chat.messages(_familyChat).last;
    expect(pending.body, 'Con ngủ rồi');
    expect(pending.isMine, isTrue);
    expect(pending.sendState, ChatSendState.waiting);
    expect(pending.clientKey, pending.id);
    expect(chat.pendingCount(_familyChat), 1);

    server.offline = false;
    await chat.syncPending();
    await _settle();
    final messages = chat.messages(_familyChat);
    expect(messages, hasLength(2));
    expect(messages.last.sendState, ChatSendState.sent);
    expect(messages.last.seq, 2);
    expect(messages.last.clientKey, pending.clientKey);
    expect(chat.pendingCount(_familyChat), 0);
    expect(server.calls.where((c) => c.startsWith('send:')), [
      'send:${pending.clientKey}',
    ]);
  });

  test('BF-20261101-001: rejected message becomes failed; tap to retry sends '
      'with the same key', () async {
    final chat = service();
    await chat.attach(active: true, parent: true);
    server.rejectWith = 403;
    await chat.send(_familyChat, 'Xin chào');
    await _settle();
    final failed = chat.messages(_familyChat).single;
    expect(failed.sendState, ChatSendState.failed);

    await chat.retry(failed.clientKey!);
    await _settle();
    final sent = chat.messages(_familyChat).single;
    expect(sent.sendState, ChatSendState.sent);
    expect(sent.clientKey, failed.clientKey);
  });

  test('BF-20261101-001: messages and queued sends survive a restart; '
      'reopening syncs only newer messages (afterSeq)', () async {
    final outbox = FakeOutbox();
    final db = FakeLocalDb();
    final first = service(outbox: outbox, db: db);
    await first.attach(active: true, parent: true);
    for (var i = 0; i < 3; i++) {
      server.add(_familyChat, _papa, 'Tin $i');
    }
    await first.refresh(_familyChat);
    server.offline = true;
    await first.send(_familyChat, 'Chờ mạng');
    await _settle();
    // Ghi gộp xuống DB trên máy.
    await Future<void>.delayed(
      kValueLocalDbWriteDelay + const Duration(milliseconds: 50),
    );

    // Mở lại app khi vẫn mất mạng.
    final second = service(outbox: outbox, db: db);
    await second.attach(active: true, parent: true);
    final restored = second.messages(_familyChat);
    expect(restored.map((m) => m.body), [
      'Tin 0',
      'Tin 1',
      'Tin 2',
      'Chờ mạng',
    ]);
    expect(restored.last.isPending, isTrue);
    expect(second.conversations.map((c) => c.id), contains(_familyChat));

    server
      ..offline = false
      ..calls.clear();
    server.add(_familyChat, _papa, 'Tin mới');
    await second.refresh(_familyChat);
    expect(server.calls, contains('messages:3:-'));
    await second.syncPending();
    await _settle();
    expect(second.messages(_familyChat).map((m) => m.body), [
      'Tin 0',
      'Tin 1',
      'Tin 2',
      'Tin mới',
      'Chờ mạng',
    ]);
    expect(second.pendingCount(_familyChat), 0);
  });

  test('BF-20261101-001: relatives never see the COUPLE conversation; '
      'unknown kinds are skipped', () async {
    final chat = service();
    await chat.attach(active: true, parent: false);
    await chat.refreshConversations();
    expect(chat.conversations.map((c) => c.id), [_familyChat]);
    expect(chat.conversation(_coupleChat), isNull);

    final parent = service();
    await parent.attach(active: true, parent: true);
    await parent.refreshConversations();
    expect(parent.conversations.map((c) => c.kind).toSet(), {
      'FAMILY',
      'COUPLE',
    });
  });

  test('BF-20261101-001: realtime signals fetch newer messages, update '
      '“seen” and typing; mark read posts the latest seq', () async {
    final chat = service();
    await chat.attach(active: true, parent: true);
    expect(realtime.status, RealtimeStatus.connected);
    await chat.refreshConversations();
    chat.open(_familyChat);
    await chat.refresh(_familyChat);

    server.add(_familyChat, _papa, 'Về chưa?');
    realtime.push('chat.message', {
      'familyId': _family,
      'conversationId': _familyChat,
      'seq': 1,
      'senderUserId': _papa,
    });
    await _settle();
    expect(chat.messages(_familyChat).single.body, 'Về chưa?');

    // Tín hiệu của gia đình khác: bỏ qua.
    realtime.push('chat.typing', {
      'familyId': 'other',
      'conversationId': _familyChat,
      'userId': _papa,
    });
    realtime.push('chat.typing', {
      'familyId': _family,
      'conversationId': _familyChat,
      'userId': _grandma,
    });
    await _settle();
    expect(chat.typingUsers(_familyChat), [_grandma]);

    realtime.push('chat.read', {
      'familyId': _family,
      'conversationId': _familyChat,
      'userId': _grandma,
      'seq': 1,
    });
    await _settle();
    expect(chat.conversation(_familyChat)!.member(_grandma)!.lastReadSeq, 1);

    chat.markRead(_familyChat);
    await Future<void>.delayed(
      kValueChatReadDebounce + const Duration(milliseconds: 50),
    );
    expect(server.calls, contains('read:$_familyChat:1'));
    expect(chat.conversation(_familyChat)!.unreadCount, 0);

    chat
      ..typing(_familyChat)
      ..typing(_familyChat);
    expect(realtime.emitted, ['chat.typing:$_familyChat']);

    // Đăng xuất: ngắt realtime, bỏ dữ liệu phiên.
    await chat.attach(active: false, parent: true);
    expect(realtime.status, RealtimeStatus.idle);
    expect(chat.available, isFalse);
    expect(chat.conversations, isEmpty);
  });

  test('BF-20261101-001: lenient parsing — unknown fields, kinds and broken '
      'rows never crash', () {
    final list = chatConversationList([
      {
        'id': 'a',
        'kind': 'GROUP_V2',
        'members': [
          {'userId': 'u1', 'role': 'GUARDIAN', 'extra': true},
          {'userId': 42},
        ],
        'lastMessage': {'id': 'm1', 'seq': 'oops'},
        'newField': {'x': 1},
      },
      {'id': 7},
      'junk',
    ]);
    expect(list, hasLength(1));
    expect(list.single.isKnown, isFalse);
    expect(list.single.members.single.isParent, isFalse);
    expect(list.single.lastMessage, isNull);

    final page = ChatMessagePage.fromJson({
      'items': [
        {'id': 'm1', 'seq': 1, 'body': 'ok', 'unknown': []},
        {'seq': 2},
      ],
      'hasMore': true,
    });
    expect(page.items.single.body, 'ok');
    expect(page.items.single.sendState, ChatSendState.sent);
  });

  test('BF-20261101-001: socket origin drops the API path; chat deep links '
      'open the conversation for parents and relatives', () {
    expect(
      RealtimeRepositoryImp.originOf('http://localhost:3000/api'),
      'http://localhost:3000',
    );
    expect(
      RealtimeRepositoryImp.originOf('https://api.example.vn/api/v1'),
      'https://api.example.vn',
    );
    expect(
      routeForDeepLink('babyfamily://chats/c1', circle: false),
      '/chats/c1',
    );
    expect(
      routeForDeepLink('babyfamily://chats/c1', circle: true),
      '/chats/c1',
    );
    expect(routeForDeepLink('babyfamily://chats', circle: true), '/chats');
  });

  test('BF-20261101-001: CHAT-02 controller — local first, send offline → '
      'pending → sent, receipt “seen” by others', () async {
    final chat = service();
    final scoped = ProviderContainer(
      overrides: [
        ...mockOverrides(),
        chatServiceProvider.overrideWithValue(chat),
      ],
    );
    addTearDown(scoped.dispose);
    final session = scoped.read(sessionRepositoryProvider);
    await session.ensureLoaded();
    session.patchSession({kValueSessionKeyServerFamilyId: _family});
    await chat.attach(active: true, parent: true);
    server.add(_coupleChat, _papa, 'Tối nay ăn gì?');

    final subscription = scoped.listen(
      chatConversationControllerProvider,
      (_, _) {},
    );
    addTearDown(subscription.close);
    final controller = scoped.read(chatConversationControllerProvider);
    await controller.init(_coupleChat);
    expect(controller.isCouple, isTrue);
    expect(controller.timeline.first.day, isNotNull);
    expect(controller.messages.single.body, 'Tối nay ăn gì?');
    expect(controller.others.map((m) => m.displayName), contains('Papa'));

    server.offline = true;
    expect(await controller.send('   '), isFalse);
    expect(await controller.send('Để anh nấu'), isTrue);
    await _settle();
    expect(controller.messages.last.sendState, ChatSendState.waiting);
    expect(controller.receipt, isNull);

    server.offline = false;
    await chat.syncPending();
    await _settle();
    expect(controller.messages.last.sendState, ChatSendState.sent);
    expect(controller.receipt?.seen, isFalse);

    realtime.push('chat.read', {
      'familyId': _family,
      'conversationId': _coupleChat,
      'userId': _papa,
      'seq': 2,
    });
    await _settle();
    expect(controller.receipt?.seenBy, ['Papa']);
    await Future<void>.delayed(
      kValueChatReadDebounce + const Duration(milliseconds: 50),
    );
  });
}
