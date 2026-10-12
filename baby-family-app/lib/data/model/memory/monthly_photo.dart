import 'package:freezed_annotation/freezed_annotation.dart';

part 'monthly_photo.freezed.dart';
part 'monthly_photo.g.dart';

/// Ảnh tháng chính của bé (MEM-20/21, BR-072).
@Freezed(when: FreezedWhenOptions.none)
abstract class MonthlyPhoto with _$MonthlyPhoto {
  @JsonSerializable(explicitToJson: true)
  const factory MonthlyPhoto({
    @JsonKey(name: 'id') required String id,
    @JsonKey(name: 'childId') required String childId,
    @JsonKey(name: 'monthIndex') required int monthIndex,
    @JsonKey(name: 'memoryId') String? memoryId,
    @JsonKey(name: 'asset') String? asset,
    @JsonKey(name: 'takenAt') DateTime? takenAt,
  }) = _MonthlyPhoto;

  factory MonthlyPhoto.fromJson(Map<String, dynamic> json) =>
      _$MonthlyPhotoFromJson(json);
}
