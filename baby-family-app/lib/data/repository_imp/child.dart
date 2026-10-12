import 'package:baby_family/data/repository/base.dart';
import 'package:baby_family/data/repository/child.dart';
import 'package:baby_family/data/repository_imp/mock_repository.dart';

class ChildRepositoryImp extends MockRepositoryImp implements IChildRepository {
  ChildRepositoryImp(super.store);

  @override
  List<JsonMap> children(String familyId) =>
      rows('children', (row) => row['familyId'] == familyId);

  @override
  JsonMap? child(String id) => row('children', id);

  @override
  JsonMap addChild(JsonMap child) {
    // New children are appended (the switcher keeps the creation order).
    final value = {'id': child['id'] ?? store.newId('child'), ...child};
    store.table('children').add(value);
    store.commit();
    return store.localized(value);
  }

  @override
  void updateChild(String id, JsonMap patch) =>
      this.patch('children', id, patch);

  @override
  JsonMap stats() =>
      store.localized(Map<String, dynamic>.from(store.meta['stats'] as Map));

  @override
  JsonMap? profile(String childId) =>
      rows('profiles', (row) => row['childId'] == childId).firstOrNull;

  @override
  void saveProfile(JsonMap profile) {
    final table = store.table('profiles');
    table.removeWhere((row) => row['childId'] == profile['childId']);
    table.add(Map<String, dynamic>.of(profile));
    store.commit();
  }

  @override
  List<JsonMap> milestoneRecords(String childId) =>
      rows('milestoneRecords', (row) => row['childId'] == childId);

  @override
  JsonMap addMilestoneRecord(JsonMap record) =>
      insert('milestoneRecords', record);
}
