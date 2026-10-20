import 'package:freezed_annotation/freezed_annotation.dart';

part 'reauth_token_record.freezed.dart';
part 'reauth_token_record.g.dart';

/// `POST /auth/reauth/verify` → mã xác thực lại ngắn hạn (≤ 5 phút) cho thao
/// tác nhạy cảm như xoá tài khoản (mục 7.25). Chỉ giữ trong bộ nhớ.
@Freezed(when: FreezedWhenOptions.none)
abstract class ReauthTokenRecord with _$ReauthTokenRecord {
  @JsonSerializable(explicitToJson: true)
  const factory ReauthTokenRecord({
    @JsonKey(name: 'reauthToken') String? reauthToken,
    @JsonKey(name: 'expiresAt') DateTime? expiresAt,
  }) = _ReauthTokenRecord;

  factory ReauthTokenRecord.fromJson(Map<String, dynamic> json) =>
      _$ReauthTokenRecordFromJson(json);
}
