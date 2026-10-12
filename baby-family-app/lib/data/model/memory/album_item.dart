import 'package:freezed_annotation/freezed_annotation.dart';

part 'album_item.freezed.dart';
part 'album_item.g.dart';

/// Ô ảnh/video trong album (MEM-03a).
@Freezed(when: FreezedWhenOptions.none)
abstract class AlbumItem with _$AlbumItem {
  @JsonSerializable(explicitToJson: true)
  const factory AlbumItem({
    @JsonKey(name: 'asset') required String asset,
    @JsonKey(name: 'isVideo') @Default(false) bool isVideo,
    @JsonKey(name: 'durationSec') int? durationSec,
    @JsonKey(name: 'memoryId') String? memoryId,
  }) = _AlbumItem;

  factory AlbumItem.fromJson(Map<String, dynamic> json) =>
      _$AlbumItemFromJson(json);
}
