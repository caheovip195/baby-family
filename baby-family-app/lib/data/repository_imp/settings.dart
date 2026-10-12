import 'package:baby_family/data/repository/base.dart';
import 'package:baby_family/data/repository/settings.dart';
import 'package:baby_family/data/repository_imp/mock_repository.dart';

class SettingsRepositoryImp extends MockRepositoryImp
    implements ISettingsRepository {
  SettingsRepositoryImp(super.store);

  JsonMap get _all => metaSection('settings');

  @override
  JsonMap section(String key) =>
      Map<String, dynamic>.from((_all[key] as Map?) ?? const {});

  @override
  void saveSection(String key, JsonMap value) {
    final raw = Map<String, dynamic>.from(
      (store.meta['settings'] as Map?) ?? const {},
    );
    raw[key] = value;
    saveMeta('settings', raw);
  }
}
