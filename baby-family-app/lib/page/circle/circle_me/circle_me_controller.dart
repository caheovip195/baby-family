import 'package:baby_family/data/dto/circle_view.dart';
import 'package:baby_family/data/model/child/child.dart';
import 'package:baby_family/data/model/circle/circle_preferences.dart';
import 'package:baby_family/data/model/family/family_membership.dart';
import 'package:baby_family/data/provider/app_setting.dart';
import 'package:baby_family/data/provider/circle.dart';
import 'package:baby_family/data/provider/family.dart';
import 'package:baby_family/data/service/circle.dart';
import 'package:baby_family/page/application_base.dart';
import 'package:baby_family/utils/constants/enum.dart';
import 'package:hooks_riverpod/legacy.dart';

/// CIR-06 — Tôi (người thân): hồ sơ, cỡ chữ (dùng chung SET-06), thông báo
/// (báo ngay / bản tin 19:00), chuyển gia đình (FAM-08), trợ giúp, rời gia
/// đình (SET-10), xoá tài khoản.
final circleMeControllerProvider =
    ChangeNotifierProvider.autoDispose<CircleMeController>(
      CircleMeController.new,
    );

class CircleMeController extends BaseNotifier {
  CircleMeController(super.ref) {
    ref.listen(appTextScaleProvider, (_, _) => notifyListeners());
    Future.microtask(load);
  }

  ICircleService get circleService => ref.read(circleServiceProvider);

  CircleView? view;
  CirclePreferences? preferences;
  bool hasError = false;

  AppTextSize get textSize =>
      AppTextSize.fromScale(ref.read(appTextScaleProvider));

  /// Cháu trong câu xem trước cỡ chữ (cháu nhỏ nhất đã chào đời).
  Child? get previewChild {
    final babies = [
      for (final child in view?.children ?? const <Child>[])
        if (child.birthDate != null) child,
    ]..sort((a, b) => b.birthDate!.compareTo(a.birthDate!));
    return babies.firstOrNull;
  }

  Future<void> load() async {
    hasError = false;
    try {
      final (loaded, prefs) = await (
        circleService.view(),
        circleService.preferences(),
      ).wait;
      if (isDisposed) {
        return;
      }
      view = loaded;
      preferences = prefs;
    } catch (_) {
      if (isDisposed) {
        return;
      }
      hasError = true;
    }
    notifyListeners();
  }

  void changeTextSize(AppTextSize value) =>
      ref.read(appTextScaleProvider.notifier).change(value.scale);

  Future<void> _save(CirclePreferences value) async {
    preferences = value;
    notifyListeners();
    await circleService.savePreferences(value);
  }

  Future<void> chooseDigest(bool digest) async {
    final current = preferences;
    if (current == null) {
      return;
    }
    await _save(current.copyWith(dailyDigest: digest, instantPhotos: !digest));
  }

  Future<void> setDigestTime(String time) async {
    final current = preferences;
    if (current == null) {
      return;
    }
    await _save(current.copyWith(digestTime: time, dailyDigest: true));
  }

  Future<List<FamilyMembership>> memberships() =>
      ref.read(familyServiceProvider).memberships();

  Future<void> switchFamily(String familyId) =>
      ref.read(familyServiceProvider).switchFamily(familyId);
}
