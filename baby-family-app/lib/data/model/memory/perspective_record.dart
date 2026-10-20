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
    @JsonKey(name: 'hiddenFromCircle') @Default(false) bool hiddenFromCircle,
    @JsonKey(name: 'createdAt') DateTime? createdAt,
  }) = _PerspectiveRecord;

  factory PerspectiveRecord.fromJson(Map<String, dynamic> json) =>
      _$PerspectiveRecordFromJson(json);
}
