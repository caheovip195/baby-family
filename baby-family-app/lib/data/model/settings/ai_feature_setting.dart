import 'package:freezed_annotation/freezed_annotation.dart';

part 'ai_feature_setting.freezed.dart';
part 'ai_feature_setting.g.dart';

/// Một tính năng AI (SET-05) — tiêu đề/dữ liệu gửi đi đã dịch.
@Freezed(when: FreezedWhenOptions.none)
abstract class AiFeatureSetting with _$AiFeatureSetting {
  @JsonSerializable(explicitToJson: true)
  const factory AiFeatureSetting({
    @JsonKey(name: 'code') required String code,
    @JsonKey(name: 'title') required String title,
    @JsonKey(name: 'sends') String? sends,
    @JsonKey(name: 'icon') String? icon,
    @JsonKey(name: 'enabled') @Default(true) bool enabled,
  }) = _AiFeatureSetting;

  factory AiFeatureSetting.fromJson(Map<String, dynamic> json) =>
      _$AiFeatureSettingFromJson(json);
}
