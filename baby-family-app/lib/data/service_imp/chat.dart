import 'dart:async';
import 'dart:math' as math;

import 'package:baby_family/data/dto/realtime_event.dart';
import 'package:baby_family/data/model/chat/chat_conversation.dart';
import 'package:baby_family/data/model/chat/chat_message.dart';
import 'package:baby_family/data/model/sync/outbox_entry.dart';
import 'package:baby_family/data/repository/chat_remote.dart';
import 'package:baby_family/data/repository/local_db.dart';
import 'package:baby_family/data/repository/outbox.dart';
import 'package:baby_family/data/repository/realtime.dart';
import 'package:baby_family/data/repository/session.dart';
import 'package:baby_family/data/service/chat.dart';
import 'package:baby_family/data/service_imp/base.dart';
import 'package:baby_family/data/service_imp/local_tables.dart';
import 'package:baby_family/data/service_imp/outbox_runner.dart';
import 'package:baby_family/utils/constants/enum.dart';
import 'package:baby_family/utils/constants/values.dart';
import 'package:baby_family/utils/helper/app_clock.dart';
import 'package:logger/logger.dart';
import 'package:uuid/uuid.dart';

/// Nhắn tin gia đình (BF-20261101-001) — xem [IChatService].
///
/// - Bản trên máy: bảng `chatConversations` / `chatMessages` của local DB
///   (nạp khi vào phiên, ghi gộp, giữ [kValueChatLocalMessageLimit] tin mới
///   nhất mỗi cuộc trò chuyện).
/// - Gửi: hàng đợi `chat` của [OutboxRunner], id thao tác = `clientKey` =
///   Idempotency-Key (UUID v4) nên gửi lại sau khi mất mạng / tắt app không
///   tạo trùng; tin server có `clientKey` trùng thay bản chờ.
/// - Realtime: `chat.message` → đọc tin mới (`afterSeq`); `chat.read` → “Đã
///   xem”; `chat.typing` → “đang nhập…”; `ready` (kết nối / kết nối lại) →
///   đồng bộ lại danh sách + cuộc trò chuyện đang mở.
class ChatServiceImp extends BaseServiceImp implements IChatService {
  ChatServiceImp(this._session, this._clock, this._remote, this._realtime);

  final ISessionRepository _session;
  final AppClock _clock;
  final IChatRemoteRepository _remote;
  final IRealtimeRepository _realtime;

  IOutboxRepository? get outbox => _outbox.store;
  set outbox(IOutboxRepository? store) => _outbox.store = store;

  /// null (test) = chỉ trong RAM.
  ILocalDb? get localDb => _tables.db;
  set localDb(ILocalDb? db) => _tables.db = db;

  static const _sendKind = 'chat.send';
  static const _uuid = Uuid();

  late final OutboxRunner _outbox = OutboxRunner(
    send: _send,
    onState: (entry, state) => _changed(_conversationOf(entry)),
  );

  late final LocalTables _tables = LocalTables({
    'chatConversations': LocalTable(
      rows: () => [for (final item in _conversations.values) item.toJson()],
      restore: (row) {
        final item = ChatConversation.fromJson(row);
        _conversations.putIfAbsent(item.id, () => item);
      },
      validate: ChatConversation.fromJson,
    ),
    'chatMessages': LocalTable(
      rows: () => [
        for (final items in _messages.values)
          for (final item in _latest(items.values)) item.toJson(),
      ],
      restore: (row) {
        final item = ChatMessage.fromJson(row);
        if (item.conversationId.isNotEmpty) {
          (_messages[item.conversationId] ??= {}).putIfAbsent(
            item.id,
            () => item,
          );
        }
      },
      validate: ChatMessage.fromJson,
    ),
  }, scope: () => _attachedScope);

  final _conversations = <String, ChatConversation>{};

  /// Tin server đã nhận theo cuộc trò chuyện (id → tin).
  final _messages = <String, Map<String, ChatMessage>>{};
  final _older = <String, bool>{};
  final _typing = <String, Map<String, DateTime>>{};
  final _typingTimers = <String, Timer>{};
  final _typingSent = <String, DateTime>{};
  final _readTimers = <String, Timer>{};
  final _openCount = <String, int>{};
  final _syncing = <String, Future<void>>{};
  final _changes = StreamController<String>.broadcast();

