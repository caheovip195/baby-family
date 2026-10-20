import 'package:freezed_annotation/freezed_annotation.dart';

part 'circle_grant_record.freezed.dart';
part 'circle_grant_record.g.dart';

/// Quyền của người thân với một bé / thai kỳ (FAM-04).
@Freezed(when: FreezedWhenOptions.none)
abstract class CircleGrantRecord with _$CircleGrantRecord {
  @JsonSerializable(explicitToJson: true)
  const factory CircleGrantRecord({
    @JsonKey(name: 'childId') String? childId,
    @JsonKey(name: 'pregnancyId') String? pregnancyId,
    @JsonKey(name: 'allowDownload') @Default(false) bool allowDownload,
    @JsonKey(name: 'permission') String? permission,
  }) = _CircleGrantRecord;

  factory CircleGrantRecord.fromJson(Map<String, dynamic> json) =>
      _$CircleGrantRecordFromJson(json);
}
