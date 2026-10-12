import 'package:baby_family/data/repository/base.dart';
import 'package:baby_family/data/repository/family.dart';
import 'package:baby_family/data/repository_imp/mock_repository.dart';

class FamilyRepositoryImp extends MockRepositoryImp
    implements IFamilyRepository {
  FamilyRepositoryImp(super.store);

  @override
  JsonMap? family(String? id) => row('families', id);

  @override
  JsonMap createFamily(JsonMap family) => insert('families', family);

  @override
  void updateFamily(String id, JsonMap patch) =>
      this.patch('families', id, patch);

  @override
  List<JsonMap> members(String familyId) =>
      rows('members', (row) => row['familyId'] == familyId);

  @override
  JsonMap? member(String? id) => row('members', id);

  @override
  JsonMap addMember(JsonMap member) => insert('members', member);

  @override
  void updateMember(String id, JsonMap patch) =>
      this.patch('members', id, patch);

  @override
  List<JsonMap> invites(String familyId) =>
      rows('invites', (row) => row['familyId'] == familyId);

  @override
  JsonMap? inviteByCode(String code) {
    final normalized = code.trim().toUpperCase();
    return rows(
      'invites',
      (row) => (row['code'] as String?)?.toUpperCase() == normalized,
    ).firstOrNull;
  }

  @override
  JsonMap addInvite(JsonMap invite) => insert('invites', invite);

  @override
  void updateInvite(String id, JsonMap patch) =>
      this.patch('invites', id, patch);

  @override
  List<JsonMap> planOffers() {
    final catalog = store.localized(
      Map<String, dynamic>.from(store.meta['catalog'] as Map),
    );
    return (catalog['plans'] as List).cast<JsonMap>();
  }

  @override
  JsonMap config() =>
      Map<String, dynamic>.from((store.meta['config'] as Map?) ?? const {});

  @override
  JsonMap familySettings() => metaSection('familySettings');

  @override
  void saveFamilySettings(JsonMap settings) =>
      saveMeta('familySettings', settings);

  @override
  List<JsonMap> memberships(String userId) => [
    for (final row
        in ((store.meta['memberships'] as Map?)?[userId] as List?) ?? const [])
      store.localized(Map<String, dynamic>.from(row as Map)),
  ];

  @override
  JsonMap planDetails() => metaSection('planDetails');

  @override
  JsonMap circlePreferences(String userId) => Map<String, dynamic>.from(
    ((store.meta['circlePreferences'] as Map?)?[userId] as Map?) ?? const {},
  );

  @override
  void saveCirclePreferences(String userId, JsonMap preferences) {
    final all = Map<String, dynamic>.from(
      (store.meta['circlePreferences'] as Map?) ?? const {},
    );
    all[userId] = preferences;
    saveMeta('circlePreferences', all);
  }

  @override
  void removeMember(String id) => removeRow('members', id);
}