  StreamSubscription<RealtimeEvent>? _events;
  Timer? _listTimer;
  String? _attachedScope;
  String? _myUserId;
  bool _parent = true;
  bool _paused = false;

  String? get _serverFamilyId =>
      _session.session()[kValueSessionKeyServerFamilyId] as String?;

  @override
  bool get available => _attachedScope != null;

  @override
  Stream<String> get changes => _changes.stream;

  @override
  String? get myUserId => _myUserId;

  @override
  RealtimeStatus get status => _realtime.status;

  @override
  Stream<RealtimeStatus> get statusChanges => _realtime.statusChanges;

  bool _visible(ChatConversation item) =>
      item.isKnown && (_parent || !item.isCouple);

  @override
  List<ChatConversation> get conversations {
    final items = _conversations.values.where(_visible).toList()
      ..sort((a, b) {
        final at = a.lastMessageAt, bt = b.lastMessageAt;
        if (at == null || bt == null) {
          // Chưa có tin: “Cả nhà” trước.
          return at != null
              ? -1
              : bt != null
              ? 1
              : (a.isFamily ? 0 : 1) - (b.isFamily ? 0 : 1);
        }
        return bt.compareTo(at);
      });
    return items;
  }

  @override
  ChatConversation? conversation(String id) {
    final item = _conversations[id];
    return item != null && _visible(item) ? item : null;
  }

  @override
  List<ChatMessage> messages(String conversationId) {
    final server = _messages[conversationId]?.values ?? const [];
    final delivered = {
      for (final item in server)
        if (item.clientKey != null) item.clientKey,
    };
    final pending = [
      for (final entry in _outbox.entries)
        if (_conversationOf(entry) == conversationId &&
            !delivered.contains(entry.id))
          _pendingMessage(entry),
    ];
    return [..._sorted(server), ...pending];
  }

  @override
  bool hasOlder(String conversationId) =>
      _older[conversationId] ?? _minSeq(conversationId) > 1;

  @override
  List<String> typingUsers(String conversationId) {
    final now = _clock.now();
    return [
      for (final MapEntry(key: userId, value: until)
          in (_typing[conversationId] ?? const <String, DateTime>{}).entries)
        if (until.isAfter(now)) userId,
    ];
  }

  @override
  int pendingCount(String conversationId) => _outbox.entries
      .where((entry) => _conversationOf(entry) == conversationId)
      .length;

  @override
  Future<void> attach({required bool active, required bool parent}) async {
    final parentChanged = _parent != parent;
    _parent = parent;
    final scope = active ? _serverFamilyId : null;
    if (scope == _attachedScope) {
      if (parentChanged) {
        _changed('');
      }
      return;
    }
    _detach();
    if (scope == null) {
      return;
    }
    _attachedScope = scope;
    _events = _realtime.events.listen(_onEvent);
    await _tables.hydrate();
    for (final items in _messages.values) {
      _rememberMe(items.values);
    }
    await _outbox.load();
    _changed('');
    if (!_paused) {
      _realtime.connect();
    }
    unawaited(_quietly(refreshConversations, 'danh sách trò chuyện'));
  }

  void _detach() {
    _events?.cancel();
    _events = null;
    _realtime.disconnect();
    _listTimer?.cancel();
    for (final timer in [..._typingTimers.values, ..._readTimers.values]) {
      timer.cancel();
    }
    _typingTimers.clear();
    _readTimers.clear();
    _typing.clear();
    _typingSent.clear();
    _conversations.clear();
    _messages.clear();
    _older.clear();
    _syncing.clear();
    _myUserId = null;
    _attachedScope = null;
    _tables.reset();
    // Đăng xuất: không gửi tin của phiên cũ bằng token phiên mới (bản lưu
    // của hàng đợi đã bị xoá cùng dữ liệu đăng nhập).
    _outbox.reset();
    _changed('');
  }

  @override
  void pause() {
    _paused = true;
    _realtime.disconnect();
  }

  @override
  Future<void> resume() async {
    _paused = false;
    if (_attachedScope == null) {
      return;
    }
    _realtime.connect();
    await _resync();
  }

