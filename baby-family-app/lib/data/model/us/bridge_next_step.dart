import 'package:freezed_annotation/freezed_annotation.dart';

part 'bridge_next_step.freezed.dart';
part 'bridge_next_step.g.dart';

/// Bước nhỏ tiếp theo hai bạn chọn (US-12).
@Freezed(when: FreezedWhenOptions.none)
abstract class BridgeNextStep with _$BridgeNextStep {
  @JsonSerializable(explicitToJson: true)
  const factory BridgeNextStep({
    @JsonKey(name: 'code') required String code,
    @JsonKey(name: 'whenLabel') String? whenLabel,
    @JsonKey(name: 'at') DateTime? at,
    @JsonKey(name: 'childIds') @Default([]) List<String> childIds,
    @JsonKey(name: 'reminder') @Default(true) bool reminder,
    @JsonKey(name: 'reminderAt') DateTime? reminderAt,
    @JsonKey(name: 'agreedUserIds') @Default([]) List<String> agreedUserIds,
  }) = _BridgeNextStep;

  factory BridgeNextStep.fromJson(Map<String, dynamic> json) =>
      _$BridgeNextStepFromJson(json);
}
