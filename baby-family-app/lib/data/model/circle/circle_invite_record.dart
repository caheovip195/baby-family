import 'package:baby_family/data/model/circle/circle_grant_record.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'circle_invite_record.freezed.dart';
part 'circle_invite_record.g.dart';

/// Lời mời người thân (FAM-05).
@Freezed(when: FreezedWhenOptions.none)
abstract class CircleInviteRecord with _$CircleInviteRecord {
  @JsonSerializable(explicitToJson: true)
  const factory CircleInviteRecord({
    @JsonKey(name: 'inviteId') String? inviteId,
    @JsonKey(name: 'status') String? status,
    @JsonKey(name: 'relation') String? relation,
    @JsonKey(name: 'displayName') String? displayName,
    @JsonKey(name: 'grants')
    @Default(<CircleGrantRecord>[])
    List<CircleGrantRecord> grants,
    @JsonKey(name: 'createdAt') DateTime? createdAt,
    @JsonKey(name: 'expiresAt') DateTime? expiresAt,
  }) = _CircleInviteRecord;

  factory CircleInviteRecord.fromJson(Map<String, dynamic> json) =>
      _$CircleInviteRecordFromJson(json);
}
