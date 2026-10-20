import 'package:freezed_annotation/freezed_annotation.dart';

part 'prep_item_record.freezed.dart';
part 'prep_item_record.g.dart';

/// Một mục chuẩn bị đón bé trên server (PREG-04).
@Freezed(when: FreezedWhenOptions.none)
abstract class PrepItemRecord with _$PrepItemRecord {
  @JsonSerializable(explicitToJson: true)
  const factory PrepItemRecord({
    @JsonKey(name: 'id') String? id,
    @JsonKey(name: 'pregnancyId') String? pregnancyId,
    @JsonKey(name: 'groupCode') String? groupCode,
    @JsonKey(name: 'title') String? title,
    @JsonKey(name: 'sortOrder') @Default(0) int sortOrder,
    @JsonKey(name: 'done') @Default(false) bool done,
  }) = _PrepItemRecord;

  factory PrepItemRecord.fromJson(Map<String, dynamic> json) =>
      _$PrepItemRecordFromJson(json);
}
