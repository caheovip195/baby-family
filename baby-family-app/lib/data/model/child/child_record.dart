import 'package:freezed_annotation/freezed_annotation.dart';

part 'child_record.freezed.dart';
part 'child_record.g.dart';

/// Hồ sơ bé do server trả (`POST/PATCH /v1/families/{fid}/children`).
@Freezed(when: FreezedWhenOptions.none)
abstract class ChildRecord with _$ChildRecord {
  @JsonSerializable(explicitToJson: true)
  const factory ChildRecord({
    @JsonKey(name: 'id') String? id,
    @JsonKey(name: 'familyId') String? familyId,
    @JsonKey(name: 'name') String? name,
    @JsonKey(name: 'nickname') String? nickname,
    @JsonKey(name: 'birthDate') DateTime? birthDate,
    @JsonKey(name: 'birthTime') String? birthTime,
    @JsonKey(name: 'gender') String? gender,
    @JsonKey(name: 'colorIndex') int? colorIndex,
    @JsonKey(name: 'status') String? status,
  }) = _ChildRecord;

  factory ChildRecord.fromJson(Map<String, dynamic> json) =>
      _$ChildRecordFromJson(json);
}
