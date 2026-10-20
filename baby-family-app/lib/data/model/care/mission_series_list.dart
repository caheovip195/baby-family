import 'package:baby_family/data/model/care/mission_series_record.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'mission_series_list.freezed.dart';
part 'mission_series_list.g.dart';

/// `{items: [...]}`.
@Freezed(when: FreezedWhenOptions.none)
abstract class MissionSeriesList with _$MissionSeriesList {
  @JsonSerializable(explicitToJson: true)
  const factory MissionSeriesList({
    @JsonKey(name: 'items')
    @Default(<MissionSeriesRecord>[])
    List<MissionSeriesRecord> items,
  }) = _MissionSeriesList;

  factory MissionSeriesList.fromJson(Map<String, dynamic> json) =>
      _$MissionSeriesListFromJson(json);
}