  /// Kết nối (lại) / lên lại: đọc danh sách + cuộc trò chuyện đang mở, gửi
  /// tin chờ.
  Future<void> _resync() async {
    unawaited(syncPending());
    await Future.wait([
      _quietly(refreshConversations, 'danh sách trò chuyện'),
      for (final id in _openCount.keys) _quietly(() => refresh(id), 'tin nhắn'),
    ]);
  }

  @override
  Future<List<ChatConversation>> refreshConversations() async {
    final scope = _attachedScope;
    if (scope == null) {
      return const [];
    }
    final items = await _remote.conversations(scope);
    if (_attachedScope != scope) {
      return const [];
    }
    _conversations
      ..clear()
      ..addAll({for (final item in items) item.id: item});
    _messages.removeWhere((id, _) => !_conversations.containsKey(id));
    _tables.schedule();
    _changed('');
    return conversations;
  }

  @override
  void open(String conversationId) {
    _openCount.update(conversationId, (count) => count + 1, ifAbsent: () => 1);
  }

  @override
  void close(String conversationId) {
    final count = (_openCount[conversationId] ?? 1) - 1;
    if (count > 0) {
      _openCount[conversationId] = count;
    } else {
      _openCount.remove(conversationId);
    }
  }

  @override
  Future<void> refresh(String conversationId) =>
      _syncing[conversationId] ??= _refresh(conversationId).whenComplete(() {
        // Không trả Future vừa gỡ: whenComplete sẽ chờ chính nó (treo).
        _syncing.remove(conversationId);
      });

  Future<void> _refresh(String conversationId) async {
    final scope = _attachedScope;
    if (scope == null) {
      return;
    }
    var after = _maxSeq(conversationId);
    if (after == 0) {
      await _latestPage(scope, conversationId);
    } else {
      for (var page = 0; ; page++) {
        if (page >= kValueChatSyncMaxPages) {
          // Xa quá: bỏ tin trên máy, lấy trang mới nhất (cuộn lên để xem
          // tiếp tin cũ).
          _messages.remove(conversationId);
          await _latestPage(scope, conversationId);
          break;
        }
        final result = await _remote.messages(
          scope,
          conversationId,
          afterSeq: after,
          limit: kValueChatPageSize,
        );
        if (_attachedScope != scope) {
          return;
        }
        _put(conversationId, result.items);
        if (!result.hasMore || result.items.isEmpty) {
          break;
        }
        after = math.max(after, result.items.last.seq);
      }
    }
    _touchConversation(conversationId);
    _changed(conversationId);
  }

  Future<void> _latestPage(String scope, String conversationId) async {
    final result = await _remote.messages(
      scope,
      conversationId,
      limit: kValueChatPageSize,
    );
    if (_attachedScope != scope) {
      return;
    }
    _put(conversationId, result.items);
    _older[conversationId] = result.hasMore;
  }

  @override
  Future<bool> loadOlder(String conversationId) async {
    final scope = _attachedScope;
    final before = _minSeq(conversationId);
    if (scope == null || before <= 1) {
      _older[conversationId] = false;
      return false;
    }
    final result = await _remote.messages(
      scope,
      conversationId,
      beforeSeq: before,
      limit: kValueChatPageSize,
    );
    if (_attachedScope != scope) {
      return false;
    }
    _put(conversationId, result.items);
    _older[conversationId] = result.hasMore;
    _changed(conversationId);
    return result.items.isNotEmpty;
  }

  @override
  Future<void> send(String conversationId, String body) async {
    final text = body.trim();
    final scope = _attachedScope;
    if (text.isEmpty || text.length > kValueChatBodyMaxLength) {
      throw ArgumentError.value(body, 'body');
    }
    if (scope == null) {
      throw StateError('Chat is not available');
    }
    await _outbox.add(
      OutboxEntry(
        id: _uuid.v4(),
        kind: _sendKind,
        args: {
          'familyId': scope,
          'conversationId': conversationId,
          'body': text,
        },
        createdAt: _clock.now(),
      ),
    );
    _changed(conversationId);
  }

  @override
  Future<void> retry(String clientKey) async {
    await _outbox.retry(clientKey);
  }

  @override
  Future<void> syncPending() => _outbox.syncAll();

