import 'package:baby_family/data/model/chat/chat_conversation.dart';
import 'package:baby_family/data/model/chat/chat_message.dart';
import 'package:baby_family/data/model/chat/chat_message_page.dart';
import 'package:baby_family/data/repository/base.dart';

/// Nhắn tin gia đình qua REST (`/v1/families/{fid}/chats`, BF-20261101-001).
/// [familyId] là id gia đình server.
abstract class IChatRemoteRepository extends IBaseRepository {
  Future<List<ChatConversation>> conversations(String familyId);

  /// [afterSeq] = tin mới hơn, [beforeSeq] = tin cũ hơn; tăng dần theo seq.
  Future<ChatMessagePage> messages(
    String familyId,
    String conversationId, {
    int? beforeSeq,
    int? afterSeq,
    int? limit,
  });

  /// [idempotencyKey] = `clientKey` của tin (giữ nguyên khi gửi lại).
  Future<ChatMessage?> send(
    String familyId,
    String conversationId,
    String idempotencyKey,
    String body,
  );

  /// Trả `readSeq` server ghi nhận.
  Future<int?> markRead(String familyId, String conversationId, int seq);
}
