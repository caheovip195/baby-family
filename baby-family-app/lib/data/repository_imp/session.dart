import 'package:baby_family/data/repository/base.dart';
import 'package:baby_family/data/repository/session.dart';
import 'package:baby_family/data/repository_imp/mock_repository.dart';
import 'package:baby_family/utils/constants/enum.dart';

class SessionRepositoryImp extends MockRepositoryImp
    implements ISessionRepository {
  SessionRepositoryImp(super.store);

  @override
  Future<void> ensureLoaded() => store.ensureLoaded();

  @override
  bool get isLoaded => store.isLoaded;

  @override
  JsonMap session() => Map.of(store.session);

  @override
  void patchSession(JsonMap patch) {
    store.session.addAll(patch);
    store.session.removeWhere((_, value) => value == null);
    store.commit();
  }

  @override
  void clearSession() {
    store.session.clear();
    store.commit();
  }

  @override
  JsonMap config() =>
      store.localized(Map<String, dynamic>.from(store.meta['config'] as Map));

  @override
  JsonMap? user(String? id) => row('users', id);

  @override
  JsonMap upsertUser(JsonMap user) {
    final existing = store.find('users', user['id'] as String?);
    if (existing != null) {
      existing.addAll(user);
      store.commit();
      return store.localized(existing);
    }
    return insert('users', user);
  }

  @override
  Future<void> reseed(DemoSeed seed, {String? actor}) =>
      store.reseed(seed, newActor: actor);

  @override
  JsonMap exportOfflineSnapshot() => store.exportSnapshot();

  @override
  void importOfflineSnapshot(JsonMap snapshot) =>
      store.importSnapshot(snapshot);
}
