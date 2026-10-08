import 'package:baby_family/data/model/auth_certificate.dart';
import 'package:baby_family/data/model/user.dart';
import 'package:baby_family/data/service/base.dart';

abstract class IAuthService extends IBaseService {
  /// Phiên đang lưu trên máy (null nếu chưa đăng nhập).
  Future<AuthCertificate?> currentSession();

  /// Lưu phiên vừa nhận từ API đăng nhập (Apple/Google/OTP), tự tính mốc hết
  /// hạn access token.
  Future<AuthCertificate> saveSession(AuthCertificate certificate);

  Future<User?> getMe();

  /// Đăng xuất: thu hồi phiên trên server (bỏ qua lỗi mạng) và xoá dữ liệu
  /// người dùng trên máy.
  Future<void> logout();
}
