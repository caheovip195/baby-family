import 'package:baby_family/data/model/chat/chat_message.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'chat_message_page.freezed.dart';
part 'chat_message_page.g.dart';

/// Một trang tin nhắn theo `seq` (`beforeSeq` / `afterSeq`), [items] tăng dần.
@Freezed(when: FreezedWhenOptions.none)
abstract class ChatMessagePage with _$ChatMessagePage {
  @JsonSerializable(explicitToJson: true)
  const factory ChatMessagePage({
    @JsonKey(name: 'items', fromJson: chatMessageList)
    @Default(<ChatMessage>[])
    List<ChatMessage> items,
    @JsonKey(name: 'hasMore') @Default(false) bool hasMore,
  }) = _ChatMessagePage;

  factory ChatMessagePage.fromJson(Map<String, dynamic> json) =>
      _$ChatMessagePageFromJson(json);
}
