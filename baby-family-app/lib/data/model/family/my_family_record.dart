import 'package:freezed_annotation/freezed_annotation.dart';

part 'my_family_record.freezed.dart';
part 'my_family_record.g.dart';

/// `GET /v1/me/families`: một gia đình của tôi (FAM-08). [role] PARENT |
/// CIRCLE; [familyStatus]/[membershipStatus] lấy từ `status`.
@Freezed(when: FreezedWhenOptions.none)
abstract class MyFamilyRecord with _$MyFamilyRecord {
  @JsonSerializable(explicitToJson: true)
  const factory MyFamilyRecord({
    @JsonKey(name: 'familyId') String? familyId,
    @JsonKey(name: 'name') String? name,
    @JsonKey(name: 'role') String? role,
    @JsonKey(name: 'status') MyFamilyStatusRecord? status,
    @JsonKey(name: 'coverUrl') String? coverUrl,
    @JsonKey(name: 'isDefault') @Default(false) bool isDefault,
  }) = _MyFamilyRecord;

  factory MyFamilyRecord.fromJson(Map<String, dynamic> json) =>
      _$MyFamilyRecordFromJson(json);
}

@Freezed(when: FreezedWhenOptions.none)
abstract class MyFamilyStatusRecord with _$MyFamilyStatusRecord {
  @JsonSerializable(explicitToJson: true)
  const factory MyFamilyStatusRecord({
    @JsonKey(name: 'family') String? family,
    @JsonKey(name: 'membership') String? membership,
  }) = _MyFamilyStatusRecord;

  factory MyFamilyStatusRecord.fromJson(Map<String, dynamic> json) =>
      _$MyFamilyStatusRecordFromJson(json);
}

/// `{items: [...]}` của `GET /v1/me/families`.
@Freezed(when: FreezedWhenOptions.none)
abstract class MyFamilyList with _$MyFamilyList {
  @JsonSerializable(explicitToJson: true)
  const factory MyFamilyList({
    @JsonKey(name: 'items')
    @Default(<MyFamilyRecord>[])
    List<MyFamilyRecord> items,
  }) = _MyFamilyList;

  factory MyFamilyList.fromJson(Map<String, dynamic> json) =>
      _$MyFamilyListFromJson(json);
}
