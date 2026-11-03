import 'package:baby_family/utils/helper/lenient_json.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'growth_entry.freezed.dart';
part 'growth_entry.g.dart';

/// CHD-06 Tăng trưởng (BF-20261028-004): một lần đo trong ngày [measuredOn]
/// (`YYYY-MM-DD`). Cân nặng gram, chiều cao milimét; [pending] = lưu trên máy,
/// chờ gửi lên server.
@Freezed(when: FreezedWhenOptions.none)
abstract class GrowthEntry with _$GrowthEntry {
  @JsonSerializable(explicitToJson: true)
  const factory GrowthEntry({
    @JsonKey(name: 'measuredOn') required String measuredOn,
    @JsonKey(name: 'weightGrams') int? weightGrams,
    @JsonKey(name: 'heightMm') int? heightMm,
    @JsonKey(name: 'note') String? note,
    @JsonKey(name: 'pending') @Default(false) bool pending,
  }) = _GrowthEntry;

  factory GrowthEntry.fromJson(Map<String, dynamic> json) =>
      _$GrowthEntryFromJson(json);

  const GrowthEntry._();

  DateTime get date => DateTime.parse(measuredOn);
}

/// `GET /children/{id}/growth`: ngày sinh + các lần đo cũ → mới.
@Freezed(when: FreezedWhenOptions.none)
abstract class GrowthListRecord with _$GrowthListRecord {
  @JsonSerializable(explicitToJson: true)
  const factory GrowthListRecord({
    @JsonKey(name: 'childId') String? childId,
    @JsonKey(name: 'birthDate') String? birthDate,
    @JsonKey(name: 'items', fromJson: _growthItems)
    @Default(<GrowthEntry>[])
    List<GrowthEntry> items,
  }) = _GrowthListRecord;

  factory GrowthListRecord.fromJson(Map<String, dynamic> json) =>
      _$GrowthListRecordFromJson(json);
}

List<GrowthEntry> _growthItems(Object? json) =>
    lenientList(json, GrowthEntry.fromJson, label: 'lần đo');
