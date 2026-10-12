import 'package:baby_family/data/model/settings/help_info.dart';
import 'package:baby_family/data/provider/settings.dart';
import 'package:baby_family/data/service/settings.dart';
import 'package:baby_family/page/application_base.dart';
import 'package:hooks_riverpod/legacy.dart';

/// SET-11 — Trợ giúp: câu hỏi thường gặp, gửi yêu cầu, báo cáo, liên hệ.
final helpControllerProvider =
    ChangeNotifierProvider.autoDispose<HelpController>(HelpController.new);

class HelpController extends BaseNotifier {
  HelpController(super.ref) {
    load();
  }

  ISettingsService get settingsService => ref.read(settingsServiceProvider);

  HelpInfo? info;
  bool hasError = false;

  Future<void> load() async {
    hasError = false;
    try {
      final result = await settingsService.help();
      if (isDisposed) {
        return;
      }
      info = result;
    } catch (_) {
      if (isDisposed) {
        return;
      }
      hasError = true;
    }
    notifyListeners();
  }
}
