import 'package:freezed_annotation/freezed_annotation.dart';

part 'bootstrap_family.freezed.dart';
part 'bootstrap_family.g.dart';

/// Phần `family` của bootstrap (tài liệu kỹ thuật 11.4).
@Freezed(when: FreezedWhenOptions.none)
abstract class BootstrapFamily with _$BootstrapFamily {
  @JsonSerializable(explicitToJson: true)
  const factory BootstrapFamily({
    @JsonKey(name: 'id') String? id,
    @JsonKey(name: 'name') String? name,
    @JsonKey(name: 'status') String? status,
    @JsonKey(name: 'timezone') String? timezone,
    @JsonKey(name: 'activatedAt') DateTime? activatedAt,
  }) = _BootstrapFamily;

  factory BootstrapFamily.fromJson(Map<String, dynamic> json) =>
      _$BootstrapFamilyFromJson(json);
}
