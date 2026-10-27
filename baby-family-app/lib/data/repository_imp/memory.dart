import 'package:baby_family/data/repository/base.dart';
import 'package:baby_family/data/repository/memory.dart';
import 'package:baby_family/data/repository_imp/mock_repository.dart';

class MemoryRepositoryImp extends MockRepositoryImp
    implements IMemoryRepository {
  @override
  void touch() => store.commit();

  MemoryRepositoryImp(super.store);

  @override
  List<JsonMap> memories(String familyId) => rows(
    'memories',
    // Nháp trên tài khoản (MEM-18) chỉ mở qua [memory] để soạn tiếp, không
    // hiện trong dòng thời gian / album / thống kê.
    (row) => row['familyId'] == familyId && row['remoteStatus'] != 'DRAFT',
  );

  @override
  JsonMap? memory(String id) => row('memories', id);

  @override
  JsonMap addMemory(JsonMap memory) => insert('memories', memory);

  @override
  void updateMemory(String id, JsonMap patch) =>
      this.patch('memories', id, patch);

  @override
  void removeMemory(String id) => removeRow('memories', id);

  @override
  List<JsonMap> comments(String memoryId) =>
      rows('comments', (row) => row['memoryId'] == memoryId);

  @override
  JsonMap addComment(JsonMap comment) {
    final value = {'id': store.newId('c'), ...comment};
    store.table('comments').add(value);
    store.commit();
    return store.localized(value);
  }

  @override
  List<JsonMap> perspectives(String memoryId) =>
      rows('perspectives', (row) => row['memoryId'] == memoryId);

  @override
  JsonMap addPerspective(JsonMap perspective) =>
      insert('perspectives', perspective);

  @override
  void updatePerspective(String id, JsonMap patch) =>
      this.patch('perspectives', id, patch);

  @override
  JsonMap? story(String id) => row('stories', id);

  @override
  List<JsonMap> stories(String familyId) =>
      rows('stories', (row) => row['familyId'] == familyId);

  @override
  void updateStory(String id, JsonMap patch) =>
      this.patch('stories', id, patch);

  @override
  List<JsonMap> collections() => rows('collections');

  @override
  JsonMap catalog() =>
      store.localized(Map<String, dynamic>.from(store.meta['catalog'] as Map));

  @override
  List<JsonMap> albums(String familyId) =>
      rows('albums', (row) => row['familyId'] == familyId);

  @override
  JsonMap? album(String id) => row('albums', id);

  @override
  JsonMap addAlbum(JsonMap album) => insert('albums', album);

  @override
  void updateAlbum(String id, JsonMap patch) => this.patch('albums', id, patch);

  @override
  void removeAlbum(String id) => removeRow('albums', id);

  @override
  void updateComment(String id, JsonMap patch) =>
      this.patch('comments', id, patch);

  @override
  void removeComment(String id) {
    store
        .table('comments')
        .removeWhere((row) => row['id'] == id || row['parentId'] == id);
    store.commit();
  }

  @override
  List<JsonMap> searchMemories(String familyId) =>
      rows('searchMemories', (row) => row['familyId'] == familyId);

  @override
  List<JsonMap> pastMemories(String familyId) =>
      rows('pastMemories', (row) => row['familyId'] == familyId);

  @override
  List<String> searchRecents({bool server = false}) =>
      ((store.meta[_recentsKey(server)] as List?) ?? const []).cast<String>();

  @override
  void saveSearchRecents(List<String> recents, {bool server = false}) =>
      saveMeta(_recentsKey(server), recents);

  static String _recentsKey(bool server) =>
      server ? 'serverSearchRecents' : 'searchRecents';

  @override
  JsonMap weeklyRecap() => metaSection('weeklyRecap');

  @override
  List<JsonMap> trash(String familyId) =>
      rows('trash', (row) => row['familyId'] == familyId);

  @override
  void restoreFromTrash(String id) {
    final row = store.find('trash', id);
    if (row == null) {
      return;
    }
    store.remove('trash', id);
    store
        .table('memories')
        .add(
          Map<String, dynamic>.of(row)
            ..remove('deletedAt')
            ..remove('deletedByUserId'),
        );
    store.commit();
  }

  @override
  void removeFromTrash(String id) => removeRow('trash', id);

  @override
  void moveToTrash(String id, JsonMap patch) {
    final row = store.find('memories', id);
    if (row == null) {
      return;
    }
    store.remove('memories', id);
    store.table('trash').insert(0, {...row, ...patch});
    store.commit();
  }

  @override
  List<JsonMap> drafts(String userId) =>
      rows('drafts', (row) => row['userId'] == userId);

  @override
  void removeDraft(String id) => removeRow('drafts', id);

  @override
  JsonMap addDraft(JsonMap draft) => insert('drafts', draft);

  @override
  void updateDraft(String id, JsonMap patch) => this.patch('drafts', id, patch);

  @override
  List<JsonMap> pendingPosts(String familyId) =>
      rows('pendingPosts', (row) => row['familyId'] == familyId);

  @override
  JsonMap addPendingPost(JsonMap post) => insert('pendingPosts', post);

  @override
  void approvePendingPost(String id, JsonMap patch) {
    final row = store.find('pendingPosts', id);
    if (row == null) {
      return;
    }
    store.remove('pendingPosts', id);
    store.table('memories').insert(0, {...row, ...patch});
    store.commit();
  }

  @override
  void removePendingPost(String id) => removeRow('pendingPosts', id);

  @override
  JsonMap dayStory() => metaSection('dayStory');

  @override
  void saveDayStory(JsonMap story) => saveMeta('dayStory', story);

  @override
  JsonMap monthRecap() => metaSection('monthRecap');

  @override
  JsonMap circlePostDraft() => metaSection('circlePostDraft');
}
