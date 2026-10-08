import 'package:baby_family/data/model/auth_certificate.dart';
import 'package:baby_family/data/model/user.dart';
import 'package:baby_family/data/repository/base.dart';

abstract class IAuthRepository extends IBaseRepository {
  /// `POST /v1/auth/refresh` — trả cặp token mới (refresh token xoay vòng).
  Future<AuthCertificate> refreshToken(String refreshToken);

  /// `POST /v1/auth/logout` — thu hồi phiên hiện tại trên server.
  Future<void> logout(String refreshToken);

  /// `GET /v1/me`.
  Future<User?> getMe();
}
