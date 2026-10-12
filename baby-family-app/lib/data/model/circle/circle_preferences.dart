import 'package:freezed_annotation/freezed_annotation.dart';

part 'circle_preferences.freezed.dart';
part 'circle_preferences.g.dart';

/// CIR-06 “Tôi” của người thân.
@Freezed(when: FreezedWhenOptions.none)
abstract class CirclePreferences with _$CirclePreferences {
  @JsonSerializable(explicitToJson: true)
  const factory CirclePreferences({
    @JsonKey(name: 'instantPhotos') @Default(false) bool instantPhotos,
    @JsonKey(name: 'dailyDigest') @Default(true) bool dailyDigest,
    @JsonKey(name: 'digestTime') @Default('19:00') String digestTime,
    @JsonKey(name: 'relationNote') String? relationNote,
    @JsonKey(name: 'postedPhotos') @Default(0) int postedPhotos,
    @JsonKey(name: 'postedComments') @Default(0) int postedComments,
  }) = _CirclePreferences;

  factory CirclePreferences.fromJson(Map<String, dynamic> json) =>
      _$CirclePreferencesFromJson(json);
}
