import 'package:baby_family/utils/helper/lenient_json.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'perspective_record.freezed.dart';
part 'perspective_record.g.dart';

/// Góc nhìn thứ hai của Parent còn lại (MEM-24).
@Freezed(when: FreezedWhenOptions.none)
abstract class PerspectiveRecord with _$PerspectiveRecord {
  @JsonSerializable(explicitToJson: true)
  const factory PerspectiveRecord({
    @JsonKey(name: 'id') String? id,
    @JsonKey(name: 'memoryId') String? memoryId,
    @JsonKey(name: 'authorUserId') String? authorUserId,
    @JsonKey(name: 'body') String? body,

    /// Ghi âm góc nhìn (BF-20261030-004): asset + URL nghe có hạn.
    @JsonKey(name: 'audioAssetId') String? audioAssetId,
    @JsonKey(name: 'audioUrl') String? audioUrl,
    @JsonKey(name: 'audioDurationSec') int? audioDurationSec,

    /// Ảnh/video của góc nhìn (BF-20261030-006).
    @JsonKey(name: 'assets', fromJson: _perspectiveAssets)
    @Default(<PerspectiveAssetRecord>[])
    List<PerspectiveAssetRecord> assets,
    @JsonKey(name: 'hiddenFromCircle') @Default(false) bool hiddenFromCircle,
    @JsonKey(name: 'createdAt') DateTime? createdAt,
  }) = _PerspectiveRecord;

  factory PerspectiveRecord.fromJson(Map<String, dynamic> json) =>
      _$PerspectiveRecordFromJson(json);
}

@Freezed(when: FreezedWhenOptions.none)
abstract class PerspectiveAssetRecord with _$PerspectiveAssetRecord {
  @JsonSerializable(explicitToJson: true)
  const factory PerspectiveAssetRecord({
    @JsonKey(name: 'assetId') required String assetId,
    @JsonKey(name: 'kind') @Default('IMAGE') String kind,
    @JsonKey(name: 'url') String? url,
    @JsonKey(name: 'videoUrl') String? videoUrl,
  }) = _PerspectiveAssetRecord;

  factory PerspectiveAssetRecord.fromJson(Map<String, dynamic> json) =>
      _$PerspectiveAssetRecordFromJson(json);
}

List<PerspectiveAssetRecord> _perspectiveAssets(Object? json) =>
    lenientList(json, PerspectiveAssetRecord.fromJson, label: 'ảnh góc nhìn');
