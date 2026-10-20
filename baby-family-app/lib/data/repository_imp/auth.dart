import 'package:baby_family/data/model/auth_certificate.dart';
import 'package:baby_family/data/model/session/me_profile.dart';
import 'package:baby_family/data/model/session/otp_dispatch.dart';
import 'package:baby_family/data/model/user.dart';
import 'package:baby_family/data/repository/auth.dart';
import 'package:baby_family/data/repository/base.dart';
import 'package:baby_family/data/repository_imp/base.dart';

class AuthRepositoryImp extends BaseRepositoryImp implements IAuthRepository {
  @override
  Future<AuthCertificate> refreshToken(String refreshToken) async {
    final rs = await client!.refreshToken({'refreshToken': refreshToken});
    return rs.auth!;
  }

  @override
  Future<void> logout(String refreshToken) {
    return client!.logout({'refreshToken': refreshToken});
  }

  @override
  Future<User?> getMe() async {
    final rs = await client!.getMe();
    return rs.user;
  }

  @override
  Future<OtpDispatch?> requestPhoneOtp(String phone) async {
    final rs = await client!.requestPhoneOtp({'phone': phone});
    return rs.dispatch;
  }

  @override
  Future<AuthCertificate> verifyPhoneOtp({
    required String phone,
    required String code,
    required JsonMap device,
  }) async {
    final rs = await client!.verifyPhoneOtp({
      'phone': phone,
      'code': code,
      'device': device,
    });
    return rs.auth!;
  }

  @override
  Future<MeProfile?> getMeProfile() async {
    final rs = await client!.getMeProfile();
    return rs.profile;
  }

  @override
  Future<void> updateProfile(JsonMap patch) async {
    await client!.updateMe(patch);
  }

  @override
  Future<void> recordConsents(List<JsonMap> consents, {String? platform}) {
    return client!.recordConsents({
      'consents': consents,
      'platform': ?platform,
    });
  }

  @override
  Future<MeProfile?> setOnboardingRole(String role) async {
    final rs = await client!.setOnboardingRole({'role': role});
    return rs.profile;
  }

  @override
  Future<void> registerDevice(JsonMap device) {
    return client!.registerDevice(device);
  }
}
