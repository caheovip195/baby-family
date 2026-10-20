import 'package:baby_family/data/model/care/mission_record.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'mission_history_page.freezed.dart';
part 'mission_history_page.g.dart';

/// Một trang lịch sử nhiệm vụ (`GET …/missions`, CARE-08).
@Freezed(when: FreezedWhenOptions.none)
abstract class MissionHistoryPage with _$MissionHistoryPage {
  @JsonSerializable(explicitToJson: true)
  const factory MissionHistoryPage({
    @JsonKey(name: 'items')
    @Default(<MissionRecord>[])
    List<MissionRecord> items,
    @JsonKey(name: 'nextCursor') String? nextCursor,
  }) = _MissionHistoryPage;

  factory MissionHistoryPage.fromJson(Map<String, dynamic> json) =>
      _$MissionHistoryPageFromJson(json);
}
