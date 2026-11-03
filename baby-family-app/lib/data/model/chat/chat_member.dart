import 'package:freezed_annotation/freezed_annotation.dart';

part 'chat_member.freezed.dart';
part 'chat_member.g.dart';

/// Thành viên có quyền với cuộc trò chuyện (BF-20261101-001). [role]
/// `PARENT` | `CIRCLE` (giữ `String` để server mở rộng không làm hỏng app);
/// [lastReadSeq] dùng cho “Đã xem”.
@Freezed(when: FreezedWhenOptions.none)
abstract class ChatMember with _$ChatMember {
  @JsonSerializable(explicitToJson: true)
  const factory ChatMember({
    @JsonKey(name: 'userId') required String userId,
    @JsonKey(name: 'displayName') @Default('') String displayName,
    @JsonKey(name: 'role') @Default('CIRCLE') String role,
    @JsonKey(name: 'lastReadSeq') @Default(0) int lastReadSeq,
  }) = _ChatMember;

  factory ChatMember.fromJson(Map<String, dynamic> json) =>
      _$ChatMemberFromJson(json);

  const ChatMember._();

  bool get isParent => role == 'PARENT';
}
