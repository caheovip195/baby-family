import 'package:baby_family/data/model/settings/ai_feature_setting.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'ai_settings.freezed.dart';
part 'ai_settings.g.dart';

/// SET-05 AI hỗ trợ.
@Freezed(when: FreezedWhenOptions.none)
abstract class AiSettings with _$AiSettings {
  @JsonSerializable(explicitToJson: true)
  const factory AiSettings({
    @JsonKey(name: 'enabled') @Default(true) bool enabled,
    @JsonKey(name: 'remaining') @Default(0) int remaining,
    @JsonKey(name: 'total') @Default(0) int total,
    @JsonKey(name: 'renewsAt') DateTime? renewsAt,
    @JsonKey(name: 'features') @Default([]) List<AiFeatureSetting> features,
  }) = _AiSettings;

  factory AiSettings.fromJson(Map<String, dynamic> json) =>
      _$AiSettingsFromJson(json);
}
