import 'package:baby_family/data/model/circle/circle_subject_record.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'my_circle_record.freezed.dart';
part 'my_circle_record.g.dart';

/// Một gia đình mà tôi là người thân (`GET /v1/me/circles`); `status`:
/// ACTIVE | PAUSED | AWAITING_APPROVAL.
@Freezed(when: FreezedWhenOptions.none)
abstract class MyCircleRecord with _$MyCircleRecord {
  @JsonSerializable(explicitToJson: true)
  const factory MyCircleRecord({
    @JsonKey(name: 'familyId') String? familyId,
    @JsonKey(name: 'familyName') String? familyName,
    @JsonKey(name: 'status') String? status,
    @JsonKey(name: 'children')
    @Default(<CircleSubjectRecord>[])
    List<CircleSubjectRecord> children,
    @JsonKey(name: 'allowDownload') @Default(false) bool allowDownload,
  }) = _MyCircleRecord;

  factory MyCircleRecord.fromJson(Map<String, dynamic> json) =>
      _$MyCircleRecordFromJson(json);
}
