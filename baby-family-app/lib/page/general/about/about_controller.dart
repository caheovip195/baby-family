import 'package:baby_family/data/provider/family.dart';
import 'package:baby_family/data/provider/mock_store.dart';
import 'package:baby_family/data/provider/settings.dart';
import 'package:baby_family/page/application_base.dart';
import 'package:hooks_riverpod/legacy.dart';

/// SET-12 — Giới thiệu: phiên bản app, điều khoản, giấy phép.
final aboutControllerProvider =
    ChangeNotifierProvider.autoDispose<AboutController>(AboutController.new);

class AboutController extends BaseNotifier {
  AboutController(super.ref) {
    _loadVersion();
    _loadLinks();
  }

  String? appVersion;

  /// Đường dẫn pháp lý từ server (null = chưa cấu hình).
  String? termsUrl;
  String? privacyUrl;

  Future<void> _loadLinks() async {
    try {
      final help = await ref.read(settingsServiceProvider).help();
      if (isDisposed) {
        return;
      }
      termsUrl = help.termsUrl;
      privacyUrl = help.privacyUrl;
      notifyListeners();
    } on Object {
      // Giữ hành vi cũ (chưa có trang) khi không đọc được.
    }
  }

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
