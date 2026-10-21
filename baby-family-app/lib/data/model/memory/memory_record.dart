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

    /// “Ai ở đó” (BF-20261021-002) và địa điểm gõ chữ.
    @JsonKey(name: 'people')
    @Default(<MemoryPersonRecord>[])
    List<MemoryPersonRecord> people,
    @JsonKey(name: 'locationLabel') String? locationLabel,
    @JsonKey(name: 'quoteContext') String? quoteContext,
    @JsonKey(name: 'commentCount') @Default(0) int commentCount,
    @JsonKey(name: 'commentsEnabled') @Default(true) bool commentsEnabled,
    @JsonKey(name: 'reactions')
    @Default(<String, int>{})
    Map<String, int> reactions,
    @JsonKey(name: 'myReaction') String? myReaction,
    @JsonKey(name: 'perspectiveCount') @Default(0) int perspectiveCount,
    @JsonKey(name: 'coverAssetId') String? coverAssetId,

    /// VOICE (BF-20261021-001): thời lượng do server đo từ asset audio.
    @JsonKey(name: 'durationSec') double? durationSec,
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

/// Một người “Ai ở đó”: thành viên ([memberId]/[userId]) hoặc tên gõ.
@Freezed(when: FreezedWhenOptions.none)
abstract class MemoryPersonRecord with _$MemoryPersonRecord {
  @JsonSerializable(explicitToJson: true)
  const factory MemoryPersonRecord({
    @JsonKey(name: 'memberId') String? memberId,
    @JsonKey(name: 'userId') String? userId,
    @JsonKey(name: 'displayName') @Default('') String displayName,
  }) = _MemoryPersonRecord;

  factory MemoryPersonRecord.fromJson(Map<String, dynamic> json) =>
      _$MemoryPersonRecordFromJson(json);
}