  Future<void> _send(OutboxEntry entry) async {
    final familyId = entry.args['familyId'] as String;
    final conversationId = entry.args['conversationId'] as String;
    final message = await _remote.send(
      familyId,
      conversationId,
      entry.id,
      entry.args['body'] as String,
    );
    if (message == null || familyId != _attachedScope) {
      return;
    }
    _put(conversationId, [
      message.copyWith(
        conversationId: message.conversationId.isEmpty
            ? conversationId
            : message.conversationId,
        clientKey: message.clientKey ?? entry.id,
        isMine: true,
      ),
    ]);
    _touchConversation(conversationId);
  }

  @override
  void typing(String conversationId) {
    final scope = _attachedScope;
    if (scope == null) {
      return;
    }
    final now = _clock.now();
    final last = _typingSent[conversationId];
    if (last != null && now.difference(last) < kValueChatTypingThrottle) {
      return;
    }
    _typingSent[conversationId] = now;
    _realtime.emit('chat.typing', {
      'familyId': scope,
      'conversationId': conversationId,
    });
  }

  @override
  void markRead(String conversationId) {
    _readTimers[conversationId]?.cancel();
    _readTimers[conversationId] = Timer(kValueChatReadDebounce, () {
      _readTimers.remove(conversationId);
      unawaited(_quietly(() => _markRead(conversationId), 'đã đọc'));
    });
  }

  Future<void> _markRead(String conversationId) async {
    final scope = _attachedScope;
    final seq = _maxSeq(conversationId);
    final current = _conversations[conversationId];
    if (scope == null ||
        seq == 0 ||
        (current != null &&
            current.readSeq >= seq &&
            current.unreadCount == 0)) {
      return;
    }
    final readSeq = await _remote.markRead(scope, conversationId, seq) ?? seq;
    final item = _conversations[conversationId];
    if (_attachedScope != scope || item == null) {
      return;
    }
    final read = math.max(item.readSeq, readSeq);
    final me = _myUserId;
    _conversations[conversationId] = item.copyWith(
      readSeq: read,
      unreadCount: math.max(0, item.lastSeq - read),
      members: [
        for (final member in item.members)
          member.userId == me && member.lastReadSeq < read
              ? member.copyWith(lastReadSeq: read)
              : member,
      ],
    );
    _tables.schedule();
    _changed(conversationId);
    _changed('');
  }

  void _onEvent(RealtimeEvent event) {
    final scope = _attachedScope;
    final familyId = event.text('familyId');
    if (scope == null || (familyId != null && familyId != scope)) {
      return;
    }
    final conversationId = event.text('conversationId');
    switch (event.name) {
      case 'ready':
        _myUserId = event.text('userId') ?? _myUserId;
        unawaited(_resync());
      case 'chat.message' when conversationId != null:
        final sender = event.text('senderUserId');
        if (sender != null) {
          _typing[conversationId]?.remove(sender);
        }
        final seq = event.number('seq') ?? 0;
        if (_openCount.containsKey(conversationId) ||
            _messages.containsKey(conversationId)) {
          if (seq == 0 || seq > _maxSeq(conversationId)) {
            unawaited(_quietly(() => refresh(conversationId), 'tin nhắn'));
          }
        }
        _refreshListSoon();
      case 'chat.read' when conversationId != null:
        _applyRead(
          conversationId,
          event.text('userId'),
          event.number('seq') ?? 0,
        );
      case 'chat.typing' when conversationId != null:
        final userId = event.text('userId');
        if (userId == null || userId == _myUserId) {
          return;
        }
        (_typing[conversationId] ??= {})[userId] = _clock.now().add(
          kValueChatTypingVisible,
        );
        _typingTimers[conversationId]?.cancel();
        _typingTimers[conversationId] = Timer(kValueChatTypingVisible, () {
          _typingTimers.remove(conversationId);
          _changed(conversationId);
        });
        _changed(conversationId);
    }
  }

