import 'package:baby_family/data/model/auth_certificate.dart';
import 'package:baby_family/data/model/user.dart';
import 'package:baby_family/data/repository/auth.dart';
import 'package:baby_family/data/repository_imp/auth.dart';
import 'package:baby_family/data/service/auth.dart';
import 'package:baby_family/data/service_imp/base.dart';
import 'package:baby_family/utils/helper/application_directory.dart';
import 'package:baby_family/utils/helper/local_store.dart';
import 'package:logger/logger.dart';

class AuthServiceImp extends BaseServiceImp implements IAuthService {
  final IAuthRepository _authRepository = AuthRepositoryImp();

  @override
  Future<AuthCertificate?> currentSession() =>
      LocalStore().getAuthCertificate();

  @override
  Future<AuthCertificate> saveSession(AuthCertificate certificate) async {
    final session = certificate.copyWith(
      expiredAccessTokenDateTime: DateTime.now().add(
        Duration(seconds: certificate.expiresIn ?? 0),
      ),
    );
    await LocalStore().saveAuthCertificate(session);
    return session;
  }

  @override
  Future<User?> getMe() => _authRepository.getMe();

  @override
  Future<void> logout() async {
    final certificate = await LocalStore().getAuthCertificate();
    final refreshToken = certificate?.refreshToken;
    if (refreshToken != null) {
      try {
        await _authRepository.logout(refreshToken);
      } catch (e) {
        // Lỗi mạng vẫn đăng xuất trên máy; server tự hết hạn phiên.
        Logger().e(e);
      }
    }
    await LocalStore().clearAll();
    await ApplicationDirectory().clearUserFiles();
  }
}
