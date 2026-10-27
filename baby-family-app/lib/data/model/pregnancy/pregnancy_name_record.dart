import 'package:baby_family/utils/helper/lenient_json.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'pregnancy_name_record.freezed.dart';
part 'pregnancy_name_record.g.dart';

/// PREG-07: một tên dự định trên server (`/pregnancies/{id}/names`);
/// `likedBy*` tính theo người đang xem.
@Freezed(when: FreezedWhenOptions.none)
abstract class PregnancyNameRecord with _$PregnancyNameRecord {
  @JsonSerializable(explicitToJson: true)
  const factory PregnancyNameRecord({
    @JsonKey(name: 'id') String? id,
    @JsonKey(name: 'name') String? name,
    @JsonKey(name: 'meaning') String? meaning,
    @JsonKey(name: 'addedByUserId') String? addedByUserId,
    @JsonKey(name: 'likedByMe') @Default(false) bool likedByMe,
    @JsonKey(name: 'likedByPartner') @Default(false) bool likedByPartner,
    @JsonKey(name: 'chosen') @Default(false) bool chosen,
    @JsonKey(name: 'createdAt') DateTime? createdAt,
  }) = _PregnancyNameRecord;

  factory PregnancyNameRecord.fromJson(Map<String, dynamic> json) =>
      _$PregnancyNameRecordFromJson(json);
}

/// Danh sách tên + số tên được chọn tối đa (bằng số bé dự kiến).
@Freezed(when: FreezedWhenOptions.none)
abstract class PregnancyNameList with _$PregnancyNameList {
  @JsonSerializable(explicitToJson: true)
  const factory PregnancyNameList({
    @JsonKey(name: 'items', fromJson: _nameItems)
    @Default(<PregnancyNameRecord>[])
    List<PregnancyNameRecord> items,
    @JsonKey(name: 'chosenLimit') @Default(1) int chosenLimit,
  }) = _PregnancyNameList;

  factory PregnancyNameList.fromJson(Map<String, dynamic> json) =>
      _$PregnancyNameListFromJson(json);
}

List<PregnancyNameRecord> _nameItems(Object? json) =>
    lenientList(json, PregnancyNameRecord.fromJson, label: 'tên dự định');
