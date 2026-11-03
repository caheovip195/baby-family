import 'package:baby_family/data/model/chat/chat_conversation.dart';
import 'package:baby_family/data/provider/mock_store.dart';
import 'package:baby_family/data/provider/session.dart';
import 'package:baby_family/data/repository/chat_remote.dart';
import 'package:baby_family/data/repository/realtime.dart';
import 'package:baby_family/data/repository_imp/chat_remote.dart';
import 'package:baby_family/data/repository_imp/local_db.dart';
import 'package:baby_family/data/repository_imp/outbox.dart';
import 'package:baby_family/data/repository_imp/realtime.dart';
import 'package:baby_family/data/service/chat.dart';
import 'package:baby_family/data/service_imp/chat.dart';
import 'package:baby_family/utils/constants/enum.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final chatRemoteRepositoryProvider = Provider<IChatRemoteRepository>(
  (ref) => ChatRemoteRepositoryImp(),
);

/// Kênh Socket.IO dùng chung của app (một kết nối mỗi phiên).
final realtimeRepositoryProvider = Provider<IRealtimeRepository>((ref) {
  final repository = RealtimeRepositoryImp();
  ref.onDispose(repository.disconnect);
  return repository;
});

/// Nhắn tin gia đình (CHAT-01…04, BF-20261101-001): chỉ có khi chạy với
/// server (`BABY_FAMILY_API_URL`) và đã có gia đình server — bản mock thì
/// [IChatService.available] = false, lối vào bị ẩn.
final chatServiceProvider = Provider<IChatService>(
  (ref) =>
      ChatServiceImp(
          ref.watch(sessionRepositoryProvider),
          ref.watch(appClockProvider),
          ref.watch(chatRemoteRepositoryProvider),
          ref.watch(realtimeRepositoryProvider),
        )
        ..outbox = OutboxRepositoryImp('chat')
        ..localDb = LocalDbImp(),
);

/// Danh sách cuộc trò chuyện trên máy, phát lại mỗi khi đổi (số chưa đọc ở
/// lối vào CHAT-04/04b).
final chatConversationsProvider = StreamProvider<List<ChatConversation>>((
  ref,
) async* {
  final service = ref.watch(chatServiceProvider);
  yield service.conversations;
  await for (final id in service.changes) {
    if (id.isEmpty) {
      yield service.conversations;
    }
  }
});

/// Trạng thái realtime (băng “Đang kết nối lại…” CHAT-03b).
final realtimeStatusProvider = StreamProvider<RealtimeStatus>((ref) async* {
  final service = ref.watch(chatServiceProvider);
  yield service.status;
  yield* service.statusChanges;
});
