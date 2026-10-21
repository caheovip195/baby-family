import 'package:freezed_annotation/freezed_annotation.dart';

part 'media_asset_record.freezed.dart';
part 'media_asset_record.g.dart';

/// Ảnh/video của ký ức do server trả; `urls` là URL đã ký theo biến thể
/// (`t320`, `m1080`, `l2048`…), rỗng tới khi `READY` (tài liệu kỹ thuật 10.5).
@Freezed(when: FreezedWhenOptions.none)
abstract class MediaAssetRecord with _$MediaAssetRecord {
  @JsonSerializable(explicitToJson: true)
  const factory MediaAssetRecord({
    @JsonKey(name: 'assetId') String? assetId,
    @JsonKey(name: 'kind') String? kind,
    @JsonKey(name: 'status') String? status,
    @JsonKey(name: 'width') int? width,
    @JsonKey(name: 'height') int? height,
    @JsonKey(name: 'durationMs') int? durationMs,
    @JsonKey(name: 'blurhash') String? blurhash,
    @JsonKey(name: 'urls')
    @Default(<String, String>{})
    Map<String, String> urls,
    @JsonKey(name: 'urlsExpireAt') DateTime? urlsExpireAt,

    /// Dấu vết file gốc trong thư viện máy (BF-20261021-008) — để ưu tiên bản
    /// local khi máy còn file đó.
    @JsonKey(name: 'source') MediaSourceRecord? source,
  }) = _MediaAssetRecord;

  factory MediaAssetRecord.fromJson(Map<String, dynamic> json) =>
      _$MediaAssetRecordFromJson(json);
}

@Freezed(when: FreezedWhenOptions.none)
abstract class MediaSourceRecord with _$MediaSourceRecord {
  @JsonSerializable(explicitToJson: true)
  const factory MediaSourceRecord({
    @JsonKey(name: 'sha256') String? sha256,
    @JsonKey(name: 'key') String? key,
    @JsonKey(name: 'capturedAt') DateTime? capturedAt,
  }) = _MediaSourceRecord;

  factory MediaSourceRecord.fromJson(Map<String, dynamic> json) =>
      _$MediaSourceRecordFromJson(json);
}
