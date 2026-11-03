import 'package:baby_family/data/model/family/member.dart';
import 'package:baby_family/data/model/settings/profile_settings.dart';
import 'package:baby_family/data/model/settings/sign_in_method.dart';
import 'package:baby_family/data/provider/family.dart';
import 'package:baby_family/data/provider/settings.dart';
import 'package:baby_family/data/service/settings.dart';
import 'package:baby_family/page/application_base.dart';
import 'package:baby_family/utils/constants/enum.dart';
import 'package:hooks_riverpod/legacy.dart';

/// SET-02 — Hồ sơ: tên, nhãn gọi, phương thức đăng nhập, múi giờ.
/// “Lưu thay đổi” luôn lưu được (mock).
final profileSettingsControllerProvider =
    ChangeNotifierProvider.autoDispose<ProfileSettingsController>(
      ProfileSettingsController.new,
    );

class ProfileSettingsController extends BaseNotifier {
  ProfileSettingsController(super.ref) {
    load();
  }

  ISettingsService get settingsService => ref.read(settingsServiceProvider);

  ProfileSettings? profile;
  FamilyRole? role;
  bool hasError = false;

  Future<void> load() async {
    hasError = false;
    try {
      final results = await Future.wait([
        settingsService.profileSettings(),
        ref.read(familyServiceProvider).me(),
      ]);
      if (isDisposed) {
        return;
      }
      profile = results[0]! as ProfileSettings;
      role = (results[1] as Member?)?.role;
    } catch (_) {
      if (isDisposed) {
        return;
      }
      hasError = true;
    }
    notifyListeners();
  }

  void setName(String value) => _edit((p) => p.copyWith(name: value));

  void setCallName(String value) => _edit((p) => p.copyWith(callName: value));

  /// AUTH-04: ảnh vừa chọn trên máy; lưu cùng nút Lưu.
  void setAvatar(String path) => _edit((p) => p.copyWith(avatarAsset: path));

  void setAutoTimezone(bool value) =>
      _edit((p) => p.copyWith(autoTimezone: value));

  /// Liên kết / huỷ liên kết; luôn giữ ít nhất 1 cách đăng nhập.
  void toggleLink(AuthMethod method) {
    final current = profile;
    if (current == null) {
      return;
    }
    final linkedCount = current.signInMethods.where((m) => m.linked).length;
    final methods = [
      for (final item in current.signInMethods)
        if (item.method == method && !(item.linked && linkedCount <= 1))
          item.copyWith(linked: !item.linked)
        else
          item,
    ];
    _edit((p) => p.copyWith(signInMethods: methods));
  }

  List<SignInMethod> get methods => profile?.signInMethods ?? const [];

  /// Bản server: xác thực lại rồi liên kết / gỡ Apple, Google. Có số điện
  /// thoại → gửi OTP và hỏi mã qua [askOtp] (null = người dùng huỷ); không
  /// có → xác thực bằng Apple/Google đã liên kết. Trả true khi đã đổi.
  Future<bool> changeLink(
    AuthMethod method, {
    required Future<String?> Function() askOtp,
  }) async {
    final linked = {
      for (final item in methods)
        if (item.linked) item.method,
    };
    final unlinking = linked.contains(method);
    var done = false;
    await whileLoading(() async {
      if (linked.contains(AuthMethod.phone)) {
        await settingsService.requestReauthOtp();
        final code = await askOtp();
        if (code == null || code.isEmpty) {
          return;
        }
        await settingsService.verifyReauth(code);
      } else {
        // Gỡ: xác thực bằng chính tài khoản đó; liên kết: bằng cách đang có.
        final via = unlinking
            ? method
            : linked.firstWhere((m) => m != AuthMethod.phone);
        await settingsService.reauthWithSignIn(via);
      }
      if (unlinking) {
        await settingsService.unlinkSignIn(method);
      } else {
        await settingsService.linkSignIn(method);
      }
      done = true;
    });
    if (done) {
      // Chỉ đọc lại phương thức đăng nhập, giữ tên/ảnh đang sửa.
      final fresh = await settingsService.profileSettings();
      if (!isDisposed) {
        _edit((p) => p.copyWith(signInMethods: fresh.signInMethods));
      }
    }
    return done;
  }

  Future<void> save() async {
    final current = profile;
    if (current == null) {
      return;
    }
    await whileLoading(() => settingsService.saveProfileSettings(current));
  }

  void _edit(ProfileSettings Function(ProfileSettings) change) {
    final current = profile;
    if (current == null) {
      return;
    }
    profile = change(current);
    notifyListeners();
  }
}
