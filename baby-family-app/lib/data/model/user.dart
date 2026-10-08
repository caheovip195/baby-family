import 'package:freezed_annotation/freezed_annotation.dart';

part 'user.freezed.dart';
part 'user.g.dart';

/// Tài khoản đang đăng nhập (`GET /v1/me`).
@Freezed(when: FreezedWhenOptions.none)
abstract class User with _$User {
  @JsonSerializable(explicitToJson: true)
  const factory User({
    @JsonKey(name: 'id') String? id,
    @JsonKey(name: 'displayName') String? displayName,
    @JsonKey(name: 'avatarUrl') String? avatarUrl,
    @JsonKey(name: 'locale') String? locale,
    @JsonKey(name: 'timezone') String? timezone,
  }) = _User;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}
