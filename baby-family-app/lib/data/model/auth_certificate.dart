import 'package:freezed_annotation/freezed_annotation.dart';

import 'user.dart';

part 'auth_certificate.freezed.dart';
part 'auth_certificate.g.dart';

/// Cặp token đăng nhập (tài liệu kỹ thuật mục 5.1).
///
/// Access token 15 phút, refresh token xoay vòng mỗi lần gia hạn.
/// `expiredAccessTokenDateTime` do app tính khi lưu, không có trong response.
@Freezed(when: FreezedWhenOptions.none)
abstract class AuthCertificate with _$AuthCertificate {
  @JsonSerializable(explicitToJson: true)
  const factory AuthCertificate({
    @JsonKey(name: 'accessToken') String? accessToken,
    @JsonKey(name: 'refreshToken') String? refreshToken,

    /// Thời hạn access token (giây).
    @JsonKey(name: 'expiresIn') int? expiresIn,
    @JsonKey(name: 'user') User? user,
    @JsonKey(name: 'expiredAccessTokenDateTime')
    DateTime? expiredAccessTokenDateTime,
  }) = _AuthCertificate;

  factory AuthCertificate.fromJson(Map<String, dynamic> json) =>
      _$AuthCertificateFromJson(json);
}
