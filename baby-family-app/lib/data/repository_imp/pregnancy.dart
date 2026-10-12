import 'package:baby_family/data/repository/base.dart';
import 'package:baby_family/data/repository/pregnancy.dart';
import 'package:baby_family/data/repository_imp/mock_repository.dart';

class PregnancyRepositoryImp extends MockRepositoryImp
    implements IPregnancyRepository {
  PregnancyRepositoryImp(super.store);

  @override
  List<JsonMap> prepItems(String pregnancyId) =>
      rows('prepItems', (row) => row['pregnancyId'] == pregnancyId);

  @override
  JsonMap addPrepItem(JsonMap item) {
    final value = {'id': store.newId('pr'), ...item};
    store.table('prepItems').add(value);
    store.commit();
    return store.localized(value);
  }

  @override
  void updatePrepItem(String id, JsonMap patch) =>
      this.patch('prepItems', id, patch);

  @override
  JsonMap prepHiddenCounts() => Map<String, dynamic>.from(
    (store.meta['prepHiddenCounts'] as Map?) ?? const {'done': 0, 'total': 0},
  );

  @override
  List<JsonMap> names(String pregnancyId) =>
      rows('names', (row) => row['pregnancyId'] == pregnancyId);

  @override
  JsonMap addName(JsonMap name) {
    final value = {'id': store.newId('n'), ...name};
    store.table('names').add(value);
    store.commit();
    return store.localized(value);
  }

  @override
  void updateName(String id, JsonMap patch) => this.patch('names', id, patch);

  @override
  JsonMap? birthDraft(String pregnancyId) {
    final drafts = store.meta['birthDrafts'] as Map?;
    final draft = drafts?[pregnancyId] as Map?;
    return draft == null ? null : Map<String, dynamic>.from(draft);
  }
}
