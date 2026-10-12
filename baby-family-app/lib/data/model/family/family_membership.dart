import 'package:baby_family/utils/constants/enum.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'family_membership.freezed.dart';
part 'family_membership.g.dart';

/// Một gia đình của tài khoản (FAM-08 chuyển gia đình, CIR-06).
@Freezed(when: FreezedWhenOptions.none)
abstract class FamilyMembership with _$FamilyMembership {
  @JsonSerializable(explicitToJson: true)
  const factory FamilyMembership({
    @JsonKey(name: 'familyId') required String familyId,
    @JsonKey(name: 'familyName') required String familyName,
    @JsonKey(name: 'role') required FamilyRole role,
    @JsonKey(name: 'callName') @Default('') String callName,
    @JsonKey(name: 'childNames') @Default([]) List<String> childNames,
    @JsonKey(name: 'partnerName') String? partnerName,
    @JsonKey(name: 'permissionSummary') String? permissionSummary,
    @JsonKey(name: 'current') @Default(false) bool current,
  }) = _FamilyMembership;

  factory FamilyMembership.fromJson(Map<String, dynamic> json) =>
      _$FamilyMembershipFromJson(json);
}
