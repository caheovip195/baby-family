import 'package:freezed_annotation/freezed_annotation.dart';

part 'bootstrap_parent.freezed.dart';
part 'bootstrap_parent.g.dart';

/// Bố/Mẹ trong bootstrap (`me`, `parents[]`).
@Freezed(when: FreezedWhenOptions.none)
abstract class BootstrapParent with _$BootstrapParent {
  @JsonSerializable(explicitToJson: true)
  const factory BootstrapParent({
    @JsonKey(name: 'userId') String? userId,
    @JsonKey(name: 'slot') String? slot,
    @JsonKey(name: 'kind') String? kind,
    @JsonKey(name: 'callName') String? callName,
    @JsonKey(name: 'displayName') String? displayName,
  }) = _BootstrapParent;

  factory BootstrapParent.fromJson(Map<String, dynamic> json) =>
      _$BootstrapParentFromJson(json);
}
