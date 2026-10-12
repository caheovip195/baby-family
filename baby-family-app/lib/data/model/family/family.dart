import 'package:baby_family/data/model/family/plan_info.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'family.freezed.dart';
part 'family.g.dart';

/// Gia đình (FAM-01).
@Freezed(when: FreezedWhenOptions.none)
abstract class Family with _$Family {
  @JsonSerializable(explicitToJson: true)
  const factory Family({
    @JsonKey(name: 'id') required String id,
    @JsonKey(name: 'name') required String name,
    @JsonKey(name: 'coverIndex') @Default(0) int coverIndex,
    @JsonKey(name: 'coverAsset') String? coverAsset,
    @JsonKey(name: 'createdAt') DateTime? createdAt,
    @JsonKey(name: 'activatedAt') DateTime? activatedAt,
    @JsonKey(name: 'setupCompleted') @Default(false) bool setupCompleted,
    @JsonKey(name: 'timezone') String? timezone,
    @JsonKey(name: 'plan') @Default(PlanInfo()) PlanInfo plan,
  }) = _Family;

  factory Family.fromJson(Map<String, dynamic> json) => _$FamilyFromJson(json);
}
