import 'package:freezed_annotation/freezed_annotation.dart';

part 'bump_photo.freezed.dart';
part 'bump_photo.g.dart';

/// Ảnh bụng bầu theo tuần (PREG-02).
@Freezed(when: FreezedWhenOptions.none)
abstract class BumpPhoto with _$BumpPhoto {
  @JsonSerializable(explicitToJson: true)
  const factory BumpPhoto({
    @JsonKey(name: 'id') required String id,
    @JsonKey(name: 'pregnancyId') required String pregnancyId,
    @JsonKey(name: 'week') required int week,
    @JsonKey(name: 'asset') String? asset,
    @JsonKey(name: 'memoryId') String? memoryId,
    @JsonKey(name: 'takenAt') DateTime? takenAt,
  }) = _BumpPhoto;

  factory BumpPhoto.fromJson(Map<String, dynamic> json) =>
      _$BumpPhotoFromJson(json);
}
