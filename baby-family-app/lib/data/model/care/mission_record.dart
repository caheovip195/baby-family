import 'package:freezed_annotation/freezed_annotation.dart';

part 'mission_record.freezed.dart';
part 'mission_record.g.dart';

/// Nhiệm vụ do server trả (CARE-01/02 — tài liệu kỹ thuật 11.6). Nhiệm vụ của bạn đời chỉ có trường rút gọn, không có Hearts (BR-018).
@Freezed(when: FreezedWhenOptions.none)
abstract class MissionRecord with _$MissionRecord {
  @JsonSerializable(explicitToJson: true)
  const factory MissionRecord({
    @JsonKey(name: 'id') String? id,
    @JsonKey(name: 'boardDate') String? boardDate,
    @JsonKey(name: 'ownerKind') String? ownerKind,
    @JsonKey(name: 'mine') bool? mine,
    @JsonKey(name: 'source') String? source,
    @JsonKey(name: 'templateId') String? templateId,
    @JsonKey(name: 'title') String? title,
    @JsonKey(name: 'note') String? note,
    @JsonKey(name: 'category') String? category,
    @JsonKey(name: 'childIds') @Default(<String>[]) List<String> childIds,
    @JsonKey(name: 'hearts') int? hearts,
    @JsonKey(name: 'status') String? status,
    @JsonKey(name: 'scheduledTime') String? scheduledTime,
    @JsonKey(name: 'completedAt') DateTime? completedAt,
    @JsonKey(name: 'late') @Default(false) bool late,
    @JsonKey(name: 'thanked') @Default(false) bool thanked,
    @JsonKey(name: 'canSwap') @Default(false) bool canSwap,
    @JsonKey(name: 'version') int? version,
  }) = _MissionRecord;

  factory MissionRecord.fromJson(Map<String, dynamic> json) =>
      _$MissionRecordFromJson(json);
}
