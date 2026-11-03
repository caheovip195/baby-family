import 'package:freezed_annotation/freezed_annotation.dart';

part 'chat_read_result.freezed.dart';
part 'chat_read_result.g.dart';

/// Kết quả đánh dấu đã đọc (`POST .../read`).
@Freezed(when: FreezedWhenOptions.none)
abstract class ChatReadResult with _$ChatReadResult {
  @JsonSerializable(explicitToJson: true)
  const factory ChatReadResult({
    @JsonKey(name: 'conversationId') @Default('') String conversationId,
    @JsonKey(name: 'readSeq') @Default(0) int readSeq,
  }) = _ChatReadResult;

  factory ChatReadResult.fromJson(Map<String, dynamic> json) =>
      _$ChatReadResultFromJson(json);
}
