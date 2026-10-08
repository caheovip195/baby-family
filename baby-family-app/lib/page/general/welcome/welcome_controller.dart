import 'package:baby_family/data/provider/app_setting.dart';
import 'package:baby_family/page/application_base.dart';
import 'package:baby_family/utils/constants/enum.dart';
import 'package:hooks_riverpod/legacy.dart';

final welcomeController = ChangeNotifierProvider.autoDispose<WelcomeController>(
  WelcomeController.new,
);

/// ONB-01 — Welcome (tài liệu nghiệp vụ mục 9.1).
class WelcomeController extends BaseNotifier {
  WelcomeController(super.ref);

  static const slideCount = 3;

  int _currentIndex = 0;

  int get currentIndex => _currentIndex;

  bool get isLastSlide => _currentIndex == slideCount - 1;

  AppLanguage get language => ref.read(appLanguageProvider);

  void onPageChanged(int index) {
    if (index == _currentIndex) {
      return;
    }
    _currentIndex = index;
    notifyListeners();
  }

  Future<void> changeLanguage(AppLanguage language) async {
    await ref.read(appLanguageProvider.notifier).change(language);
    if (isDisposed) {
      return;
    }
    notifyListeners();
  }
}
