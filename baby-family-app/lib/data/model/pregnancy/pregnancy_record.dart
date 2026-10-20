import 'package:freezed_annotation/freezed_annotation.dart';

part 'pregnancy_record.freezed.dart';
part 'pregnancy_record.g.dart';

/// Thai kỳ do server trả (`POST/PATCH /v1/families/{fid}/pregnancies`).
@Freezed(when: FreezedWhenOptions.none)
abstract class PregnancyRecord with _$PregnancyRecord {
  @JsonSerializable(explicitToJson: true)
  const factory PregnancyRecord({
    @JsonKey(name: 'id') String? id,
    @JsonKey(name: 'familyId') String? familyId,
    @JsonKey(name: 'seqNo') int? seqNo,
    @JsonKey(name: 'nickname') String? nickname,
    @JsonKey(name: 'dueDate') DateTime? dueDate,
    @JsonKey(name: 'expectedCount') int? expectedCount,
    @JsonKey(name: 'status') String? status,
  }) = _PregnancyRecord;

  factory PregnancyRecord.fromJson(Map<String, dynamic> json) =>
      _$PregnancyRecordFromJson(json);
}
