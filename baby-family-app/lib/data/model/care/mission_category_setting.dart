import 'package:freezed_annotation/freezed_annotation.dart';

part 'mission_category_setting.freezed.dart';
part 'mission_category_setting.g.dart';

/// Loại việc muốn nhận (CARE-12).
@Freezed(when: FreezedWhenOptions.none)
abstract class MissionCategorySetting with _$MissionCategorySetting {
  @JsonSerializable(explicitToJson: true)
  const factory MissionCategorySetting({
    @JsonKey(name: 'code') required String code,
    @JsonKey(name: 'title') required String title,
    @JsonKey(name: 'icon') String? icon,
    @JsonKey(name: 'enabled') @Default(true) bool enabled,
  }) = _MissionCategorySetting;

  factory MissionCategorySetting.fromJson(Map<String, dynamic> json) =>
      _$MissionCategorySettingFromJson(json);
}
