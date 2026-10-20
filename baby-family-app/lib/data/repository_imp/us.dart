import 'package:baby_family/data/repository/base.dart';
import 'package:baby_family/data/repository/us.dart';
import 'package:baby_family/data/repository_imp/mock_repository.dart';

class UsRepositoryImp extends MockRepositoryImp implements IUsRepository {
  UsRepositoryImp(super.store);

  @override
  List<JsonMap> checkins(String familyId) =>
      rows('checkins', (row) => row['familyId'] == familyId);

  @override
  JsonMap addCheckin(JsonMap checkin) => insert('checkins', checkin);

  @override
  void removeCheckin(String id) => removeRow('checkins', id);

  @override
  List<JsonMap> requests(String familyId) =>
      rows('requests', (row) => row['familyId'] == familyId);

  @override
  JsonMap? request(String id) => row('requests', id);

  @override
  JsonMap addRequest(JsonMap request) => insert('requests', request);

  @override
  void updateRequest(String id, JsonMap patch) =>
      this.patch('requests', id, patch);

  @override
  List<JsonMap> thanks(String familyId) =>
      rows('thanks', (row) => row['familyId'] == familyId);

  @override
  JsonMap addThanks(JsonMap thanks) => insert('thanks', thanks);

  @override
  List<String> dailyQuestions() => [
    for (final question in store.meta['dailyQuestions'] as List)
      store.text(question),
  ];

  @override
  List<JsonMap> questionAnswers(String familyId) =>
      rows('questionAnswers', (row) => row['familyId'] == familyId);

  @override
  JsonMap addQuestionAnswer(JsonMap answer) =>
      insert('questionAnswers', answer);

  @override
  void updateThanks(String id, JsonMap patch) =>
      this.patch('thanks', id, patch);

  @override
  List<JsonMap> journal(String userId) =>
      rows('journal', (row) => row['userId'] == userId);

  @override
  JsonMap addJournal(JsonMap entry) => insert('journal', entry);

  @override
  void updateJournal(String id, JsonMap patch) =>
      this.patch('journal', id, patch);

  @override
  JsonMap coupleSettings() => metaSection('coupleSettings');

  @override
  void saveCoupleSettings(JsonMap settings) =>
      saveMeta('coupleSettings', settings);

  @override
  List<JsonMap> bridgeSessions(String familyId) =>
      rows('bridgeSessions', (row) => row['familyId'] == familyId);

  @override
  JsonMap? bridgeSession(String id) => row('bridgeSessions', id);

  @override
  JsonMap addBridgeSession(JsonMap session) =>
      insert('bridgeSessions', session);

  @override
  void updateBridgeSession(String id, JsonMap patch) =>
      this.patch('bridgeSessions', id, patch);

  @override
  JsonMap bridgeRewrite() => metaSection('bridgeRewrite');

  @override
  JsonMap coupleWeek() => metaSection('coupleWeek');

  @override
  JsonMap catalog() => metaSection('catalog');
}
