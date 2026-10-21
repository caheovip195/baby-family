import 'package:freezed_annotation/freezed_annotation.dart';

part 'sign_in_method_record.freezed.dart';
part 'sign_in_method_record.g.dart';

/// `GET /v1/me/sign-in-methods`: phương thức đã liên kết (APPLE | GOOGLE |
/// PHONE), gợi ý đã che (không có subject/email thô).
@Freezed(when: FreezedWhenOptions.none)
abstract class SignInMethodRecord with _$SignInMethodRecord {
  @JsonSerializable(explicitToJson: true)
  const factory SignInMethodRecord({
    @JsonKey(name: 'provider') String? provider,
    @JsonKey(name: 'linkedAt') DateTime? linkedAt,
    @JsonKey(name: 'maskedHint') String? maskedHint,
  }) = _SignInMethodRecord;

  factory SignInMethodRecord.fromJson(Map<String, dynamic> json) =>
      _$SignInMethodRecordFromJson(json);
}
