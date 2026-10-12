import 'package:baby_family/utils/constants/enum.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'sign_in_method.freezed.dart';
part 'sign_in_method.g.dart';

/// Phương thức đăng nhập (SET-02).
@Freezed(when: FreezedWhenOptions.none)
abstract class SignInMethod with _$SignInMethod {
  @JsonSerializable(explicitToJson: true)
  const factory SignInMethod({
    @JsonKey(name: 'method') required AuthMethod method,
    @JsonKey(name: 'linked') @Default(false) bool linked,
    @JsonKey(name: 'maskedAccount') String? maskedAccount,
  }) = _SignInMethod;

  factory SignInMethod.fromJson(Map<String, dynamic> json) =>
      _$SignInMethodFromJson(json);
}
