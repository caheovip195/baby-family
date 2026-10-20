import 'package:freezed_annotation/freezed_annotation.dart';

part 'circle_subject_record.freezed.dart';
part 'circle_subject_record.g.dart';

/// Bé / thai kỳ người thân được cấp quyền (`kind`: CHILD | PREGNANCY).
@Freezed(when: FreezedWhenOptions.none)
abstract class CircleSubjectRecord with _$CircleSubjectRecord {
  @JsonSerializable(explicitToJson: true)
  const factory CircleSubjectRecord({
    @JsonKey(name: 'id') String? id,
    @JsonKey(name: 'name') String? name,
    @JsonKey(name: 'kind') String? kind,
    @JsonKey(name: 'permission') String? permission,
    @JsonKey(name: 'allowDownload') bool? allowDownload,
  }) = _CircleSubjectRecord;

  factory CircleSubjectRecord.fromJson(Map<String, dynamic> json) =>
      _$CircleSubjectRecordFromJson(json);
}
