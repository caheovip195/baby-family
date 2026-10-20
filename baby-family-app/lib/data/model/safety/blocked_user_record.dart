import 'package:freezed_annotation/freezed_annotation.dart';

part 'blocked_user_record.freezed.dart';
part 'blocked_user_record.g.dart';

/// Một người tôi đã chặn trong gia đình (`GET /v1/me/blocks`).
@Freezed(when: FreezedWhenOptions.none)
abstract class BlockedUserRecord with _$BlockedUserRecord {
  @JsonSerializable(explicitToJson: true)
  const factory BlockedUserRecord({
    @JsonKey(name: 'userId') String? userId,
    @JsonKey(name: 'displayName') String? displayName,
    @JsonKey(name: 'blockedAt') DateTime? blockedAt,
  }) = _BlockedUserRecord;

  factory BlockedUserRecord.fromJson(Map<String, dynamic> json) =>
      _$BlockedUserRecordFromJson(json);
}
