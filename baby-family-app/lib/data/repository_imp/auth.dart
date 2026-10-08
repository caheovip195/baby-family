import 'package:baby_family/data/model/auth_certificate.dart';
import 'package:baby_family/data/model/user.dart';
import 'package:baby_family/data/repository/auth.dart';
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
}
