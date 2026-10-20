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
  }) = _MediaAssetRecord;

  factory MediaAssetRecord.fromJson(Map<String, dynamic> json) =>
      _$MediaAssetRecordFromJson(json);
}
