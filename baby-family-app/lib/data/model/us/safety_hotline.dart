import 'package:freezed_annotation/freezed_annotation.dart';

part 'safety_hotline.freezed.dart';
part 'safety_hotline.g.dart';

/// Số khẩn cấp (US-13) — catalog đã dịch.
@Freezed(when: FreezedWhenOptions.none)
abstract class SafetyHotline with _$SafetyHotline {
  @JsonSerializable(explicitToJson: true)
  const factory SafetyHotline({
    @JsonKey(name: 'number') required String number,
    @JsonKey(name: 'title') required String title,
    @JsonKey(name: 'hint') String? hint,
  }) = _SafetyHotline;

  factory SafetyHotline.fromJson(Map<String, dynamic> json) =>
      _$SafetyHotlineFromJson(json);
}
