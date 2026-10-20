import 'package:baby_family/data/model/circle/circle_grant_record.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'circle_member_record.freezed.dart';
part 'circle_member_record.g.dart';

/// Một người thân trong gia đình (`GET /families/:fid/circle`).
@Freezed(when: FreezedWhenOptions.none)
abstract class CircleMemberRecord with _$CircleMemberRecord {
  @JsonSerializable(explicitToJson: true)
  const factory CircleMemberRecord({
    @JsonKey(name: 'id') String? id,
    @JsonKey(name: 'userId') String? userId,
    @JsonKey(name: 'displayName') String? displayName,
    @JsonKey(name: 'relation') String? relation,
    @JsonKey(name: 'status') String? status,
    @JsonKey(name: 'allowDownload') @Default(false) bool allowDownload,
    @JsonKey(name: 'grants')
    @Default(<CircleGrantRecord>[])
    List<CircleGrantRecord> grants,
    @JsonKey(name: 'joinedAt') DateTime? joinedAt,
  }) = _CircleMemberRecord;

  factory CircleMemberRecord.fromJson(Map<String, dynamic> json) =>
      _$CircleMemberRecordFromJson(json);
}
