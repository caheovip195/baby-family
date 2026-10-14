import 'package:baby_family/data/dto/circle_view.dart';
import 'package:baby_family/data/model/child/child.dart';
import 'package:baby_family/data/model/circle/circle_preferences.dart';
import 'package:baby_family/data/model/family/member.dart';
import 'package:baby_family/data/model/session/app_session.dart';
import 'package:baby_family/data/provider/circle.dart';
import 'package:baby_family/data/provider/family.dart';
import 'package:baby_family/data/provider/session.dart';
import 'package:baby_family/data/service/circle.dart';
import 'package:baby_family/page/application_base.dart';
import 'package:baby_family/utils/constants/enum.dart';
import 'package:hooks_riverpod/legacy.dart';

/// SET-10 — Rời gia đình (người thân, mục 7.25.1): mất quyền xem ngay sau
/// khi xác nhận; nội dung đã đăng giữ lại cho gia đình (mặc định) hoặc gỡ
/// toàn bộ; bố mẹ nhận thông báo trung tính. Xong → CIR-WAIT.
final leaveFamilyControllerProvider =
    ChangeNotifierProvider.autoDispose<LeaveFamilyController>(
      LeaveFamilyController.new,
    );

class LeaveFamilyController extends BaseNotifier {
  LeaveFamilyController(super.ref) {
    Future.microtask(load);
  }

  ICircleService get circleService => ref.read(circleServiceProvider);

  CircleView? view;
  CirclePreferences? preferences;
  Member? inviter;
  bool removeContent = false;
  bool hasError = false;

  AppSession get session => ref.read(sessionServiceProvider).current;

  /// Các cháu đang theo dõi (không gồm thai kỳ).
  List<Child> get following => [
    for (final child in view?.children ?? const <Child>[])
      if (!child.isPregnancy) child,
  ];

  Future<void> load() async {
    hasError = false;
    try {
      final (loaded, prefs, members) = await (
        circleService.view(),
        circleService.preferences(),
        ref.read(familyServiceProvider).members(),
      ).wait;
      if (isDisposed) {
        return;
      }
      view = loaded;
      preferences = prefs;
      // Người nhận thông báo / gửi lời mời mới: Mama, không có thì Papa.
      inviter =
          members
              .where((member) => member.role == FamilyRole.mother)
              .firstOrNull ??
          members.where((member) => member.role.isParent).firstOrNull;
    } catch (_) {
      if (isDisposed) {
        return;
      }
      hasError = true;
    }
    notifyListeners();
  }

  void chooseRemove(bool value) {
    removeContent = value;
    notifyListeners();
  }

  Future<void> leave() => whileLoading(
    () => circleService.leaveFamily(removeContent: removeContent),
  );
}
