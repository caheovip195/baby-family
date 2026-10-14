import 'package:baby_family/data/model/family/family.dart';
import 'package:baby_family/data/model/settings/ai_settings.dart';
import 'package:baby_family/data/provider/family.dart';
import 'package:baby_family/data/provider/mock_store.dart';
import 'package:baby_family/data/provider/settings.dart';
import 'package:baby_family/data/service/settings.dart';
import 'package:baby_family/page/application_base.dart';
import 'package:hooks_riverpod/legacy.dart';

/// SET-05 — AI hỗ trợ: bật/tắt AI chung và từng tính năng (mỗi tính năng ghi
/// rõ dữ liệu gửi đi), lượt AI còn lại theo gói của gia đình.
final aiSettingsControllerProvider =
    ChangeNotifierProvider.autoDispose<AiSettingsController>(
      AiSettingsController.new,
    );

class AiSettingsController extends BaseNotifier {
  AiSettingsController(super.ref) {
    ref.listen(mockRevisionProvider, (_, _) => load());
    load();
  }

  ISettingsService get settingsService => ref.read(settingsServiceProvider);

  AiSettings? settings;
  Family? family;
  bool hasError = false;

  Future<void> load() async {
    hasError = false;
    try {
      final results = await Future.wait<Object?>([
        settingsService.aiSettings(),
        ref.read(familyServiceProvider).currentFamily(),
      ]);
      if (isDisposed) {
        return;
      }
      settings = results[0]! as AiSettings;
      family = results[1] as Family?;
    } on Object {
      if (isDisposed) {
        return;
      }
      hasError = true;
    }
    notifyListeners();
  }

  Future<void> setEnabled(bool value) async {
    final current = settings;
    if (current == null) {
      return;
    }
    await _save(current.copyWith(enabled: value));
  }

  Future<void> setFeature(String code, bool value) async {
    final current = settings;
    if (current == null) {
      return;
    }
    await _save(
      current.copyWith(
        features: [
          for (final feature in current.features)
            feature.code == code ? feature.copyWith(enabled: value) : feature,
        ],
      ),
    );
  }

  Future<void> _save(AiSettings value) async {
    settings = value;
    notifyListeners();
    await settingsService.saveAiSettings(value);
  }
}
