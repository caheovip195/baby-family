import 'package:baby_family/data/model/care/mission_template_record.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'mission_template_list.freezed.dart';
part 'mission_template_list.g.dart';

/// `{items: [...]}` của `GET /v1/missions/templates`.
@Freezed(when: FreezedWhenOptions.none)
abstract class MissionTemplateList with _$MissionTemplateList {
  @JsonSerializable(explicitToJson: true)
  const factory MissionTemplateList({
    @JsonKey(name: 'items')
    @Default(<MissionTemplateRecord>[])
    List<MissionTemplateRecord> items,
  }) = _MissionTemplateList;

  factory MissionTemplateList.fromJson(Map<String, dynamic> json) =>
      _$MissionTemplateListFromJson(json);
}
