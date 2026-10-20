import 'package:baby_family/data/model/care/mission_record.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'mission_result_record.freezed.dart';
part 'mission_result_record.g.dart';

/// Kết quả tạo/hoàn thành/đổi nhiệm vụ: `mission` (+ `myHeartsAwarded` khi hoàn thành, `removedId` khi đổi).
@Freezed(when: FreezedWhenOptions.none)
abstract class MissionResultRecord with _$MissionResultRecord {
  @JsonSerializable(explicitToJson: true)
  const factory MissionResultRecord({
    @JsonKey(name: 'mission') MissionRecord? mission,
    @JsonKey(name: 'myHeartsAwarded') int? myHeartsAwarded,
    @JsonKey(name: 'removedId') String? removedId,
  }) = _MissionResultRecord;

  factory MissionResultRecord.fromJson(Map<String, dynamic> json) =>
      _$MissionResultRecordFromJson(json);
}
