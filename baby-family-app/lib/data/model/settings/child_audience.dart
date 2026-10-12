import 'package:freezed_annotation/freezed_annotation.dart';

part 'child_audience.freezed.dart';
part 'child_audience.g.dart';

/// Ai đang thấy bé nào (SET-04).
@Freezed(when: FreezedWhenOptions.none)
abstract class ChildAudience with _$ChildAudience {
  @JsonSerializable(explicitToJson: true)
  const factory ChildAudience({
    @JsonKey(name: 'childId') required String childId,
    @JsonKey(name: 'relativeCount') @Default(0) int relativeCount,
  }) = _ChildAudience;

  factory ChildAudience.fromJson(Map<String, dynamic> json) =>
      _$ChildAudienceFromJson(json);
}
