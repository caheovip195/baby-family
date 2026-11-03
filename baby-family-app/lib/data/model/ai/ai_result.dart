import 'package:baby_family/utils/helper/lenient_json.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'ai_result.freezed.dart';
part 'ai_result.g.dart';

/// AI 1.2 (`/families/{id}/ai/*`, BF-20261028-010): trạng thái + hạn mức.
@Freezed(when: FreezedWhenOptions.none)
abstract class AiStatusRecord with _$AiStatusRecord {
  @JsonSerializable(explicitToJson: true)
  const factory AiStatusRecord({
    @JsonKey(name: 'available') @Default(false) bool available,
    @JsonKey(name: 'used') @Default(0) int used,
    @JsonKey(name: 'total') @Default(0) int total,
    @JsonKey(name: 'consented') @Default(<String>[]) List<String> consented,
  }) = _AiStatusRecord;

  factory AiStatusRecord.fromJson(Map<String, dynamic> json) =>
      _$AiStatusRecordFromJson(json);
}

/// Bản nháp AI: gợi ý chú thích / câu chuyện / tóm tắt / ba phiên bản viết
/// lại. [safety] = câu có dấu hiệu không an toàn, không gửi cho AI.
@Freezed(when: FreezedWhenOptions.none)
abstract class AiDraftRecord with _$AiDraftRecord {
  @JsonSerializable(explicitToJson: true)
  const factory AiDraftRecord({
    /// Lượt gọi trên server — dùng khi báo cáo nội dung AI.
    @JsonKey(name: 'invocationId') String? invocationId,
    @JsonKey(name: 'suggestions') @Default(<String>[]) List<String> suggestions,
    @JsonKey(name: 'story') String? story,
    @JsonKey(name: 'summary') String? summary,
    @JsonKey(name: 'safety') @Default(false) bool safety,
    @JsonKey(name: 'neutral') String? neutral,
    @JsonKey(name: 'warm') String? warm,
    @JsonKey(name: 'short') String? short,
    @JsonKey(name: 'missions', fromJson: _missionPicks)
    @Default(<AiMissionPick>[])
    List<AiMissionPick> missions,
  }) = _AiDraftRecord;

  factory AiDraftRecord.fromJson(Map<String, dynamic> json) =>
      _$AiDraftRecordFromJson(json);
}

/// Gợi ý nhiệm vụ AI: luôn là một mẫu có thật trong catalog + lý do ngắn.
@Freezed(when: FreezedWhenOptions.none)
abstract class AiMissionPick with _$AiMissionPick {
  @JsonSerializable(explicitToJson: true)
  const factory AiMissionPick({
    @JsonKey(name: 'templateId') required String templateId,
    @JsonKey(name: 'title') @Default('') String title,
    @JsonKey(name: 'category') String? category,
    @JsonKey(name: 'hearts') @Default(0) int hearts,
    @JsonKey(name: 'durationMin') int? durationMin,
    @JsonKey(name: 'reason') @Default('') String reason,
  }) = _AiMissionPick;

  factory AiMissionPick.fromJson(Map<String, dynamic> json) =>
      _$AiMissionPickFromJson(json);
}

List<AiMissionPick> _missionPicks(Object? json) =>
    lenientList(json, AiMissionPick.fromJson, label: 'gợi ý nhiệm vụ');
