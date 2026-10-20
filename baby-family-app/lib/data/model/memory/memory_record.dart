import 'package:baby_family/data/model/memory/media_asset_record.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'memory_record.freezed.dart';
part 'memory_record.g.dart';

/// Ký ức do server trả (`POST /v1/memories`, feed — tài liệu kỹ thuật 11.5).
@Freezed(when: FreezedWhenOptions.none)
abstract class MemoryRecord with _$MemoryRecord {
  @JsonSerializable(explicitToJson: true)
  const factory MemoryRecord({
    @JsonKey(name: 'id') String? id,
    @JsonKey(name: 'familyId') String? familyId,
    @JsonKey(name: 'kind') String? kind,
    @JsonKey(name: 'status') String? status,
    @JsonKey(name: 'version') int? version,
    @JsonKey(name: 'authorUserId') String? authorUserId,
    @JsonKey(name: 'title') String? title,
    @JsonKey(name: 'body') String? body,
    @JsonKey(name: 'occurredAt') DateTime? occurredAt,
    @JsonKey(name: 'visibility') String? visibility,
    @JsonKey(name: 'familyMoment') @Default(false) bool familyMoment,
    @JsonKey(name: 'childIds') @Default(<String>[]) List<String> childIds,
    @JsonKey(name: 'pregnancyId') String? pregnancyId,
    @JsonKey(name: 'pregnancyWeek') int? pregnancyWeek,
    @JsonKey(name: 'feeling') String? feeling,
    @JsonKey(name: 'quoteContext') String? quoteContext,
    @JsonKey(name: 'commentCount') @Default(0) int commentCount,
    @JsonKey(name: 'commentsEnabled') @Default(true) bool commentsEnabled,
    @JsonKey(name: 'reactions')
    @Default(<String, int>{})
    Map<String, int> reactions,
    @JsonKey(name: 'myReaction') String? myReaction,
    @JsonKey(name: 'perspectiveCount') @Default(0) int perspectiveCount,
    @JsonKey(name: 'coverAssetId') String? coverAssetId,
    @JsonKey(name: 'assets')
    @Default(<MediaAssetRecord>[])
    List<MediaAssetRecord> assets,
    @JsonKey(name: 'createdAt') DateTime? createdAt,
    @JsonKey(name: 'publishedAt') DateTime? publishedAt,
    @JsonKey(name: 'trashedAt') DateTime? trashedAt,
    @JsonKey(name: 'trashedBy') String? trashedBy,
    @JsonKey(name: 'purgeAfter') DateTime? purgeAfter,
  }) = _MemoryRecord;

  factory MemoryRecord.fromJson(Map<String, dynamic> json) =>
      _$MemoryRecordFromJson(json);
}
