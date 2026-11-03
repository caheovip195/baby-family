import 'package:baby_family/data/model/chat/chat_member.dart';
import 'package:baby_family/data/model/chat/chat_message.dart';
import 'package:baby_family/utils/helper/lenient_json.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'chat_conversation.freezed.dart';
part 'chat_conversation.g.dart';

/// Cuộc trò chuyện của gia đình (CHAT-01, BF-20261101-001). [kind] `FAMILY`
/// (Bố Mẹ + người thân) | `COUPLE` (chỉ Papa & Mama); giữ `String` — loại lạ
/// bị bỏ qua khi hiển thị. [readSeq] là vị trí tôi đã đọc.
@Freezed(when: FreezedWhenOptions.none)
abstract class ChatConversation with _$ChatConversation {
  @JsonSerializable(explicitToJson: true)
  const factory ChatConversation({
    @JsonKey(name: 'id') required String id,
    @JsonKey(name: 'familyId') @Default('') String familyId,
    @JsonKey(name: 'kind') @Default('') String kind,
    @JsonKey(name: 'lastSeq') @Default(0) int lastSeq,
    @JsonKey(name: 'readSeq') @Default(0) int readSeq,
    @JsonKey(name: 'unreadCount') @Default(0) int unreadCount,
    @JsonKey(name: 'lastMessageAt') DateTime? lastMessageAt,
    @JsonKey(name: 'lastMessage', fromJson: _chatLastMessage)
    ChatMessage? lastMessage,
    @JsonKey(name: 'members', fromJson: _chatMembers)
    @Default(<ChatMember>[])
    List<ChatMember> members,
  }) = _ChatConversation;

  factory ChatConversation.fromJson(Map<String, dynamic> json) =>
      _$ChatConversationFromJson(json);

  const ChatConversation._();

  bool get isFamily => kind == 'FAMILY';

  bool get isCouple => kind == 'COUPLE';

  /// Loại app hiện tại biết hiển thị.
  bool get isKnown => isFamily || isCouple;

  ChatMember? member(String userId) =>
      members.where((member) => member.userId == userId).firstOrNull;
}

/// Tin cuối hỏng không làm hỏng cả cuộc trò chuyện.
ChatMessage? _chatLastMessage(Object? json) =>
    json is Map ? chatMessageList([json]).firstOrNull : null;

List<ChatMember> _chatMembers(Object? json) =>
    lenientList(json, ChatMember.fromJson, label: 'thành viên trò chuyện');

/// Danh sách cuộc trò chuyện: dòng không đọc được bị bỏ qua.
List<ChatConversation> chatConversationList(Object? json) =>
    lenientList(json, ChatConversation.fromJson, label: 'cuộc trò chuyện');
