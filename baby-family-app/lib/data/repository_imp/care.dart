import 'package:baby_family/data/repository/base.dart';
import 'package:baby_family/data/repository/care.dart';
import 'package:baby_family/data/repository_imp/mock_repository.dart';

class CareRepositoryImp extends MockRepositoryImp implements ICareRepository {
  CareRepositoryImp(super.store);

  @override
  List<JsonMap> missions(String familyId) =>
      rows('missions', (row) => row['familyId'] == familyId);

  @override
  JsonMap? mission(String id) => row('missions', id);

  @override
  JsonMap addMission(JsonMap mission) {
    final value = {'id': store.newId('ms'), ...mission};
    store.table('missions').add(value);
    store.commit();
    return store.localized(value);
  }

  @override
  void updateMission(String id, JsonMap patch) =>
      this.patch('missions', id, patch);

  @override
  List<JsonMap> templates() => rows('templates');

  @override
  JsonMap? template(String? id) => row('templates', id);

  @override
  List<JsonMap> heartsLedger(String familyId) =>
      rows('heartsLedger', (row) => row['familyId'] == familyId);

  @override
  JsonMap addHearts(JsonMap entry) => insert('heartsLedger', entry);

  @override
  void removeHearts(bool Function(JsonMap entry) test) {
    store.table('heartsLedger').removeWhere(test);
    store.commit();
  }

  @override
  JsonMap heartsBaseline(String userId) {
    final baseline = store.meta['heartsBaseline'] as Map<String, dynamic>;
    return Map<String, dynamic>.from(
      (baseline[userId] as Map?) ?? const {'weekBefore': 0, 'totalBefore': 0},
    );
  }

  @override
  JsonMap treeStats() => Map<String, dynamic>.from(store.meta['tree'] as Map);

  @override
  List<JsonMap> treeLevels() => [
    for (final level in store.meta['treeLevels'] as List)
      store.localized(Map<String, dynamic>.from(level as Map)),
  ];

  @override
  int swapsUsed(String userId) =>
      ((store.meta['swapsUsed'] as Map?)?[userId] as int?) ?? 0;

  @override
  void setSwapsUsed(String userId, int value) {
    (store.meta['swapsUsed'] as Map)[userId] = value;
    store.commit();
  }

  @override
  JsonMap missionDraft() => store.localized(
    Map<String, dynamic>.from((store.meta['createDraft'] as Map?) ?? const {}),
  );

  @override
  List<JsonMap> calendarEvents(String familyId) =>
      rows('calendarEvents', (row) => row['familyId'] == familyId);

  @override
  JsonMap addCalendarEvent(JsonMap event) => insert('calendarEvents', event);

  @override
  JsonMap eventDraft() => metaSection('eventDraft');

  @override
  List<JsonMap> missionHistory() => metaList('missionHistory');

  @override
  List<JsonMap> badges(String familyId) =>
      rows('badges', (row) => row['familyId'] == familyId);

  @override
  JsonMap missionSettings() => metaSection('missionSettings');

  @override
  void saveMissionSettings(JsonMap settings) =>
      saveMeta('missionSettings', settings);

  @override
  JsonMap careStats() => metaSection('careStats');
}
