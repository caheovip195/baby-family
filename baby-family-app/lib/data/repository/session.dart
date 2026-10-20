import 'package:baby_family/data/repository/base.dart';
import 'package:baby_family/utils/constants/enum.dart';

/// Phiên đăng nhập + cấu hình mock (OTP, mã mời mẫu).
abstract class ISessionRepository extends IBaseRepository {
  Future<void> ensureLoaded();

  bool get isLoaded;

  /// Bản ghi phiên hiện tại (userId, familyId, memberId, authMethod, phone,
  /// profileDone, role, callName, stage, pendingInvite, setupCompleted…).
  JsonMap session();

  void patchSession(JsonMap patch);

  void clearSession();

  /// `session.json`: otp, partnerInviteCode, relativeInviteCode, samples…
  JsonMap config();

  JsonMap? user(String? id);

  JsonMap upsertUser(JsonMap user);

  Future<void> reseed(DemoSeed seed, {String? actor});

  /// Bản chụp phiên + dữ liệu đã đồng bộ (mở app lúc mất mạng).
  JsonMap exportOfflineSnapshot();

  void importOfflineSnapshot(JsonMap snapshot);
}
