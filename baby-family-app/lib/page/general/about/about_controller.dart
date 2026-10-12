import 'package:baby_family/data/provider/family.dart';
import 'package:baby_family/data/provider/mock_store.dart';
import 'package:baby_family/page/application_base.dart';
import 'package:hooks_riverpod/legacy.dart';

/// SET-12 — Giới thiệu: phiên bản app, điều khoản, giấy phép.
final aboutControllerProvider =
    ChangeNotifierProvider.autoDispose<AboutController>(AboutController.new);

class AboutController extends BaseNotifier {
  AboutController(super.ref) {
    _loadVersion();
  }

  String? appVersion;

  /// Năm bản quyền theo đồng hồ của app (“© 2026 Baby Family”).
  int get year => ref.read(appClockProvider).now().year;

  Future<void> _loadVersion() async {
    final version = await ref.read(familyServiceProvider).appVersion();
    if (isDisposed) {
      return;
    }
    appVersion = version;
    notifyListeners();
  }
}
