import 'package:freezed_annotation/freezed_annotation.dart';

part 'monthly_photo_record.freezed.dart';
part 'monthly_photo_record.g.dart';

/// Ảnh tháng của bé trên server (`/v1/children/{id}/monthly-photos`, MEM-20/21).
@Freezed(when: FreezedWhenOptions.none)
abstract class MonthlyPhotoRecord with _$MonthlyPhotoRecord {
  @JsonSerializable(explicitToJson: true)
  const factory MonthlyPhotoRecord({
    @JsonKey(name: 'monthIndex') int? monthIndex,
    @JsonKey(name: 'memoryId') String? memoryId,
    @JsonKey(name: 'url') String? url,
    @JsonKey(name: 'occurredAt') DateTime? occurredAt,
  }) = _MonthlyPhotoRecord;

  factory MonthlyPhotoRecord.fromJson(Map<String, dynamic> json) =>
      _$MonthlyPhotoRecordFromJson(json);
}
