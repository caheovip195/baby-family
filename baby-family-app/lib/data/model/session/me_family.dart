import 'package:freezed_annotation/freezed_annotation.dart';

part 'me_family.freezed.dart';
part 'me_family.g.dart';

/// Gia đình mà tài khoản là Bố/Mẹ (`GET /v1/me` → `families[]`).
@Freezed(when: FreezedWhenOptions.none)
abstract class MeFamily with _$MeFamily {
  @JsonSerializable(explicitToJson: true)
  const factory MeFamily({
    @JsonKey(name: 'familyId') String? familyId,
    @JsonKey(name: 'name') String? name,
    @JsonKey(name: 'status') String? status,
    @JsonKey(name: 'slot') String? slot,
    @JsonKey(name: 'kind') String? kind,
    @JsonKey(name: 'callName') String? callName,
  }) = _MeFamily;

  factory MeFamily.fromJson(Map<String, dynamic> json) =>
      _$MeFamilyFromJson(json);
}
