import 'package:baby_family/utils/constants/enum.dart';
import 'package:baby_family/utils/helper/lenient_json.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'chat_message.freezed.dart';
part 'chat_message.g.dart';

/// Tin nhắn trong cuộc trò chuyện gia đình (CHAT-02, BF-20261101-001).
/// [seq] tăng dần theo cuộc trò chuyện (0 = chưa lên server); [clientKey] là
/// Idempotency-Key người gửi tạo (chỉ có ở tin của tôi) để khớp bản trên máy
/// với bản server. [localState] chỉ dùng trên máy: `SENDING` | `WAITING` |
/// `FAILED` (null = server đã nhận).
@Freezed(when: FreezedWhenOptions.none)
abstract class ChatMessage with _$ChatMessage {
  @JsonSerializable(explicitToJson: true)
  const factory ChatMessage({
    @JsonKey(name: 'id') required String id,
    @JsonKey(name: 'conversationId') @Default('') String conversationId,
    @JsonKey(name: 'seq') @Default(0) int seq,
    @JsonKey(name: 'senderUserId') @Default('') String senderUserId,
    @JsonKey(name: 'body') @Default('') String body,
    @JsonKey(name: 'isMine') @Default(false) bool isMine,
    @JsonKey(name: 'clientKey') String? clientKey,
    @JsonKey(name: 'createdAt') DateTime? createdAt,
    @JsonKey(name: 'localState') String? localState,
  }) = _ChatMessage;

  factory ChatMessage.fromJson(Map<String, dynamic> json) =>
      _$ChatMessageFromJson(json);

  const ChatMessage._();

  ChatSendState get sendState => switch (localState) {
    'SENDING' => ChatSendState.sending,
    'WAITING' => ChatSendState.waiting,
    'FAILED' => ChatSendState.failed,
    _ => ChatSendState.sent,
  };

  bool get isPending => sendState != ChatSendState.sent;
}

/// Danh sách tin từ server / máy: dòng không đọc được bị bỏ qua.
List<ChatMessage> chatMessageList(Object? json) =>
    lenientList(json, ChatMessage.fromJson, label: 'tin nhắn');
