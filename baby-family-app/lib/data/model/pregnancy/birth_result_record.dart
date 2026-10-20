import 'package:baby_family/data/model/child/child_record.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'birth_result_record.freezed.dart';
part 'birth_result_record.g.dart';

/// `POST /pregnancies/:id/birth` (PREG-05).
@Freezed(when: FreezedWhenOptions.none)
abstract class BirthResultRecord with _$BirthResultRecord {
  @JsonSerializable(explicitToJson: true)
  const factory BirthResultRecord({
    @JsonKey(name: 'pregnancyId') String? pregnancyId,
    @JsonKey(name: 'children')
    @Default(<ChildRecord>[])
    List<ChildRecord> children,
  }) = _BirthResultRecord;

  factory BirthResultRecord.fromJson(Map<String, dynamic> json) =>
      _$BirthResultRecordFromJson(json);
}
