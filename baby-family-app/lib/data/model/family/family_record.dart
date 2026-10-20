import 'package:freezed_annotation/freezed_annotation.dart';

part 'family_record.freezed.dart';
part 'family_record.g.dart';

/// `GET /v1/families/{familyId}` (FAM-07): tên, ngôn ngữ nội dung, ảnh bìa.
@Freezed(when: FreezedWhenOptions.none)
abstract class FamilyRecord with _$FamilyRecord {
  @JsonSerializable(explicitToJson: true)
  const factory FamilyRecord({
    @JsonKey(name: 'id') String? id,
    @JsonKey(name: 'name') String? name,
    @JsonKey(name: 'timezone') String? timezone,
    @JsonKey(name: 'contentLocale') String? contentLocale,
    @JsonKey(name: 'coverUrl') String? coverUrl,
  }) = _FamilyRecord;

  factory FamilyRecord.fromJson(Map<String, dynamic> json) =>
      _$FamilyRecordFromJson(json);
}