  void _applyRead(String conversationId, String? userId, int seq) {
    final item = _conversations[conversationId];
    if (item == null || userId == null || seq <= 0) {
      return;
    }
    final mine = userId == _myUserId;
    _conversations[conversationId] = item.copyWith(
      readSeq: mine ? math.max(item.readSeq, seq) : item.readSeq,
      unreadCount: mine
          ? math.max(0, item.lastSeq - math.max(item.readSeq, seq))
          : item.unreadCount,
      members: [
        for (final member in item.members)
          member.userId == userId && member.lastReadSeq < seq
              ? member.copyWith(lastReadSeq: seq)
              : member,
      ],
    );
    _tables.schedule();
    _changed(conversationId);
    if (mine) {
      _changed('');
    }
  }

  /// Gộp các tín hiệu tin mới rồi đọc lại danh sách (số chưa đọc).
  void _refreshListSoon() {
    _listTimer?.cancel();
    _listTimer = Timer(kValueChatListRefreshDebounce, () {
      _listTimer = null;
      unawaited(_quietly(refreshConversations, 'danh sách trò chuyện'));
    });
  }

  void _put(String conversationId, Iterable<ChatMessage> items) {
    final bucket = _messages[conversationId] ??= {};
    for (final item in items) {
      bucket[item.id] = item.copyWith(
        conversationId: item.conversationId.isEmpty
            ? conversationId
            : item.conversationId,
        localState: null,
      );
    }
    _rememberMe(items);
    _tables.schedule();
  }

  void _rememberMe(Iterable<ChatMessage> items) {
    if (_myUserId != null) {
      return;
    }
    for (final item in items) {
      if (item.isMine && item.senderUserId.isNotEmpty) {
        _myUserId = item.senderUserId;
        return;
      }
    }
  }

  /// Tin cuối trên máy mới hơn bản danh sách → cập nhật dòng xem trước.
  void _touchConversation(String conversationId) {
    final item = _conversations[conversationId];
    final last = _sorted(
      _messages[conversationId]?.values ?? const [],
    ).lastOrNull;
    if (item == null || last == null || last.seq <= item.lastSeq) {
      return;
    }
    _conversations[conversationId] = item.copyWith(
      lastSeq: last.seq,
      lastMessage: last,
      lastMessageAt: last.createdAt ?? item.lastMessageAt,
      // Ước lượng tới lần đọc lại danh sách (server đếm chính xác).
      unreadCount: last.isMine
          ? item.unreadCount
          : math.max(item.unreadCount, last.seq - item.readSeq),
    );
    _tables.schedule();
    _changed('');
  }

  int _maxSeq(String conversationId) =>
      (_messages[conversationId]?.values ?? const <ChatMessage>[]).fold(
        0,
        (value, item) => math.max(value, item.seq),
      );

  int _minSeq(String conversationId) {
    final items = _messages[conversationId]?.values;
    if (items == null || items.isEmpty) {
      return 0;
    }
    return items.map((item) => item.seq).reduce(math.min);
  }

  static List<ChatMessage> _sorted(Iterable<ChatMessage> items) =>
      items.toList()..sort((a, b) => a.seq.compareTo(b.seq));

  static Iterable<ChatMessage> _latest(Iterable<ChatMessage> items) {
    final sorted = _sorted(items);
    return sorted.length <= kValueChatLocalMessageLimit
        ? sorted
        : sorted.sublist(sorted.length - kValueChatLocalMessageLimit);
  }

  static String? _conversationOf(OutboxEntry entry) =>
      entry.args['conversationId'] as String?;

  ChatMessage _pendingMessage(OutboxEntry entry) => ChatMessage(
    id: entry.id,
    conversationId: _conversationOf(entry) ?? '',
    senderUserId: _myUserId ?? '',
    body: entry.args['body'] as String? ?? '',
    isMine: true,
    clientKey: entry.id,
    createdAt: entry.createdAt,
    localState: entry.failed
        ? 'FAILED'
        : (_outbox.active == entry.id || entry.attempts == 0)
        ? 'SENDING'
        : 'WAITING',
  );

  void _changed(String? conversationId) {
    if (conversationId != null && !_changes.isClosed) {
      _changes.add(conversationId);
    }
  }

  /// Việc chạy nền: mất mạng / lỗi chỉ ghi log, giữ bản trên máy.
  Future<void> _quietly(Future<Object?> Function() call, String what) async {
    try {
      await call();
    } on Object catch (error) {
      Logger().w('Nhắn tin: chưa đồng bộ được $what: $error');
    }
  }
}
