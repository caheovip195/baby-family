import 'package:baby_family/data/repository/base.dart';
import 'package:baby_family/utils/helper/user_cancelled.dart';

/// JWT của Apple kèm nonce gốc (server so SHA-256 với `nonce` trong token).
class AppleCredential {
  const AppleCredential({
    required this.identityToken,
    required this.rawNonce,
    this.fullName,
  });

  final String identityToken;
  final String rawNonce;

  /// Apple chỉ trả tên ở lần đăng nhập đầu tiên.
  final String? fullName;
}

/// Người dùng đóng hộp thoại đăng nhập — không phải lỗi.
class SocialSignInCancelled implements UserCancelled {
  const SocialSignInCancelled();
}

/// Đăng nhập Apple / Google trên máy (AUTH-01): chỉ lấy JWT của nhà cung cấp,
/// server xác minh và phát hành phiên.
abstract class ISocialCredentialRepository extends IBaseRepository {
  Future<AppleCredential> apple();

  /// `idToken` (audience = server client id).
  Future<String> google();
}
