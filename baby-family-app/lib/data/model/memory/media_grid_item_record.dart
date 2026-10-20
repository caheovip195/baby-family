import 'package:freezed_annotation/freezed_annotation.dart';

part 'media_grid_item_record.freezed.dart';
part 'media_grid_item_record.g.dart';

/// Một ô của `GET /v1/families/{fid}/media-grid` (MEM-02).
@Freezed(when: FreezedWhenOptions.none)
abstract class MediaGridItemRecord with _$MediaGridItemRecord {
  @JsonSerializable(explicitToJson: true)
  const factory MediaGridItemRecord({
    @JsonKey(name: 'assetId') String? assetId,
    @JsonKey(name: 'memoryId') String? memoryId,
    @JsonKey(name: 'kind') String? kind,
    @JsonKey(name: 'width') int? width,
    @JsonKey(name: 'height') int? height,
    @JsonKey(name: 'durationMs') int? durationMs,
    @JsonKey(name: 'blurhash') String? blurhash,
    @JsonKey(name: 'occurredAt') DateTime? occurredAt,
    @JsonKey(name: 'urls')
    @Default(<String, String>{})
    Map<String, String> urls,
    @JsonKey(name: 'urlsExpireAt') DateTime? urlsExpireAt,
  }) = _MediaGridItemRecord;

  factory MediaGridItemRecord.fromJson(Map<String, dynamic> json) =>
      _$MediaGridItemRecordFromJson(json);
}
