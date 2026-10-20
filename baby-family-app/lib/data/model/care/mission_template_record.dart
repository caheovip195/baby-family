import 'package:freezed_annotation/freezed_annotation.dart';

part 'mission_template_record.freezed.dart';
part 'mission_template_record.g.dart';

/// Mẫu nhiệm vụ của thư viện server (CARE-04, đổi nhiệm vụ CARE-05).
@Freezed(when: FreezedWhenOptions.none)
abstract class MissionTemplateRecord with _$MissionTemplateRecord {
  @JsonSerializable(explicitToJson: true)
  const factory MissionTemplateRecord({
    @JsonKey(name: 'id') String? id,
    @JsonKey(name: 'title') String? title,
    @JsonKey(name: 'category') String? category,
    @JsonKey(name: 'hearts') @Default(0) int hearts,
    @JsonKey(name: 'durationMin') int? durationMin,
    @JsonKey(name: 'multiChildOk') @Default(true) bool multiChildOk,
  }) = _MissionTemplateRecord;

  factory MissionTemplateRecord.fromJson(Map<String, dynamic> json) =>
      _$MissionTemplateRecordFromJson(json);
}
