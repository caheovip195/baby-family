import 'package:baby_family/data/model/session/app_session.dart';
import 'package:baby_family/data/provider/session.dart';
import 'package:baby_family/data/service/session.dart';
import 'package:baby_family/page/application_base.dart';
import 'package:baby_family/utils/constants/enum.dart';
import 'package:baby_family/utils/constants/values.dart';
import 'package:hooks_riverpod/legacy.dart';

/// ONB-03 — chọn vai trò (mặc định Mama như thiết kế) + tên gọi.
/// Papa/Mama → ONB-06; Người thân → CIR-WAIT.
final onboardingRoleControllerProvider =
    ChangeNotifierProvider.autoDispose<OnboardingRoleController>(
      OnboardingRoleController.new,
    );

class OnboardingRoleController extends BaseNotifier {
  OnboardingRoleController(super.ref) {
    final current = sessionService.current;
    role = current.role ?? FamilyRole.mother;
    callName = current.callName?.isNotEmpty ?? false
        ? current.callName!
        : _defaultCallName(role);
  }

  ISessionService get sessionService => ref.read(sessionServiceProvider);

  /// Phiên sau thao tác — view điều hướng bằng `routeForSession`.
  AppSession get session => ref.read(sessionServiceProvider).current;

  late FamilyRole role;
  late String callName;

  void selectRole(FamilyRole value) {
    if (value == role) {
      return;
    }
    role = value;
    callName = _defaultCallName(value);
    notifyListeners();
  }

  void changeCallName(String value) {
    callName = value;
    notifyListeners();
  }

  Future<void> submit() async {
    await whileLoading(() async {
      await sessionService.chooseRole(
        role,
        callName: role == FamilyRole.relative || callName.trim().isEmpty
            ? null
            : callName.trim(),
      );
    });
  }

  static String _defaultCallName(FamilyRole role) => switch (role) {
    FamilyRole.father => kValueDefaultCallNameFather,
    FamilyRole.mother => kValueDefaultCallNameMother,
    FamilyRole.relative => '',
  };
}
