import 'package:baby_family/data/model/session/me_awaiting_approval.dart';
import 'package:baby_family/data/model/session/me_family.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'me_profile.freezed.dart';
part 'me_profile.g.dart';

/// Hồ sơ + gia đình + tiến độ onboarding (`GET /v1/me`, tài liệu kỹ thuật 11.3).
@Freezed(when: FreezedWhenOptions.none)
abstract class MeProfile with _$MeProfile {
  @JsonSerializable(explicitToJson: true)
  const factory MeProfile({
    @JsonKey(name: 'id') String? id,
    @JsonKey(name: 'displayName') String? displayName,

    /// AUTH-04: URL ký ngắn hạn của ảnh đại diện (null khi chưa có).
    @JsonKey(name: 'avatarUrl') String? avatarUrl,
    @JsonKey(name: 'locale') String? locale,
    @JsonKey(name: 'timezone') String? timezone,
    @JsonKey(name: 'onboardingRole') String? onboardingRole,
    @JsonKey(name: 'profileCompleted') @Default(false) bool profileCompleted,
    @JsonKey(name: 'families') @Default(<MeFamily>[]) List<MeFamily> families,
    @JsonKey(name: 'awaitingApproval')
    @Default(<MeAwaitingApproval>[])
    List<MeAwaitingApproval> awaitingApproval,
  }) = _MeProfile;

  factory MeProfile.fromJson(Map<String, dynamic> json) =>
      _$MeProfileFromJson(json);
}
