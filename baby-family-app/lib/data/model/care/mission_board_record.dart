import 'package:baby_family/data/model/care/mission_record.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'mission_board_record.freezed.dart';
part 'mission_board_record.g.dart';

/// Bảng nhiệm vụ một ngày của một tab (`GET /v1/families/{fid}/missions/board`).
@Freezed(when: FreezedWhenOptions.none)
abstract class MissionBoardRecord with _$MissionBoardRecord {
  @JsonSerializable(explicitToJson: true)
  const factory MissionBoardRecord({
    @JsonKey(name: 'date') String? date,
    @JsonKey(name: 'items')
    @Default(<MissionRecord>[])
    List<MissionRecord> items,
    @JsonKey(name: 'myHeartsToday') int? myHeartsToday,
    @JsonKey(name: 'swapsLeft') int? swapsLeft,
    @JsonKey(name: 'openRequestCount') @Default(0) int openRequestCount,
  }) = _MissionBoardRecord;

  factory MissionBoardRecord.fromJson(Map<String, dynamic> json) =>
      _$MissionBoardRecordFromJson(json);
}
