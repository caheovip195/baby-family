import 'package:freezed_annotation/freezed_annotation.dart';

part 'bridge_option.freezed.dart';
part 'bridge_option.g.dart';

/// Lựa chọn catalog của Cầu nối (cảm xúc / nhu cầu / bước tiếp theo) — đã dịch.
@Freezed(when: FreezedWhenOptions.none)
abstract class BridgeOption with _$BridgeOption {
  @JsonSerializable(explicitToJson: true)
  const factory BridgeOption({
    @JsonKey(name: 'code') required String code,
    @JsonKey(name: 'title') required String title,
    @JsonKey(name: 'icon') String? icon,
    @JsonKey(name: 'tag') String? tag,
  }) = _BridgeOption;

  factory BridgeOption.fromJson(Map<String, dynamic> json) =>
      _$BridgeOptionFromJson(json);
}
