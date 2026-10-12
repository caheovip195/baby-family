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

  @override
  List<JsonMap> sectionList(String key) => [
    for (final row in (_all[key] as List?) ?? const [])
      Map<String, dynamic>.from(row as Map),
  ];

  @override
  void saveSectionList(String key, List<JsonMap> value) {
    final raw = Map<String, dynamic>.from(
      (store.meta['settings'] as Map?) ?? const {},
    );
    raw[key] = value;
    saveMeta('settings', raw);
  }

  @override
  JsonMap catalog() => metaSection('catalog');
}
