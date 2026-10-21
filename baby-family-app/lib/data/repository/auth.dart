import 'package:baby_family/data/model/auth_certificate.dart';
import 'package:baby_family/data/model/session/me_profile.dart';
import 'package:baby_family/data/model/session/otp_dispatch.dart';
import 'package:baby_family/data/model/user.dart';
import 'package:baby_family/data/repository/base.dart';

abstract class IAuthRepository extends IBaseRepository {
  /// `POST /v1/auth/refresh` — trả cặp token mới (refresh token xoay vòng).
  Future<AuthCertificate> refreshToken(String refreshToken);

  /// `POST /v1/auth/logout` — thu hồi phiên hiện tại trên server.
  Future<void> logout(String refreshToken);

  /// `GET /v1/me`.
  Future<User?> getMe();

  /// `POST /v1/auth/phone/otp` — `phone` dạng E.164.
  Future<OtpDispatch?> requestPhoneOtp(String phone);

  /// `POST /v1/auth/phone/verify` → cặp token (refresh token xoay vòng).
  Future<AuthCertificate> verifyPhoneOtp({
    required String phone,
    required String code,
    required JsonMap device,
  });

  /// `POST /v1/auth/apple` — JWT Apple + nonce gốc.
  Future<AuthCertificate> signInWithApple({
    required String identityToken,
    required String nonce,
    String? fullName,
  });

  /// `POST /v1/auth/google` — idToken Google.
  Future<AuthCertificate> signInWithGoogle(String idToken);

  /// `GET /v1/me` — hồ sơ + gia đình + tiến độ onboarding.
  Future<MeProfile?> getMeProfile();

  /// `PATCH /v1/me`.
  Future<void> updateProfile(JsonMap patch);

  /// `POST /v1/me/consents`.
  Future<void> recordConsents(List<JsonMap> consents, {String? platform});

  /// `PUT /v1/me/onboarding-role` — `PARENT_FATHER|PARENT_MOTHER|CIRCLE`.
  Future<MeProfile?> setOnboardingRole(String role);

  /// `POST /v1/me/devices`.
  Future<void> registerDevice(JsonMap device);
}
