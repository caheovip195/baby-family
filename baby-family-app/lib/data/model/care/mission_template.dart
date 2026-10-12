import 'package:baby_family/utils/constants/enum.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'mission_template.freezed.dart';
part 'mission_template.g.dart';

/// Mẫu nhiệm vụ trong thư viện (CARE-04, CARE-05).
@Freezed(when: FreezedWhenOptions.none)
abstract class MissionTemplate with _$MissionTemplate {
  @JsonSerializable(explicitToJson: true)
  const factory MissionTemplate({
    @JsonKey(name: 'id') required String id,
    @JsonKey(name: 'title') required String title,
    @JsonKey(name: 'category')
    @Default(MissionCategory.care)
    MissionCategory category,
    @JsonKey(name: 'hearts') @Default(0) int hearts,
    @JsonKey(name: 'durationMin') int? durationMin,
    @JsonKey(name: 'icon') String? icon,
    @JsonKey(name: 'hint') String? hint,
    @JsonKey(name: 'forPregnancy') @Default(false) bool forPregnancy,
    @JsonKey(name: 'perChild') @Default(true) bool perChild,
  }) = _MissionTemplate;

  factory MissionTemplate.fromJson(Map<String, dynamic> json) =>
      _$MissionTemplateFromJson(json);
}
