import 'package:baby_family/data/model/chat/chat_conversation.dart';
import 'package:baby_family/data/model/chat/chat_message.dart';
import 'package:baby_family/data/model/chat/chat_message_page.dart';
import 'package:baby_family/data/repository/chat_remote.dart';
import 'package:baby_family/data/repository_imp/base.dart';

class ChatRemoteRepositoryImp extends BaseRepositoryImp
    implements IChatRemoteRepository {
  @override
  Future<List<ChatConversation>> conversations(String familyId) async =>
      (await client!.getChats(familyId)).conversations;

  @override
  Future<ChatMessagePage> messages(
    String familyId,
    String conversationId, {
    int? beforeSeq,
    int? afterSeq,
    int? limit,
  }) async =>
      (await client!.getChatMessages(
        familyId,
        conversationId,
        beforeSeq: beforeSeq,
        afterSeq: afterSeq,
        limit: limit,
      )).page ??
      const ChatMessagePage();

  @override
  Future<ChatMessage?> send(
    String familyId,
    String conversationId,
    String idempotencyKey,
    String body,
  ) async => (await client!.sendChatMessage(
    familyId,
    conversationId,
    idempotencyKey,
    {'body': body},
  )).message;

  @override
  Future<int?> markRead(
    String familyId,
    String conversationId,
    int seq,
  ) async => (await client!.markChatRead(familyId, conversationId, {
    'seq': seq,
  })).result?.readSeq;
}
